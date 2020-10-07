pragma solidity ^0.6.10;
import "./Ownable.sol";

contract AuditablePlatform is Ownable {

    address public archivedNFT;

    mapping(address => bool) isAuditor;

    event CompleteAudit(address _auditor, address _contractAddress, string _metaData);
    event AddAuditor(address _auditor, bool _isAuditor);
    event RemoveAuditor(address _auditor, bool _isAuditor);

    constructor(address _archivedNFT) Ownable() public {
        archivedNFT = _archivedNFT;
    }


    function completeAudit(string memory _metaData, address _contractAddress, bool _auditPassed) public returns (bool) {
        require(isAuditor[msg.sender], "Not an auditor");

        archivedNFT.call(abi.encodeWithSignature("mint(address, string)", msg.sender, _metaData));

        emit CompleteAudit(msg.sender, _contractAddress, _metaData);

        return(_auditPassed);

    }

    function addAuditor(address _auditor) public onlyOwner() {
        require(!isAuditor[_auditor], "Already an auditor");
        
        isAuditor[_auditor] = true;

        emit AddAuditor(_auditor, true);
    }

    function removeAuditor(address _auditor) public onlyOwner() {
        require(isAuditor[_auditor], "Already NOT an auditor");
        
        isAuditor[_auditor] = false;

        emit RemoveAuditor(_auditor, false);

    }





}