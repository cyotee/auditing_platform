pragma solidity ^0.6.10;

import "./AccessControl.sol";
import "./Context.sol";
import "../../IAuditingPlatform.sol";
import "./AuditingDetails.sol";

abstract contract AuditorControl is AccessControl {

    using AuditingDetails for AuditingDetails.AuditOrgDetails;
    using AuditingDetails for AuditingDetails.AuditorDetails;

    IAuditingPlatform private audtingPlatform;
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    AuditingDetails.AuditorDetails private auditorDetails;

    modifier onlyAuditor() {
        require(audtingPlatform.hasRole(auditingPlatform.getAuditorRoleName(), _msgSender()));
    }
}