/*
pragma solidity ^0.6.10;
/*
import "./Ownable.sol";

// When Datastore is deployed, Auditable contract will
// use this contract address to call functions that will update
contract AuditableDataStore is Ownable {

    address[] public auditors;

    struct AuditorDetails {
        address auditor;
        address[] contractsApproved;
        address[] contractsOpposed;
        uint256 totalAudits;
        bool isAuditor;
    }

    struct ContractDetails {
        address auditor;
        address contractAddress;
        bool inSystem;  // why and what is this?
        bool isAudited;
        bool passedAudit;
    }

    mapping(address => address[]) approvedAudits;   // this does not need to exist
    mapping(address => address[]) opposedAudits;    // this does not need to exist
    mapping(address => AuditorDetails) auditorDetails;
    mapping(address => ContractDetails) contractDetails;
    
    constructor(address _platform) Ownable() public {
        transferOwnership(_platform);
    }

    function addAuditor(address _auditor) public onlyOwner() {
        require(!auditorDetails[_auditor].isAuditor, "Address is already an auditor");

        auditorDetails[_auditor].isAuditor = true;
        auditorDetails[_auditor].auditor = _auditor;

        // need an event
    }

    function auditOpposed(address _contract, address _auditor) private {    // private?
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
    }

    function auditApproved(address _contract, address _auditor) private {   // private?
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
    }

    function contractDetails(address _contract) public view returns (address _auditor, bool _isAudited, bool ) {
        require(contractDetails[_contract].inSystem, "Contract not in datastore");
        
        return 
        (
            contractDetails[_contract].auditor, 
            contractDetails[_contract].isAudited, 
            contractDetails[_contract].passedAudit
        );
    }

    function auditorDetails(address _auditor) public view returns (address[] calldata _contractsApproved, address[] calldata _contractsOpposed, uint256 _totalAudits) {
        require(auditorDetails[_auditor].isAuditor, "Address not an auditor");

        return 
        (
            auditorDetails[_auditor].contractsApproved, 
            auditorDetails[_auditor].contractsOpposed, 
            auditorDetails[_auditor].totalAudits
        );
    }
}*/
