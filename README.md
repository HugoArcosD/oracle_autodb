# OCI Autonomous Database with Terraform

Terraform configuration para provisionar una base de datos Oracle Autonomous Database (Always Free Tier) en OCI.

## Requisitos

- Terraform >= 1.x
- OCI CLI configurado en tu máquina (con credenciales)
- Cuenta OCI con acceso a Always Free Tier
- Python 3.7+ (para scripts de conexión)

## Estructura del Proyecto

```
.
├── main.tf              # Recursos principales (base de datos + compartment)
├── provider.tf          # Configuración del proveedor OCI
├── variables.tf         # Declaración de variables
├── outputs.tf           # Outputs (conexión strings, etc.)
├── terraform.tfvars     # ⚠️ NO está en el repo (contiene credenciales)
├── test_conn.py         # Script para probar conexión desde Python
├── query_dual.py        # Script de ejemplo para ejecutar queries
├── Wallet_POCDB/        # ⚠️ NO está en el repo (certificados SSL)
└── README.md            # Este archivo
```

## Configuración Inicial

### 1. Clonar el repositorio
```bash
git clone https://github.com/TU_USUARIO/oracle_autodb.git
cd oracle_autodb
```

### 2. Obtener las credenciales de OCI
Necesitas tu archivo de configuración de OCI CLI:
```bash
cat ~/.oci/config
```

Necesitarás los siguientes valores:
- `tenancy`: OCID de tu tenancy
- `user`: OCID de tu usuario
- `fingerprint`: Fingerprint de tu API key
- `region`: Región (ej. eu-frankfurt-1)
- `key_file`: Ruta a tu private key PEM

### 3. Descargar el Wallet de la Base de Datos

Después de crear la base de datos (primer `terraform apply`), descarga el wallet desde OCI Console:
1. Autonomous Database → Tu base de datos → DB Connection
2. Download Client Credentials (Wallet)
3. Descomprime el wallet en `./Wallet_POCDB/`

```bash
unzip Wallet_POCDB.zip -d ./Wallet_POCDB/
```

### 4. Crear `terraform.tfvars`

Crea un archivo `terraform.tfvars` en la raíz del proyecto (NO lo hagas commit):

```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaacwrzupbdnu6a3vcua56liklvd44w4zehpfekuy5cfifruidkzm7q"
user_ocid        = "ocid1.user.oc1..aaaaaaaartkwuxk63tu5cey24kwodwlmu5nab3g5vpbtubwsme5ieuk2xw6a"
fingerprint      = "96:7f:bd:02:9a:bd:34:8c:51:96:fb:7a:85:3e:d0:34"
region           = "eu-frankfurt-1"
private_key_path = "/ruta/a/tu/private_key.pem"
db_password      = "TuContraseñaSegura123!"  # Mínimo 12 caracteres
```

Reemplaza los valores con los tuyos de OCI.

## Desplegar la Base de Datos

### Inicializar Terraform
```bash
terraform init
```

### Verificar plan
```bash
terraform plan
```

### Crear los recursos
```bash
terraform apply
```

Terraform creará:
- Un compartment llamado `terraform-poc`
- Una base de datos Autonomous Database (Always Free Tier)

## Conectarse a la Base de Datos desde Python

### Instalar dependencias
```bash
python3 -m venv venv-oracledb
source venv-oracledb/bin/activate
pip install oracledb
```

### Ejecutar queries de ejemplo
```bash
export ORACLE_WALLET_DIR=./Wallet_POCDB
export DB_USER=admin
export DB_PASS='TuContraseñaSegura123!'
python3 query_dual.py
```

### Código de ejemplo
```python
import oracledb, os

conn = oracledb.connect(
    user="admin",
    password="TuContraseñaSegura123!",
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

Después de `terraform apply`, puedes ver:
```bash
terraform output
```

Obtendrás:
- `db_name`: Nombre de la base de datos (POCDB)
- `db_state`: Estado actual (AVAILABLE)

## Limpiar los Recursos

Para destruir la base de datos y evitar costos:
```bash
terraform destroy
```

## Variables de Entorno Disponibles

En `variables.tf` se definen:
- `tenancy_ocid`: OCID de tu tenancy
- `user_ocid`: OCID de tu usuario
- `fingerprint`: Fingerprint de API key
- `region`: Región de OCI
- `private_key_path`: Ruta a la clave privada
- `db_password`: Contraseña del admin (sensible)

## Consideraciones de Seguridad

⚠️ **IMPORTANTE:**
- **Nunca** hagas commit de `terraform.tfvars` (contiene credenciales)
- **Nunca** hagas commit de la carpeta `Wallet_POCDB/` (contiene certificados SSL y llaves)
- **Nunca** hagas commit de archivos `.pem` con tus claves privadas
- Usa `.gitignore` para excluir estos archivos automáticamente

## Troubleshooting

### Error de conexión "DPY-6005"
Asegúrate de:
1. El wallet está descargado y en `./Wallet_POCDB/`
2. Las variables de entorno están exportadas:
   ```bash
   export ORACLE_WALLET_DIR=./Wallet_POCDB
   export DB_USER=admin
   export DB_PASS='tu_contraseña'
   ```
3. La base de datos está en estado `AVAILABLE`

### Error de autenticación con OCI
Verifica:
1. Tu `terraform.tfvars` tiene los valores correctos de OCI
2. Tu clave privada está en la ruta indicada y es legible
3. Tu fingerprint coincide exactamente con el que aparece en OCI Console

## Referencias

- [Terraform OCI Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI Autonomous Database](https://docs.oracle.com/en-us/iaas/Content/Database/Concepts/adboverview.htm)
- [Python oracledb Driver](https://python-oracledb.readthedocs.io/)
- [OCI Free Tier](https://www.oracle.com/cloud/free/)

## Licencia

MIT

## Contacto

Si necesitas ayuda, consulta la documentación oficial de OCI o abre un issue.
