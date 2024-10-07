// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibConstraintOperator} from "../../lib/cu-osc-common/src/libraries/LibConstraintOperator.sol";
import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";

import {LibShadowcornDNA} from "./LibShadowcornDNA.sol";

/// @custom:storage-location erc7201:games.laguna.shadowcorns.stats
library LibStats {
    uint256 constant MIGHT = 1;
    uint256 constant WICKEDNESS = 2;
    uint256 constant TENACITY = 3;
    uint256 constant CUNNING = 4;
    uint256 constant ARCANA = 5;

    //  These should move somewhere better
    uint256 constant FIRE = 1;
    uint256 constant SLIME = 2;
    uint256 constant VOLT = 3;
    uint256 constant SOUL = 4;
    uint256 constant NEBULA = 5;

    //  These should move somewhere better
    uint256 constant COMMON = 1;
    uint256 constant RARE = 2;
    uint256 constant MYTHIC = 3;

    uint256 private constant SALT_1 = 1;
    uint256 private constant SALT_2 = 2;
    uint256 private constant SALT_3 = 3;
    uint256 private constant SALT_4 = 4;
    uint256 private constant SALT_5 = 5;

    bytes32 constant STATS_STORAGE_POSITION =
        keccak256(
            abi.encode(uint256(keccak256("games.laguna.shadowcorns.stats")) - 1)
        ) & ~bytes32(uint256(0xff));

    struct StatsStorage {
        //  [class][stat] => floor
        mapping(uint256 => mapping(uint256 => uint256)) statFloorByClass;
        //  [class][stat] => range
        mapping(uint256 => mapping(uint256 => uint256)) statRangeByClass;
        //  [rarity] => scalar
        mapping(uint256 => uint256) rarityScalar;
    }

    function statsStorage() internal pure returns (StatsStorage storage ss) {
        bytes32 position = STATS_STORAGE_POSITION;
        assembly {
            ss.slot := position
        }
    }

    function rollRandomMight(
        uint256 class,
        uint256 rarity,
        uint256 randomness
    ) internal view returns (uint256) {
        StatsStorage storage ss = statsStorage();
        return
            (ss.rarityScalar[rarity] *
                (ss.statFloorByClass[class][MIGHT] +
                    LibRNG.expand(
                        ss.statRangeByClass[class][MIGHT],
                        randomness,
                        SALT_1
                    ))) / 100;
    }

    function rollRandomWickedness(
        uint256 class,
        uint256 rarity,
        uint256 randomness
    ) internal view returns (uint256) {
        StatsStorage storage ss = statsStorage();
        return
            (ss.rarityScalar[rarity] *
                (ss.statFloorByClass[class][WICKEDNESS] +
                    LibRNG.expand(
                        ss.statRangeByClass[class][WICKEDNESS],
                        randomness,
                        SALT_2
                    ))) / 100;
    }

    function rollRandomTenacity(
        uint256 class,
        uint256 rarity,
        uint256 randomness
    ) internal view returns (uint256) {
        StatsStorage storage ss = statsStorage();
        return
            (ss.rarityScalar[rarity] *
                (ss.statFloorByClass[class][TENACITY] +
                    LibRNG.expand(
                        ss.statRangeByClass[class][TENACITY],
                        randomness,
                        SALT_3
                    ))) / 100;
    }

    function rollRandomCunning(
        uint256 class,
        uint256 rarity,
        uint256 randomness
    ) internal view returns (uint256) {
        StatsStorage storage ss = statsStorage();
        return
            (ss.rarityScalar[rarity] *
                (ss.statFloorByClass[class][CUNNING] +
                    LibRNG.expand(
                        ss.statRangeByClass[class][CUNNING],
                        randomness,
                        SALT_4
                    ))) / 100;
    }

    function rollRandomArcana(
        uint256 class,
        uint256 rarity,
        uint256 randomness
    ) internal view returns (uint256) {
        StatsStorage storage ss = statsStorage();
        return
            (ss.rarityScalar[rarity] *
                (ss.statFloorByClass[class][ARCANA] +
                    LibRNG.expand(
                        ss.statRangeByClass[class][ARCANA],
                        randomness,
                        SALT_5
                    ))) / 100;
    }

    function initializeData() internal {
        StatsStorage storage ss = statsStorage();

        ss.rarityScalar[COMMON] = 110; //  Pre-multiplied by 100 (ie. 110% == 1.1)
        ss.rarityScalar[RARE] = 130;
        ss.rarityScalar[MYTHIC] = 160;

        ss.statFloorByClass[FIRE][MIGHT] = 30;
        ss.statFloorByClass[FIRE][WICKEDNESS] = 20;
        ss.statFloorByClass[FIRE][TENACITY] = 10;
        ss.statFloorByClass[FIRE][CUNNING] = 10;
        ss.statFloorByClass[FIRE][ARCANA] = 20;
        ss.statRangeByClass[FIRE][MIGHT] = 30;
        ss.statRangeByClass[FIRE][WICKEDNESS] = 20;
        ss.statRangeByClass[FIRE][TENACITY] = 20;
        ss.statRangeByClass[FIRE][CUNNING] = 20;
        ss.statRangeByClass[FIRE][ARCANA] = 20;

        ss.statFloorByClass[SLIME][MIGHT] = 20;
        ss.statFloorByClass[SLIME][WICKEDNESS] = 30;
        ss.statFloorByClass[SLIME][TENACITY] = 20;
        ss.statFloorByClass[SLIME][CUNNING] = 10;
        ss.statFloorByClass[SLIME][ARCANA] = 10;
        ss.statRangeByClass[SLIME][MIGHT] = 20;
        ss.statRangeByClass[SLIME][WICKEDNESS] = 30;
        ss.statRangeByClass[SLIME][TENACITY] = 20;
        ss.statRangeByClass[SLIME][CUNNING] = 20;
        ss.statRangeByClass[SLIME][ARCANA] = 20;

        ss.statFloorByClass[VOLT][MIGHT] = 10;
        ss.statFloorByClass[VOLT][WICKEDNESS] = 20;
        ss.statFloorByClass[VOLT][TENACITY] = 30;
        ss.statFloorByClass[VOLT][CUNNING] = 20;
        ss.statFloorByClass[VOLT][ARCANA] = 10;
        ss.statRangeByClass[VOLT][MIGHT] = 20;
        ss.statRangeByClass[VOLT][WICKEDNESS] = 20;
        ss.statRangeByClass[VOLT][TENACITY] = 30;
        ss.statRangeByClass[VOLT][CUNNING] = 20;
        ss.statRangeByClass[VOLT][ARCANA] = 20;

        ss.statFloorByClass[SOUL][MIGHT] = 10;
        ss.statFloorByClass[SOUL][WICKEDNESS] = 10;
        ss.statFloorByClass[SOUL][TENACITY] = 20;
        ss.statFloorByClass[SOUL][CUNNING] = 30;
        ss.statFloorByClass[SOUL][ARCANA] = 20;
        ss.statRangeByClass[SOUL][MIGHT] = 20;
        ss.statRangeByClass[SOUL][WICKEDNESS] = 20;
        ss.statRangeByClass[SOUL][TENACITY] = 20;
        ss.statRangeByClass[SOUL][CUNNING] = 30;
        ss.statRangeByClass[SOUL][ARCANA] = 20;

        ss.statFloorByClass[NEBULA][MIGHT] = 20;
        ss.statFloorByClass[NEBULA][WICKEDNESS] = 10;
        ss.statFloorByClass[NEBULA][TENACITY] = 10;
        ss.statFloorByClass[NEBULA][CUNNING] = 20;
        ss.statFloorByClass[NEBULA][ARCANA] = 30;
        ss.statRangeByClass[NEBULA][MIGHT] = 20;
        ss.statRangeByClass[NEBULA][WICKEDNESS] = 20;
        ss.statRangeByClass[NEBULA][TENACITY] = 20;
        ss.statRangeByClass[NEBULA][CUNNING] = 20;
        ss.statRangeByClass[NEBULA][ARCANA] = 30;
    }

    /// @notice Check if balance constraint for owner is met.
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check.
    /// @param owner The owner to check how many tokens they have
    /// @param operator The operator to check
    /// @param value The value to check against
    function checkBalanceConstraint(
        address owner,
        uint256 operator,
        uint256 value
    ) internal view returns (bool) {
        return
            LibConstraintOperator.checkOperator(
                LibERC721.erc721Storage().balances[owner],
                operator,
                value
            );
    }

    /// @notice Check if balance constraint for (owner + list of extra tokens) is met.
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check. This makes sense for staked tokens that don't belong to the user, but have to be taken into account.
    /// @param owner The owner to check how many tokens they have
    /// @param operator The operator to check
    /// @param value The value to check against
    /// @param extraTokensToCheck The extra tokens to take into account
    function checkBalanceConstraintWithExtraTokens(
        address owner,
        uint256 operator,
        uint256 value,
        uint256[] memory extraTokensToCheck
    ) internal view returns (bool) {
        return
            LibConstraintOperator.checkOperator(
                (LibERC721.erc721Storage().balances[owner] +
                    extraTokensToCheck.length),
                operator,
                value
            );
    }

    /// @notice Check if shadowcorn stat constraint for any shadowcorn that belongs to the owner is met.
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check. The constraint must be of type LibConstraints.Constraint and be one of the ConstraintType.SHADOWCORN_ constraints.
    /// @param owner The owner to check
    /// @param constraint The constraint to check
    /// @return isMet True if the constraint is met, false otherwise
    function checkStatConstraintForOwner(
        address owner,
        LibConstraints.Constraint memory constraint
    ) internal view returns (bool isMet) {
        //get all shadowcorns from owner
        uint256 i = 0;
        isMet = false;
        mapping(address => mapping(uint256 => uint256))
            storage ownedTokens = LibERC721.erc721Storage().ownedTokens;
        while (ownedTokens[owner][i] > 0 && isMet == false) {
            //for each shadowcorn, check if constraint is met
            isMet =
                isMet ||
                checkShadowcornMeetsConstraint(
                    ownedTokens[owner][i],
                    constraint
                );
            i++;
        }
    }

    /// @notice Check if shadowcorn stat constraint for any shadowcorn that belongs to the owner is met.
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check. The constraint must be of type LibConstraints.Constraint and be one of the ConstraintType.SHADOWCORN_ constraints.
    /// @param tokens The tokens to check
    /// @param constraint The constraint to check
    /// @return isMet True if the constraint is met, false otherwise
    function checkStatConstraintForTokens(
        uint256[] memory tokens,
        LibConstraints.Constraint memory constraint
    ) internal view returns (bool isMet) {
        isMet = false;
        for (uint256 i = 0; i < tokens.length && isMet == false; i++) {
            //for each shadowcorn, check if constraint is met
            isMet =
                isMet ||
                checkShadowcornMeetsConstraint(tokens[i], constraint);
        }
    }

    /// @notice Check if shadowcorn stat constraint for any shadowcorn that belongs to the owner is met.
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check. The constraint must be of type LibConstraints.Constraint and be one of the ConstraintType.SHADOWCORN_ constraints.
    /// @param owner The owner to check
    /// @param constraint The constraint to check
    /// @return isMet True if the constraint is met, false otherwise
    function checkStatConstraintWithExtraTokens(
        address owner,
        LibConstraints.Constraint memory constraint
    ) internal view returns (bool isMet) {
        //get all shadowcorns from owner
        uint256 i = 0;
        isMet = false;
        mapping(address => mapping(uint256 => uint256))
            storage ownedTokens = LibERC721.erc721Storage().ownedTokens;
        while (ownedTokens[owner][i] > 0 && isMet == false) {
            //for each shadowcorn, check if constraint is met
            isMet =
                isMet ||
                checkShadowcornMeetsConstraint(
                    ownedTokens[owner][i],
                    constraint
                );
            i++;
        }
    }

    /// @notice Check if a stat constraint for a specific shadowcorn is met.
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check. The constraint must be of type LibConstraints.Constraint and be one of the ConstraintType.SHADOWCORN_* constraints.
    /// @param shadowcornTokenId The shadowcorn to check
    /// @param constraint The constraint to check
    /// @return isMet True if the constraint is met, false otherwise
    function checkShadowcornMeetsConstraint(
        uint256 shadowcornTokenId,
        LibConstraints.Constraint memory constraint
    ) internal view returns (bool isMet) {
        uint256 shadowcornDNA = LibShadowcornDNA.getDNA(shadowcornTokenId);
        LibConstraints.ConstraintType constraintType = LibConstraints
            .ConstraintType(constraint.constraintType);
        if (constraintType == LibConstraints.ConstraintType.SHADOWCORN_CLASS) {
            require(
                constraint.operator ==
                    uint256(LibConstraintOperator.ConstraintOperator.EQUAL),
                "LibStats: checkShadowcornMeetsConstraint: Operator for class constraint must be EQUAL"
            );
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getClass(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
        if (constraintType == LibConstraints.ConstraintType.SHADOWCORN_RARITY) {
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getRarity(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
        if (constraintType == LibConstraints.ConstraintType.SHADOWCORN_MIGHT) {
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getMight(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
        if (
            constraintType ==
            LibConstraints.ConstraintType.SHADOWCORN_WICKEDNESS
        ) {
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getWickedness(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
        if (
            constraintType == LibConstraints.ConstraintType.SHADOWCORN_TENACITY
        ) {
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getTenacity(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
        if (
            constraintType == LibConstraints.ConstraintType.SHADOWCORN_CUNNING
        ) {
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getCunning(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
        if (constraintType == LibConstraints.ConstraintType.SHADOWCORN_ARCANA) {
            isMet = LibConstraintOperator.checkOperator(
                LibShadowcornDNA.getArcana(shadowcornDNA),
                constraint.operator,
                constraint.value
            );
        }
    }
}
