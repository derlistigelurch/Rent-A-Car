SET SERVEROUTPUT ON;
/
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
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_insert_person_i;
  /*************************************************************************/
END;
/
COMMIT;

