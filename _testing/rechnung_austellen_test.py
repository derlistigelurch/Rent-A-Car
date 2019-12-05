import cx_Oracle

con = cx_Oracle.connect('system/oracle@192.168.8.101/XE')
print(con.version)
cursor = con.cursor()

try:
    # enable DBMS_OUTPUT
    cursor.callproc("dbms_output.enable")
    vorname = str(input('Vorname: '))
    nachname = str(input('Nachname: '))

    rechnung = cursor.var(str)
    cursor.callproc('sp_rechnung_anzeigen', [
        vorname, nachname, rechnung])

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
    print('Kunde exisitiert nicht, oder hat keine offene Rechnung!')

except KeyboardInterrupt:
    print('\n\nVorgang wird abgebrochen...')

finally:
    con.close()
