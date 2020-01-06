/*********************************************************************
/**
/** Name: mitarbeiter_person_id_index
/** Table: MITARBEITER
/** Attributes: PERSON_ID
/**
/*********************************************************************/
CREATE INDEX mitarbeiter_person_id_index
ON MITARBEITER(PERSON_ID);

/*********************************************************************
/**
/** Name: mitarbeiter_standort_id_index
/** Table: MITARBEITER
/** Attributes: STANDORT_ID
/**
/*********************************************************************/
CREATE INDEX mitarbeiter_standort_id_index
ON MITARBEITER(STANDORT_ID);

COMMIT;
