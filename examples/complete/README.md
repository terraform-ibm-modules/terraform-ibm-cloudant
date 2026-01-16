# Cloudant instance, access controls, and rotation of credentials through Secret Manager

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=cloudant-complete-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-cloudant/tree/main/examples/complete"><img src="https://img.shields.io/badge/Deploy%20with IBM%20Cloud%20Schematics-0f62fe?logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics" style="height: 16px; vertical-align: text-bottom;"></a>
<!-- END SCHEMATICS DEPLOY HOOK -->


This example shows how to:
 - Create a new standard Cloudant instance in the resource group and region provided.
 - Create access group and access policy for the Cloudant instance
 - Create a serviceId associated with the access group (manager, operator role)
 - Configure a Secret Manager instance to generate and rotate the API Key associated with the serviceId

<!-- BEGIN SCHEMATICS DEPLOY TIP HOOK -->
:information_source: Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab
<!-- END SCHEMATICS DEPLOY TIP HOOK -->
