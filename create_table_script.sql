/*********************************************************************
/**
/** Table: HERSTELLER
/** Developer:
/** Description: Herstellerdaten
/**
/*********************************************************************/
CREATE TABLE HERSTELLER
(	
	HERSTELLER_ID NUMBER PRIMARY KEY,
	BEZEICHNUNG VARCHAR2(20) NOT NULL
);

/*********************************************************************
/**
/** Table: VERLEIH
/** Developer:
/** Description: Rechnungsdaten
/**
/*********************************************************************/
CREATE TABLE VERLEIH
(	
	VERLEIH_ID NUMBER PRIMARY KEY,
	EXEMPLAR_ID NUMBER NOT NULL,
	KUNDE_ID NUMBER NOT NULL,
	VERLIEHEN_AB TIMESTAMP(6),
	VERLIEHEN_BIS TIMESTAMP(6),
	RETOURNIERT NUMBER(1) CHECK(RETOURNIERT IN (1,0)),
	MITARBEITER_ID NUMBER
);

/*********************************************************************
/**
/** Table: EXEMPLAR
/** Developer:
/** Description: Speichert Daten zu einzelnen zu verleihenden Exemplaren
/**
/*********************************************************************/
CREATE TABLE EXEMPLAR
(	
	EXEMPLAR_ID NUMBER PRIMARY KEY,
	KENNZEICHEN VARCHAR2(20) NOT NULL,
	ERSTZULASSUNG DATE NOT NULL,
	FARBE VARCHAR(15) NOT NULL,
	STATUS_ID NUMBER NOT NULL,
	SCHAEDEN_ID NUMBER,
	STANDORT_ID NUMBER,
	AUTO_DETAILS_ID NUMBER
);

/*********************************************************************
/**
/** Table: SCHAEDEN
/** Developer:
/** Description: Beschreibungen der Schaeden (Motorschaden, ...)
/**
/*********************************************************************/
CREATE TABLE SCHAEDEN
(	
	SCHAEDEN_ID NUMBER PRIMARY KEY,
	BESCHREIBUNG VARCHAR2(200) NOT NULL
);

/*********************************************************************
/**
/** Table: STATUS
/** Developer:
/** Description: Statusbeschreibungen der Autos (im Haus, verliehen, kaputt, ...)
/**
/*********************************************************************/
CREATE TABLE STATUS
(	
	STATUS_ID NUMBER PRIMARY KEY,
	BESCHREIBUNG VARCHAR2(200) NOT NULL
);

/*********************************************************************
/**
/** Table: PREISLISTE
/** Developer:
/** Description: Preis/Tag
/**
/*********************************************************************/
CREATE TABLE PREISLISTE
(	
	PREIS_ID NUMBER PRIMARY KEY,
	KOSTEN_PRO_TAG NUMBER(7,2) NOT NULL
);

/*********************************************************************
/**
/** Table: AUTO_DETAILS
/** Developer:
/** Description: Beinhaltet allgemeine Details zu einem Auto
/**
/*********************************************************************/
CREATE TABLE AUTO_DETAILS
(	
	DETAIL_ID NUMBER PRIMARY KEY,
	MODELL_BESCHREIBUNG VARCHAR(30) NOT NULL,
	SITZPLAETZE NUMBER,
	VERBRAUCH NUMBER,
	PS NUMBER,
	PREIS_ID NUMBER NOT NULL,
	HERSTELLER_ID NUMBER NOT NULL
);

/*********************************************************************
/**
/** Table: PERSON
/** Developer:
/** Description: Daten zur Person (Name, Geburtsdatum usw.)
/**
/*********************************************************************/
CREATE TABLE PERSON
(
	PERSON_ID NUMBER PRIMARY KEY,
	VORNAME VARCHAR2(30) NOT NULL,
	NACHNAME VARCHAR(30) NOT NULL,
	GEBURTSDATUM DATE NOT NULL,
	ADRESS_ID NUMBER NOT NULL
);

/*********************************************************************
/**
/** Table: MITARBEITER
/** Developer:
/** Description: Mitarbeiterdaten
/**
/*********************************************************************/
CREATE TABLE MITARBEITER
(	
	MITARBEITER_ID NUMBER PRIMARY KEY,
	PERSON_ID NUMBER NOT NULL,
	STANDORT_ID NUMBER NOT NULL
);

