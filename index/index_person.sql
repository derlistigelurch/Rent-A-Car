/*********************************************************************
/**
/** Name: person_adress_id_index
/** Table: PERSON
/** Attributes: ADRESS_ID
/**
/*********************************************************************/
CREATE INDEX person_adress_id_index
ON PERSON(ADRESS_ID);

/*********************************************************************
/**
/** Name: person_name_index
/** Table: PERSON
/** Attributes: NACHNAME, VORNAME
/**
/*********************************************************************/
CREATE INDEX person_name_index
ON PERSON(NACHNAME, VORNAME);

COMMIT;
