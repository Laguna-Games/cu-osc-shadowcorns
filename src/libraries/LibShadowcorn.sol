// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";

/// @custom:storage-location erc7201:games.laguna.shadowcorns.shadowcorns
library LibShadowcorn {
    bytes32 constant SHADOWCORN_STORAGE_POSITION =
        keccak256(
            abi.encode(
                uint256(keccak256("games.laguna.shadowcorns.shadowcorns")) - 1
            )
        ) & ~bytes32(uint256(0xff));

    struct ShadowcornStorage {
        // DNA version
        uint256 targetDNAVersion;
        // mapping from shadowcorn tokenId to shadowcorn DNA
        mapping(uint256 => uint256) shadowcornDNA;
        //classId => rarityId => shadowcorn image URI
        mapping(uint256 => mapping(uint256 => string)) shadowcornImage;
        mapping(uint256 => uint256) shadowcornBirthnight;
        uint256 commonEggPoolId;
        uint256 rareEggPoolId;
        uint256 mythicEggPoolId;
    }

    function shadowcornStorage()
        internal
        pure
        returns (ShadowcornStorage storage scs)
    {
        bytes32 position = SHADOWCORN_STORAGE_POSITION;
        assembly {
            scs.slot := position
        }
    }

    function setTargetDNAVersion(uint256 newTargetDNAVersion) internal {
        // We enforce contract ownership directly here because this functionality needs to be highly
        // protected.
        LibContractOwner.enforceIsContractOwner();
        ShadowcornStorage storage scs = shadowcornStorage();
        require(
            newTargetDNAVersion > scs.targetDNAVersion,
            "LibShadowcorn: new version must be greater than current"
        );
        require(
            newTargetDNAVersion < 256,
            "LibShadowcorn: version cannot be greater than 8 bits"
        );
        scs.targetDNAVersion = newTargetDNAVersion;
    }

    function targetDNAVersion() internal view returns (uint256) {
        return shadowcornStorage().targetDNAVersion;
    }

    function setShadowcornDNA(uint256 tokenId, uint256 newDNA) internal {
        ShadowcornStorage storage scs = shadowcornStorage();
        scs.shadowcornDNA[tokenId] = newDNA;
    }

    function shadowcornDNA(uint256 tokenId) internal view returns (uint256) {
        return shadowcornStorage().shadowcornDNA[tokenId];
    }

    function setShadowcornImage(string[15] memory newShadowcornImage) internal {
        ShadowcornStorage storage scs = shadowcornStorage();

        scs.shadowcornImage[1][1] = newShadowcornImage[0];
        scs.shadowcornImage[2][1] = newShadowcornImage[1];
        scs.shadowcornImage[3][1] = newShadowcornImage[2];
        scs.shadowcornImage[4][1] = newShadowcornImage[3];
        scs.shadowcornImage[5][1] = newShadowcornImage[4];

        scs.shadowcornImage[1][2] = newShadowcornImage[5];
        scs.shadowcornImage[2][2] = newShadowcornImage[6];
        scs.shadowcornImage[3][2] = newShadowcornImage[7];
        scs.shadowcornImage[4][2] = newShadowcornImage[8];
        scs.shadowcornImage[5][2] = newShadowcornImage[9];

        scs.shadowcornImage[1][3] = newShadowcornImage[10];
        scs.shadowcornImage[2][3] = newShadowcornImage[11];
        scs.shadowcornImage[3][3] = newShadowcornImage[12];
        scs.shadowcornImage[4][3] = newShadowcornImage[13];
        scs.shadowcornImage[5][3] = newShadowcornImage[14];
    }

    function shadowcornImage(
        uint256 classId,
        uint256 rarityId
    ) internal view returns (string memory) {
        return shadowcornStorage().shadowcornImage[classId][rarityId];
    }

    function setCommonEggPoolId(uint256 newCommonEggPoolId) internal {
        LibContractOwner.enforceIsContractOwner();
        shadowcornStorage().commonEggPoolId = newCommonEggPoolId;
    }

    function commonEggPoolId() internal view returns (uint256) {
        return shadowcornStorage().commonEggPoolId;
    }

    function setRareEggPoolId(uint256 newRareEggPoolId) internal {
        LibContractOwner.enforceIsContractOwner();
        shadowcornStorage().rareEggPoolId = newRareEggPoolId;
    }

    function rareEggPoolId() internal view returns (uint256) {
        return shadowcornStorage().rareEggPoolId;
    }

    function setMythicEggPoolId(uint256 newMythicEggPoolId) internal {
        LibContractOwner.enforceIsContractOwner();
        shadowcornStorage().mythicEggPoolId = newMythicEggPoolId;
    }

    function mythicEggPoolId() internal view returns (uint256) {
        return shadowcornStorage().mythicEggPoolId;
    }
}
