/*********************************************************************
/**
/** Trigger: tr_as_i_kunde_erstellen
/** Type: after statement
/** Type Extension: insert
/** Developer: 
/** Description: Gibt den Namen und die Kundenid des neuen Kunden aus
/**
/*********************************************************************/
SET SERVEROUTPUT ON;
/

CREATE OR REPLACE TRIGGER tr_as_i_kunde_erstellen
  AFTER INSERT ON KUNDE
  DECLARE
    l_i_kunde_id INTEGER;
    l_v_vorname VARCHAR2(30);
    l_v_nachname VARCHAR2(50);
  BEGIN
    SELECT k.KUNDE_ID, k.VORNAME, k.NACHNAME
    INTO l_i_kunde_id, l_v_vorname, l_v_nachname
    FROM (SELECT KUNDE_ID, VORNAME, NACHNAME
      FROM PERSON JOIN KUNDE ON PERSON.PERSON_ID = KUNDE.PERSON_ID
      ORDER BY KUNDE_ID DESC) k
    WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Neuer Kunde ' || l_v_vorname || ' ' || l_v_nachname || ' mit der Kunden ID ' || l_i_kunde_id || ' wurd angelegt!');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------');
  END tr_as_i_kunde_erstellen;
/

COMMIT;
