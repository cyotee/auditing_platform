pragma solidity ^0.6.10;
import "./Ownable.sol";

contract Auditable is Ownable {

    address public auditor;
    address public platform;
    address public auditedContract;

    // Indicates whether the audit has been completed and approved (true) or not (false)
    bool public audited;

    // A deployed contract has a creation hash, store it so that you can access the code post self destruct
    string public contractCreationHash;

    modifier isAudited() {
        require(audited, "Not audited");
        _;
    }

    event SetAuditor(address _previousAuditor, address _newAuditor, address _contract, uint256 _time);
    event SetPlatform(address _previousPlatform, address _newPlatform, address _contract, uint256 _time);
    event ApprovedAudit(address _auditor, address _contract, uint256 _time);
    event OpposedAudit(address _auditor, address _contract, uint256 _time);
    event TxHashSet(string _txHash, uint256 _time);

    constructor(address _auditor, address _platform) Ownable() public {
        setAuditor(_auditor);
        setPlatform(_platform);
        auditedContract = address(this);
    }

    function setContractCreationHash(string memory _txHash) public onlyOwner() {
        require(bytes(contractCreationHash).length == 0, "tx has been set");

        contractCreationHash = _txHash;

        emit TxHashSet(contractCreationHash, now);
    }

    function setAuditor(address _auditor) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change auditor post audit");

        address previousAuditor = auditor;
        auditor = _auditor;

        emit SetAuditor(previousAuditor, auditor, auditedContract, now);
    }

    function setPlatform(address _platform) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change platform post audit");

        address previousPlatform = platform;
        platform = _platform;

        emit SetPlatform(previousPlatform, platform, auditedContract, now);
    }

    // The auditor is approving the contract by switching the audit bool to true.
    function approveAudit(string memory _txHash) public {
        require(msg.sender == auditor, "Auditor only");
        require(keccak256(abi.encodePacked(_txHash)) == keccak256(abi.encodePacked(contractCreationHash)), "tx hashes do not match");
        require(!audited, "Contract has already been approved");

        audited = true;

        bytes memory _metaData;

        // Address types must be converted manually otherwise conversions will not be in human readable form later
        string memory _auditor = addressToString(msg.sender);
        string memory _address = addressToString(auditedContract);

        _metaData =  abi.encodePacked(
                '{ "',
                'name" : ' , '"The Church of the Chain Incorporated Audit Archive NFT", ',
                '"description" : ', '"A record of the audit for this contract provided free to devs from The Church of the Chain Incorporated", ',
                '"image" : ', '"https://ipfs.io/ipfs/QmSZUL7Ea21osUUUESX6nPuUSSTF6RniyoJGBaa2ZY7Vjd", ',
                '"inSystem" : ', 'true, ',
                '"isAudited" : ', 'true, ',
                '"passedAudit" : ', 'true, ',
                '"contract" : ', '"', _address, '", ',
                '"deploymentHash" : ', '"', _txHash, '", ',
                '"auditor" : ', '"', _auditor,
                ' }');

        // Delegate the call via the platform to complete the audito
        platform.delegatecall(abi.encodeWithSignature("completeAudit(address, bool, bytes)", auditedContract, true, _metaData));

        emit ApprovedAudit(msg.sender, auditedContract, now);
    }

    // The auditor is opposing the audit by switching the bool to false
    function opposeAudit(string memory _txHash) public {
        require(msg.sender == auditor, "Auditor only");
        require(keccak256(abi.encodePacked(_txHash)) == keccak256(abi.encodePacked(contractCreationHash)), "tx hashes do not match");
        require(!audited, "Cannot destroy an approved contract");

        // The default (unset) bool is set to false but do not rely on that; set to false to be sure.
        audited = false;

        bytes memory _metaData;

        // Address types must be converted manually otherwise conversions will not be in human readable form later
        string memory _auditor = addressToString(msg.sender);
        string memory _address = addressToString(auditedContract);

        _metaData =  abi.encodePacked(
                '{ "',
                'name" : ' , '"The Church of the Chain Incorporated Audit Archive NFT", ',
                '"description" : ', '"A record of the audit for this contract provided free to devs from The Church of the Chain Incorporated", ',
                '"image" : ', '"https://ipfs.io/ipfs/QmSZUL7Ea21osUUUESX6nPuUSSTF6RniyoJGBaa2ZY7Vjd", ',
                '"inSystem" : ', '"true", ',
                '"isAudited" : ', '"true", ',
                '"passedAudit" : ', '"false", ',
                '"contract" : ', '"', _address, '", ',
                '"deploymentHash" : ', '"', _txHash, '", ',
                '"auditor" : ', '"', _auditor,
                ' }');

        // Delegate the call via the platform to complete the audito
        platform.delegatecall(abi.encodeWithSignature("completeAudit(address, bool, bytes)", auditedContract, false, _metaData));

        emit OpposedAudit(msg.sender, auditedContract, now);
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




