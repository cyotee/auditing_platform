pragma solidity ^0.6.10;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Ownable.sol";

contract AuditArchive is Ownable, ERC721 {

    // Used to issue unique tokens
    uint256 public tokenID;

    event MintedToken(address _recipient, uint256 _tokenId, uint256 _time);
    event TransferAttempted(address _from, address _to, uint256 _tokenId, uint256 _time, string _message);

    constructor() Ownable() ERC721("Audit Archive NFT", "AAN") public {}

    function mint(address _recipient, bytes calldata _metaData) external onlyOwner() {

        // Mint token and send to the donator
        _safeMint(_recipient, tokenID, '');
        _setTokenURI(tokenID, string(_metaData));

        emit MintedToken(_recipient, tokenID, now);

        // Increment the token ID for the next mint
        tokenID = tokenID.add(1);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override {
        emit TransferAttempted(from, to, tokenId, now, "The NFT is a non-fungible, non-transferable token");
    }
}