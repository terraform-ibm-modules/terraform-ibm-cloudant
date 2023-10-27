<!-- This page is for the GoldenEye core team only -->

# NIST controls

This module implements the following NIST control enhancements.

## NIST Controls required for compliance

These controls are required for compliance with the listed frameworks.

### Control mapping

The controls that are implemented by this module fall into the following
FedRAMP impact levels:

- High-impact controls: AC-4, AC-6(9), AU-12, SC-7(3), SC-8, SC-28

<!-- AC-4 is listed as moderate in https://csrc.nist.gov/Projects/risk-management/sp800-53-controls/release-search#/control?version=5.1&number=AC-4 but in IBM Draft5 its listed as high impact>


<!-- Include an H3 called "Implementation information" -->
### Implementation information
Implementation information for the supported control enhancements.

#### Access Control family
- [AC-4](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=AC-4#headerElement) INFORMATION FLOW ENFORCEMENT
    - Enforce approved authorizations for controlling the flow of information within the system and between connected systems.
    - Implementation
      - With cloudant dedicated hardware plan based instance inbound traffic can be restricted to use private endpoint only.
    - Evidence collection and checks
      - Data to collect:
        - Inventory of Cloudant instances in the account along with the details of end points enabled.
      - Data checks:
        - Cloudant is accessible only using private endpoints.
      - Source of evidence:
        - Account level cloudant instance details are gathered using service API by SCC.
      - Validation:
        - The Security and Compliance Center goal to check Cloudant service is accessible only by using private endpoints. *Rule name - Check whether Databases for PostgreSQL is accessible only by using private endpoints. Rule id rule-872db4fc-2f7c-4ba0-ace7-dc468f6813c7 service Databases for PostgreSQL (Note: We need similar one for Cloudant)*
- [AC-6(9)](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=AC-6#AC-6(9)) LEAST PRIVILEGE | LOG USE OF PRIVILEGED FUNCTIONS
    - Log the execution of privileged functions.
    - Implementation
      - Activity Tracker is enabled on the Cloudant. Management and data events can be enabled.
    - Evidence collection and checks
      - Data to collect:
        - Inventory of Cloudant instances in the account.
      - Data checks:
        - Cloudant is enabled for audit events.
      - Source of evidence:
        - Account level cloudant instance details are gathered using service API by SCC.
      - Validation:
        - The Security and Compliance Center goal to check Cloudant service is enabled for audit events. *Note: Rule name - Check that system activity is audited. Goal id 1800614 service Mongodb - We need similar one for Cloudant*

#### Audit and Accountability family

- [AU-12(a)](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=AU-12#headerElement) AUDIT RECORD GENERATION
    - Provide audit record generation capability.
    - Implementation
      - Activity Tracker can be enabled on the Cloudant. Management and data events can be enabled.
    - Evidence collection and checks
      - Data to collect:
        - Inventory of Cloudant instances in the account.
      - Data checks:
        - Cloudant is enabled for audit events.
      - Source of evidence:
        - Account level cloudant instance details are gathered using service API by SCC.
      - Validation:
        - The Security and Compliance Center goal to check Cloudant service is enabled for audit events. *Note:  Rule name - Check that system activity is audited. Goal id 1800614 service Mongodb We need similar one for Cloudant*

#### System and communications protection family

- [SC-7(3)](https://csrc.nist.gov/Projects/risk-management/sp800-53-controls/release-search#/control?version=5.1&number=SC-7#active-control-number) BOUNDARY PROTECTION | ACCESS POINTS
    - Monitor and control communications at the external managed interfaces to the system and at key internal managed interfaces within the system.
    - Implementation
        - Cloudant allows only TLS connections.
        - With cloudant dedicated hardware plan based instance inbound traffic can be restricted to use private endpoint only.
    - Evidence collection and checks
      - Data to collect:
        - Inventory of Cloudant instances in the account.
      - Data checks:
        - Cloudant is accessible only using private endpoints.
        - Cloudant is accessible only using TLS.
      - Source of evidence:
        - Account level cloudant instance details are gathered using service API by SCC.
      - Validation:
        - The Security and Compliance Center goal to check Cloudant service is accessible only through TLS. *Rule name - Databases for PostgreSQL is accessible only through TLS 1.2 or higher. Rule id rule-094495cf-c092-4dcb-96b8-3654c4bcf787 service Databases for PostgreSQL. Note: We need similar one for Cloudant*
        - The Security and Compliance Center goal to check Cloudant service is accessible only by using private endpoints. *Rule name - Check whether Databases for PostgreSQL is accessible only by using private endpoints. Rule id rule-872db4fc-2f7c-4ba0-ace7-dc468f6813c7 service Databases for PostgreSQL Note: We need similar one for Cloudant*
- [SC-8](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=SC-8#headerElement) TRANSMISSION CONFIDENTIALITY AND INTEGRITY
    - Protect the confidentiality and integrity of data during transmission.
    - Implementation
        - Data is encrypted in transit using TLS.
    - Evidence collection and checks
      - Data to collect:
        - Inventory of Cloudant instances in the account.
      - Data checks:
        - Cloudant ia accessible only using TLS.
      - Source of evidence:
        - Account level cloudant instance details are gathered using service API by SCC.
      - Validation:
        - The Security and Compliance Center goal to check Cloudant service is accessible only through TLS. *Rule name - Databases for PostgreSQL is accessible only through TLS 1.2 or higher. Rule id rule-094495cf-c092-4dcb-96b8-3654c4bcf787 service Databases for PostgreSQL Note: We need similar one for Cloudant*
- [SC-28](https://csrc.nist.gov/projects/cprt/catalog#/cprt/framework/version/SP_800_53_5_1_0/home?element=SC-28#headerElement) PROTECTION OF INFORMATION AT REST
    - Protect the information at rest.
    - Implementation
        - With cloudant dedicated hardware plan based instance data is encrypted at rest using encryption keys (BYOK).
    - Evidence collection and checks
      - Data to collect:
        - Inventory of Cloudant instances in the account.
      - Data checks:
        - Cloudant data is encrypted at rest using a key management service.
      - Source of evidence:
        - Account level cloudant instance details are gathered using service API by SCC.
      - Validation:
        - The Security and Compliance Center goal to check Cloudant service uses key management for encryption at rest. *Rule name - Check whether Schematics uses KYOK for Key management. Rule id rule-82ae957e-06ac-4b21-b32c-f571141aab35 service Schematics Note: We need similar one for Cloudant*
