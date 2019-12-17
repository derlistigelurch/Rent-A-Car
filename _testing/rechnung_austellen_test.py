import cx_Oracle
import json
with open('config/config.json') as config_file:
    config = json.load(config_file)

def rechnung_austellen():
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

        if count.getvalue() > 0:
            kunden_id = int(input('Kundennummer: '))
            rechnung = cursor.var(str)
            cursor.callproc('pa_verleih.sp_rechnung_anzeigen', [
                kunden_id, rechnung])

            if rechnung.getvalue() is None:
                textVar = cursor.var(str)
                statusVar = cursor.var(int)
                while True:
                    cursor.callproc("dbms_output.get_line", (textVar, statusVar))
                    if statusVar.getvalue() is not 0:
                        break
                    print(textVar.getvalue())
            else:
                data = str(rechnung.getvalue()).split(',')
                print("----- RECHNUNG ", data[0], " -----------------")
                print("| Rechnungsnummer:", data[0])
                print("| Kundennummer:", data[1])
                print("| Vorname:", data[2])
                print("| Nachname:", data[3])
                print("| Mitarbeiternummer:", data[4])
                print("| Fahrzeug:", data[5],  data[6])
                print("| Dauer (Tage):", data[7])
                print("| Kosten pro Tag: €", data[8])
                print("| Kosten Gesamt: €", data[9])
                print("------------------------------------")

    except ValueError:
        print('Daten haben das falsche Format!')

    except TypeError:
        print('Für diesen Kunden gibt es keine offene Rechnung!')

    except KeyboardInterrupt:
        print('\n\nVorgang wird abgebrochen...')

    finally:
        con.close()
