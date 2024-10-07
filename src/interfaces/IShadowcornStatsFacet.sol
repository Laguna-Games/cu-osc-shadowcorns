// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IShadowcornStatsFacet {
    // //  Classes
    // uint256 constant FIRE = 1;
    // uint256 constant SLIME = 2;
    // uint256 constant VOLT = 3;
    // uint256 constant SOUL = 4;
    // uint256 constant NEBULA = 5;

    // //  Stats
    // uint256 constant MIGHT = 1;
    // uint256 constant WICKEDNESS = 2;
    // uint256 constant TENACITY = 3;
    // uint256 constant CUNNING = 4;
    // uint256 constant ARCANA = 5;

    // //  Rarities
    // uint256 constant COMMON = 1;
    // uint256 constant RARE = 2;
    // uint256 constant MYTHIC = 3;

    function getClass(uint256 tokenId) external view returns (uint256 class);

    function getClassRarityAndStat(
        uint256 tokenId,
        uint256 statId
    ) external view returns (uint256 class, uint256 rarity, uint256 stat);

    function getStats(
        uint256 tokenId
    ) external view returns (uint256 might, uint256 wickedness, uint256 tenacity, uint256 cunning, uint256 arcana);

    function getMight(uint256 tokenId) external view returns (uint256 might);

    function getWickedness(uint256 tokenId) external view returns (uint256 wickedness);

    function getTenacity(uint256 tokenId) external view returns (uint256 tenacity);

    function getCunning(uint256 tokenId) external view returns (uint256 cunning);

    function getArcana(uint256 tokenId) external view returns (uint256 arcana);

    function getRarity(uint256 tokenId) external view returns (uint256 rarity);
}
