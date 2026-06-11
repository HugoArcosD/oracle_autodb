#!/usr/bin/env python3
import os
import oracledb

wallet_dir = os.environ.get('ORACLE_WALLET_DIR') or os.environ.get('TNS_ADMIN')
if not wallet_dir:
    raise SystemExit('Define ORACLE_WALLET_DIR o TNS_ADMIN antes de ejecutar este script.')

user = os.environ.get('DB_USER', 'admin')
password = os.environ.get('DB_PASS')
if not password:
    raise SystemExit('Define DB_PASS en el entorno antes de ejecutar este script.')

alias = 'pocdb_tp'

print('Usando alias:', alias)
print('Wallet dir:', wallet_dir)

conn = oracledb.connect(user=user, password=password, dsn=alias, wallet_location=wallet_dir)
cur = conn.cursor()
cur.execute('SELECT 1 FROM DUAL')
row = cur.fetchone()
print('Resultado:', row)
cur.close()
conn.close()
