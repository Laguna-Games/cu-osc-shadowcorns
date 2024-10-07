// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";
import {LibHatching} from "../libraries/LibHatching.sol";

contract HatchingFacet {
    function beginHatching(uint256 terminusPoolId) external {
        LibHatching.beginHatching(terminusPoolId);
    }

    function retryHatching(uint256 tokenId) external {
        LibHatching.retryHatching(tokenId);
    }

    function getHatchesStatus(
        address playerWallet
    ) external view returns (uint256[] memory, string[] memory) {
        return LibHatching.getHatchesStatus(playerWallet);
    }

    function getHatchesInProgress(
        address playerWallet
    ) external view returns (uint256[] memory, bool[] memory) {
        return LibHatching.getHatchesInProgress(playerWallet);
    }

    function setHatchingCosts(uint256 rbwCost, uint256 unimCost) external {
        LibContractOwner.enforceIsContractOwner();
        LibHatching.setHatchingCosts(rbwCost, unimCost);
    }
}
