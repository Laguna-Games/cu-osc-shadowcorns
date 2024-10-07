// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";
import {IConstraintFacet} from "../../lib/cu-osc-common/src/interfaces/IConstraintFacet.sol";
import {LibConstraintOperator} from "../../lib/cu-osc-common/src/libraries/LibConstraintOperator.sol";

import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";
import {LibStats} from "../libraries/LibStats.sol";
import {LibShadowcornDNA} from "../libraries/LibShadowcornDNA.sol";
import {IShadowcornStatsFacet} from "../interfaces/IShadowcornStatsFacet.sol";

contract StatsFacet is IShadowcornStatsFacet, IConstraintFacet {
    function initializeData() external {
        LibContractOwner.enforceIsContractOwner();
        LibStats.initializeData();
    }

    /// @notice Check if constraint for an owner is met
    /// @dev This uses @cu-common/LibConstraints and @lg-commons/LibOperator to check. The constraint must be of type LibConstraints.Constraint and be one of the ConstraintType.SHADOWCORN_* constraints
    /// @param owner The owner to check
    /// @param constraint The constraint to check
    /// @return isMet True if the constraint is met, false otherwise
    function checkConstraint(
        address owner,
        LibConstraints.Constraint memory constraint
    ) external view returns (bool) {
        LibConstraints.ConstraintType constraintType = LibConstraints
            .ConstraintType(constraint.constraintType);
        if (
            constraintType >= LibConstraints.ConstraintType.SHADOWCORN_RARITY &&
            constraintType <= LibConstraints.ConstraintType.SHADOWCORN_ARCANA
        ) {
            return LibStats.checkStatConstraintForOwner(owner, constraint);
        }
        if (
            constraintType == LibConstraints.ConstraintType.BALANCE_SHADOWCORN
        ) {
            return
                LibStats.checkBalanceConstraint(
                    owner,
                    constraint.operator,
                    constraint.value
                );
        }
        revert("StatsFacet: Invalid constraint type");
    }

    /// @notice Check if constraint for an owner or for the extraTokens is met
    /// @dev This uses @lg-commons/LibConstraintOperator to check.  This makes sense for staked tokens that don't belong to the user, but have to be taken into account.
    /// @param owner Will check if the constraint is met any tokens owned by this address
    /// @param constraint The constraint to check, must be one of the constraint types and operators defined in @lg-commons/LibConstraintOperator
    /// @param extraTokensToCheck Will check if the constraint is met for these extra token ids
    /// @return isMet True if the constraint is met, false otherwise
    function checkConstraintForUserAndExtraTokens(
        address owner,
        LibConstraints.Constraint memory constraint,
        uint256[] memory extraTokensToCheck
    ) external view returns (bool) {
        LibConstraints.ConstraintType constraintType = LibConstraints
            .ConstraintType(constraint.constraintType);
        if (
            constraintType >= LibConstraints.ConstraintType.SHADOWCORN_RARITY &&
            constraintType <= LibConstraints.ConstraintType.SHADOWCORN_ARCANA
        ) {
            return
                LibStats.checkStatConstraintForOwner(owner, constraint) ||
                LibStats.checkStatConstraintForTokens(
                    extraTokensToCheck,
                    constraint
                );
        }
        if (
            constraintType == LibConstraints.ConstraintType.BALANCE_SHADOWCORN
        ) {
            return
                LibStats.checkBalanceConstraintWithExtraTokens(
                    owner,
                    constraint.operator,
                    constraint.value,
                    extraTokensToCheck
                );
        }
        revert("StatsFacet: Invalid constraint type");
    }

    function getClass(uint256 tokenId) public view returns (uint256 class) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        class = LibShadowcornDNA.getClass(dna);
    }

    //  For MinionHatchery
    function getClassRarityAndStat(
        uint256 tokenId,
        uint256 statId
    ) public view returns (uint256 class, uint256 rarity, uint256 stat) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        class = LibShadowcornDNA.getClass(dna);
        rarity = LibShadowcornDNA.getRarity(dna);

        if (statId == LibStats.MIGHT) {
            stat = LibShadowcornDNA.getMight(dna);
        } else if (statId == LibStats.WICKEDNESS) {
            stat = LibShadowcornDNA.getWickedness(dna);
        } else if (statId == LibStats.TENACITY) {
            stat = LibShadowcornDNA.getTenacity(dna);
        } else if (statId == LibStats.CUNNING) {
            stat = LibShadowcornDNA.getCunning(dna);
        } else if (statId == LibStats.ARCANA) {
            stat = LibShadowcornDNA.getArcana(dna);
        }
    }

    function getStats(
        uint256 tokenId
    )
        public
        view
        returns (
            uint256 might,
            uint256 wickedness,
            uint256 tenacity,
            uint256 cunning,
            uint256 arcana
        )
    {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        might = LibShadowcornDNA.getMight(dna);
        wickedness = LibShadowcornDNA.getWickedness(dna);
        tenacity = LibShadowcornDNA.getTenacity(dna);
        cunning = LibShadowcornDNA.getCunning(dna);
        arcana = LibShadowcornDNA.getArcana(dna);
    }

    function getMight(uint256 tokenId) public view returns (uint256 might) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        might = LibShadowcornDNA.getMight(dna);
    }

    function getWickedness(
        uint256 tokenId
    ) public view returns (uint256 wickedness) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        wickedness = LibShadowcornDNA.getWickedness(dna);
    }

    function getTenacity(
        uint256 tokenId
    ) public view returns (uint256 tenacity) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        tenacity = LibShadowcornDNA.getTenacity(dna);
    }

    function getCunning(uint256 tokenId) public view returns (uint256 cunning) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        cunning = LibShadowcornDNA.getCunning(dna);
    }

    function getArcana(uint256 tokenId) public view returns (uint256 arcana) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        arcana = LibShadowcornDNA.getArcana(dna);
    }

    function getRarity(uint256 tokenId) public view returns (uint256 rarity) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        rarity = LibShadowcornDNA.getRarity(dna);
    }
}
