from datetime import datetime
import cx_Oracle
import json
with open('config/config.json') as config_file:
    config = json.load(config_file)

connection_string = config['username'] + '/' + config['password'] + '@' + config['ip_address'] + '/' + config['service']
con = cx_Oracle.connect(connection_string)
print(con.version)
cursor = con.cursor()
try:
    # enable DBMS_OUTPUT
    cursor.callproc("dbms_output.enable")
    vorname = str(input('Vorname: '))
    nachname = str(input('Nachname: '))

    geb_datum = str(input('Geburtsdatum: '))
    # convert to datetime object
    datetime_object = datetime.strptime(geb_datum, '%d-%m-%Y').date()

    ortsname = str(input('Ortsname: '))
    strasse = str(input('Strasse: '))
    hausnummer = int(input('Hausnummer: '))

    # check value of tuernummer
    tuernummer = input('Türnummer: ')
    if tuernummer is not "":
        tuernummer = int(tuernummer)

    plz = int(input('PLZ: '))

    # perform loop to fetch the text that was added by PL/SQL
    cursor.callproc('pa_kunde.sp_kunde_anlegen', [
                    plz, ortsname, strasse, hausnummer, tuernummer, vorname, nachname, datetime_object])
    textVar = cursor.var(str)
    statusVar = cursor.var(int)

    while True:
        cursor.callproc("dbms_output.get_line", (textVar, statusVar))
        if statusVar.getvalue() is not 0:
            break
        print(textVar.getvalue())

except ValueError:
    print('Daten haben das falsche Format!')

except KeyboardInterrupt:
    print('\n\nVorgang wird abgebrochen...')

finally:
    con.close()
