/*********************************************************************
/**
/** Trigger: tr_as_u_person_adresse
/** Type: after statement
/** Type Extension: update
/** Developer: 
/** Description: Zeigt die neue und die alte Adresse nach einer Änderung an
/**
/*********************************************************************/
SET SERVEROUTPUT ON;
/

CREATE OR REPLACE TRIGGER tr_as_u_person_adresse
  AFTER UPDATE OF ADRESS_ID ON PERSON FOR EACH ROW
  DECLARE
    l_v_strasse_old VARCHAR2(255);
    l_v_ortsname_old VARCHAR2(255);
    l_i_plz_old INTEGER;
    l_i_hausnummer_old INTEGER;
    l_i_tuernummer_old INTEGER;

    l_v_strasse_new VARCHAR2(255);
    l_v_ortsname_new VARCHAR2(255);
    l_i_plz_new INTEGER;
    l_i_hausnummer_new INTEGER;
    l_i_tuernummer_new INTEGER;

  BEGIN
    IF :old.ADRESS_ID != :new.ADRESS_ID
    THEN
      SELECT ADRESSE.HAUSNUMMER, ADRESSE.PLZ, ADRESSE.STRASSE, ADRESSE.TUERNUMMER, POSTLEITZAHL.ORTSNAME
      INTO l_i_hausnummer_old, l_i_plz_old, l_v_strasse_old, l_i_tuernummer_old, l_v_ortsname_old
      FROM ADRESSE JOIN POSTLEITZAHL ON POSTLEITZAHL.PLZ = ADRESSE.PLZ 
      WHERE ADRESSE.ADRESS_ID = :old.ADRESS_ID;

      SELECT ADRESSE.HAUSNUMMER, ADRESSE.PLZ, ADRESSE.STRASSE, ADRESSE.TUERNUMMER, POSTLEITZAHL.ORTSNAME
      INTO l_i_hausnummer_new, l_i_plz_new, l_v_strasse_new, l_i_tuernummer_new, l_v_ortsname_new
      FROM ADRESSE JOIN POSTLEITZAHL ON POSTLEITZAHL.PLZ = ADRESSE.PLZ 
      WHERE ADRESSE.ADRESS_ID = :new.ADRESS_ID;

      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      IF l_i_tuernummer_old IS NULL
        THEN
          DBMS_OUTPUT.PUT_LINE('Alte Adresse: ' || l_v_strasse_old || ' ' || l_i_hausnummer_old || ', ' || l_i_plz_old || ' ' || l_v_ortsname_old);
        ELSE
          DBMS_OUTPUT.PUT_LINE('Alte Adresse: ' || l_v_strasse_old || ' ' || l_i_hausnummer_old || '/' || l_i_tuernummer_old || ', ' || l_i_plz_old || ' ' || l_v_ortsname_old);
      END IF;
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
      IF l_i_tuernummer_new IS NULL
        THEN
          DBMS_OUTPUT.PUT_LINE('Neue Adresse: ' || l_v_strasse_new || ' ' || l_i_hausnummer_new || ', ' || l_i_plz_new || ' ' || l_v_ortsname_new);
        ELSE
          DBMS_OUTPUT.PUT_LINE('Neue Adresse: ' || l_v_strasse_new || ' ' || l_i_hausnummer_new || '/' || l_i_tuernummer_new || ', ' || l_i_plz_new || ' ' || l_v_ortsname_new);
      END IF;
      DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    END IF;
  END tr_as_u_person_adresse;
/
COMMIT;
