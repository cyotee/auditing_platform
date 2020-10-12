pragma solidity ^0.6.10;

import "./AccessControl.sol";
import "./Context.sol";
import "../../IAuditingPlatform.sol";

abstract contract AuditorControl is AccessControl {

    IAuditingPlatform private audtingPlatform;

    modifier onlyAuditor() {

    }
}