// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract NamesFragment {
    function lookupFirstName(uint256 _nameId) external view returns (string memory) {}

    function lookupLastName(uint256 _nameId) external view returns (string memory) {}

    function getFullName(uint256 _tokenId) external view returns (string memory) {}

    function getFullNameFromDNA(uint256 _dna) public view returns (string memory) {}
}
