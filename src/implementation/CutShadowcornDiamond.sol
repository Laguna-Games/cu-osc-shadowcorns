// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutDiamond} from "../../lib/cu-osc-common-tokens/lib/cu-osc-diamond-template/src/diamond/CutDiamond.sol";
import {ERC721Fragment} from "../../lib/cu-osc-common-tokens/src/implementation/ERC721Fragment.sol";
import {HatchingFragment} from "./HatchingFragment.sol";
import {NamesFragment} from "./NamesFragment.sol";
import {RNGFragment} from "./RNGFragment.sol";
import {StatsFragment} from "./StatsFragment.sol";

// @TODO: Implement all facet functions that should be accessible to the public
/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract CutShadowcornDiamond is
    CutDiamond,
    ERC721Fragment,
    HatchingFragment,
    NamesFragment,
    RNGFragment,
    StatsFragment
{}
