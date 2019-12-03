SET SERVEROUTPUT ON;
/
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
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RETURN -1;
        RAISE;
    END f_get_plz_count_bi;
  /*************************************************************************/
  
  /* sp_insert_plz definition **********************************************/
  PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2)
  AS
    BEGIN
      INSERT INTO POSTLEITZAHL (PLZ, ORTSNAME) 
      VALUES (l_i_plz_in, l_v_ortsname_in);
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RAISE;
    END sp_insert_plz;
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
    EXCEPTION
      WHEN OTHERS THEN
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
        RETURN -1;
        --RAISE;
    END f_insert_adresse_i;
  /*************************************************************************/
END;
/
COMMIT;

