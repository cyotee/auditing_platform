pragma solidity ^0.6.10;

import "./utils/access/AccessControl.sol";

interface IAuditingPlatform is AccessControl {

    function getAuditPlatformAddress() public view pure returns (address);

    function isAuditor(address auditorQuery) public view pure returns (bool);

}