# Configuring complex inputs in IBM Cloudant (gen2)

Several optional input variables in the IBM Cloud [IBM Cloudant deployable architecture](https://cloud.ibm.com/catalog#deployable_architecture) use complex object types. You specify these inputs when you configure deployable architecture.

- [Database configuration](#database-config) (`database_config`)
- [Service credentials](#svc-credential-name) (`service_credential_names`)
- [Service credential secrets](#service-credential-secrets) (`service_credential_secrets`)

## Database configuration <a name="database-config"></a>

You can pre-create databases inside the Cloudant instance with the `database_config` input variable. For each database, you can optionally enable partitioning and set the number of shards.

- Variable name: `database_config`.
- Type: A list of objects that represent databases.
- Default value: An empty list (`[]`).

### Options for database_config

- `db` (required): The name of the database to create.
- `partitioned` (optional, default = `null`): Whether the database is partitioned.
- `shards` (optional, default = `null`): The number of shards for the database.

### Example database configuration

```hcl
[
  {
    "db": "my-database",
    "partitioned": true,
    "shards": 16
  },
  {
    "db": "my-simple-database"
  }
]
```

## Service credentials <a name="svc-credential-name"></a>

You can specify a set of IAM credentials to connect to the Cloudant instance with the `service_credential_names` input variable. Include a resource key name and IAM service role for each key. Each role provides a specific level of access to the database. For more information, see [Adding and viewing credentials](https://cloud.ibm.com/docs/account?topic=account-service_credentials&interface=ui). If you want to add service credentials to Secrets Manager and allow Secrets Manager to manage them, use `service_credential_secrets` instead. See [Service credential secrets](#service-credential-secrets).

- Variable name: `service_credential_names`.
- Type: A list of objects that represent resource keys.
- Default value: An empty list (`[]`).

### Options for service_credential_names

- `name` (required): A unique human-readable name that identifies this resource key.
- `role` (optional, default = `Reader`): The IAM service role assigned to the credential. Valid values are `Reader`, `Writer`, `Manager`, `Monitor`, and `Checkpointer`.
- `endpoint` (optional, default = `private`): The endpoint type for the resource key. For Gen2 instances only `private` is supported.

### Example service credentials

```hcl
[
  {
    "name": "cloudant-manager-resource-key",
    "role": "Manager",
    "endpoint": "private"
  },
  {
    "name": "cloudant-reader-resource-key",
    "role": "Reader"
  }
]
```

## Service credential secrets <a name="service-credential-secrets"></a>

When you add an IBM Cloudant deployable architecture from the IBM Cloud catalog to IBM Cloud Projects, you can configure service credentials to be stored in Secrets Manager. In edit mode for the projects configuration, from the configure panel click the optional tab.

To enter a custom value, use the edit action to open the "Edit Array" panel. Add the service credential secrets configurations to the array here.

In the configuration, specify the secret group name, whether it already exists or will be created, and include all the necessary service credential secrets that need to be created within that secret group.

[Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/sm_service_credentials_secret) about service credential secrets.

- Variable name: `service_credential_secrets`.
- Type: A list of objects that represent service credential secret groups and secrets.
- Default value: An empty list (`[]`).

### Options for service_credential_secrets

- `secret_group_name` (required): A unique human-readable name that identifies this service credential secret group.
- `secret_group_description` (optional, default = `null`): A human-readable description for this secret group.
- `existing_secret_group` (optional, default = `false`): Set to `true` if the secret group name provided in `secret_group_name` already exists.
- `service_credentials` (required): A list of objects that represent a service credential secret.

#### Options for service_credentials

- `secret_name` (required): A unique human-readable name of the secret to create.
- `service_credentials_source_service_role_crn` (required): The CRN of the role to give the service credential in the Cloudant service. Service credentials role CRNs can be found at https://cloud.ibm.com/iam/roles, select IBM Cloudant and select the role.
- `secret_labels` (optional, default = `[]`): Labels of the secret to create. Up to 30 labels can be created. Labels can be 2 - 30 characters, including spaces. Special characters that are not permitted include the angled brackets (<>), comma (,), colon (:), ampersand (&), and vertical pipe character (|).
- `secret_auto_rotation` (optional, default = `true`): Whether to configure automatic rotation of the service credential.
- `secret_auto_rotation_unit` (optional, default = `day`): Specifies the unit of time for rotation of a secret. Acceptable values are `day` or `month`.
- `secret_auto_rotation_interval` (optional, default = `89`): Specifies the rotation interval for the rotation unit.
- `service_credentials_ttl` (optional, default = `7776000`): The time-to-live (TTL) to assign to generated service credentials (in seconds).
- `service_credential_secret_description` (optional, default = `null`): Description of the secret to create.

The following example includes all the configuration options for four service credentials across two secret groups.

```hcl
[
  {
    "secret_group_name": "sg-1"
    "existing_secret_group": true
    "service_credentials": [                                              # pragma: allowlist secret
      {
        "secret_name": "cred-1"
        "service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Editor"
        "secret_labels": ["test-editor-1", "test-editor-2"]
        "secret_auto_rotation": true
        "secret_auto_rotation_unit": "day"
        "secret_auto_rotation_interval": 89
        "service_credentials_ttl": 7776000
        "service_credential_secret_description": "sample description"
      },
      {
        "secret_name": "cred-2"
        "service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Viewer"
      }
    ]
  },
  {
    "secret_group_name": "sg-2"
    "service_credentials": [                                              # pragma: allowlist secret
      {
        "secret_name": "cred-3"
        "service_credentials_source_service_role_crn": "crn:v1:bluemix:public:iam::::role:Viewer"
      }
    ]
  }
]
```
