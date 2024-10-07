// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Address} from "../../lib/openzeppelin-contracts/contracts/utils/Address.sol";
import {IERC20} from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {TerminusFacet} from "../../lib/web3/contracts/terminus/TerminusFacet.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";

import {LibShadowcorn} from "./LibShadowcorn.sol";
import {LibShadowcornDNA} from "./LibShadowcornDNA.sol";
import {LibStats} from "./LibStats.sol";
import {LibNames} from "./LibNames.sol";
import {LibEnvironment} from "../../lib/cu-osc-common/src/libraries/LibEnvironment.sol";
import {LibResourceLocator} from "../../lib/cu-osc-common/src/libraries/LibResourceLocator.sol";

/// @custom:storage-location erc7201:games.laguna.shadowcorns.hatching
library LibHatching {
    using Address for address;
    string public constant CALLBACK_SIGNATURE =
        "rawFulfillRandomness(uint256,uint256[])";
    bytes32 constant HATCHING_STORAGE_POSITION =
        keccak256(
            abi.encode(
                uint256(keccak256("games.laguna.shadowcorns.hatching")) - 1
            )
        ) & ~bytes32(uint256(0xff));

    uint256 constant MAX_COMMON_CORNS_PER_CLASS = 400;
    uint256 constant MAX_RARE_CORNS_PER_CLASS = 190;
    uint256 constant MAX_MYTHIC_CORNS_PER_CLASS = 10;

    uint256 constant MAX_UINT = type(uint256).max;
    uint256 constant SALT_1 = 1;
    uint256 constant SALT_2 = 2;
    uint256 constant SALT_3 = 3;

    event HatchingShadowcornRNGRequested(
        uint256 indexed tokenId,
        address indexed playerWallet,
        uint256 indexed blockDeadline
    );
    event HatchingShadowcornCompleted(
        uint256 indexed tokenId,
        address indexed playerWallet
    );

    struct HatchingStorage {
        uint256 RBWCost;
        uint256 UNIMCost;
        // class => rarity => amount of unicorns of that class of that rarity.
        mapping(uint256 => mapping(uint256 => uint256)) rarityTotalsByClass;
        mapping(uint256 => uint256) blockDeadlineByVRFRequestId;
        mapping(uint256 => uint256) vrfRequestIdByTokenId;
        mapping(uint256 => uint256) tokenIdByVRFRequestId;
        mapping(uint256 => address) playerWalletByVRFRequestId;
        mapping(address => uint256[]) tokenIdsByOwner;
    }

    function maxCornsPerClass(
        uint256 rarity
    ) internal pure returns (uint256 max) {
        if (rarity == 1) {
            max = MAX_COMMON_CORNS_PER_CLASS;
        }
        if (rarity == 2) {
            max = MAX_RARE_CORNS_PER_CLASS;
        }
        if (rarity == 3) {
            max = MAX_MYTHIC_CORNS_PER_CLASS;
        }
    }

    function hatchingStorage()
        internal
        pure
        returns (HatchingStorage storage hs)
    {
        bytes32 position = HATCHING_STORAGE_POSITION;
        assembly {
            hs.slot := position
        }
    }

    function setHatchingCosts(uint256 rbwCost, uint256 unimCost) internal {
        HatchingStorage storage hs = hatchingStorage();
        hs.RBWCost = rbwCost;
        hs.UNIMCost = unimCost;
    }

    function beginHatching(uint256 terminusPoolId) internal {
        require(
            terminusPoolId == LibShadowcorn.commonEggPoolId() ||
                terminusPoolId == LibShadowcorn.rareEggPoolId() ||
                terminusPoolId == LibShadowcorn.mythicEggPoolId(),
            "Hatching: terminusPoolId must be a valid Terminus pool id of a Shadowcorn egg"
        );
        require(
            !(msg.sender.isContract()),
            "Hatching: Cannot call beginHatching from a contract"
        );

        spendTokens(terminusPoolId);
        uint256 tokenId = mintAndSetBasicDNAForShadowcorn(terminusPoolId);
        hatchingStorage().tokenIdsByOwner[msg.sender].push(tokenId);
        tryVRFRequest(tokenId);
    }

    function spendTokens(uint256 terminusPoolId) internal {
        HatchingStorage storage hs = hatchingStorage();
        //Burn terminus token (shadowcorn egg)
        TerminusFacet(LibResourceLocator.unicornItems()).burn(
            msg.sender,
            terminusPoolId,
            1
        );

        IERC20(LibResourceLocator.rbwToken()).transferFrom(
            msg.sender,
            LibResourceLocator.gameBank(),
            hs.RBWCost
        );

        IERC20(LibResourceLocator.unimToken()).transferFrom(
            msg.sender,
            LibResourceLocator.gameBank(),
            hs.UNIMCost
        );
    }

    function tryVRFRequest(uint256 tokenId) internal {
        uint256 vrfRequestId = LibRNG.requestRandomness(CALLBACK_SIGNATURE);
        uint256 blockDeadline = LibEnvironment.getBlockNumber() +
            LibRNG.rngStorage().blocksToRespond;

        saveHatchingData(vrfRequestId, tokenId, blockDeadline);

        emit HatchingShadowcornRNGRequested(tokenId, msg.sender, blockDeadline);
    }

    function retryHatching(uint256 tokenId) internal {
        HatchingStorage storage hs = hatchingStorage();
        require(tokenId != 0, "Hatching: cannot retry a hatch for tokenId = 0");
        require(
            hatchIsInProgress(tokenId),
            "Hatching: cannot retry a hatch that is not in progress"
        );
        uint256 failedVrfRequestId = hs.vrfRequestIdByTokenId[tokenId];
        require(
            LibEnvironment.getBlockNumber() >
                hs.blockDeadlineByVRFRequestId[failedVrfRequestId],
            "Hatching: cannot retry a hatch with blockDeadline that is not expired"
        );
        require(
            hs.playerWalletByVRFRequestId[failedVrfRequestId] == msg.sender,
            "Hatching: cannot retry for a hatch process that you didn't start"
        );
        require(
            !(msg.sender.isContract()),
            "Hatching: Cannot call retry from a contract"
        );
        //dna version?

        cleanVRFData(tokenId, failedVrfRequestId);
        tryVRFRequest(tokenId);
    }

    function saveHatchingData(
        uint256 vrfRequestId,
        uint256 tokenId,
        uint256 blockDeadline
    ) internal {
        HatchingStorage storage hs = hatchingStorage();
        hs.vrfRequestIdByTokenId[tokenId] = vrfRequestId;
        hs.tokenIdByVRFRequestId[vrfRequestId] = tokenId;
        hs.playerWalletByVRFRequestId[vrfRequestId] = msg.sender;
        hs.blockDeadlineByVRFRequestId[vrfRequestId] = blockDeadline;
    }

    function mintAndSetBasicDNAForShadowcorn(
        uint256 terminusPoolId
    ) internal returns (uint256 tokenId) {
        tokenId = LibERC721.mintNextToken(address(this));
        uint256 dna = 0;
        dna = LibShadowcornDNA.setVersion(
            dna,
            LibShadowcornDNA.targetDNAVersion()
        );
        dna = LibShadowcornDNA.setRarity(
            dna,
            getRarityByPoolId(terminusPoolId)
        );
        dna = LibShadowcornDNA.setTier(dna, 1);
        LibShadowcornDNA.setDNA(tokenId, dna);
    }

    function getHatchesInProgress(
        address playerWallet
    ) internal view returns (uint256[] memory, bool[] memory) {
        HatchingStorage storage hs = hatchingStorage();
        uint256 tokenBalance = hs.tokenIdsByOwner[playerWallet].length;
        uint256[] memory inProgress = new uint256[](tokenBalance);
        uint256 resultLength = 0;
        for (uint256 tokenIndex = 0; tokenIndex < tokenBalance; tokenIndex++) {
            uint256 tokenId = hs.tokenIdsByOwner[playerWallet][tokenIndex];
            if (hatchIsInProgress(tokenId)) {
                inProgress[resultLength] = tokenId;
                resultLength++;
            }
        }

        uint256[] memory tokenIds = new uint256[](resultLength);
        bool[] memory needsRetry = new bool[](resultLength);

        for (
            uint256 inProgressIndex = 0;
            inProgressIndex < resultLength;
            inProgressIndex++
        ) {
            uint256 tokenId = inProgress[inProgressIndex];
            uint256 vrfRequestId = hs.vrfRequestIdByTokenId[tokenId];
            tokenIds[inProgressIndex] = tokenId;
            needsRetry[inProgressIndex] =
                LibEnvironment.getBlockNumber() >
                hs.blockDeadlineByVRFRequestId[vrfRequestId];
        }

        return (tokenIds, needsRetry);
    }

    function getHatchesStatus(
        address playerWallet
    ) internal view returns (uint256[] memory, string[] memory) {
        HatchingStorage storage hs = hatchingStorage();
        uint256 tokenBalance = hs.tokenIdsByOwner[playerWallet].length;
        uint256[] memory tokenIds = new uint256[](tokenBalance);
        string[] memory statuses = new string[](tokenBalance);
        for (uint256 tokenIndex = 0; tokenIndex < tokenBalance; tokenIndex++) {
            uint256 tokenId = hs.tokenIdsByOwner[playerWallet][tokenIndex];
            tokenIds[tokenIndex] = tokenId;

            statuses[tokenIndex] = "success";
            if (hatchIsInProgress(tokenId)) {
                uint256 vrfRequestId = hs.vrfRequestIdByTokenId[tokenId];
                statuses[tokenIndex] = "pending";
                if (
                    LibEnvironment.getBlockNumber() >
                    hs.blockDeadlineByVRFRequestId[vrfRequestId]
                ) {
                    statuses[tokenIndex] = "needs_retry";
                }
            }
        }

        return (tokenIds, statuses);
    }

    function hatchIsInProgress(uint256 tokenId) internal view returns (bool) {
        return hatchingStorage().vrfRequestIdByTokenId[tokenId] != 0;
    }

    function hatchingFulfillRandomness(
        uint256 vrfRequestId,
        uint256 randomness
    ) internal {
        HatchingStorage storage hs = hatchingStorage();
        require(
            LibEnvironment.getBlockNumber() <=
                hs.blockDeadlineByVRFRequestId[vrfRequestId],
            "Hatching: blockDeadline has expired."
        );
        uint256 tokenId = hs.tokenIdByVRFRequestId[vrfRequestId];
        require(
            hatchIsInProgress(tokenId),
            "Hatching: Hatch is not in progress"
        );
        address playerWallet = hs.playerWalletByVRFRequestId[vrfRequestId];

        LibERC721.transfer(address(this), playerWallet, tokenId);

        setShadowcornDNA(randomness, tokenId);
        LibShadowcorn.shadowcornStorage().shadowcornBirthnight[tokenId] = block
            .timestamp;

        emit HatchingShadowcornCompleted(tokenId, playerWallet);
        cleanVRFData(tokenId, vrfRequestId);
    }

    function cleanVRFData(uint256 tokenId, uint256 vrfRequestId) internal {
        HatchingStorage storage hs = hatchingStorage();
        delete hs.tokenIdByVRFRequestId[vrfRequestId];
        delete hs.vrfRequestIdByTokenId[tokenId];
        delete hs.playerWalletByVRFRequestId[vrfRequestId];
        delete hs.blockDeadlineByVRFRequestId[vrfRequestId];
    }

    function setShadowcornDNA(uint256 randomness, uint256 tokenId) internal {
        HatchingStorage storage hs = hatchingStorage();
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        uint256 rarity = LibShadowcornDNA.getRarity(dna);
        //first 3 bits are used for class
        uint256 class = LibRNG.expand(5, randomness, SALT_1) + 1;
        while (
            hs.rarityTotalsByClass[class][rarity] >= maxCornsPerClass(rarity)
        ) {
            //re-roll class because max corns for that class have been minted.
            class = (class % 5) + 1;
        }

        dna = LibShadowcornDNA.setClass(dna, class);
        hs.rarityTotalsByClass[class][rarity]++;

        // NOTE: The stats generated here are saved at 1/10th scale
        //       ie. setMight(35) -> getMight=350

        //might
        dna = LibShadowcornDNA.setMight(
            dna,
            LibStats.rollRandomMight(class, rarity, randomness)
        );
        // //wickedness
        dna = LibShadowcornDNA.setWickedness(
            dna,
            LibStats.rollRandomWickedness(class, rarity, randomness)
        );
        // //tenacity
        dna = LibShadowcornDNA.setTenacity(
            dna,
            LibStats.rollRandomTenacity(class, rarity, randomness)
        );
        // //cunning
        dna = LibShadowcornDNA.setCunning(
            dna,
            LibStats.rollRandomCunning(class, rarity, randomness)
        );
        // //arcana
        dna = LibShadowcornDNA.setArcana(
            dna,
            LibStats.rollRandomArcana(class, rarity, randomness)
        );

        //firstName
        dna = LibShadowcornDNA.setFirstName(
            dna,
            LibNames.getRandomFirstName(
                LibRNG.expand(MAX_UINT, randomness, SALT_2)
            )
        );
        //lastName
        dna = LibShadowcornDNA.setLastName(
            dna,
            LibNames.getRandomLastName(
                LibRNG.expand(MAX_UINT, randomness, SALT_3)
            )
        );

        LibShadowcornDNA.setDNA(tokenId, dna);
    }

    function getRarityByPoolId(
        uint256 terminusPoolId
    ) internal view returns (uint256 rarity) {
        if (terminusPoolId == LibShadowcorn.commonEggPoolId()) {
            rarity = 1;
        }
        if (terminusPoolId == LibShadowcorn.rareEggPoolId()) {
            rarity = 2;
        }
        if (terminusPoolId == LibShadowcorn.mythicEggPoolId()) {
            rarity = 3;
        }
    }
}
