pragma solidity ^0.6.10;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AuditablePlatform is Ownable {

    address public NFT;
    address public dataStore;

    mapping(address => bool) isAuditor;

    event AddedAuditor(address indexed _owner, address indexed _auditor);
    event RemovedAuditor(address indexed _owner, address indexed _auditor);
    event CompletedAudit(address indexed _auditor, address indexed _contract, bool _auditPassed, string indexed _txHash);
    event ChangedDataStore(address indexed _owner, address _dataStore);

    constructor(address _NFT, address _dataStore) Ownable() public {
        NFT = _NFT;
        dataStore = _dataStore;
    }

    function completeAudit(address _contract, bool _auditPassed, bytes calldata _txHash) external {

        // Tell the data store that an audit has been completed
        dataStore.call(abi.encodeWithSignature("completeAudit(address, bool, bytes)", _msgSender(), _auditPassed, _txHash));

        // Mint a non-fungible token for the auditor as a receipt
        NFT.call(abi.encodeWithSignature("mint(address, address, bool, bytes)", _msgSender(), _contract, _auditPassed, _txHash));

        emit CompletedAudit(_msgSender(), _contract, _auditPassed, string(_txHash));
    }

    function addAuditor(address _auditor) public onlyOwner() {
        // Tell the data store to add an auditor
        dataStore.call(abi.encodeWithSignature("addAuditor(address)", _auditor));
        
        emit AddedAuditor(_msgSender(), _auditor);
    }

    function suspendAuditor(address _auditor) public onlyOwner() {
        // Tell the data store to switch the value which indicates whether someone is an auditor to false
        dataStore.call(abi.encodeWithSignature("suspendAuditor(address)", _auditor));
        
        emit RemovedAuditor(_msgSender(), _auditor);
    }

    function changeDataStore(address _dataStore) public onlyOwner() {
        dataStore = _dataStore;
        
        emit ChangedDataStore(_msgSender(), dataStore);
    }
}