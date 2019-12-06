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

    count = cursor.var(int)
    cursor.callproc('pa_kunde.sp_kunden_anzeigen', [vorname, nachname, count])

    textVar = cursor.var(str)
    statusVar = cursor.var(int)
    print("------------------------------------")
    while True:
        cursor.callproc("dbms_output.get_line", (textVar, statusVar))
        if statusVar.getvalue() is not 0:
            break
        print(textVar.getvalue())
    print("------------------------------------")
    if count.getvalue() is not 0:
        kunden_id = int(input('Kundennummer: '))
        aendern = int(input('1.) Adresse ändern\n2.) Name ändern\n:'))

        # name oder adresse ändern
        if aendern is 1:
            ortsname = str(input('Ortsname: '))
            strasse = str(input('Strasse: '))
            hausnummer = int(input('Hausnummer: '))

            # check value of tuernummer
            tuernummer = input('Türnummer: ')
            if tuernummer is not "":
                tuernummer = int(tuernummer)

            plz = int(input('PLZ: '))

            cursor.callproc('pa_adresse.sp_adresse_bearbeiten', [
                plz, ortsname, strasse, hausnummer, tuernummer, kunden_id])
        elif aendern is 2:
            vorname_neu = str(input('(Neuer) Vorname: '))
            nachname_neu = str(input('(Neuer) Nachname: '))

            cursor.callproc('pa_kunde.sp_name_bearbeiten', [
                kunden_id, vorname_neu, nachname_neu])
        else:
            print('Ungültige Eingabe')

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
