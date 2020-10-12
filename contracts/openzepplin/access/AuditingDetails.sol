pragma solidity ^0.6.10;

import "../../IAuditingPlatform.sol";

library AuditingDetails {

    struct AuditorDetails {
        address auditor;
        string[] auditOrgs;
        mapping( address => uint256) auditOrgIndexes;
        ContractDetails[] contractsApproved;
        mapping( address => uint256 ) approvedContractIndexes;
        ContractDetails[] contractsOpposed;
        mapping( address => uint256) opposedContractIndexes;
        uint256 totalAudits;
        bool isActive;
    }

    struct ContractDetails {
        AuditorDetails auditor;
        uint256 auditorDetailsIndex;
        address contractAddress;
        bool isAudited;
        bool passedAudit;
    }

    struct AuditOrgDetails {
        string auditOrgName;
        string auditOrgDesc;
        string AuditOrgImage;
        IAuditingPlatform audtingPlatform;
        AuditorDetails[] auditors;
        mapping( address => uint256 ) auditorIndexes;
    }

}