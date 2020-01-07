from datetime import datetime
import cx_Oracle
import json
with open('config/config.json') as config_file:
    config = json.load(config_file)

############################################################################################################# auto verleihen
def auto_verleihen():
    connection_string = config['username'] + '/' + config['password'] + '@' + config['ip_address'] + '/' + config['service']
    con = cx_Oracle.connect(connection_string)
    # print(con.version)
    cursor = con.cursor()

    try:
        # enable DBMS_OUTPUT
        cursor.callproc("dbms_output.enable")
        count = cursor.var(int)
        # enable DBMS_OUTPUT
        cursor.callproc("dbms_output.enable")
        vorname = str(input('Vorname: '))
        nachname = str(input('Nachname: '))
        count = cursor.var(int)
        cursor.callproc('pa_kunde.sp_kunden_anzeigen', [vorname, nachname, count])

        textVar = cursor.var(str)
        statusVar = cursor.var(int)
        print("---------------------------------------")
        while True:
            cursor.callproc("dbms_output.get_line", (textVar, statusVar))
            if statusVar.getvalue() is not 0:
                break
            print(textVar.getvalue())
        print("---------------------------------------")
        
        if count.getvalue() is not 0:
            kunden_id = int(input('Kundennummer: '))
        
            cursor.callproc('pa_verleih.sp_autos_anzeigen', [count])

            while True:
                cursor.callproc("dbms_output.get_line", (textVar, statusVar))
                if statusVar.getvalue() is not 0:
                    break
                print(textVar.getvalue())

            if count.getvalue() is not 0:
                exemplar_id = int(input('Exemplar ID: '))

                while(True):
                    verliehen_von = str(input('Verliehen von: '))
                    # convert to datetime object
                    datetime_verliehen_von = datetime.strptime(
                        verliehen_von, '%d-%m-%Y').date()

                    verliehen_bis = str(input('Verliehen bis: '))
                    # convert to datetime object
                    datetime_verliehen_bis = datetime.strptime(
                        verliehen_bis, '%d-%m-%Y').date()

                    if datetime_verliehen_bis >= datetime_verliehen_von:
                        break

                    print("---------------------------------------")
                    print("Verleih-Ende ist ungültig!")
                    print("---------------------------------------")

                cursor.callproc('pa_verleih.sp_auto_verleihen', [
                                kunden_id, exemplar_id, datetime_verliehen_von, datetime_verliehen_bis])

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
#############################################################################################################

############################################################################################################# auto zurückgeben
def auto_zurueckgeben():
    connection_string = config['username'] + '/' + config['password'] + \
        '@' + config['ip_address'] + '/' + config['service']
    con = cx_Oracle.connect(connection_string)
    # print(con.version)
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
        print("---------------------------------------")
        while True:
            cursor.callproc("dbms_output.get_line", (textVar, statusVar))
            if statusVar.getvalue() is not 0:
                break
            print(textVar.getvalue())
        print("---------------------------------------")
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
#############################################################################################################

############################################################################################################# kunde anlegen
def kunde_anlegen():
    connection_string = config['username'] + '/' + config['password'] + '@' + config['ip_address'] + '/' + config['service']
    con = cx_Oracle.connect(connection_string)
    # print(con.version)
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
#############################################################################################################

############################################################################################################# kunde bearbeiten
def kunde_bearbeiten():
    connection_string = config['username'] + '/' + config['password'] + '@' + config['ip_address'] + '/' + config['service']
    con = cx_Oracle.connect(connection_string)
    # print(con.version)
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
        print("---------------------------------------")
        while True:
            cursor.callproc("dbms_output.get_line", (textVar, statusVar))
            if statusVar.getvalue() is not 0:
                break
            print(textVar.getvalue())
        print("---------------------------------------")
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
#############################################################################################################

############################################################################################################# rechnung austellen
def rechnung_austellen():
    connection_string = config['username'] + '/' + config['password'] + '@' + config['ip_address'] + '/' + config['service']
    con = cx_Oracle.connect(connection_string)
    # print(con.version)
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
        print("---------------------------------------")
        while True:
            cursor.callproc("dbms_output.get_line", (textVar, statusVar))
            if statusVar.getvalue() is not 0:
                break
            print(textVar.getvalue())
        print("---------------------------------------")

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
                print("----- RECHNUNG ", data[0], " --------------------")
                print("| Rechnungsnummer:", data[0])
                print("| Kundennummer:", data[1])
                print("| Vorname:", data[2])
                print("| Nachname:", data[3])
                print("| Mitarbeiternummer:", data[4])
                print("| Fahrzeug:", data[5],  data[6])
                print("| Dauer (Tage):", data[7])
                print("| Kosten pro Tag: €", data[8])
                print("| Kosten Gesamt: €", data[9])
                print("---------------------------------------")

    except ValueError:
        print('Daten haben das falsche Format!')

    except TypeError:
        print('Für diesen Kunden gibt es keine offene Rechnung!')

    except KeyboardInterrupt:
        print('\n\nVorgang wird abgebrochen...')

    finally:
        con.close()