pragma solidity ^0.6.10;
import "./Auditable.sol";

contract Test is Ownable, Auditable {

    event Audited(string _msg);

    constructor(address _auditor, address _platform) Auditable(_auditor, _platform) public  {

    }

    function readMessage() public isAudited()  {
        emit Audited("Platform works");
    }

}