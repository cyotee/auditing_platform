pragma solidity ^0.6.10;

import "./utils/access/AccessControl.sol";
import "./utils/token/ERC721/IERC721NonTransferable.sol";
import "./utils/token/ERC721/ERC721Holder.sol";
import "./IAuditingPlatform.sol";
import "./utils/math/SafeMath.sol";

// When Datastore is deployed, Auditable contract will
// use this contract address to call functions that will update
contract AuditingDataStore is AccessControl, ERC721Holder {

    using SafeMath for uint256;

    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");
    bytes32 public constant PLATFORM_ADMIN_ROLE  = keccak256("PLATFORM_ADMIN_ROLE");

    bytes32 public auditOrganizationName;

    IAuditingPlatform auditingPlatform;

    string  public platformName;
    string public platformOrganization;

    IERC721NonTransferable public auditArchiveNFT;

    modifier onlyDefaultAdmin() {
        require( hasRole( DEFAULT_ADMIN_ROLE, _msgSender()));
        _;
    }

    modifier onlyPlatformAdmin() {
        require( hasRole( PLATFORM_ADMIN_ROLE, _msgSender()));
        _;
    }

    struct ContractDetails {
        AuditorDetails auditor;
        uint256 auditorDetailsIndex;
        address contractAddress;
        bool isAudited;
        bool passedAudit;
    }

    struct AuditorDetails {
        address auditor;
        ContractDetails[] contractsApproved;
        mapping( address => uint256 ) approvedContractIndexes;
        ContractDetails[] contractsOpposed;
        mapping( address => uint256)
        uint256 totalAudits;
    }

    mapping( address => ContractDetails[]) public contractByAuditor;
    mapping( address => AuditorDetails) public auditorByContract;

    //mapping(address => address[]) approvedAudits;   // this does not need to exist
    //mapping(address => address[]) opposedAudits;    // this does not need to exist
    //mapping(address => AuditorDetails) auditorDetails;
    //mapping(address => ContractDetails) contractDetails;
    
    constructor( string _auditOrganizationName, address _auditArchiveNFT) public {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(PLATFORM_ADMIN_ROLE, _msgSender());
        _setRoleAdmin(PLATFORM_ADMIN_ROLE, DEFAULT_ADMIN_ROLE);

        _setupRole(AUDITOR_ROLE, _msgSender());
        _setRoleAdmin(PLATFORM_ADMIN_ROLE, PLATFORM_ADMIN_ROLE);

        auditArchiveNFT = IERC721NonTransferable(_auditArchiveNFT);

        auditOrganizationName = _auditOrganizationName;
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
