pragma solidity ^0.6.10;
import "./Ownable.sol";

contract AuditablePlatform is Ownable {

    address public archivedNFT;
    address[] public auditors;

    mapping(address => bool) isAuditor;

    constructor(address _archivedNFT) Ownable() public {
        archivedNFT = _archivedNFT;
    }

    function completeAudit(string memory _metaData, bool _auditPassed) returns (bool _auditPassed) {
        require(isAuditor[msg.sender], "Not an auditor");

        archivedNFT.call(abi.encodeWithSignature("mint(address, string"), msg.sender, _metaData);

        // need an event
        
        return _auditPassed;    // wtf is this?
    }

    function addAuditor(address _auditor) public onlyOwner() {
        require(!isAuditor[_auditor], "Already an auditor");
        
        isAuditor[_auditor] = true;
        
        auditors.push(_auditor);    // why?

        // need an event
    }

    function removeAuditor(address _auditor) public onlyOwner() {
        require(isAuditor[_auditor], "Already NOT an auditor");
        
        isAuditor[_auditor] = false;

        // you've added to the array, now go and remove them

        // need an event
    }





}