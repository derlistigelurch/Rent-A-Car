/*********************************************************************
/**
/** Name: plz_ortsname_index
/** Table: POSTLEITZAHL
/** Attributes: ORTSNAME
/**
/*********************************************************************/
CREATE INDEX plz_ortsname_index
ON POSTLEITZAHL(ORTSNAME);

COMMIT;
