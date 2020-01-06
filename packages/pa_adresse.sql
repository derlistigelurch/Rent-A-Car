/**********************************************************************
/*
/* Package: pa_adresse
/* Developer:
/* Description: Beinhaltet alle Adress-Tabellen-Funktionen
/*
/**********************************************************************/
CREATE OR REPLACE PACKAGE pa_adresse
AS
  /*********************************************************************
  /**
  /** Function: f_get_plz_count_bi
  /** In: l_i_plz_in - Postleitzahl
  /** Returns: Anzahl der gefundenen PLZ (0 oder 1)
  /** Developer: 
  /** Description: Checkt ob die angegebene PLZ schon vorhanden ist
  /**
  /*********************************************************************/
  FUNCTION f_get_plz_count_bi (l_i_plz_in IN INTEGER) RETURN INTEGER;

  /*********************************************************************
  /**
  /** Procedure: sp_insert_plz
  /** In: l_i_plz_in - Postleitzahl
  /** In: l_v_ortsname_in - Ortsname
  /** Developer: 
  /** Description: Speichert PLZ und Ortsname in der Datenbank
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2);
  

  /*********************************************************************
  /**
  /** Function: f_get_adress_count_bi
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_i_plz_in - Postleitzahl
  /** Returns: Anzahl der gefundenen Adressen (0 oder 1)
  /** Developer: 
  /** Description: Checkt ob die angegebene Adresse schon vorhanden ist
  /**
  /*********************************************************************/
  FUNCTION f_get_adress_count_bi (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Function: f_get_adress_id_i
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_i_plz_in - Postleitzahl
  /** Returns: Adress ID
  /** Developer: 
  /** Description: Gibt die ID der angegebenen Adresse zurück
  /**
  /*********************************************************************/
  FUNCTION f_get_adress_id_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER;

  /*********************************************************************
  /**
  /** Function: f_insert_adresse_i
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_i_plz_in - Postleitzahl
  /** Returns: Adress ID
  /** Developer: 
  /** Description: Speichert die neue Adresse in der Datenbank
  /**
  /*********************************************************************/
  FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Procedure: sp_adresse_bearbeiten
  /** In: l_i_plz_in - Postleitzahl
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_v_ortsname_in - Ortsname
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Developer: 
  /** Description: Ändert die Adresse eines Kunden
  /**
  /**********************************************************************/
  PROCEDURE sp_adresse_bearbeiten(l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER, l_i_kunde_id_in IN INTEGER);
END pa_adresse;
/

-- pa_adresse body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_adresse
AS
  /* f_get_plz_count_bi definition ****************************************/
  FUNCTION f_get_plz_count_bi(l_i_plz_in IN INTEGER) 
  RETURN INTEGER
  AS
    l_bi_plz_count INTEGER;
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_plz_count
      FROM POSTLEITZAHL
      WHERE PLZ = l_i_plz_in;
      RETURN l_bi_plz_count;
    END f_get_plz_count_bi;
  /*************************************************************************/
  
  /* sp_insert_plz definition **********************************************/
  PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2)
  AS
    BEGIN
      INSERT INTO POSTLEITZAHL (PLZ, ORTSNAME) 
      VALUES (l_i_plz_in, l_v_ortsname_in);
    END sp_insert_plz;
  /*************************************************************************/

  /* f_get_adress_count_bi definition **********************************************/
  FUNCTION f_get_adress_count_bi (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER)
  RETURN INTEGER
  AS
    l_bi_adress_count INTEGER;
    BEGIN
      IF l_i_tuernr_in IS NULL
      THEN
        SELECT COUNT(*)
        INTO l_bi_adress_count
        FROM ADRESSE
        WHERE STRASSE = l_v_strasse_in
              AND HAUSNUMMER = l_i_hausnr_in
              AND TUERNUMMER IS NULL
              AND PLZ = l_i_plz_in;
      ELSE
        SELECT COUNT(*)
        INTO l_bi_adress_count
        FROM ADRESSE
        WHERE STRASSE = l_v_strasse_in
              AND HAUSNUMMER = l_i_hausnr_in
              AND TUERNUMMER = l_i_tuernr_in
              AND PLZ = l_i_plz_in;
      END IF;
      RETURN l_bi_adress_count;
    END f_get_adress_count_bi;
  /*************************************************************************/

  /* f_get_adress_id_i definition **********************************************/
  FUNCTION f_get_adress_id_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) 
  RETURN INTEGER
  AS
    l_i_adress_id INTEGER;
    BEGIN
      IF l_i_tuernr_in IS NULL
      THEN
        SELECT ADRESS_ID
        INTO l_i_adress_id
        FROM ADRESSE
        WHERE STRASSE = l_v_strasse_in
              AND HAUSNUMMER = l_i_hausnr_in
              AND TUERNUMMER IS NULL
              AND PLZ = l_i_plz_in;
      ELSE
        SELECT ADRESS_ID
        INTO l_i_adress_id
        FROM ADRESSE
        WHERE STRASSE = l_v_strasse_in
              AND HAUSNUMMER = l_i_hausnr_in
              AND TUERNUMMER = l_i_tuernr_in
              AND PLZ = l_i_plz_in;
      END IF;
      RETURN l_i_adress_id;
    END f_get_adress_id_i;
  /*************************************************************************/

  /* f_insert_adresse_i definition ******************************************/
  FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER)
  RETURN INTEGER
  AS
    l_i_adress_id INTEGER;
    BEGIN      
      INSERT INTO ADRESSE (ADRESS_ID, STRASSE, HAUSNUMMER, TUERNUMMER, PLZ) 
      VALUES (adresse_seq.NEXTVAL, l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in)
      RETURNING ADRESS_ID
      INTO l_i_adress_id;
      RETURN l_i_adress_id;
    END f_insert_adresse_i;
  /*************************************************************************/
  
  /* sp_adresse_bearbeiten definition ******************************************/
  PROCEDURE sp_adresse_bearbeiten(l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER, l_i_kunde_id_in IN INTEGER)
  AS
    l_i_adress_id INTEGER;
    l_i_person_id INTEGER;
    BEGIN
      SAVEPOINT l_savepoint;
      -- Person_ID herausfinen
      -- FUNCTION f_get_person_id (l_i_kunde_id_in IN INTEGER) RETURN INTEGER
      l_i_person_id := pa_person.f_get_person_id(l_i_kunde_id_in);
      -- Adresse ändern
      -- PLZ bereits vorhanden? Wenn nicht, dann einfügen (PLZ, Ortsname)
      -- FUNCTION f_get_plz_count_bi(l_i_plz_in IN INTEGER) RETURN INTEGER
      IF pa_adresse.f_get_plz_count_bi(l_i_plz_in) < 1
      THEN
        -- PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2)
        pa_adresse.sp_insert_plz(l_i_plz_in, l_v_ortsname_in);
      END IF;
      -- Adresse bereits vorhanden? Wenn nicht Adresse einfügen (Strasse, Hausnummer, Türnummer)
      -- FUNCTION f_get_adress_count_bi (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
      IF pa_adresse.f_get_adress_count_bi(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in) < 1
      THEN  
        -- FUNCTION f_insert_adresse_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
        l_i_adress_id := pa_adresse.f_insert_adresse_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
      ELSE
        -- FUNCTION f_get_adress_id_i (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER) RETURN INTEGER
        l_i_adress_id := pa_adresse.f_get_adress_id_i(l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in);
      END IF;
      -- AdressId ändern
      -- PROCEDURE sp_update_adress_id (l_i_person_id_in IN INTEGER, l_i_adress_id_in IN INTEGER)
      pa_person.sp_update_adress_id(l_i_person_id, l_i_adress_id);
      COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Kunde nicht gefunden!');
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        DBMS_OUTPUT.PUT_LINE('---------------------------------------');
        ROLLBACK TO l_savepoint;
    END sp_adresse_bearbeiten;
  /*************************************************************************/
END;
/

COMMIT;
