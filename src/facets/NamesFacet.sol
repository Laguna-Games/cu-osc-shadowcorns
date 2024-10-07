// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibNames} from "../libraries/LibNames.sol";
import {LibContractOwner} from "../../lib/cu-osc-diamond-template/src/libraries/LibContractOwner.sol";

contract NamesFacet {
    function resetFirstNamesList() external {
        LibContractOwner.enforceIsContractOwner();
        LibNames.resetFirstNamesList();
    }

    function resetLastNamesList() external {
        LibContractOwner.enforceIsContractOwner();
        LibNames.resetLastNamesList();
    }

    //  New names are automatically added as valid options for the RNG
    function registerFirstNames(
        uint256[] memory _ids,
        string[] memory _names
    ) external {
        LibContractOwner.enforceIsContractOwner();
        LibNames.registerFirstNames(_ids, _names);
    }

    //  New names are automatically added as valid options for the RNG
    function registerLastNames(
        uint256[] memory _ids,
        string[] memory _names
    ) external {
        LibContractOwner.enforceIsContractOwner();
        LibNames.registerLastNames(_ids, _names);
    }

    //  If _delete is TRUE, the name will no longer be retrievable, and
    //  any legacy DNA using that name will point to (undefined -> "").
    //  If FALSE, the name will continue to work for existing DNA,
    //  but the RNG will not assign the name to any new tokens.
    function retireFirstName(
        uint256 _id,
        bool _delete
    ) external returns (bool) {
        LibContractOwner.enforceIsContractOwner();
        return LibNames.retireFirstName(_id, _delete);
    }

    //  If _delete is TRUE, the name will no longer be retrievable, and
    //  any legacy DNA using that name will point to (undefined -> "").
    //  If FALSE, the name will continue to work for existing DNA,
    //  but the RNG will not assign the name to any new tokens.
    function retireLastName(uint256 _id, bool _delete) external returns (bool) {
        LibContractOwner.enforceIsContractOwner();
        return LibNames.retireLastName(_id, _delete);
    }

    function lookupFirstName(
        uint256 _nameId
    ) external view returns (string memory) {
        return LibNames.lookupFirstName(_nameId);
    }

    function lookupLastName(
        uint256 _nameId
    ) external view returns (string memory) {
        return LibNames.lookupLastName(_nameId);
    }

    function getFullName(
        uint256 _tokenId
    ) external view returns (string memory) {
        return LibNames.getFullName(_tokenId);
    }

    function getFullNameFromDNA(
        uint256 _dna
    ) public view returns (string memory) {
        return LibNames.getFullNameFromDNA(_dna);
    }
}
