pragma solidity ^0.6.10;
import "./Ownable.sol";

contract Auditable is Ownable {

    address public auditor;
    address public auditedContract;
    address public auditablePlatform;

    // Indicates whether the audit has been completed and approved (true) or not (false)
    bool public audited;

    bool public contractCreationTxHashSet;

    string public contractCreationTxHash;

    modifier txHashMatches(string _txHash) {
        require(_txHash == contractCreationTxHash, "tx hashes do not match");
    }

    modifier txHashSet() {
        require(contractCreationTxHashSet == false, "tx has been set");
    }

    modifier isAudited() {
        require(audited, "Not audited");
        _;
    }

    // emitted when the contract has been audited and approved/opposed
    event ApprovedAudit(address _auditor, address _contract, uint256 _time, string _message);
    event OpposedAudit(address _auditor, address _contract, uint256 _time, string _message);
    event SetAuditor(address _previousAuditor, address _newAuditor, address _contract, uint256 _time, string _message);
    event TxHashSet(string _txHash);

    constructor(address _auditor, address _auditedContract, address _auditablePlatform) Ownable() public {
        setAuditor(_auditor);
        auditedContract = _auditedContract;
        auditablePlatform = _auditablePlatform;
    }

    function setContractCreationTxHash(string _txHash) public onlyOwner() txHashSet() {
        contractCreationTxHash = _txHash;
        emit TxHashSet(_txHash);
    }

    function setAuditor(address _auditor) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change auditor post audit");

        address previousAuditor = auditor;
        auditor = _auditor;

        // Inform everyone and use a user friendly message
        emit SetAuditor(previousAuditor, auditor, auditedContract, now, "Auditor has been set");
    }

    // The auditor is approving the contract by switching the audit bool to true.
    // This unlocks contract functionality via the isAudited modifier
    function approveAudit(string _txHash) public txHashMatches(_txHash){
        require(msg.sender == auditor, "Auditor only");
        require(!audited, "Contract has already been approved");

        audited = true;

        // Inform everyone and use a user friendly message
        emit ApprovedAudit(auditor, auditedContract, now, "Contract approved, functionality unlocked");
    }

    // The auditor is opposing the audit by switching the bool to false
    function opposeAudit(string _txHash) public txHashMatches(_txHash) {
        require(msg.sender == auditor, "Auditor only");
        require(!audited, "Cannot destroy an approved contract");

        // The default (unset) bool is set to false but do not rely on that; set to false to be sure.
        audited = false;

        // Inform everyone and use a user friendly message
        emit OpposedAudit(auditor, auditedContract, now, "Contract has failed the audit");
    }
}




