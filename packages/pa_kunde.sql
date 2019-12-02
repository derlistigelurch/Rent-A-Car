SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_kunde
AS
  /*********************************************************************
  /**
  /** Function: f_get_kunde_id_i
  /** In: l_v_vorname_in - Vorname des Kunden
  /** In: l_v_nachname_in - Nachname des Kunden
  /** Returns: ID des Kunden
  /** Developer: 
  /** Description: Ausgabe der Kunden ID
  /**
  /*********************************************************************/
  FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Function: f_get_car_count_bi
  /** In: l_i_kunde_id_in - ID des Kunden
  /** Returns: Anzahl der geliehenen Autos
  /** Developer: 
  /** Description: Ausgabe der Kunden ID
  /**
  /*********************************************************************/
  FUNCTION f_get_car_count_bi (l_i_kunde_id_in IN INTEGER) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Function: f_insert_kunde_i
  /** In: l_i_person_id_in - Person ID
  /** Returns: ID des Kunden
  /** Developer: 
  /** Description: Neuen Kunden anlegen
  /**
  /**********************************************************************/
  FUNCTION f_insert_kunde_i (l_i_person_id_in IN INTEGER) RETURN INTEGER;
END pa_kunde;
/

-- pa_kunde body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_kunde
AS
  /* f_get_kunde_id_i definition *********************************************/
  FUNCTION f_get_kunde_id_i (l_v_vorname_in IN VARCHAR2, l_v_nachname_in IN VARCHAR2)
  RETURN INTEGER
  AS
    l_i_kunde_id INTEGER;
    BEGIN
      SELECT KUNDENNUMMER
      INTO l_i_kunde_id
      FROM kundendaten_view
      WHERE VORNAME = l_v_vorname_in 
            AND NACHNAME = l_v_nachname_in;
      RETURN l_i_kunde_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 0;
        --RAISE;
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RETURN -1;
        --RAISE;
    END f_get_kunde_id_i;
  /*************************************************************************/
  
  /* f_get_car_count_bi definition *******************************************/
  FUNCTION f_get_car_count_bi (l_i_kunde_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_bi_car_count INTEGER;
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_car_count
      FROM VERLEIH
      WHERE VERLEIH.KUNDE_ID = l_i_kunde_id_in 
            AND VERLEIH.RETOURNIERT = 0;
      RETURN l_bi_car_count;
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RETURN -1;
        --RAISE;
    END f_get_car_count_bi;
  /*************************************************************************/

  /* f_insert_kunde_i definition *******************************************/
  FUNCTION f_insert_kunde_i (l_i_person_id_in IN INTEGER)
  RETURN INTEGER
  AS
    l_i_kunde_id INTEGER;
    BEGIN    
      INSERT INTO  KUNDE (KUNDE_ID, PERSON_ID) 
      VALUES (kunden_seq.NEXTVAL, l_i_person_id_in)
      RETURNING KUNDE_ID
      INTO l_i_kunde_id;
      RETURN l_i_kunde_id;
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_insert_kunde_i;
  /*************************************************************************/
END;
/
COMMIT;
