#!/usr/bin/env python3
"""
Simple test script for Autonomous DB using python-oracledb (thin mode).
Usage:
  export TNS_ADMIN=~/oracle/wallet
  export DB_USER=admin
  export DB_PASS="your_admin_password"
  python3 test_conn.py [TNS_ALIAS]
If DB_PASS not set, the script will prompt for it.
"""
import os
import sys
import getpass

try:
    import oracledb
except Exception as e:
    print("python-oracledb no está instalado. Activa tu venv y `pip install python-oracledb`.")
    raise

alias = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('TNS_ALIAS', 'pocdb_tp')
wallet_dir = os.environ.get('TNS_ADMIN') or os.environ.get('ORACLE_WALLET_DIR')
user = os.environ.get('DB_USER', 'admin')
password = os.environ.get('DB_PASS')
if not wallet_dir:
    print('ERROR: define TNS_ADMIN o ORACLE_WALLET_DIR al directorio de tu wallet.')
    print('Ejemplo: export ORACLE_WALLET_DIR=/mnt/c/Users/hgaz/Downloads/terraform/oracle/oracle_autodb/Wallet_POCDB')
    sys.exit(1)
if not password:
    password = getpass.getpass(f'Password for {user}: ')

try:
    conn = oracledb.connect(user=user, password=password, dsn=alias, wallet_location=wallet_dir)
    print('Conectado. versión cliente/servidor:', conn.version)
    conn.close()
except Exception as e:
    print('Error al conectar:', e)
    sys.exit(1)
