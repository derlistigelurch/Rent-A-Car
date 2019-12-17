import cx_Oracle
import json
with open('config/config.json') as config_file:
    config = json.load(config_file)

def auto_zurueckgeben():
    connection_string = config['username'] + '/' + config['password'] + \
        '@' + config['ip_address'] + '/' + config['service']
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

            schaeden = int(input('Gibt es Schäden?\n1.) Ja\n2.)Nein\n:'))
            if schaeden is 1:
                bezeichnung = str(input('Bezeichnung: '))
            else:
                bezeichnung = None
            
            cursor.callproc('pa_verleih.sp_auto_zurueckgeben',
                            [kunden_id, schaeden, bezeichnung])
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
