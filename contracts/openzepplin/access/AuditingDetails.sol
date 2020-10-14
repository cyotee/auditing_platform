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
        string txHash;
        bool isAudited;
        bool passedAudit;
        string ipfsitRepo;
        string dappIPNSHash;
        string DappDNSlinkURL;
        string dappUnstoppableDomainURL;
        string dappHandshakeURL;
        string dappIPLDIPFSHash;
        string[] testResultIPFSHashes;
        string[] auditReportIPFSHashes;
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