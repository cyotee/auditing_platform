pragma solidity ^0.6.10;

import "./utils/access/AccessControl.sol";

interface IAuditingDatastore is AccessControl {

    function isAuditor(address maybeAuditor) public view pure returns (bool);
}