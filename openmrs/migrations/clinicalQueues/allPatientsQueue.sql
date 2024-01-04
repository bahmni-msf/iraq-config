DELETE FROM global_property where property = 'emrapi.sqlSearch.allPatients';
select uuid() into @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.allPatients',
        "SELECT DISTINCT
    pi.identifier                                  AS identifier,
    concat(pn.given_name,' ', pn.family_name)      AS name,
    DATE_FORMAT(pa.value,'%Y/%m/%d')               AS 'Date of Entry',
    concat('', p.uuid)                             AS uuid
    FROM person p
    INNER JOIN person_name pn ON p.person_id = pn.person_id AND p.voided IS FALSE AND pn.voided IS FALSE
    INNER JOIN patient_identifier pi ON p.person_id = pi.patient_id AND pi.voided IS FALSE
    INNER JOIN person_attribute pa ON p.person_id = pa.person_id AND pa.voided IS FALSE
    INNER JOIN person_attribute_type pat ON pa.person_attribute_type_id = pat.person_attribute_type_id
        AND pat.name='dateOfEntry' AND pa.value >= '2021-01-01'
        ORDER BY pa.value DESC",'All Patients',
        @uuid);

