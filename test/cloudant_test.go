package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAccIBMCloudantE2ETest(t *testing.T) {
	t.Parallel()

	// Unique name for an instance so we can distinguish it from any other cloudant instances provisioned in your IBM account
	expectedPrInstanceName := fmt.Sprintf("terratest-pr-instance-%s", strings.ToLower(random.UniqueId()))

	// Unique name for an instance so we can distinguish it from any other cloudant instances provisioned in your IBM account
	expectedDrInstanceName := fmt.Sprintf("terratest-dr-instance-%s", strings.ToLower(random.UniqueId()))

	// Unique name for an instance so we can distinguish it from any other resource key instances provisioned in your IBM account
	expectedPrResourceKeyName := fmt.Sprintf("terratest-pr-resource-key-%s", strings.ToLower(random.UniqueId()))

	// Unique name for an instance so we can distinguish it from any other resource key instances provisioned in your IBM account
	expectedDrResourceKeyName := fmt.Sprintf("terratest-dr-resource-key-%s", strings.ToLower(random.UniqueId()))

	// resource group
	expectedResourceGroup := "default"

	roles := []string{"Writer"}

	// Unique name for an instance so we can distinguish it from any other service name
	expectedServiceName := fmt.Sprintf("terratest-servicename-%s", strings.ToLower(random.UniqueId()))

	// Unique name for an instance so we can distinguish it from any other service name
	expectedDatabaseName := fmt.Sprintf("terratest-databasename-%s", strings.ToLower(random.UniqueId()))

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/e2e",

		Vars: map[string]interface{}{
			"pri_instance_name":        expectedPrInstanceName,
			"dr_instance_name":         expectedDrInstanceName,
			"plan":                     "standard",
			"pri_rg_name":              expectedResourceGroup,
			"dr_rg_name":               expectedResourceGroup,
			"pri_region":               "us-east",
			"dr_region":                "us-east",
			"pri_resource_key":         expectedPrResourceKeyName,
			"dr_resource_key":          expectedDrResourceKeyName,
			"role":                     "Writer",
			"roles":                    roles,
			"service_name":             expectedServiceName,
			"db_name":                  expectedDatabaseName,
			"service_policy_provision": true,
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
