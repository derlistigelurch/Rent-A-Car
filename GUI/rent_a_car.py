import subprocess as sp
import cx_Oracle
import functions as functions
import json
with open('config/config.json') as config_file:
    config = json.load(config_file)


def welcome_screen():
    print("                -.+*'*+._Welcome to DB-project 2019.+*'*+._-")
    print("     Teammembers: Oliver Wondrusch, Alina Brem, Morris Venz, Jakob Müllner")
    print(" -----------------------------------------------------------------------------\n")


def main_screen():
    print("---------------------------------------")
    print("-Choose an option:                    -")
    print("---------------------------------------")
    print("- 1.) Add customer                    -")
    print("- 2.) Edit customer                   -")
    print("- 3.) Rent a car                      -")
    print("- 4.) Return a car                    -")
    print("-                                     -")
    print("- 5.) QUIT                            -")
    print("---------------------------------------")


welcome_screen()

while(True):
    try:
        main_screen()
        i = int(input(": "))

        if i == 1:
            functions.kunde_anlegen()
        elif i == 2:
            functions.kunde_bearbeiten()
        elif i == 3:
            functions.auto_verleihen()
        elif i == 4:
            functions.auto_zurueckgeben()
        elif i == 5:
            exit()

    except ValueError:
        print('\n\nDaten haben das falsche Format!\n\n')

    except KeyboardInterrupt:
        print('\n\nVorgang wird abgebrochen...\n\n')
