pragma solidity ^0.6.10;
import "./Ownable.sol";

contract AuditablePlatform is Ownable {

    address public archivedNFT;

    mapping(address => bool) isAuditor;

    event AddedAuditor(address _owner, address _auditor, uint256 _time);
    event RemovedAuditor(address _owner, address _auditor, uint256 _time);
    event CompletedAudit(address _auditor, address _contract, bool _auditPassed, string _metaData, uint256 _time);

    constructor(address _archivedNFT) Ownable() public {
        archivedNFT = _archivedNFT;
    }

    function completeAudit(address _contract, bool _auditPassed, bytes calldata _metaData) external {
        require(isAuditor[msg.sender], "Not an auditor");

        archivedNFT.call(abi.encodeWithSignature("mint(address, bytes)", msg.sender, _metaData));

        emit CompletedAudit(msg.sender, _contract, _auditPassed, string(_metaData), now);
    }

    function addAuditor(address _auditor) public onlyOwner() {
        require(!isAuditor[_auditor], "Already an auditor");
        
        isAuditor[_auditor] = true;

        emit AddedAuditor(msg.sender, _auditor, now);
    }

    function removeAuditor(address _auditor) public onlyOwner() {
        require(isAuditor[_auditor], "Already removed from auditors");
        
        isAuditor[_auditor] = false;

        emit RemovedAuditor(msg.sender, _auditor, now);
    }
}