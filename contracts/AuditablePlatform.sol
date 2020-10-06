pragma solidity ^0.6.10;
import "./Ownable.sol";

contract AuditablePlatform is Ownable {

    address public archivedNFT;

    mapping(address => bool) isAuditor;

    event AddedAuditor(address _owner, address _auditor, uint256 _time);
    event RemovedAuditor(address _owner, address _auditor, uint256 _time);
    event CompletedAudit(address _auditor, address _contractAddress, bool _auditPassed, string _metaData, uint256 _time);

    constructor(address _archivedNFT) Ownable() public {
        archivedNFT = _archivedNFT;
    }

    function completeAudit(address _contractAddress, string memory _metaData, bool _auditPassed) public returns (bool) {
        require(isAuditor[msg.sender], "Not an auditor");

        archivedNFT.call(abi.encodeWithSignature("mint(address, string)", msg.sender, _metaData));

        emit CompletedAudit(msg.sender, _contractAddress, _auditPassed, _metaData, now);

        return _auditPassed;    // why is this needed / where is this used?
    }

    function addAuditor(address _auditor) public onlyOwner() {
        require(!isAuditor[_auditor], "Already an auditor");
        
        isAuditor[_auditor] = true;

        emit AddAuditor(owner, _auditor, now);
    }

    function removeAuditor(address _auditor) public onlyOwner() {
        require(isAuditor[_auditor], "Already removed from auditors");
        
        isAuditor[_auditor] = false;

        emit RemoveAuditor(owner, _auditor, now);
    }
}