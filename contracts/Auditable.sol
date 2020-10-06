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
/*    modifier txHashMatches(string memory _txHash) {
        require(_txHash == contractCreationTxHash, "tx hashes do not match");
        _;
    }*/

    // if this is internal (not used outside this contract) then this modifier does not need to exist
    modifier txHashSet() {
        require(!contractCreationTxHashSet, "tx has been set");
        _;
    }

    modifier isAudited() {
        require(audited, "Not audited");
        _;
    }

    event ApprovedAudit(address _auditor, address _contract, uint256 _time);
    event OpposedAudit(address _auditor, address _contract, uint256 _time);
    event SetAuditor(address _previousAuditor, address _newAuditor, address _contract, uint256 _time);
    event SetPlatform(address _previousPlatform, address _newPlatform, address _contract, uint256 _time);
    event TxHashSet(string _txHash, uint256 _time);
    event SetMetaData(string _metaData, uint256 _time);

    constructor(address _auditor,  address _platform) Ownable() public {
        setAuditor(_auditor);
        setPlatform(_platform);
        auditedContract = address(this);    // this won't work, you're referencing the auditable contract itself
    }

    function setContractCreationTxHash(string memory _txHash) public onlyOwner() {
        require(!contractCreationTxHashSet, "tx has been set");

        contractCreationTxHash = _txHash;
        contractCreationTxHashSet = true;

        // Inform everyone and use a user friendly message
        emit TxHashSet(contractCreationTxHash, now);
    }

    function setAuditor(address _auditor) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change auditor post audit");

        address previousAuditor = auditor;
        auditor = _auditor;

        // Inform everyone and use a user friendly message
        emit SetAuditor(previousAuditor, auditor, auditedContract, now);
    }

    function setPlatform(address _platform) public {
        require(msg.sender == auditor || msg.sender == owner, "Auditor and Owner only");
        require(!audited, "Cannot change platform post audit");

        address previousPlatform = platform;
        platform = _platform;

        // Inform everyone and use a user friendly message
        emit SetPlatform(previousPlatform, platform, auditedContract, now);
    }

    // The auditor is approving the contract by switching the audit bool to true.
    function approveAudit(string calldata _contractAddress, string calldata _txHash, string calldata _auditor) public {
        require(msg.sender == auditor, "Auditor only");
        require(keccak256(abi.encodePacked(_txHash)) == keccak256(abi.encodePacked(contractCreationTxHash)), "tx hashes do not match");
        require(!audited, "Contract has already been approved");

        audited = true;

        string memory _metaData;

        _metaData =  string(abi.encodePacked(
                '{ "',
                'name" : ' , '"The Church of the Chain Incorporated Audit Archive NFT", ',
                '"description" : ', '"A record of the audit for this contract provided free to devs from The Church of the Chain Incorporated", ',
                '"image" : ', '"https://ipfs.io/ipfs/QmSZUL7Ea21osUUUESX6nPuUSSTF6RniyoJGBaa2ZY7Vjd", ',
                '"inSystem" : ', 'true, ',
                '"isAudited" : ', 'true, ',
                '"passedAudit" : ', 'true, ',
                '"contractAddress" : ', '"', _contractAddress, '", ',
                '"contractDeploymentTxHash" : ', '"', _txHash, '", ',
                '"auditorOfContract" : ', '"', _auditor,
                ' }'));


        // Delegateall complete audit function from platform
        platform.delegatecall(abi.encodeWithSignature("completeAudit(string, address, bool)", _metaData, auditedContract, true));

        emit SetMetaData(_metaData, now);
        emit ApprovedAudit(auditor, auditedContract, now);
    }

    // The auditor is opposing the audit by switching the bool to false
    function opposeAudit(string calldata _contractAddress, string calldata _txHash, string calldata _auditor) public {
        require(msg.sender == auditor, "Auditor only");
        require(keccak256(abi.encodePacked(_txHash)) == keccak256(abi.encodePacked(contractCreationTxHash)), "tx hashes do not match");
        require(!audited, "Cannot destroy an approved contract");

        // The default (unset) bool is set to false but do not rely on that; set to false to be sure.
        audited = false;

        string memory _metaData;

        _metaData =  string(abi.encodePacked(
                '{ "',
                'name" : ' , '"The Church of the Chain Incorporated Audit Archive NFT", ',
                '"description" : ', '"A record of the audit for this contract provided free to devs from The Church of the Chain Incorporated", ',
                '"image" : ', '"https://ipfs.io/ipfs/QmSZUL7Ea21osUUUESX6nPuUSSTF6RniyoJGBaa2ZY7Vjd", ',
                '"inSystem" : ', '"true", ',
                '"isAudited" : ', '"true", ',
                '"passedAudit" : ', '"false", ',
                '"contractAddress" : ', '"', _contractAddress, '", ',
                '"contractDeploymentTxHash" : ', '"', _txHash, '", ',
                '"auditorOfContract" : ', '"', _auditor,
                ' }'));

        // Delegateall complete audit function from platform
        platform.delegatecall(abi.encodeWithSignature("completeAudit(string, address, bool)", _metaData, auditedContract, false));

        emit SetMetaData(_metaData, now);
        emit OpposedAudit(auditor, auditedContract, now);
    }
}




