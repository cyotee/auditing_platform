pragma solidity ^0.6.10;
import "./Ownable.sol";

contract Auditable is Ownable {

    address public auditor;
    address public platform;
    address public auditedContract;

    // Indicates whether the audit has been completed and approved (true) or not (false)
    bool public audited;

    // Write a comment here telling me what this is
    bool public contractCreationTxHashSet;

    // Write a comment here telling me what this is
    string public contractCreationTxHash;

    // if this is internal (not used outside this contract) then this modifier does not need to exist
    // also it's just a require statement
    modifier txHashMatches(string memory _txHash) {
        require(_txHash == contractCreationTxHash, "tx hashes do not match");
    }

    // if this is internal (not used outside this contract) then this modifier does not need to exist
    // also it's just a require statement
    modifier txHashSet() {
        require(!contractCreationTxHashSet, "tx has been set");
    }

    modifier isAudited() {
        require(audited, "Not audited");
        _;
    }

    event ApprovedAudit(address _auditor, address _contract, uint256 _time, string _message);
    event OpposedAudit(address _auditor, address _contract, uint256 _time, string _message);
    event SetAuditor(address _previousAuditor, address _newAuditor, address _contract, uint256 _time, string _message);
    event SetPlatform(address _previousPlatform, address _newPlatform, address _contract, uint256 _time, string _message);
    event TxHashSet(string _txHash, uint256 _time, string _message);

    constructor(address _auditor, address _auditedContract, address _platform) Ownable() public {
        setAuditor(_auditor);
        setPlatform(_platform);
        auditedContract = _auditedContract;
    }

    function setContractCreationTxHash(string _txHash) public onlyOwner() {
        require(!contractCreationTxHashSet, "tx has been set");

        contractCreationTxHash = _txHash;

        // Inform everyone and use a user friendly message
        emit TxHashSet(contractCreationTxHash, now, "Contract hash has been set");
    }

    function setAuditor(address _auditor) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change auditor post audit");

        address previousAuditor = auditor;
        auditor = _auditor;

        // Inform everyone and use a user friendly message
        emit SetAuditor(previousAuditor, auditor, auditedContract, now, "Auditor has been set");
    }

    function setPlatform(address _platform) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change platform post audit");

        address previousPlatform = platform;
        platform = _platform;

        // Inform everyone and use a user friendly message
        emit SetPlatform(previousPlatform, platform, auditedContract, now, "Platform has been set");
    }

    // The auditor is approving the contract by switching the audit bool to true.
    function approveAudit(string memory _txHash) public {
        require(msg.sender == auditor, "Auditor only");
        require(_txHash == contractCreationTxHash, "tx hashes do not match");
        require(!audited, "Contract has already been approved");

        audited = true;

        // Where is this _metaData defined?
        platform.delegateCall(abi.encodeWithSignature("completeAudit(string, bool"), _metaData, true);

        // Inform everyone and use a user friendly message
        emit ApprovedAudit(auditor, auditedContract, now, "Contract approved, functionality unlocked");
    }

    // The auditor is opposing the audit by switching the bool to false
    function opposeAudit(string memory _txHash) public {
        require(msg.sender == auditor, "Auditor only");
        require(_txHash == contractCreationTxHash, "tx hashes do not match");
        require(!audited, "Cannot destroy an approved contract");

        // The default (unset) bool is set to false but do not rely on that; set to false to be sure.
        audited = false;

        // Where is this _metaData defined?
        platform.delegateCall(abi.encodeWithSignature("completeAudit(string, bool"), _metaData, false);

        // Inform everyone and use a user friendly message
        emit OpposedAudit(auditor, auditedContract, now, "Contract has failed the audit");
    }
}




