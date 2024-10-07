// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {LibConstraints} from "../../lib/cu-osc-common/src/libraries/LibConstraints.sol";

contract StatsFragment {
    function initializeData() external {}

    function checkConstraint(
        address owner,
        LibConstraints.Constraint memory constraint
    ) external view returns (bool) {}

    function checkConstraintForUserAndExtraTokens(
        address owner,
        LibConstraints.Constraint memory constraint,
        uint256[] memory extraTokensToCheck
    ) external view returns (bool) {}

    function getClass(uint256 tokenId) public view returns (uint256 class) {}

    function getClassRarityAndStat(
        uint256 tokenId,
        uint256 statId
    ) public view returns (uint256 class, uint256 rarity, uint256 stat) {}

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
    {}

    function getMight(uint256 tokenId) public view returns (uint256 might) {}

    function getWickedness(
        uint256 tokenId
    ) public view returns (uint256 wickedness) {}

    function getTenacity(
        uint256 tokenId
    ) public view returns (uint256 tenacity) {}

    function getCunning(
        uint256 tokenId
    ) public view returns (uint256 cunning) {}

    function getArcana(uint256 tokenId) public view returns (uint256 arcana) {}

    function getRarity(uint256 tokenId) public view returns (uint256 rarity) {}
}
