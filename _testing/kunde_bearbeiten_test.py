import cx_Oracle

con = cx_Oracle.connect('system/oracle@192.168.8.101/XE')
print(con.version)
cursor = con.cursor()