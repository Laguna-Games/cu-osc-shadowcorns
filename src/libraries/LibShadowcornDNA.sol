// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibBin} from "../../lib/cu-osc-common/src/libraries/LibBin.sol";

import {LibShadowcorn} from "./LibShadowcorn.sol";

library LibShadowcornDNA {
    uint256 internal constant MAX = type(uint256).max;

    //  version is in bits 0-7 = 0b11111111
    uint internal constant DNA_VERSION_MASK = 0xFF;
    //  locked is in bit 8 = 0b100000000
    uint internal constant DNA_LOCKED_MASK = 0x100;
    //  limitedEdition is in bit 9 = 0b1000000000
    uint internal constant DNA_LIMITEDEDITION_MASK = 0x200;
    //  class is in bits 10-12 = 0b1110000000000
    uint internal constant DNA_CLASS_MASK = 0x1C00;
    //  rarity is in bits 13-14 = 0b110000000000000
    uint internal constant DNA_RARITY_MASK = 0x6000;
    //  tier is in bits 15-22 = 0b11111111000000000000000
    uint internal constant DNA_TIER_MASK = 0x7F8000;
    //  might is in bits 23-32 = 0b111111111100000000000000000000000
    uint internal constant DNA_MIGHT_MASK = 0x1FF800000;
    //  wickedness is in bits 33-42 = 0b1111111111000000000000000000000000000000000
    uint internal constant DNA_WICKEDNESS_MASK = 0x7FE00000000;
    //  tenacity is in bits 43-52 = 0b11111111110000000000000000000000000000000000000000000
    uint internal constant DNA_TENACITY_MASK = 0x1FF80000000000;
    //  cunning is in bits 53-62 = 0b111111111100000000000000000000000000000000000000000000000000000
    uint internal constant DNA_CUNNING_MASK = 0x7FE0000000000000;
    //  arcana is in bits 63-72 = 0b1111111111000000000000000000000000000000000000000000000000000000000000000
    uint internal constant DNA_ARCANA_MASK = 0x1FF8000000000000000;
    //  firstName is in bits 73-82 = 0b11111111110000000000000000000000000000000000000000000000000000000000000000000000000
    uint internal constant DNA_FIRSTNAME_MASK = 0x7FE000000000000000000;
    //  lastName is in bits 83-92 = 0b111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000
    uint internal constant DNA_LASTNAME_MASK = 0x1FF800000000000000000000;

    event DNAUpdated(uint256 tokenId, uint256 dna);

    function getDNA(uint256 _tokenId) internal view returns (uint256) {
        return LibShadowcorn.shadowcornDNA(_tokenId);
    }

    function setDNA(uint256 _tokenId, uint256 _dna) internal returns (uint256) {
        require(_dna > 0, "LibShadowcornDNA: cannot set 0 DNA");
        LibShadowcorn.setShadowcornDNA(_tokenId, _dna);
        emit DNAUpdated(_tokenId, _dna);
        return _dna;
    }

    //  The currently supported DNA version - all DNA should be at this number,
    //  or lower if migrating...
    function targetDNAVersion() internal view returns (uint256) {
        return LibShadowcorn.targetDNAVersion();
    }

    function enforceDNAVersionMatch(uint256 _dna) internal view {
        require(
            getVersion(_dna) == targetDNAVersion(),
            "LibShadowcornDNA: Invalid DNA version"
        );
    }

    function enforceUnicornIsTransferable(uint256 tokenId) internal view {
        require(
            !getLocked(getDNA(tokenId)),
            "LibShadowcornDNA: Shadowcorn is locked."
        );
    }

    function setVersion(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_VERSION_MASK);
    }

    function getVersion(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_VERSION_MASK);
    }

    function setLocked(
        uint256 _dna,
        bool _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_LOCKED_MASK);
    }

    function getLocked(uint256 _dna) internal pure returns (bool) {
        return LibBin.extractBool(_dna, DNA_LOCKED_MASK);
    }

    function setLimitedEdition(
        uint256 _dna,
        bool _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_LIMITEDEDITION_MASK);
    }

    function getLimitedEdition(uint256 _dna) internal pure returns (bool) {
        return LibBin.extractBool(_dna, DNA_LIMITEDEDITION_MASK);
    }

    function setClass(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_CLASS_MASK);
    }

    function getClass(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_CLASS_MASK);
    }

    function setRarity(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_RARITY_MASK);
    }

    function getRarity(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_RARITY_MASK);
    }

    function setTier(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_TIER_MASK);
    }

    function getTier(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_TIER_MASK);
    }

    //  NOTE: Stats are saved at 1/10th scale
    function setMight(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_MIGHT_MASK);
    }

    function getMight(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_MIGHT_MASK) * 10;
    }

    //  NOTE: Stats are saved at 1/10th scale
    function setWickedness(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_WICKEDNESS_MASK);
    }

    function getWickedness(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_WICKEDNESS_MASK) * 10;
    }

    //  NOTE: Stats are saved at 1/10th scale
    function setTenacity(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_TENACITY_MASK);
    }

    function getTenacity(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_TENACITY_MASK) * 10;
    }

    //  NOTE: Stats are saved at 1/10th scale
    function setCunning(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_CUNNING_MASK);
    }

    function getCunning(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_CUNNING_MASK) * 10;
    }

    //  NOTE: Stats are saved at 1/10th scale
    function setArcana(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_ARCANA_MASK);
    }

    function getArcana(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_ARCANA_MASK) * 10;
    }

    function setFirstName(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_FIRSTNAME_MASK);
    }

    function getFirstName(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_FIRSTNAME_MASK);
    }

    function setLastName(
        uint256 _dna,
        uint256 _val
    ) internal pure returns (uint256) {
        return LibBin.splice(_dna, _val, DNA_LASTNAME_MASK);
    }

    function getLastName(uint256 _dna) internal pure returns (uint256) {
        return LibBin.extract(_dna, DNA_LASTNAME_MASK);
    }
}
