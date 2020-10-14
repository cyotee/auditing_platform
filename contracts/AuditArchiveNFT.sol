pragma solidity ^0.6.10;

import "./openzepplin/token/ERC721/ERC721NonTransferable.sol";
import "./openzepplin/utils/Counters.sol";
import "./openzepplin/access/AuditorControl.sol";
import "./IAuditingDatastore.sol";
import "./openzepplin/utils/AuditingDetails.sol";

contract AuditArchiveNFT is AuditorControl, ERC721NonTransferable {

    using Counters for Counters.Counter;
    using AuditingDetails for AuditingDetails.AuditOrgDetails;
    using AuditingDetails for AuditingDetails.AuditorDetails;
    using AuditingDetails for AuditingDetails.ContractDetails;

    string constant public tokenNameSuffix = "Audit Archive NFT";
    string constant public tokenSymbolSuffix = "_AAN";

    AuditOrgDetails private auditOrg;

    // Used to issue unique token
    Counters.Counter private _tokenIdTracker;

    IAuditingDatastore private auditingDataStore;

    string constant private uriPrefix = '{ ';
    string constant private uriSuffix = ' }';

    event MintedToken(address _recipient, uint256 _tokenId, uint256 _time);
    //event TransferAttempted(address _from, address _to, uint256 _tokenId, uint256 _time, string _message);

    /*
    '"name" : "The Church of the Chain Incorporated Audit Archive NFT, description" : "A record of the audit for this contract provided free to devs from The Church of the Chain Incorporated"',
    */
    constructor( string _auditOrgName, string _auditOrgDesc,  string _auditOrgImage, address _auditingPlatform) ERC721(tokenName, tokenSymbol) public {
        auditOrg.auditOrgName = _auditOrgName;
        auditOrg.auditOrgDesc = _auditOrgDesc;
        auditOrg.auditOrgImage = _auditOrgImage;
        auditOrg.auditingPlatform = IAuditingDatastore(_auditingPlatform);
    }

    function setAuditingPlatform( address _auditingPlatform ) public {
        auditingPlatform = IAuditingPlatform(_auditingPlatform);
    }

    function mint(address _recipient, bytes calldata _metaData) external onlyOwner {
        require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");

        // Mint token and send to the donator
        _safeMint(_recipient, _tokenIdTracker.current(), "");
        _setTokenURI(tokenID, string(_metaData));

        emit MintedToken(_recipient, tokenID, now);

        // Increment the token ID for the next mint
        _tokenIdTracker.increment();
    }

}