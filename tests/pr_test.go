// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const resourceGroup = "geretain-test-cloudant"
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"
const dedicatedTerraformDir = "solutions/dedicated"
const modulesTerraformDir = "modules/fscloud"
const basicExampleTerraformDir = "examples/basic"
const fullyConfigurableGen2SolutionTerraformDir = "solutions/fully-configurable-gen2"

var validRegions = []string{
	"che01",
	"au-syd",
	"br-sao",
	"ca-tor",
	"eu-de",
	"eu-gb",
	"eu-es",
	"jp-osa",
	"jp-tok",
	"us-south",
	"us-east",
}

var gen2Regions = []string{
	"eu-de",
	"us-east",
}

var permanentResources map[string]interface{}

var sharedInfoSvc *cloudinfo.CloudInfoService

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {
	var err error
	sharedInfoSvc, err = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})
	if err != nil {
		log.Fatal(err)
	}

	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string) *testhelper.TestOptions {
	region := validRegions[common.CryptoIntn(len(validRegions))]
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  "examples/complete",
		Region:        region,
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

func setupDedicatedSolutionOptions(t *testing.T, prefix string) *testschematic.TestSchematicOptions {
	region := "us-south" // Locking into us-south since that is where the dedicated host is provisioned

	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Prefix:  prefix,
		TarIncludePatterns: []string{
			"*.tf",
			modulesTerraformDir + "/*.tf",
			dedicatedTerraformDir + "/*.tf",
		},
		TemplateFolder:         dedicatedTerraformDir,
		ResourceGroup:          resourceGroup,
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
		Tags:                   []string{"dedicated-schematic"},
	})

	// Schematic Terraform Vars
	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "resource_group_name", Value: resourceGroup, DataType: "string"},
		{Name: "existing_resource_group", Value: true, DataType: "bool"},
		{Name: "instance_name", Value: options.Prefix, DataType: "string"},
		{Name: "access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "environment_crn", Value: permanentResources["dedicatedHostCrn"], DataType: "string"}, // crn of the dedicated host
		{
			Name:     "database_config",
			Value:    []map[string]interface{}{{"db": "cloudant-dedicated-db", "partitioned": false, "shards": 16}},
			DataType: "list(object)",
		},
	}

	return options
}

// Dedicated solution schematic test
func TestRunDedicatedSolutionSchematic(t *testing.T) {
	t.Parallel()

	options := setupDedicatedSolutionOptions(t, "dedicated")

	// Run the schematic test
	err := options.RunSchematicTest()
	assert.NoError(t, err, "Schematics test should complete without errors")
}

// Dedicated solution schematic upgrade test
func TestRunDedicatedSolutionSchematicUpgrade(t *testing.T) {
	t.Parallel()

	options := setupDedicatedSolutionOptions(t, "dedicated-upg")
	options.CheckApplyResultForUpgrade = true

	// Run the upgrade test
	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.NoError(t, err, "Upgrade test should complete without errors")
	}
}

func generateUniqueResourceGroupName(baseName string) string {
	id := uuid.New().String()[:8] // Shorten UUID for readability
	return fmt.Sprintf("%s-%s", baseName, id)
}

// Test the fully-configurable-gen2 DA with defaults
func TestRunFullyConfigurableGen2SolutionSchematics(t *testing.T) {
	t.Parallel()

	region := gen2Regions[common.CryptoIntn(len(gen2Regions))]
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		TarIncludePatterns: []string{
			"*.tf",
			fullyConfigurableGen2SolutionTerraformDir + "/*.tf",
		},
		TemplateFolder:             fullyConfigurableGen2SolutionTerraformDir,
		Prefix:                     "cldnt-gen2",
		ResourceGroup:              resourceGroup,
		DeleteWorkspaceOnFail:      false,
		WaitJobCompleteMinutes:     60,
		CheckApplyResultForUpgrade: true,
	})

	uniqueResourceGroup := generateUniqueResourceGroupName(options.Prefix)

	serviceCredentialSecrets := []map[string]interface{}{
		{
			"secret_group_name": fmt.Sprintf("%s-secret-group", options.Prefix),
			"service_credentials": []map[string]string{
				{
					"secret_name": fmt.Sprintf("%s-cred-reader", options.Prefix),
					"service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Viewer",
				},
				{
					"secret_name": fmt.Sprintf("%s-cred-writer", options.Prefix),
					"service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Editor",
				},
			},
		},
	}

	serviceCredentialNames := []map[string]string{
		{
			"name":     "cloudant-admin",
			"role":     "Manager",
			"endpoint": "private",
		},
	}

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "access_tags", Value: permanentResources["accessTags"], DataType: "list(string)"},
		{Name: "existing_resource_group_name", Value: uniqueResourceGroup, DataType: "string"},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "service_credential_names", Value: serviceCredentialNames, DataType: "list(object)"},
		{Name: "service_credential_secrets", Value: serviceCredentialSecrets, DataType: "list(object)"},
		{Name: "existing_secrets_manager_instance_crn", Value: permanentResources["secretsManagerCRN"], DataType: "string"},
	}

	err := sharedInfoSvc.WithNewResourceGroup(uniqueResourceGroup, func() error {
		return options.RunSchematicTest()
	})
	assert.Nil(t, err, "This should not have errored")
}

func TestRunBasicGen2Example(t *testing.T) {
	t.Parallel()

	// set up a schematics test
	region := gen2Regions[common.CryptoIntn(len(gen2Regions))]
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing:                t,
		TarIncludePatterns:     []string{"*.tf", fmt.Sprintf("%s/*.tf", basicExampleTerraformDir)},
		TemplateFolder:         basicExampleTerraformDir,
		Prefix:                 "cloudant-gen2",
		Tags:                   []string{"test-schematic"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "region", Value: region, DataType: "string"},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "plan", Value: "standard-gen2", DataType: "string"},
		{Name: "service_endpoints", Value: "private", DataType: "string"},
		{Name: "resource_group", Value: resourceGroup, DataType: "string"},
	}

	err := options.RunSchematicTest()
	assert.NoError(t, err, "Schematic Test had unexpected error")
}
