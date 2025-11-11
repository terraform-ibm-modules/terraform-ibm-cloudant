// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
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
		"use_existing_resource_group": true,
		"provider_visibility":     "public",
		"resource_group_name":     options.ResourceGroup,
		"cloudant_instance_name":           options.Prefix,
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
