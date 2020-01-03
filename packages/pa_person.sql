SET SERVEROUTPUT ON;
/
/**********************************************************************
/*
/* Package: pa_person
/* Developer:
/* Description: Beinhaltet alle Person-Tabellen-Funktionen
/*
/**********************************************************************/
CREATE OR REPLACE PACKAGE pa_person
AS
  /*********************************************************************
  /**
  /** Function: f_insert_person_i
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** In: l_d_gebdatum_in - Geburtsdatum des Kunden
  /** In: l_i_adress_id_in - Adress ID
  /** Returns: Person ID
  /** Developer: 
  /** Description: Neuen Datensatz in Personen-Tabelle erstellen
  /**
  /*********************************************************************/
  FUNCTION f_insert_person_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER) RETURN INTEGER;

  /*********************************************************************
  /**
  /** Procedure: sp_change_name
  /** In: l_i_person_id - Person ID
  /** Developer: 
  /** Description: Ändert den Namen des Kunden
  /**
  /**********************************************************************/
  PROCEDURE sp_change_name (l_i_person_id_in IN INTEGER, l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2);

  /*********************************************************************
  /**
  /** Procedure: sp_update_adress_id
  /** In: l_i_person_id_in - Person ID
  /** In: l_i_adress_id_in - Adress ID
  /** Developer: 
  /** Description: Ändert die Adresse des Kunden
  /**
  /**********************************************************************/
  PROCEDURE sp_update_adress_id (l_i_person_id_in IN INTEGER, l_i_adress_id_in IN INTEGER);

  /*********************************************************************
  /**
  /** Function: f_get_person_id
  /** In: l_i_kunde_id - Kunden ID
  /** Developer: 
  /** Description: Returned die KundenID
  /**
  /**********************************************************************/
  Function f_get_person_id (l_i_kunde_id_in IN INTEGER) RETURN INTEGER;
END pa_person;
/

-- pa_person body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_person
AS
  /* f_insert_person_i definition *******************************************/
  FUNCTION f_insert_person_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_i_person_id INTEGER;
    BEGIN  
      INSERT INTO PERSON (PERSON_ID, VORNAME, NACHNAME, GEBURTSDATUM, ADRESS_ID) 
      VALUES (person_seq.NEXTVAL, l_v_vorname_in, l_v_nachname_in, l_d_gebdatum_in, l_i_adress_id_in)
      RETURNING PERSON_ID
      INTO l_i_person_id;
      RETURN l_i_person_id;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END f_insert_person_i;
  /*************************************************************************/
  
  /* sp_change_name definition *******************************************/
  PROCEDURE sp_change_name (l_i_person_id_in IN INTEGER, l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2)
  AS
    BEGIN
      UPDATE PERSON
      SET VORNAME = l_v_vorname_in,
          NACHNAME = l_v_nachname_in
      WHERE PERSON_ID = l_i_person_id_in;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END sp_change_name; 
  /*************************************************************************/

  /* sp_update_adress_id definition *******************************************/
  PROCEDURE sp_update_adress_id (l_i_person_id_in IN INTEGER, l_i_adress_id_in IN INTEGER)
  AS
    BEGIN
      UPDATE PERSON
      SET ADRESS_ID = l_i_adress_id_in
      WHERE PERSON_ID = l_i_person_id_in;
    /*EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END sp_update_adress_id;
  /*************************************************************************/

  /* f_get_person_id definition *******************************************/
  FUNCTION f_get_person_id (l_i_kunde_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_i_kunde_id INTEGER;
    BEGIN
      SELECT PERSON_ID
      INTO l_i_kunde_id
      FROM KUNDE
      WHERE KUNDE_ID = l_i_kunde_id_in;
      RETURN l_i_kunde_id;
    /*EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE NO_DATA_FOUND;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;*/
    END f_get_person_id;
  /*************************************************************************/
END;
/
COMMIT;

