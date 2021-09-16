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
	expectedInstanceName := fmt.Sprintf("terratest-pr-instance-%s", strings.ToLower(random.UniqueId()))

	// Unique name for an instance so we can distinguish it from any other resource key instances provisioned in your IBM account
	expectedResourceKeyName := fmt.Sprintf("terratest-pr-resource-key-%s", strings.ToLower(random.UniqueId()))

	// resource group
	expectedResourceGroup := "default"

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/e2e",

		Vars: map[string]interface{}{
			"instance_name":     expectedInstanceName,
			"plan":              "standard",
			"resource_group":    expectedResourceGroup,
			"region":            "us-east",
			"resource_key_name": expectedResourceKeyName,
			"role":              "Writer",
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
