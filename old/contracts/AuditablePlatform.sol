pragma solidity ^0.6.10;
import "./Ownable.sol";

contract AuditablePlatform is Ownable {

    address public auditArchiveNFT;
    address[] public auditors;

    mapping(address => bool) isAuditor;

    constructor(address _auditArchiveNFT) Ownable() public {
        auditArchiveNFT = _auditArchiveNFT;
    }

    function completeAudit(string _metaData, bool _auditPassed) returns(bool _auditPassed){
        require(isAuditor[msg.sender] == true, "Not an auditor");
        auditArchiveNFT.call(abi.encodeWithSignature("mint(address, string"), msg.sender, _metaData);
        return _auditPassed;
    }

    function addAuditor(address _auditorToAdd) public onlyOwner() {
        require(isAuditor[_auditorToAdd] == false, "Already an auditor");
        isAuditor[_auditorToAdd] = true;
        auditors.push(_auditorToAdd);
    }

    function removeAuditor(address _auditorToRemove) public onlyOwner() {
        require(isAuditor[_auditorToRemove] == true, "Already NOT an auditor");
        isAuditor[_auditorToRemove] = false;
    }





}