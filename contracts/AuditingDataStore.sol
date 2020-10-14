pragma solidity ^0.6.10;

import "./utils/access/AccessControl.sol";
import "./utils/token/ERC722/IERC722.sol";
import "./utils/token/ERC721/ERC721Holder.sol";
import "./IAuditingPlatform.sol";
import "./utils/math/SafeMath.sol";
import "./utils/utils/AuditingDetails.sol";
import "./IAuditingPlatform.sol"

// When Datastore is deployed, Auditable contract will
// use this contract address to call functions that will update
contract AuditingDataStore is AccessControl {

    using SafeMath for uint256;
    using AuditingDetails for AuditingDetails.AuditorDetails;
    using AuditingDetails for AuditingDetails.ContractDetails;

    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant PLATFORM_ADMIN_ROLE  = keccak256("PLATFORM_ADMIN_ROLE");

    IAuditingPlatform public auditingPlatform;

    IERC721NonTransferable public auditArchiveNFT;

    mapping( address => AuditingDetails.AuditorDetails) public auditorDetailByAuditorAddress;
    mapping( address => AuditingDetails.AuditorDetails) public auditorByContract;

    modifier onlyDefaultAdmin() {
        require( hasRole( DEFAULT_ADMIN_ROLE, _msgSender()));
        _;
    }

    modifier onlyPlatformAdmin() {
        require( hasRole( PLATFORM_ADMIN_ROLE, _msgSender()));
        _;
    }
    
    constructor() public {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(PLATFORM_ADMIN_ROLE, _msgSender());
        _setRoleAdmin(PLATFORM_ADMIN_ROLE, DEFAULT_ADMIN_ROLE);

        _setupRole(AUDITOR_ROLE, _msgSender());
        _setRoleAdmin(PLATFORM_ADMIN_ROLE, PLATFORM_ADMIN_ROLE);
    }

    function getAuditorRoleName() public view returns ( bytes32 ) {
        return AUDITOR_ROLE;
    }

    function setAudtingPlatform ( address _auditingPlatform ) public onlyDefaultAdmin {
        auditingPlatform = IAuditingPlatform(_auditingPlatform);
    }

    function setAuditArchiveNFT( IERC721NonTransferable _auditArchiveNFT ) public onlyDefaultAdmin {
        auditArchiveNFT = _auditArchiveNFT;
    }

    function isPlatformAdmin( address _maybePlatformAdmin ) public view pure returns (bool) {
        return hasRole(PLATFORM_ADMIN_ROLE, _maybePlatformAdmin);
    }

    function addPlatformAdmin( address adminToAdd ) public onlyDefaultAdmin {
        grantRole(PLATFORM_ADMIN_ROLE, adminToAdd);
    }

    function removePlatformAdmin( address adminToRemove ) public onlyDefaultAdmin {
        revokeRole( PLATFORM_ADMIN_ROLE, adminToRemove);
    }

    function isAuditor(address maybeAuditor) public view pure returns (bool) {
        return hasRole(AUDITOR_ROLE, maybeAuditor);
    }

    function addAuditor( address auditorToAdd ) public onlyPlatformAdmin {
        grantRole( AUDITOR_ROLE, auditorToAdd);
    }

    function removeAuditor( address auditorToRemove ) public onlyPlatformAdmin {
        revokeRole( AUDITOR_ROLE, auditorToRemove);
    }


    /*function auditOpposed(address _contract, address _auditor) private {    // private?
        require(auditorDetails[_auditor].isAuditor, "Not an auditor");
        require(!contractDetails[_contract].isAudited, "Contract already audited");

        // Update details for auditor
        opposedAudits[_contract].push(_contract);
        auditorDetails[_auditor].contractsOpposed.push(_contract);
        auditorDetails[_auditor].totalAudits = auditorDetails[_auditor].totalAudits.add(1);

        // Update details for contract
        contractDetails[_contract].inSystem = true;
        contractDetails[_contract].isAudited = true;
        contractDetails[_contract].passedAudit = false;
        contractDetails[_contract].contractAddress = _contract;
        contractDetails[_contract].auditor = _auditor;

        // need an event
    }*/

    /*function auditApproved(address _contract, address _auditor) private {   // private?
        require(auditorDetails[_auditor].isAuditor, "Not an auditor");
        require(!contractDetails[_contract].isAudited, "Contract already audited");

        approvedAudits[_contract].push(_contract);

        // Update details for auditor
        auditorDetails[_auditor].contractsApproved.push(_contract);
        auditorDetails[_auditor].totalAudits = auditorDetails[_auditor].totalAudits.add(1);

        // Update details for contract
        contractDetails[_contract].inSystem = true;
        contractDetails[_contract].isAudited = true;
        contractDetails[_contract].passedAudit = true;
        contractDetails[_contract].contractAddress = _contract;
        contractDetails[_contract].auditor = _auditor;

        // need an event
    }*/

    /*function contractDetails(address _contract) public view returns (address _auditor, bool _isAudited, bool ) {
        require(contractDetails[_contract].inSystem, "Contract not in datastore");
        
        return 
        (
            contractDetails[_contract].auditor, 
            contractDetails[_contract].isAudited, 
            contractDetails[_contract].passedAudit
        );
    }*/

    /*function auditorDetails(address _auditor) public view returns (address[] calldata _contractsApproved, address[] calldata _contractsOpposed, uint256 _totalAudits) {
        require(auditorDetails[_auditor].isAuditor, "Address not an auditor");

        return 
        (
            auditorDetails[_auditor].contractsApproved, 
            auditorDetails[_auditor].contractsOpposed, 
            auditorDetails[_auditor].totalAudits
        );
    }*/
}
