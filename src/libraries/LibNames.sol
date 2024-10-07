// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibShadowcornDNA} from './LibShadowcornDNA.sol';

/// @custom:storage-location erc7201:games.laguna.shadowcorns.names
library LibNames {
    bytes32 constant NAMES_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.shadowcorns.names')) - 1)) & ~bytes32(uint256(0xff));
    struct NamesStorage {
        // nameIndex -> name string
        mapping(uint256 => string) firstNamesList;
        mapping(uint256 => string) lastNamesList;
        // Names which can be chosen by RNG for new lands (unordered)
        uint256[] validFirstNames;
        uint256[] validLastNames;
    }

    function namesStorage() internal pure returns (NamesStorage storage ns) {
        bytes32 position = NAMES_STORAGE_POSITION;
        assembly {
            ns.slot := position
        }
    }

    function resetFirstNamesList() internal {
        NamesStorage storage ns = namesStorage();
        delete ns.validFirstNames;
        for (uint16 i = 0; i < 1024; ++i) {
            delete ns.firstNamesList[i];
        }
    }

    function resetLastNamesList() internal {
        NamesStorage storage ns = namesStorage();
        delete ns.validLastNames;
        for (uint16 i = 0; i < 1024; ++i) {
            delete ns.lastNamesList[i];
        }
    }

    //  New names are automatically added as valid options for the RNG
    function registerFirstNames(uint256[] memory _ids, string[] memory _names) internal {
        require(_names.length == _ids.length, 'NameLoader: Mismatched id and name array lengths');
        NamesStorage storage ns = namesStorage();
        uint256 len = _ids.length;
        for (uint256 i = 0; i < len; ++i) {
            ns.firstNamesList[_ids[i]] = _names[i];
            ns.validFirstNames.push(_ids[i]);
        }
    }

    //  New names are automatically added as valid options for the RNG
    function registerLastNames(uint256[] memory _ids, string[] memory _names) internal {
        require(_names.length == _ids.length, 'NameLoader: Mismatched id and name array lengths');
        NamesStorage storage ns = namesStorage();
        uint256 len = _ids.length;
        for (uint256 i = 0; i < len; ++i) {
            ns.lastNamesList[_ids[i]] = _names[i];
            ns.validLastNames.push(_ids[i]);
        }
    }

    //  If _delete is TRUE, the name will no longer be retrievable, and
    //  any legacy DNA using that name will point to (undefined -> "").
    //  If FALSE, the name will continue to work for existing DNA,
    //  but the RNG will not assign the name to any new tokens.
    function retireFirstName(uint256 _id, bool _delete) internal returns (bool) {
        NamesStorage storage ns = namesStorage();
        uint256 len = ns.validFirstNames.length;
        if (len == 0) return true;
        for (uint256 i = 0; i < len; ++i) {
            if (ns.validFirstNames[i] == _id) {
                ns.validFirstNames[i] = ns.validFirstNames[len - 1];
                ns.validFirstNames.pop();
                if (_delete) {
                    delete ns.firstNamesList[_id];
                }
                return true;
            }
        }
        return false;
    }

    //  If _delete is TRUE, the name will no longer be retrievable, and
    //  any legacy DNA using that name will point to (undefined -> "").
    //  If FALSE, the name will continue to work for existing DNA,
    //  but the RNG will not assign the name to any new tokens.
    function retireLastName(uint256 _id, bool _delete) internal returns (bool) {
        NamesStorage storage ns = namesStorage();
        uint256 len = ns.validLastNames.length;
        if (len == 0) return true;
        for (uint256 i = 0; i < len; ++i) {
            if (ns.validLastNames[i] == _id) {
                ns.validLastNames[i] = ns.validLastNames[len - 1];
                ns.validLastNames.pop();
                if (_delete) {
                    delete ns.lastNamesList[_id];
                }
                return true;
            }
        }
        return false;
    }

    function lookupFirstName(uint256 _nameId) internal view returns (string memory) {
        return namesStorage().firstNamesList[_nameId];
    }

    function lookupLastName(uint256 _nameId) internal view returns (string memory) {
        return namesStorage().lastNamesList[_nameId];
    }

    function getFullName(uint256 _tokenId) internal view returns (string memory) {
        return getFullNameFromDNA(LibShadowcornDNA.getDNA(_tokenId));
    }

    function getFullNameFromDNA(uint256 _dna) internal view returns (string memory) {
        LibShadowcornDNA.enforceDNAVersionMatch(_dna);
        NamesStorage storage ns = namesStorage();
        return
            string(
                abi.encodePacked(
                    ns.firstNamesList[LibShadowcornDNA.getFirstName(_dna)],
                    ' ',
                    ns.lastNamesList[LibShadowcornDNA.getLastName(_dna)]
                )
            );
    }

    function getRandomFirstName(uint256 randomnessFirstName) internal view returns (uint256) {
        NamesStorage storage ns = namesStorage();
        require(ns.validFirstNames.length > 0, 'Names: First-name list is empty');
        return ns.validFirstNames[(randomnessFirstName % ns.validFirstNames.length)];
    }

    function getRandomLastName(uint256 randomnessLastName) internal view returns (uint256) {
        NamesStorage storage ns = namesStorage();
        require(ns.validLastNames.length > 0, 'Names: Last-name list is empty');
        return ns.validLastNames[(randomnessLastName % ns.validLastNames.length)];
    }
}
