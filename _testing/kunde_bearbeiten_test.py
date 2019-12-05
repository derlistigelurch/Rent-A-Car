import cx_Oracle

con = cx_Oracle.connect('system/oracle@192.168.8.101/XE')
print(con.version)
cursor = con.cursor()

try:
    # enable DBMS_OUTPUT
    cursor.callproc("dbms_output.enable")
    vorname = str(input('vorname: '))
    nachname = str(input('Nachname: '))
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

        cursor.callproc('sp_adresse_bearbeiten', [
            plz, ortsname, strasse, hausnummer, tuernummer, vorname, nachname])
    elif aendern is 2:
        vorname_neu = str(input('vorname: '))
        nachname_neu = str(input('Nachname: '))

        cursor.callproc('sp_name_bearbeiten', [
            vorname, nachname, vorname_neu, nachname_neu])
    else:
        print('Ungültige Eingabe')

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
