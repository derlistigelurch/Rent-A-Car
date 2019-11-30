SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_person
AS
  /*********************************************************************
  /**
  /** Procedure: sp_insert_person_i
  /** Out: l_i_person_id_ou - Person ID
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** In: l_d_gebdatum_in - Geburtsdatum des Kunden
  /** In: l_i_adress_id_in - Adress ID
  /** Developer: 
  /** Description: Neuen Datensatz in Personen-Tabelle erstellen
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_person_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER, l_i_person_id_ou OUT INTEGER);
END pa_person;
/

-- pa_person body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_person
AS
  /* sp_insert_person_i definition *****************************************/
  PROCEDURE  sp_insert_person_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_d_gebdatum_in IN DATE, l_i_adress_id_in IN INTEGER, l_i_person_id_ou OUT INTEGER)
  AS
    l_i_person_id INTEGER;
    BEGIN
      SELECT person_seq.NEXTVAL
      INTO l_i_person_id
      FROM DUAL;
      
      INSERT INTO PERSON (PERSON_ID, VORNAME, NACHNAME, GEBURTSTDATUM, ADRESS_ID) 
      VALUES (l_i_person_id, l_v_vorname_in, l_v_nachname_in, l_d_gebdatum_in, l_i_adress_id_in)
      RETURNING l_i_person_id
      INTO l_i_person_id_ou;
    END sp_insert_person_i;
  /*************************************************************************/
END;
/
