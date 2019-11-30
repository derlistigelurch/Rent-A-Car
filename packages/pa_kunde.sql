SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_kunde
AS
  /*********************************************************************
  /**
  /** Procedure: sp_get_kunde_id
  /** Out: l_i_kunde_id_ou - ID des Kunden
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** Developer: 
  /** Description: Ausgabe der Kunden ID
  /**
  /**********************************************************************/
  PROCEDURE sp_get_kunde_id (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_kunde_id_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_get_car_count
  /** Out: l_bi_car_count_ou - Anzahl der Autos die ein Kunde ausgeliehen hat max. 1, min. 0
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Developer: 
  /** Description: Anzahl der Autos die ein Kunde ausgeliehen hat ausgeben
  /**
  /**********************************************************************/
  PROCEDURE sp_get_car_count (l_i_kunde_id_in IN INTEGER, l_bi_car_count_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_kunde
  /** Out: l_i_kunde_id_ou - ID des Kunden
  /** In: l_i_person_id_in - Person ID
  /** Developer: 
  /** Description: Neuen Kunden anlegen
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_kunde (l_i_person_id_in IN INTEGER, l_i_kunde_id_ou OUT INTEGER);
END pa_kunde;
/

-- pa_kunde body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_kunde
AS
  /* sp_get_kunde_id definition *********************************************/
  PROCEDURE sp_get_kunde_id (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2, l_i_kunde_id_ou OUT INTEGER)
  AS
    BEGIN
      SELECT KUNDE.KUNDE_ID
      INTO l_i_kunde_id_ou
      FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
      WHERE PERSON.VORNAME = l_v_vorname_in AND
            PERSON.NACHNAME = l_v_nachname_in;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_i_kunde_id_ou := 0;
      WHEN OTHERS THEN
        l_i_kunde_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_kunde_id;
  /*************************************************************************/
  
  /* sp_get_car_count definition *******************************************/
  PROCEDURE sp_get_car_count (l_i_kunde_id_in IN INTEGER, l_bi_car_count_ou OUT INTEGER)
  AS
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_car_count_ou
      FROM VERLEIH
      WHERE VERLEIH.KUNDE_ID = l_i_kunde_id_in AND
            VERLEIH.RETOURNIERT = 0;
    EXCEPTION
      WHEN OTHERS THEN
        l_bi_car_count_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_car_count;
  /*************************************************************************/

  /* sp_kunde_anlegen definition *******************************************/
  PROCEDURE sp_insert_kunde (l_i_person_id_in IN INTEGER, l_i_kunde_id_ou OUT INTEGER)
  AS
    BEGIN    
      INSERT INTO  KUNDE (KUNDE_ID, PERSON_ID) 
      VALUES (kunden_seq.NEXTVAL, l_i_person_id_in)
      RETURNING KUNDE_ID
      INTO l_i_kunde_id_ou;
      COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        l_i_kunde_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_insert_kunde;
  /*************************************************************************/
END;
/
COMMIT;
