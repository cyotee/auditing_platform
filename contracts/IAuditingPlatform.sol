pragma solidity ^0.6.10;

import "./utils/access/AccessControl.sol";

interface IAuditingPlatform is AccessControl {

    function getAuditorRoleName() public view pure returns ( bytes32 )

    function isAuditor(address auditorQuery) public view pure returns (bool);

}