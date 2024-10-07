// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutShadowcornDiamond} from './CutShadowcornDiamond.sol';

// @TODO: Implement all facet functions that should be accessible to the public
/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract CutShadowcornDebugDiamond is CutShadowcornDiamond {
    function debugGetShadowcornMetadata(
        uint256 tokenId
    )
        external
        view
        returns (
            uint256 version,
            string memory locked,
            bool limitedEdition,
            uint256 class,
            uint256 rarity,
            uint256 tier,
            uint256 might,
            uint256 wickedness,
            uint256 tenacity,
            uint256 cunning,
            uint256 arcana,
            uint256 firstName,
            uint256 lastName
        )
    {}

    function debugGetClassNameFromId(uint256 classId) external view returns (string memory) {}

    function debugGetRarityNameFromId(uint256 rarityId) external view returns (string memory) {}

    function debugGetVRFRequestIdByTokenId(uint256 tokenId) external view returns (bytes32 vrfRequestId) {}

    function debugHatchIsInProgress(uint256 tokenId) external view returns (bool) {}

    function debugTokenIdByVRFRequestId(bytes32 vrfRequestId) external view returns (uint256) {}

    function debugSetRarityTotalsByClass(uint256 class, uint256 rarity, uint256 total) external {}

    function debugChangeRoundTripOwner(uint256 tokenId, address newOwner) external {}

    function debugMintShadowcorns(address receiver, uint256 commons, uint256 rares, uint256 mythics) external {}

    function debugBurn(uint256 tokenId) external {}
}
