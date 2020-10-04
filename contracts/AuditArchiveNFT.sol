pragma solidity ^0.6.10;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Ownable.sol";

contract Dawning_Chain is Ownable, ERC721 {

    // Used to issue unique tokens
    uint256 public tokenID;

    event MintedToken(address _donator, uint256 _tokenId, uint256 _time, string _message);
    event TransferAttempted(address _from, address _to, uint256 _tokenId, uint256 _time, string _message);

    constructor() Ownable() ERC721("Audit Archive NFT", "AAN") public {}

    function mint(address _address, string memory _metaData) public onlyOwner() {

        // who is this _address? you've copied and changed it in only one place

        // Mint token and send to the donator
        _safeMint(_address, tokenID, '');
        _setTokenURI(tokenID, _metaData);

        // Inform everyone and use a user friendly message
        emit MintedToken(_address, tokenID, now, "Token has been minted");

        // Increment the token ID for
        tokenID = tokenID.add(1);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        // Inform everyone and use a user friendly message
        emit TransferAttempted(from, to, tokenId, now, "The NFT is a non-fungible, non-transferable token");
    }
}