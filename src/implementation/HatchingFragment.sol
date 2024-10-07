// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HatchingFragment {
    function beginHatching(uint256 terminusPoolId) external {}

    function retryHatching(uint256 tokenId) external {}

    function getHatchesStatus(address playerWallet) external view returns (uint256[] memory, string[] memory) {}

    function getHatchesInProgress(address playerWallet) external view returns (uint256[] memory, bool[] memory) {}

    function setHatchingCosts(uint256 rbwCost, uint256 unimCost) external {}
}
