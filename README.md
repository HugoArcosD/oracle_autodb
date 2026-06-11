# OCI Autonomous Database with Terraform

Terraform configuration to provision an Oracle Autonomous Database (Always Free Tier) on OCI.

## Requirements

- Terraform >= 1.x
- OCI CLI configured on your machine (with credentials)
- OCI account with access to Always Free Tier
- Python 3.7+ (for connection scripts)

## Project Structure

```
.
├── main.tf              # Main resources (database + compartment)
├── provider.tf          # OCI provider configuration
├── variables.tf         # Variable declarations
├── outputs.tf           # Outputs (connection strings, etc.)
├── terraform.tfvars     # ⚠️ NOT in the repo (contains credentials)
├── test_conn.py         # Script to test connection from Python
├── query_dual.py        # Example script to execute queries
├── Wallet_POCDB/        # ⚠️ NOT in the repo (SSL certificates)
└── README.md            # This file
```

## Initial Configuration

### 1. Clone the repository
```bash
git clone https://github.com/HugoArcosD/oracle_autodb.git
cd oracle_autodb
```

### 2. Get OCI credentials
You need your OCI CLI configuration file:
```bash
cat ~/.oci/config
```

You will need the following values:
- `tenancy`: OCID of your tenancy
- `user`: OCID of your user
- `fingerprint`: Fingerprint of your API key
- `region`: Region (e.g. eu-frankfurt-1)
- `key_file`: Path to your private key PEM

### 3. Download the Database Wallet

After creating the database (first `terraform apply`), download the wallet from OCI Console:
1. Autonomous Database → Your database → DB Connection
2. Download Client Credentials (Wallet)
3. Decompress the wallet into `./Wallet_POCDB/`

```bash
unzip Wallet_POCDB.zip -d ./Wallet_POCDB/
```

### 4. Create `terraform.tfvars`

Create a `terraform.tfvars` file in the project root (do NOT commit it):

```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaacwrzupbdnu6a3vcua56liklvd44w4zehpfekuy5cfifruidkzm7q"
user_ocid        = "ocid1.user.oc1..aaaaaaaartkwuxk63tu5cey24kwodwlmu5nab3g5vpbtubwsme5ieuk2xw6a"
fingerprint      = "96:7f:bd:02:9a:bd:34:8c:51:96:fb:7a:85:3e:d0:34"
region           = "eu-frankfurt-1"
private_key_path = "/path/to/your/private_key.pem"
db_password      = "YourSecurePassword123!"  # Minimum 12 characters
```

Replace the values with yours from OCI.

## Deploy the Database

### Initialize Terraform
```bash
terraform init
```

### Verify the plan
```bash
terraform plan
```

### Create the resources
```bash
terraform apply
```

Terraform will create:
- A compartment named `terraform-poc`
- An Autonomous Database (Always Free Tier)

## Connect to the Database from Python

### Install dependencies
```bash
python3 -m venv venv-oracledb
source venv-oracledb/bin/activate
pip install oracledb
```

### Run example queries
```bash
export ORACLE_WALLET_DIR=./Wallet_POCDB
export DB_USER=admin
export DB_PASS='YourSecurePassword123!'
python3 query_dual.py
```

### Example code
```python
import oracledb, os

conn = oracledb.connect(
    user="admin",
    password="YourSecurePassword123!",
    dsn="pocdb_tp",
    wallet_location="./Wallet_POCDB"
)
cur = conn.cursor()
cur.execute("SELECT 1 FROM DUAL")
print(cur.fetchone())
cur.close()
conn.close()
```

## Outputs

After `terraform apply`, you can view:
```bash
terraform output
```

You will get:
- `db_name`: Database name (POCDB)
- `db_state`: Current state (AVAILABLE)
- `connection_strings`: Connection strings for HIGH, MEDIUM, LOW, TP, TPURGENT
- `sql_dev_web_url`: SQL Developer Web URL
- `apex_url`: APEX (Oracle Application Express) URL

## Clean up Resources

To destroy the database and avoid costs:
```bash
terraform destroy
```

## Available Environment Variables

In `variables.tf` are defined:
- `tenancy_ocid`: OCID of your tenancy
- `user_ocid`: OCID of your user
- `fingerprint`: API key fingerprint
- `region`: OCI region
- `private_key_path`: Path to the private key
- `db_password`: Admin password (sensitive)
- `db_version`: Database version (default: 19c, can be 23ai or 26ai)

## Security Considerations

⚠️ **IMPORTANT:**
- **Never** commit `terraform.tfvars` (contains credentials)
- **Never** commit the `Wallet_POCDB/` folder (contains SSL certificates and keys)
- **Never** commit `.pem` files with your private keys
- Use `.gitignore` to automatically exclude these files

## Troubleshooting

### Connection error "DPY-6005"
Make sure:
1. The wallet is downloaded and in `./Wallet_POCDB/`
2. The environment variables are exported:
   ```bash
   export ORACLE_WALLET_DIR=./Wallet_POCDB
   export DB_USER=admin
   export DB_PASS='your_password'
   ```
3. The database is in `AVAILABLE` state

### OCI authentication error
Check:
1. Your `terraform.tfvars` has the correct OCI values
2. Your private key is at the specified path and is readable
3. Your fingerprint matches exactly what appears in OCI Console

## References

- [Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Autonomous Database](https://docs.oracle.com/en-us/iaas/Content/Database/Concepts/adboverview.htm)
- [Python oracledb Driver](https://python-oracledb.readthedocs.io/)
- [OCI Free Tier](https://www.oracle.com/cloud/free/)

## License

MIT

## Support

If you need help, consult the official OCI documentation or open an issue.

