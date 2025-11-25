// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const resourceGroup = "geretain-test-cloudant"
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/complete",
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		TerraformVars: map[string]interface{}{
			"existing_sm_instance_guid":   permanentResources["secretsManagerGuid"],
			"existing_sm_instance_region": permanentResources["secretsManagerRegion"],
		},
	})
	return options
}

func TestRunCompleteExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "cloudant")
	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "cloudant-upg")
	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}

func TestRunDedicatedSolution(t *testing.T) {
	t.Parallel()

	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "solutions/dedicated",
		Region:        "us-south", // Locking into us-south since that is where the dedicated host is provisioned
		Prefix:        "dedicated",
		ResourceGroup: resourceGroup,
	})

	options.TerraformVars = map[string]interface{}{
		"ibmcloud_api_key": options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"],
		"access_tags":      permanentResources["accessTags"],
		// crn of the dedicated host
		"environment_crn":         permanentResources["dedicatedHostCrn"],
		"existing_resource_group": true,
		"provider_visibility":     "public",
		"resource_group_name":     options.ResourceGroup,
		"instance_name":           options.Prefix,
		"database_config": []map[string]interface{}{
			{
				"db":          "cloudant-dedicated-db",
				"partitioned": false,
				"shards":      16,
			},
		},
	}

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func setupDedicatedSolutionOptions(t *testing.T, prefix string) *testschematic.TestSchematicOptions {
	region := "us-south" // Locking into us-south since that is where the dedicated host is provisioned

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing:                t,
		Prefix:                 prefix,
		TemplateFolder:         "solutions/dedicated",
		ResourceGroup:          resourceGroup,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
		Tags:                   []string{"dedicated-schematic"},
	})

	// Schematic Terraform Vars
	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "resource_group_name", Value: options.ResourceGroup, DataType: "string"},
		{Name: "existing_resource_group", Value: true, DataType: "bool"},
		{Name: "provider_visibility", Value: "public", DataType: "string"},
		{Name: "instance_name", Value: prefix, DataType: "string"},
		{Name: "access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "environment_crn", Value: permanentResources["dedicatedHostCrn"], DataType: "string"}, // crn of the dedicated host
		// database_config declared with optional fields, no default value
		{Name: "database_config", DataType: "list(object({ db = string, partitioned = optional(bool), shards = optional(number) }))"},
	}

	return options
}

// Dedicated solution schematic test
func TestRunDedicatedSolutionSchematic(t *testing.T) {
	t.Parallel()

	// Use the schematic-compatible setup
	options := setupDedicatedSolutionOptions(t, "dedicated")

	// Run the schematic test
	err := options.RunSchematicTest()
	assert.NoError(t, err, "Schematics test should complete without errors")
}

// Dedicated solution schematic upgrade test
func TestRunDedicatedSolutionSchematicUpgrade(t *testing.T) {
	t.Parallel()

	// Use schematic-compatible setup for upgrade
	options := setupDedicatedSolutionOptions(t, "dedicated-upgrade")

	// Upgrade-specific configurations
	options.CheckApplyResultForUpgrade = true

	// Run the upgrade test
	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.NoError(t, err, "Upgrade test should complete without errors")
	}
}
