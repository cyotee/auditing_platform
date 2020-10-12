pragma solidity ^0.6.0;

import "./ERC721.sol";

contract ERC721NonTransferable is ERC721 {

    event TransferAttempted(address _from, address _to, uint256 _tokenId, uint256 _time, string _message);

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        emit TransferAttempted(from, to, tokenId, now, "The NFT is a non-fungible, non-transferable token");
    }
}