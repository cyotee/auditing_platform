pragma solidity ^0.6.10;

import "./utils/token/ERC721/ERC721NonTransferable.sol";
import "./utils/access/Ownable.sol";
import "./utils/utils/Counters.sol";
import "./utils/access/AccessControl.sol";

contract AuditArchiveNFT is Ownable, ERC721NonTransferable, AccessControl {

    using Counters for Counters.Counter;

    // Used to issue unique token
    Counters.Counter private _tokenIdTracker;

    string constant public tokenNameSuffix = "Audit Archive NFT";
    string constant public tokenSymbolSuffix = "AAN";
    string public auditOrganizationName;

    string constant private uriPrefix = '{ ';
    string constant private uriSuffix = ' }';

    string constant public baseURI;

    event MintedToken(address _recipient, uint256 _tokenId, uint256 _time);
    //event TransferAttempted(address _from, address _to, uint256 _tokenId, uint256 _time, string _message);

    /*
    '"name" : "The Church of the Chain Incorporated Audit Archive NFT, description" : "A record of the audit for this contract provided free to devs from The Church of the Chain Incorporated"',
    */
    constructor( , string baseURI ) Ownable() ERC721(tokenName, tokenSymbol) public {
        _setBaseURI(baseURI);
    }

    function setAuditingPlatform( address auditingPlatform ) public

    function mint(address _recipient, bytes calldata _metaData) external onlyOwner() {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");

        // Mint token and send to the donator
        _safeMint(_recipient, _tokenIdTracker.current(), "");
        _setTokenURI(tokenID, string(_metaData));

        emit MintedToken(_recipient, tokenID, now);

        // Increment the token ID for the next mint
        _tokenIdTracker.increment();
    }

}