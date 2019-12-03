#import cx_Oracle

#myuser = "system"
#mypwd = "oracle"
#dsn_tns = cx_Oracle.makedsn('jdbc:oracle:thin:@192.168.8.103','1521',service_name='XE')
# connection = cx_Oracle.connect(user=myuser, password=mypwd, dsn=dsn_tns) # jdbc:oracle:thin:@192.168.8.103:1521/XE
import cx_Oracle

con = cx_Oracle.connect('system/oracle@192.168.8.101/XE')
print(con.version)
cursor = con.cursor()
try:
    # enable DBMS_OUTPUT
    cursor.callproc("dbms_output.enable")
    vorname = str(input('vorname: '))
    nachname = str(input('Nachname: '))
    geb_datum = str(input('Geburtsdatum: '))
    ortsname = str(input('Ortsname: '))
    strasse = str(input('Strasse: '))
    hausnummer = int(input('Hausnummer: '))
    tuernummer = int(input('Türnummer: '))
    plz = int(input('PLZ: '))
    # perform loop to fetch the text that was added by PL/SQL
    cursor.callproc('sp_kunde_anlegen', [
                    plz, ortsname, strasse, hausnummer, tuernummer, vorname, nachname, geb_datum])
    textVar = cursor.var(str)
    statusVar = cursor.var(int)
    while True:
        cursor.callproc("dbms_output.get_line", (textVar, statusVar))
        if statusVar.getvalue() != 0:
            break
        print(textVar.getvalue())

except ValueError:
    print('Daten haben das falsche Format!')

finally:
    con.close()
