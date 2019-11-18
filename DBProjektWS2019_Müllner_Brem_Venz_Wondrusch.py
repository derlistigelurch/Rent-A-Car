import subprocess as sp
import cx_Oracle

def clearScreen():
    tmp = sp.call('clear',shell=True)

class userInterface:
    
    def __init__(self,control_unit):
        self.control_unit = 0
        self.database = databaseAction()
        self.flag = 0
        #self.connection = cx_Oracle.connect('username/password@localhost')
        #self.cursor = cx_Oracle.cursor() 

    #Welcome screen
    @staticmethod
    def welcomeScreen():
        print("                -.+*'*+._Welcome to DB-project 2019.+*'*+._-")
        print("     Teammembers: Oliver Wondrusch, Alina Brem, Morris Venz, Jakob Müllner")
        print(" -----------------------------------------------------------------------------\n")

    #SCREEN:Main screen
    def mainScreen(self):
        if self.flag == 0:
            self.welcomeScreen()
            self.flag = 1

        print("---------------------------------------")
        print("-Choose an option:                    -")
        print("---------------------------------------")
        print("- 1.) Show views                      -")
        print("- 2.) Edit database                   -")
        print("- 3.) Add entry                       -")
        print("- 666.) -quit program-                -")
        print("---------------------------------------")
        
        self.control_unit = int(input("Please choose your option: "))

    #SCREEN: Show possible views
    def showViewsScreen(self):
        self.showViewsController()

        if self.control_unit != 0:
            print("---------------------------------------")
            print("-Choose a view you wish to SHOW:      -")
            print("---------------------------------------")
            print("- 1.) Demands                         -")
            print("- 2.) Cars in location                -")
            print("- 3.) Pricelist                       -")
            print("- 4.) Customer data                   -")
            print("- 5.) return to main                  -")
            print("- 666.) -quit program-                -")
            print("---------------------------------------")
            
            self.control_unit += int(input("Please choose your option: "))

    #CONTROLLER: Show Views SQL + Output
    def showViewsController(self):
        if self.control_unit == 11:
                self.database.showDemands()
                self.control_unit = 10

        elif self.control_unit == 12:
                self.database.showCarsInLocation()
                self.control_unit = 10

        elif self.control_unit == 13:
                self.database.showPricelist()
                self.control_unit = 10

        elif self.control_unit == 14:
                self.database.showCustomerData()
                self.control_unit = 10

        elif self.control_unit == 15:
                print("Returning to main")
                self.control_unit = 0
        else:
                pass

    #SCREEN: Edit database            
    def editDatabaseScreen(self):
        self.editDatabseController()
        
        if self.control_unit != 0:
            print("---------------------------------------")
            print("-Choose an action on database:        -")
            print("---------------------------------------")
            print("- 1.) ADD customer                    -")
            print("- 2.) EDIT customer                   -")
            print("- 3.) RENT car                        -")
            print("- 4.) RETURN car                      -")
            print("- 5.) CHECK availability              -")
            print("- 6.) CHECK status                    -")
            print("- 7.) EDIT status                     -")
            print("- 8.) SHOW pricelist                  -")
            print("- 9.) EDIT damage                     -")
            print("- 0.) return to main                  -")
            print("- 666.) -quit program-                -")
            print("---------------------------------------")
            
            tmp = int(input("Please choose your option: "))
            if tmp == 0:
                self.control_unit = 0
            else:    
                self.control_unit += tmp


    #CONTROLLER: Show Views SQL + Output
    def editDatabseController(self):
        if self.control_unit == 21:
                self.database.addCustomer()
                self.control_unit = 20

        elif self.control_unit == 22:
                self.database.editCustomer()
                self.control_unit = 20

        elif self.control_unit == 23:
                self.database.rentCar()
                self.control_unit = 20

        elif self.control_unit == 24:
                self.database.returnCar()
                self.control_unit = 20

        elif self.control_unit == 25:
                self.database.checkAvailability()
                self.control_unit = 20

        elif self.control_unit == 26:
                self.database.checkStatus()
                self.control_unit = 20

        elif self.control_unit == 27:
                self.database.editStatus()
                self.control_unit = 20

        elif self.control_unit == 28:
                self.database.showPricelist()
                self.control_unit = 20

        elif self.control_unit == 29:
                self.database.editDamage()
                self.control_unit = 20

        elif (self.control_unit == 666):
                print("Quitting... nobody cares :*")
                #self.cursor.close()
                #self.connection.close()
                exit(0)

        else:
                pass

    #Main controller
    ##############################################
    # controller values:                         #        
    # 0 = Main Screen                            #
    # 10-19 = show Views screen                  #
    # 20-29 = edit databse 
    ##############################################
    def controller(self):
        if self.control_unit == 0:
            self.mainScreen()

            if self.control_unit == 1:
                self.control_unit = 10                               #prepares controller for showViews
            elif self.control_unit == 2:
                self.control_unit = 20
            elif self.control_unit == 666:
                print("Quitting... nobody cares :*")
                #self.cursor.close()
                #self.connection.close()
                exit(0)

            else:
                print("Invalid statement returning to main")
                self.control_unit = 0

        elif self.control_unit >= 10 and self.control_unit < 20:
            self.showViewsScreen()

        elif self.control_unit >= 20 and self.control_unit < 30:
            self.editDatabaseScreen()

        elif self.control_unit > 600:
            print("Quitting... 0 fucks given :**")
            #self.cursor.close()
            #self.connection.close()
            exit(0)

        else:
            print("Invalid statement returning to main")
            self.control_unit = 0


class databaseAction:

    ############EDIT DATABASE##########################

    def addCustomer(self):
        print("Hello World")
        #self.cursor.execute(SQL)

    def editCustomer(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def rentCar(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def returnCar(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def checkAvailability(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def checkStatus(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def editStatus(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def showPricelist(self):
        print("Hello World")
        #implement SQL- Statement + output here

    def editDamage(self):
        print("Hello World")                                    
        #implement SQL- Statement + output here

    ###############VIEWS#################################

    def showDemands(self):
        print("Hello World")                                    
        #implement SQL- Statement + output here

    def showCarsInLocation(self):
        print("Hello World")                                    
        #implement SQL- Statement + output here

    def showPricelist(self):
        print("Hello World")                                    
        #implement SQL- Statement + output here

    def showCustomerData(self):
        print("Hello World")                                    
        #implement SQL- Statement + output here        

#######################################################################################MAIN METHOD    
gui = userInterface(0)
gui.welcomeScreen()
clearScreen()

while gui.control_unit != "q":
    gui.controller()
    clearScreen()


