/*********************************************************************
/**
/** Name: verleih_verliehen_von_index
/** Table: VERLEIH
/** Attributes: VERLIEHEN_AB
/**
/*********************************************************************/
CREATE INDEX verleih_verliehen_von_index
ON VERLEIH(VERLIEHEN_AB);

/*********************************************************************
/**
/** Name: verleih_verliehen_bis_index
/** Table: VERLEIH
/** Attributes: VERLIEHEN_BIS
/**
/*********************************************************************/
CREATE INDEX verleih_verliehen_bis_index
ON VERLEIH(VERLIEHEN_BIS);

/*********************************************************************
/**
/** Name: verleih_exemplar_id_index
/** Table: VERLEIH
/** Attributes: EXEMPLAR_ID
/**
/*********************************************************************/
CREATE INDEX verleih_exemplar_id_index
ON VERLEIH(EXEMPLAR_ID);

/*********************************************************************
/**
/** Name: verleih_kunde_id_index
/** Table: VERLEIH
/** Attributes: KUNDE_ID
/**
/*********************************************************************/
CREATE INDEX verleih_kunde_id_index
ON VERLEIH(KUNDE_ID);

/*********************************************************************
/**
/** Name: verleih_mitarbeiter_id_index
/** Table: VERLEIH
/** Attributes: MITARBEITER_ID
/**
/*********************************************************************/
CREATE INDEX verleih_mitarbeiter_id_index
ON VERLEIH(MITARBEITER_ID);

COMMIT;