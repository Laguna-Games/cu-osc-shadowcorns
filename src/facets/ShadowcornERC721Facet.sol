// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Address} from "../../lib/openzeppelin-contracts/contracts/utils/Address.sol";
import {Context} from "../../lib/openzeppelin-contracts/contracts/utils/Context.sol";
import {Strings} from "../../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {LibERC721} from "../../lib/cu-osc-common-tokens/src/libraries/LibERC721.sol";

import {LibTokenURI} from "../libraries/LibTokenURI.sol";
import {LibShadowcornDNA} from "../libraries/LibShadowcornDNA.sol";

contract ShadowcornERC721Facet is
    Context /*, ERC165, IERC721, IERC721Metadata, IERC721Enumerable */
{
    using Address for address;
    using Strings for uint256;

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return LibERC721.balanceOf(owner);
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) external view returns (address) {
        return LibERC721.ownerOf(tokenId);
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view returns (string memory) {
        return LibERC721.erc721Storage().name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view returns (string memory) {
        return LibERC721.erc721Storage().symbol;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     * @dev See https://docs.opensea.io/docs/contract-level-metadata
     */
    function contractURI() public view returns (string memory) {
        return LibERC721.erc721Storage().contractURI;
    }

    /**
     * @dev Reference URI for the NFT license file hosted on Arweave permaweb.
     */
    function license() public view returns (string memory) {
        return LibERC721.erc721Storage().licenseURI;
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public {
        address owner = LibERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner ||
                LibERC721.isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        LibERC721.approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) external view returns (address) {
        return LibERC721.getApproved(tokenId);
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public {
        LibERC721.setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool) {
        return LibERC721.isApprovedForAll(owner, operator);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        require(
            LibERC721.isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        LibERC721.safeTransfer(from, to, tokenId, _data);
    }

    /**
     * The following methods add support for IERC721Enumerable.
     */

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return LibERC721.erc721Storage().allTokens.length;
    }

    /**
     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
     */
    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) public view returns (uint256) {
        require(
            index < balanceOf(owner),
            "ERC721Enumerable: owner index out of bounds"
        );
        return LibERC721.erc721Storage().ownedTokens[owner][index];
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     */
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(
            index < totalSupply(),
            "ERC721Enumerable: global index out of bounds"
        );
        return LibERC721.erc721Storage().allTokens[index];
    }

    /// @notice gets all tokens owned by a given address
    /// @param owner address to query
    /// @return tokens tokens owned by the address
    function getAllTokensByOwner(
        address owner
    ) external view returns (uint256[] memory) {
        return LibERC721.getAllTokensByOwner(owner);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return LibTokenURI.generateTokenURI(tokenId);
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(
            LibERC721.isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        LibShadowcornDNA.enforceUnicornIsTransferable(tokenId);
        LibERC721.transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        LibShadowcornDNA.enforceUnicornIsTransferable(tokenId);
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function burn(uint256 tokenId) public {
        require(
            LibERC721.isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: burn caller is not owner nor approved"
        );
        LibShadowcornDNA.enforceUnicornIsTransferable(tokenId);
        return LibERC721.burn(tokenId);
    }
}
