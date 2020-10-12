pragma solidity ^0.6.10;

import "./IERC721.sol";

interface IERC721NonTransferable is IERC721 {

    function mint(address _recipient, bytes calldata _metaData) external onlyOwner;
}