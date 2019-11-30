SET SERVEROUTPUT ON;
/
CREATE OR REPLACE PACKAGE pa_adresse
AS
  /*********************************************************************
  /**
  /** Procedure: sp_get_plz_count
  /** Out: l_bi_plz_count_ou - Anzahl der gefundenen PLZ (0 oder 1)
  /** In: l_i_plz_in - Postleitzahl
  /** Developer: 
  /** Description: Checkt ob die angegebene PLZ schon vorhanden ist
  /**
  /**********************************************************************/
  PROCEDURE sp_get_plz_count (l_i_plz_in IN INTEGER, l_bi_plz_count_ou OUT INTEGER);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_plz
  /** Out: l_row_plz_ou - Returned die Rowid des neuen Datensatzes
  /** In: l_i_plz_in - Postleitzahl
  /** In: l_v_ortsname_in - Ortsname
  /** Developer: 
  /** Description: Speichert PLZ und Ortsname in der Datenbank
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_row_plz_ou OUT ROWID);
  
  /*********************************************************************
  /**
  /** Procedure: sp_insert_adresse
  /** Out: l_i_adress_id_ou - Adress ID
  /** In: l_v_strasse_in - Strasse
  /** In: l_i_hausnr_in - Hausnummer
  /** In: l_i_tuernr_in - Türnummer
  /** In: l_i_plz_in - Postleitzahl
  /** Developer: 
  /** Description: Speichert die neue Adresse in der Datenbank
  /**
  /**********************************************************************/
  PROCEDURE sp_insert_adresse (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER, l_i_adress_id_ou OUT INTEGER);
END pa_adresse;
/

-- pa_adresse body
--------------------------------------
CREATE OR REPLACE PACKAGE BODY pa_adresse
AS
  /* sp_get_plz_count_bi definition ****************************************/
  PROCEDURE sp_get_plz_count (l_i_plz_in IN INTEGER, l_bi_plz_count_ou OUT INTEGER)
  AS
    BEGIN
      SELECT COUNT(*)
      INTO l_bi_plz_count_ou
      FROM POSTLEITZAHL
      WHERE PLZ = l_i_plz_in;
    EXCEPTION
      WHEN OTHERS THEN
        l_bi_plz_count_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_get_plz_count;
  /*************************************************************************/
  
  /* sp_insert_plz definition **********************************************/
  PROCEDURE sp_insert_plz (l_i_plz_in IN INTEGER, l_v_ortsname_in IN VARCHAR2, l_row_plz_ou OUT ROWID)
  AS
    BEGIN
      INSERT INTO POSTLEITZAHL (PLZ, ORTSNAME) 
      VALUES (l_i_plz_in, l_v_ortsname_in)
      RETURNING ROWID 
      INTO l_row_plz_ou;
    EXCEPTION
      WHEN OTHERS THEN
        l_row_plz_ou := NULL;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_insert_plz;
  /*************************************************************************/
  
  /* sp_insert_adresse definition ******************************************/
  PROCEDURE sp_insert_adresse (l_v_strasse_in IN VARCHAR2, l_i_hausnr_in IN INTEGER, l_i_tuernr_in IN INTEGER DEFAULT NULL, l_i_plz_in IN INTEGER, l_i_adress_id_ou OUT INTEGER)
  AS
    BEGIN      
      INSERT INTO ADRESSE (ADRESS_ID, STRASSE, HAUSNUMMER, TUERNUMMER, PLZ) 
      VALUES (adresse_seq.NEXTVAL, l_v_strasse_in, l_i_hausnr_in, l_i_tuernr_in, l_i_plz_in)
      RETURNING ADRESS_ID
      INTO l_i_adress_id_ou;
    EXCEPTION
      WHEN OTHERS THEN
        l_i_adress_id_ou := -1;
        pa_err.sp_err_handling(SQLCODE, SQLERRM);
    END sp_insert_adresse;
  /*************************************************************************/
END;
/
COMMIT;
