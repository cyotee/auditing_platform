pragma solidity ^0.6.10;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Auditable is Ownable {

    address public auditor;
    address public platform;
    address public auditedContract;

    // Indicates whether the audit has been completed and approved (true) or not (false)
    bool public audited;

    // A deployed contract has a creation hash, store it so that you can access the code 
    // post self destruct from an external location
    string public contractCreationHash;

    modifier isAudited() {
        require(audited, "Not audited");
        _;
    }

    event SetAuditor(address _previous, address _new, address _contract);
    event SetPlatform(address _previous, address _new, address _contract);
    event ApprovedAudit(address _auditor, address _contract);
    event OpposedAudit(address _auditor, address _contract);
    event TxHashSet(string _txHash);

    constructor(address _auditor, address _platform) Ownable() public {
        setAuditor(_auditor);
        setPlatform(_platform);
        auditedContract = address(this);
    }

    function setContractCreationHash(string memory _txHash) public onlyOwner() {
        require(bytes(contractCreationHash).length == 0, "tx has been set");

        contractCreationHash = _txHash;

        emit TxHashSet(contractCreationHash);
    }

    function setAuditor(address _auditor) public {
        require(_msgSender() == auditor || _msgSender() == owner, "Auditor and Owner only");
        require(!audited, "Cannot change auditor post audit");

        address previousAuditor = auditor;
        auditor = _auditor;

        emit SetAuditor(previousAuditor, auditor, auditedContract);
    }

    function setPlatform(address _platform) public {
        require(_msgSender() == auditor || _msgSender() == owner, "Auditor and Owner only");
        require(!audited, "Cannot change platform post audit");

        address previousPlatform = platform;
        platform = _platform;

        emit SetPlatform(previousPlatform, platform, auditedContract);
    }

    function approveAudit(string memory _txHash) public {
        require(_msgSender() == auditor, "Auditor only");
        require(keccak256(abi.encodePacked(_txHash)) == keccak256(abi.encodePacked(contractCreationHash)), "tx hashes do not match");
        require(!audited, "Contract has already been approved");

        audited = true;        

        // Delegate the call via the platform to complete the audit        
        platform.delegatecall(abi.encodeWithSignature("completeAudit(address, bool, bytes)", auditedContract, audited, abi.encodePacked(_txHash)));

        emit ApprovedAudit(_msgSender(), auditedContract);
    }

    function opposeAudit(string memory _txHash) public {
        require(_msgSender() == auditor, "Auditor only");
        require(keccak256(abi.encodePacked(_txHash)) == keccak256(abi.encodePacked(contractCreationHash)), "tx hashes do not match");
        require(!audited, "Cannot destroy an approved contract");

        audited = false;

        // Delegate the call via the platform to complete the audit
        platform.delegatecall(abi.encodeWithSignature("completeAudit(address, bool, bytes)", auditedContract, audited, abi.encodePacked(_txHash)));

        emit OpposedAudit(_msgSender(), auditedContract);
    }

    function addressToString(address _address) private pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(_address));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _addr = new bytes(42);
        
        _addr[0] = '0';
        _addr[1] = 'x';
        
        for(uint256 i = 0; i < 20; i++) {
            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        
        return string(_addr);
    }
}




