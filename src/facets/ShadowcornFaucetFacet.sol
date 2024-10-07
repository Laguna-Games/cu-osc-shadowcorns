// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";
import {LibShadowcornDNA} from "../libraries/LibShadowcornDNA.sol";
import {LibShadowcorn} from "../libraries/LibShadowcorn.sol";
import {LibTestnetDebugInterface} from "../../lib/cu-osc-common/src/libraries/LibTestnetDebugInterface.sol";
import {LibRNG} from "../../lib/cu-osc-common/src/libraries/LibRNG.sol";
import {LibStats} from "../libraries/LibStats.sol";
import {LibNames} from "../libraries/LibNames.sol";

contract ShadowcornFaucetFacet {
    function faucetMintShadowcorn(
        address to,
        uint8 class,
        uint8 rarity
    ) external {
        LibTestnetDebugInterface.enforceDebugger();

        require(
            class > 0 && class <= 5,
            "ShadowcornFaucetFacet: invalid class"
        );
        require(
            rarity > 0 && rarity <= 3,
            "ShadowcornFaucetFacet: invalid rarity"
        );

        uint256 tokenId = LibERC721.mintNextToken(to);
        uint256 dna = 0;
        dna = LibShadowcornDNA.setVersion(
            dna,
            LibShadowcornDNA.targetDNAVersion()
        );
        dna = LibShadowcornDNA.setRarity(dna, rarity);
        dna = LibShadowcornDNA.setClass(dna, class);
        dna = LibShadowcornDNA.setTier(dna, 1);
        dna = LibShadowcornDNA.setMight(
            dna,
            LibStats.rollRandomMight(class, rarity, LibRNG.getRuntimeRNG())
        );
        // //wickedness
        dna = LibShadowcornDNA.setWickedness(
            dna,
            LibStats.rollRandomWickedness(class, rarity, LibRNG.getRuntimeRNG())
        );
        // //tenacity
        dna = LibShadowcornDNA.setTenacity(
            dna,
            LibStats.rollRandomTenacity(class, rarity, LibRNG.getRuntimeRNG())
        );
        // //cunning
        dna = LibShadowcornDNA.setCunning(
            dna,
            LibStats.rollRandomCunning(class, rarity, LibRNG.getRuntimeRNG())
        );
        // //arcana
        dna = LibShadowcornDNA.setArcana(
            dna,
            LibStats.rollRandomArcana(class, rarity, LibRNG.getRuntimeRNG())
        );

        //firstName
        dna = LibShadowcornDNA.setFirstName(
            dna,
            LibNames.getRandomFirstName(LibRNG.getRuntimeRNG())
        );
        //lastName
        dna = LibShadowcornDNA.setLastName(
            dna,
            LibNames.getRandomLastName(LibRNG.getRuntimeRNG())
        );

        LibShadowcorn.shadowcornStorage().shadowcornBirthnight[tokenId] = block
            .timestamp;
        LibShadowcornDNA.setDNA(tokenId, dna);
    }
}
