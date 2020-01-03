/*********************************************************************
/**
/** Trigger: tr_as_u_person_name
/** Type: after statement
/** Type Extension: update
/** Developer: 
/** Description: Zeigt den neuen und den alten Namen des Kunden bei einer Änderung an
/**
/*********************************************************************/
SET SERVEROUTPUT ON;
/

CREATE OR REPLACE TRIGGER tr_as_u_person_name
  AFTER UPDATE ON PERSON FOR EACH ROW
  BEGIN
  IF :old.VORNAME != :new.VORNAME AND :old.NACHNAME != :new.NACHNAME
  THEN
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Alter Name: ' || :old.VORNAME || ' ' || :old.NACHNAME);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Neuer Name: ' || :new.VORNAME || ' ' || :new.NACHNAME);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
  END IF;
  END tr_as_u_person_name;
/
COMMIT;
