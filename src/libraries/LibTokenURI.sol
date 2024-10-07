// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibBase64} from "../../lib/cu-osc-common/src/libraries/LibBase64.sol";

import {LibShadowcornDNA} from "./LibShadowcornDNA.sol";
import {LibNames} from "./LibNames.sol";
import {LibShadowcorn} from "./LibShadowcorn.sol";

import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

library LibTokenURI {
    struct JSONShadowcornData {
        string fullName;
        string image;
        string locked;
        string class;
        string rarity;
        string birthnight;
        string tier;
        string might;
        string wickedness;
        string tenacity;
        string cunning;
        string arcana;
    }

    function getJSONReadyShadowcornData(
        uint256 tokenId
    ) internal view returns (JSONShadowcornData memory) {
        uint256 dna = LibShadowcornDNA.getDNA(tokenId);
        uint256 classId = LibShadowcornDNA.getClass(dna);
        uint256 rarityId = LibShadowcornDNA.getRarity(dna);
        return
            JSONShadowcornData(
                LibNames.getFullName(tokenId),
                LibShadowcorn.shadowcornStorage().shadowcornImage[classId][
                    rarityId
                ],
                LibShadowcornDNA.getLocked(dna) ? "Locked" : "Unlocked",
                getClassNameFromId(classId),
                getRarityNameFromId(rarityId),
                Strings.toString(
                    LibShadowcorn.shadowcornStorage().shadowcornBirthnight[
                        tokenId
                    ]
                ),
                Strings.toString(LibShadowcornDNA.getTier(dna)),
                Strings.toString(LibShadowcornDNA.getMight(dna)),
                Strings.toString(LibShadowcornDNA.getWickedness(dna)),
                Strings.toString(LibShadowcornDNA.getTenacity(dna)),
                Strings.toString(LibShadowcornDNA.getCunning(dna)),
                Strings.toString(LibShadowcornDNA.getArcana(dna))
            );
    }

    // @TODO: benchmark the gas cost of abi.encodePacked against string.concat
    function generateTokenURI(
        uint256 tokenId
    ) internal view returns (string memory) {
        JSONShadowcornData memory shadowcornData = getJSONReadyShadowcornData(
            tokenId
        );
        bytes memory json = abi.encodePacked(
            '{"token_id":"',
            Strings.toString(tokenId),
            '","name":"',
            shadowcornData.fullName,
            '","external_url":"https://www.cryptounicorns.fun","image":"',
            shadowcornData.image,
            '","metadata_version":1,"attributes":[{"trait_type":"Game Lock","value":"',
            shadowcornData.locked,
            '"},{"trait_type":"Class","value":"',
            shadowcornData.class,
            '"},{"trait_type":"Rarity","value":"',
            shadowcornData.rarity,
            '"},{"trait_type":"Birthnight","display_type":"date","value":',
            shadowcornData.birthnight
        );

        json = abi.encodePacked(
            json,
            '},{"trait_type":"Tier","display_type":"number","value":',
            shadowcornData.tier,
            '},{"trait_type":"Might","display_type":"number","value":',
            shadowcornData.might,
            '},{"trait_type":"Wickedness","display_type":"number","value":',
            shadowcornData.wickedness,
            '},{"trait_type":"Tenacity","display_type":"number","value":',
            shadowcornData.tenacity,
            '},{"trait_type":"Cunning","display_type":"number","value":',
            shadowcornData.cunning,
            '},{"trait_type":"Arcana","display_type":"number","value":',
            shadowcornData.arcana,
            "}]}"
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    LibBase64.encode(json)
                )
            );
    }

    function getClassNameFromId(
        uint256 classId
    ) internal pure returns (string memory) {
        if (classId == 1) {
            return "Fire";
        }
        if (classId == 2) {
            return "Slime";
        }
        if (classId == 3) {
            return "Volt";
        }
        if (classId == 4) {
            return "Soul";
        }
        if (classId == 5) {
            return "Nebula";
        }
        return "None";
    }

    function getRarityNameFromId(
        uint256 rarityId
    ) internal pure returns (string memory) {
        if (rarityId == 1) {
            return "Common";
        }
        if (rarityId == 2) {
            return "Rare";
        }
        if (rarityId == 3) {
            return "Mythic";
        }
        return "None";
    }
}
