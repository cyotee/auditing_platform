pragma solidity ^0.6.10;
import "./Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// When Datastore us deployed, Auditable contract will
// use this contract address to call functions that will update
contract AuditableDataStore is Ownable {
    using SafeMath for uint;

    // Struct that keeps track of details of auditors
    struct AuditorDetails {
        bool isAuditor;
        address auditorAddress;
        address[] contractsApproved;
        address[] contractsOpposed;
        uint totalContractsAudited;
    }

    // Struct that keeps track of contract details
    struct AuditedContractDetails {
        bool inSystem;
        bool isAudited;
        bool passedAudit;
        address contractAddress;
        address auditorOfContract;
    }

    mapping(address => address[]) approvedAudits;
    mapping(address => address[]) opposedAudits;
    mapping(address => AuditorDetails) auditorDetails;
    mapping(address => AuditedContractDetails) auditedContractDetails;
    address[] public auditors;

    // Function that will allow the owner to set an auditor
    function addAuditor(address _newAuditor) public onlyOwner() {
        require(auditorDetails[_newAuditor].isAuditor == false, "Address is already an auditor");

        auditors.push(_auditorAddress);
        auditorDetails[_auditorAddress].isAuditor = true;
        auditorDetails[_auditorAddress].auditorAddress = _newAuditor;
    }

    // Function that will allow auditor to oppose a contract
    function auditOpposed(address _contractAddress, address _auditorAddress) private {
        require(auditorDetails[_auditorAddress].isAuditor == true, "Not an auditor");
        require(auditedContractDetails[_contractAddress].isAudited == false, "Contract already audited");

        // Update details for auditor
        opposedAudits[_contractAddress].push(_contractAddress);
        auditorDetails[_auditorAddress].contractsOpposed.push(_contractAddress);
        auditorDetails[_auditorAddress].totalContractsAudited = auditorDetails[_auditorAddress].totalContractsAudited.add(1);

        // Update details for contract
        auditedContractDetails[_contractAddress].inSystem = true;
        auditedContractDetails[_contractAddress].isAudited = true;
        auditedContractDetails[_contractAddress].passedAudit = false;
        auditedContractDetails[_contractAddress].contractAddress = _contractAddress;
        auditedContractDetails[_contractAddress].auditorOfContract = _auditorAddress;
    }

    // Function that will allow auditor to approve a contract
    function auditApproved(address _contractAddress, address _auditorAddress) private {
        require(auditorDetails[_auditorAddress].isAuditor == true, "Not an auditor");
        require(auditedContractDetails[_contractAddress].isAudited == false, "Contract already audited");

        // Update details for auditor
        approvedAudits[_contractAddress].push(_contractAddress);
        auditorDetails[_auditorAddress].contractsApproved.push(_contractAddress);
        auditorDetails[_auditorAddress].totalContractsAudited = auditorDetails[_auditorAddress].totalContractsAudited.add(1);

        // Update details for contract
        auditedContractDetails[_contractAddress].inSystem = true;
        auditedContractDetails[_contractAddress].isAudited = true;
        auditedContractDetails[_contractAddress].passedAudit = true;
        auditedContractDetails[_contractAddress].contractAddress = _contractAddress;
        auditedContractDetails[_contractAddress].auditorOfContract = _auditorAddress;
    }

    // Get details of a specific
    function getDetailsOfContract(address _contractAddress) public view returns (address _auditor, bool _isAudited, bool _passedAudit) {
        require(auditedContractDetails[_contractAddress].inSystem == true, "Contract not in datastore");
        return (auditedContractDetails[_contractAddress].auditorOfContract, auditedContractDetails[_contractAddress].isAudited, auditedContractDetails[_contractAddress].passedAudit);
    }

    // Get details of a specific auditor
    function getAuditorDetails(address _auditor) public view returns (address[] _contractsApproved, address[] _contractsOpposed, uint totalContractsAudited) {
        require(auditorDetails[_auditor].isAuditor == true, "Address not an auditor");
        return(auditorDetails[_auditor].contractsApproved, auditorDetails[_auditor].contractsOpposed, auditorDetails[_auditor].totalContractsAudited);

    }



}