from datetime import datetime
import cx_Oracle
import json
with open('config/config.json') as config_file:
    config = json.load(config_file)

def auto_verleihen():
    connection_string = config['username'] + '/' + config['password'] + '@' + config['ip_address'] + '/' + config['service']
    con = cx_Oracle.connect(connection_string)
    print(con.version)
    cursor = con.cursor()

    try:
        # enable DBMS_OUTPUT
        cursor.callproc("dbms_output.enable")
        count = cursor.var(int)
        cursor.callproc('pa_verleih.sp_autos_anzeigen', [count])

        textVar = cursor.var(str)
        statusVar = cursor.var(int)
        while True:
            cursor.callproc("dbms_output.get_line", (textVar, statusVar))
            if statusVar.getvalue() is not 0:
                break
            print(textVar.getvalue())

        if count.getvalue() is not 0:
            vorname = str(input('Vorname: '))
            nachname = str(input('Nachname: '))
            exemplar_id = int(input('Exemplar ID: '))

            verliehen_von = str(input('Verliehen von: '))
            # convert to datetime object
            datetime_verliehen_von = datetime.strptime(
                verliehen_von, '%d-%m-%Y').date()

            verliehen_bis = str(input('Verliehen bis: '))
            # convert to datetime object
            datetime_verliehen_bis = datetime.strptime(
                verliehen_bis, '%d-%m-%Y').date()

            cursor.callproc('pa_verleih.sp_auto_verleihen', [
                            vorname, nachname, exemplar_id, datetime_verliehen_von, datetime_verliehen_bis])

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
