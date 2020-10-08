pragma solidity ^0.6.10;

// used for testing, do not use in prod, this should be deleted

contract Token {

    string public metaData;
    bytes public metaBytes;

    address public token2;

    // bytes gas before/after
    uint256 public bgB;
    uint256 public bgA;

    // string gas before/after
    uint256 public sgB;
    uint256 public sgA;

    constructor(address token) public {
        token2 = token;

        string memory addre = addressToString(msg.sender);
        
        metaData =  string(abi.encodePacked(
                '{ "',
                '"auditorOfContract" : ', '"', addre,
                ' }'));
        
        metaBytes =  abi.encodePacked(
                '{ "',
                '"auditorOfContract" : ', '"', addre,
                ' }');
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

    function makeBytesCall() payable public {
        require(metaBytes.length != 0, "Empty meta data");

        bgB = gasleft();
        token2.delegatecall(abi.encodeWithSignature("receiveBytesCall(bytes)", metaBytes));
        bgA = gasleft();
    }

    function makeStringCall() payable public {

        sgB = gasleft();
        token2.delegatecall(abi.encodeWithSignature("receiveStringCall(string)", metaData));
        sgA = gasleft();
    }
}



