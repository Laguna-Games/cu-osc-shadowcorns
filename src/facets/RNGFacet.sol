// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";
import {LibHatching} from "../libraries/LibHatching.sol";

contract RNGFacet {
    function rawFulfillRandomness(
        uint256 nonce,
        uint256[] calldata rngList
    ) external {
        LibRNG.rngReceived(nonce);
        LibHatching.hatchingFulfillRandomness(nonce, rngList[0]);
    }
}
