pragma solidity ^0.6.10;
import "@openzeppelin/contracts/utils/Address.sol";

contract Auditable {
    using Address for address;

    address public auditor;
    address public auditedContract;

    // Indicates whether the audit has been completed and approved (true) or not (false)
    bool public audited;

    modifier isAudited() {
        require(audited == true, "Not audited");
        _;
    }

    // emitted when the contract has been audited and approved/opposed
    event ApprovedAudit(address _auditor, address _contract, string _message);
    event OpposedAudit(address _auditor, address _contract, string _message);

    constructor(address _auditor, address _auditedContract) public {
        auditor = _auditor;
        auditedContract = _auditedContract;
    }

    function setAuditor(address _auditor) public {
        require(msg.sender == auditor, "Only the auditor ???");
        require(audited == false, "Cannot change auditor post audit");
        // Can change the auditor if they bail, saves from having to redeploy and lose funds
        auditor = _auditor;
    }

    // The auditor is approving the contract by switching the audit bool to true.
    // This unlocks contract functionality via the isAudited modifier
    function approveAudit() public {
        require(msg.sender == auditor, "Auditor only");

        audited = true;

        // Inform everyone and use a user friendly message
        emit ApprovedAudit(auditor, auditedContract, "Contract approved, functionality unlocked");
    }

    // The auditor is opposing the audit by switching the bool to false
    function opposeAudit() public {
        require(msg.sender == auditor, "Auditor only");
        require(audited != true, "Cannot destroy an approved contract");

        // The default (unset) bool is set to false but do not rely on that; set to false to be sure.
        audited = false;

        // Inform everyone and use a user friendly message
        emit OpposedAudit(auditor, auditedContract, "Contract has failed the audit");
    }
}




