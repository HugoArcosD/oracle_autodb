#!/usr/bin/env python3
import os
import oracledb

wallet_dir = os.environ.get('ORACLE_WALLET_DIR') or os.environ.get('TNS_ADMIN')
if not wallet_dir:
    raise SystemExit('Define ORACLE_WALLET_DIR or TNS_ADMIN before running this script.')

user = os.environ.get('DB_USER', 'admin')
password = os.environ.get('DB_PASS')
if not password:
    raise SystemExit('Define DB_PASS in the environment before running this script.')

alias = 'pocdb_tp'

print('Using alias:', alias)
print('Wallet dir:', wallet_dir)

conn = oracledb.connect(user=user, password=password, dsn=alias, wallet_location=wallet_dir)
cur = conn.cursor()
cur.execute('SELECT 1 FROM DUAL')
row = cur.fetchone()
print('Result:', row)
cur.close()
conn.close()