/*********************************************************************
/**
/** Table: KUNDE
/** Developer:
/** Description: Kundennummer, Referenz auf die Personentabelle
/**
/*********************************************************************/
CREATE TABLE KUNDE
(	
	KUNDE_ID NUMBER PRIMARY KEY,
	PERSON_ID NUMBER NOT NULL
);

/*********************************************************************
/**
/** Table: ADRESSE
/** Developer:
/** Description: Strasse, Hausnummer usw.
/**
/*********************************************************************/
CREATE TABLE ADRESSE
(	
	ADRESS_ID NUMBER PRIMARY KEY,
	STRASSE VARCHAR2(100),
	HAUSNUMMER NUMBER NOT NULL,
	TUERNUMMER NUMBER,
	PLZ NUMBER NOT NULL
);

/*********************************************************************
/**
/** Table: STANDORT
/** Developer:
/** Description: Standortinformationen
/**
/*********************************************************************/
CREATE TABLE STANDORT
(	
	STANDORT_ID NUMBER PRIMARY KEY,
	BEZEICHNUNG VARCHAR(30) NOT NULL,
	ADRESS_ID NUMBER NOT NULL
);

/*********************************************************************
/**
/** Table: POSTLEITZAHL
/** Developer:
/** Description: PLZ und Ortsnamen
/**
/*********************************************************************/
CREATE TABLE POSTLEITZAHL
(	
	PLZ NUMBER PRIMARY KEY,
	ORTSNAME VARCHAR(30) NOT NULL
);

/*********************************************************************
/**
/** Table: ERR_TABLE
/** Developer:
/** Description: Error logging
/**
/*********************************************************************/
CREATE TABLE ERR_TABLE
(
	ERR_ID NUMBER PRIMARY KEY,
	ERR_CODE NUMBER,
	ERR_MSG VARCHAR(256) 
);

ALTER TABLE VERLEIH ADD FOREIGN KEY (EXEMPLAR_ID)
	  REFERENCES EXEMPLAR (EXEMPLAR_ID) ENABLE;
ALTER TABLE VERLEIH ADD FOREIGN KEY (KUNDE_ID)
	  REFERENCES KUNDE (KUNDE_ID) ENABLE;
ALTER TABLE VERLEIH ADD FOREIGN KEY (MITARBEITER_ID)
	  REFERENCES MITARBEITER (MITARBEITER_ID) ENABLE;

ALTER TABLE EXEMPLAR ADD FOREIGN KEY (STATUS_ID)
	  REFERENCES STATUS (STATUS_ID) ENABLE;
ALTER TABLE EXEMPLAR ADD FOREIGN KEY (SCHAEDEN_ID)
	  REFERENCES SCHAEDEN (SCHAEDEN_ID) ENABLE;
ALTER TABLE EXEMPLAR ADD FOREIGN KEY (STANDORT_ID)
	  REFERENCES STANDORT (STANDORT_ID) ENABLE;
ALTER TABLE EXEMPLAR ADD FOREIGN KEY (AUTO_DETAILS_ID)
	  REFERENCES AUTO_DETAILS (DETAIL_ID) ENABLE;

ALTER TABLE AUTO_DETAILS ADD FOREIGN KEY (PREIS_ID)
	  REFERENCES PREISLISTE (PREIS_ID) ENABLE;
ALTER TABLE AUTO_DETAILS ADD FOREIGN KEY (HERSTELLER_ID)
	  REFERENCES HERSTELLER (HERSTELLER_ID) ENABLE;

ALTER TABLE MITARBEITER ADD FOREIGN KEY (PERSON_ID)
	  REFERENCES PERSON (PERSON_ID) ENABLE;
ALTER TABLE MITARBEITER ADD FOREIGN KEY (STANDORT_ID)
	  REFERENCES STANDORT (STANDORT_ID) ENABLE;

ALTER TABLE ADRESSE ADD FOREIGN KEY (PLZ)
		REFERENCES POSTLEITZAHL (PLZ) ENABLE;

ALTER TABLE KUNDE ADD FOREIGN KEY (PERSON_ID)
		REFERENCES PERSON (PERSON_ID) ENABLE;

ALTER TABLE PERSON ADD FOREIGN KEY (ADRESS_ID)
	  REFERENCES ADRESSE (ADRESS_ID) ENABLE;

COMMIT;