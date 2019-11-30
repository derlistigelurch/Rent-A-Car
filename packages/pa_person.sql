SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_person
AS
  /*********************************************************************
  /**
  /** Procedure: sp_insert_person
  /** Out: l_i_person_id_ou - Person ID
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** In: l_d_gebdatum_in - Geburtsdatum des Kunden
  /** In: l_i_adress_id_in - Adress ID
  /** Developer: 
  /** Description: Neuen Datensatz in Personen-Tabelle erstellen
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_person (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER, l_i_person_id_ou OUT INTEGER);
END pa_person;
/

-- pa_person body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_person
AS
  /* sp_insert_person definition *******************************************/
  PROCEDURE  sp_insert_person (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER, l_i_person_id_ou OUT INTEGER)
  AS
    BEGIN  
      INSERT INTO PERSON (PERSON_ID, VORNAME, NACHNAME, GEBURTSDATUM, ADRESS_ID) 
      VALUES (person_seq.NEXTVAL, l_v_vorname_in, l_v_nachname_in, l_d_gebdatum_in, l_i_adress_id_in)
      RETURNING PERSON_ID
      INTO l_i_person_id_ou;
    EXCEPTION
      WHEN OTHERS THEN
        l_i_person_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_insert_person;
  /*************************************************************************/
END;
/
