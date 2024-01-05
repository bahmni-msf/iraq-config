DELETE FROM global_property where property = 'emrapi.sqlSearch.allPatients';
select uuid() into @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.allPatients',
        "SELECT DISTINCT
    pi.identifier                                  AS identifier,
    concat(pn.given_name,' ', pn.family_name)      AS name,
    DATE_FORMAT(p.date_created,'%Y/%m/%d')               AS 'Registered Date',
    concat('', pe.uuid)                             AS uuid
    FROM patient p
    INNER JOIN person pe ON pe.person_id = p.patient_id AND p.voided IS FALSE and pe.voided = FALSE
    INNER JOIN person_name pn ON p.patient_id = pn.person_id AND pn.voided IS FALSE
    INNER JOIN patient_identifier pi ON p.patient_id = pi.patient_id AND pi.voided IS FALSE
      AND p.date_created >= '2021-01-01'
        ORDER BY p.date_created DESC",'All Patients',
        @uuid);