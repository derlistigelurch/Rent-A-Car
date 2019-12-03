SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_schaeden
AS
  /*********************************************************************
  /**
  /** Function: f_get_schaeden_id_i
  /** In: l_v_schaeden_in - Schaden Beschreibung
  /** Returns: Schaden ID
  /** Developer: 
  /** Description: Returned Schaden ID
  /**
  /*********************************************************************/
  FUNCTION f_get_schaeden_id_i (l_v_schaeden_in IN VARCHAR2) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Function: f_get_schaeden_count_bi
  /** In: l_v_schaeden_in - Schaden Beschreibung
  /** Returns: 0 oder 1
  /** Developer: 
  /** Description: Gibt es den Schaden bereits in der Tabelle? (0 oder 1)
  /**
  /*********************************************************************/
  FUNCTION f_get_schaeden_count_bi (l_v_schaeden_in IN VARCHAR2) RETURN INTEGER;

  /*********************************************************************
  /**
  /** Function: f_insert_schaden_i
  /** In: l_v_schaeden_in -  Schaden Beschreibung
  /** Returns: Schaden ID
  /** Developer: 
  /** Description: Speichert eine neue Schadensart in der Datenbank
  /**
  /*********************************************************************/
  FUNCTION f_insert_schaden_i (l_v_schaeden_in IN VARCHAR2) RETURN INTEGER;
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_exemp_schaeden
  /** In: l_i_exemplar_id - Exemplar ID
  /** In: l_i_schaeden_id_in - Schaden ID
  /** Developer: 
  /** Description: Checkt ob die angegebene PLZ schon vorhanden ist
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_exemp_schaeden (l_i_exemplar_id IN INTEGER, l_i_schaeden_id_in IN INTEGER);
END pa_schaeden;
/

-- pa_schaeden body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_schaeden
AS
  /* f_get_schaeden_id_i definition *****************************************/
  FUNCTION f_get_schaeden_id_i (l_v_schaeden_in IN VARCHAR2)
  RETURN INTEGER
  AS
    l_i_schaeden_id INTEGER;
    BEGIN
      SELECT SCHAEDEN.SCHAEDEN_ID
      INTO l_i_schaeden_id
      FROM SCHAEDEN
      WHERE SCHAEDEN.BESCHREIBUNG = l_v_schaeden_in;
      RETURN l_i_schaeden_id;
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_get_schaeden_id_i;
  /*************************************************************************/
  /* f_get_schaeden_count_bi definition **************************************/
  FUNCTION f_get_schaeden_count_bi (l_v_schaeden_in IN VARCHAR2)
  RETURN INTEGER
  AS
    l_bi_schaeden_count INTEGER;
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_schaeden_count
      FROM SCHAEDEN
      WHERE BESCHREIBUNG = l_v_schaeden_in;
      RETURN l_bi_schaeden_count;
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_get_schaeden_count_bi;
  /*************************************************************************/
  
  /* sp_insert_schaden definition ******************************************/
  FUNCTION f_insert_schaden_i (l_v_schaeden_in IN VARCHAR2)
  RETURN INTEGER
  AS
    l_i_schaeden_id INTEGER;
    BEGIN
      INSERT INTO SCHAEDEN (SCHAEDEN_ID, BESCHREIBUNG)
      VALUES (schaden_seq.NEXTVAL, l_v_schaeden_in)
      RETURNING SCHAEDEN_ID
      INTO l_i_schaeden_id;
      RETURN l_i_schaeden_id;
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END f_insert_schaden_i;
  /*************************************************************************/
  
  /* sp_insert_exemp_schaeden_i definition **********************************/
  PROCEDURE sp_insert_exemp_schaeden (l_i_exemplar_id IN INTEGER, l_i_schaeden_id_in IN INTEGER)
  AS
    BEGIN
      INSERT INTO EXEMP_SCHAEDEN (KOMBO_ID, SCHAEDEN_ID, EXEMPLAR_ID) 
      VALUES (exemp_schaden_seq.NEXTVAL, l_i_schaeden_id_in, l_i_exemplar_id);
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END sp_insert_exemp_schaeden;
  /*************************************************************************/
END;
/
COMMIT;
