# Cloudant instance, access controls, and rotation of credentials through Secret Manager

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=cloudant-complete-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-cloudant/tree/main/examples/complete">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

This example shows how to:
 - Create a new standard Cloudant instance in the resource group and region provided.
 - Create access group and access policy for the Cloudant instance
 - Create a serviceId associated with the access group (manager, operator role)
 - Configure a Secret Manager instance to generate and rotate the API Key associated with the serviceId
