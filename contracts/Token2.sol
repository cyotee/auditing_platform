pragma solidity ^0.6.10;

// used for testing, do not use in prod, this should be deleted

contract Token2 {

    address public owner;

    event DataBytes(string _data);
    event DataString(string _data);

    constructor() public {
        owner = msg.sender;
    }

    function receiveBytesCall(bytes calldata data) external {
        string(data);
        // emit DataBytes(string(data));
    }

    function receiveStringCall(string memory data) public {
        data;
        // emit DataString(data);
    }
}