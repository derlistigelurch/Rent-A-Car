SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_kunde
AS
  /*********************************************************************
  /**
  /** Procedure: f_get_kunde_id_i
  /** Out: l_i_kunde_id_ou - ID des Kunden
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** Developer: 
  /** Description: Ausgabe der Kunden ID
  /**
  /**********************************************************************/
  PROCEDURE sp_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_kunde_id_ou OUT INTEGER);
  
  
  /*********************************************************************
  /**
  /** Procedure: f_get_car_count_i
  /** Out: l_bi_car_count_ou - Anzahl der Autos die ein Kunde ausgeliehen hat max. 1, min. 0
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Developer: 
  /** Description: Anzahl der Autos die ein Kunde ausgeliehen hat ausgeben
  /**
  /**********************************************************************/
  PROCEDURE sp_get_car_count_bi (l_i_kunde_id_in IN INTEGER, l_bi_car_count_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_kunde_i
  /** Out: l_i_kunde_id_ou - ID des Kunden
  /** In: l_i_person_id_in - Person ID
  /** Developer: 
  /** Description: Neuen Kunden anlegen
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_kunde_i (l_i_person_id_in IN INTEGER, l_i_kunde_id_ou OUT INTEGER);
END pa_kunde;
/

-- pa_kunde body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_kunde
AS
  /* sp_get_kunde_id_i definition *******************************************/
  PROCEDURE sp_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_kunde_id_ou OUT INTEGER)
  AS
    BEGIN
      SELECT KUNDE.KUNDE_ID
      INTO l_i_kunde_id_ou
      FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
      WHERE PERSON.VORNAME = l_v_vorname_in AND
            PERSON.NACHNAME = l_v_nachname_in;
    END sp_get_kunde_id_i;
  /*************************************************************************/
  
  /* sp_get_car_count_i definition *****************************************/
  PROCEDURE sp_get_car_count_bi (l_i_kunde_id_in IN INTEGER, l_bi_car_count_ou OUT INTEGER)
  AS
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_car_count_ou
      FROM VERLEIH
      WHERE VERLEIH.KUNDE_ID = l_i_kunde_id_in AND
            VERLEIH.RETOURNIERT = 0;
     END sp_get_car_count_bi;
  /*************************************************************************/

  /* sp_kunde_anlegen_i definition *****************************************/
  PROCEDURE sp_insert_kunde_i (l_i_person_id_in IN INTEGER, l_i_kunde_id_ou OUT INTEGER)
  AS
    l_i_kunde_id INTEGER;
    BEGIN    
      SELECT kunden_seq.NEXTVAL 
      INTO l_i_kunde_id
      FROM DUAL;
      
      INSERT INTO  KUNDE (KUNDE_ID, PERSON_ID) 
      VALUES (l_i_kunde_id, l_i_person_id_in)
      RETURNING l_i_kunde_id
      INTO l_i_kunde_id_ou;
    END sp_insert_kunde_i;
END;
/

