pragma solidity ^0.6.10;
import "./Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

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
        bool isAudited;
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
        auditedContractDetails[_contractAddress].isAudited = true;
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
        auditedContractDetails[_contractAddress].isAudited = true;
        auditedContractDetails[_contractAddress].contractAddress = _contractAddress;
        auditedContractDetails[_contractAddress].auditorOfContract = _auditorAddress;
    }



}