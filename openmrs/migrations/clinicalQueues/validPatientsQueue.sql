DELETE FROM global_property where property = 'emrapi.sqlSearch.validPatients';
select uuid() into @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.validPatients',
        "SELECT SQL_CACHE final.`Date Of Presentation`,
                    pi.identifier                              AS identifier,
                    concat(pn.given_name, ' ', pn.family_name) AS PATIENT_LISTING_QUEUES_HEADER_NAME,
                    final.`Requested Admission`,
                    p.uuid                                     AS uuid,
                    final.`comments`                           AS Comments,
                    final.`MLO`                                AS `Treating Surgeon`
    FROM patient_identifier pi
          JOIN person p ON p.person_id = pi.patient_id AND p.voided IS FALSE AND pi.voided IS FALSE
          JOIN person_name pn ON pn.person_id = pi.patient_id AND pn.voided IS FALSE
          LEFT JOIN (SELECT o.person_id                                                             AS person_id,
                            GROUP_CONCAT(DISTINCT (IF(
                                                     obs_fscn.name IN ('Date Of presentation') AND
                                                     latest_encounter.person_id IS NOT NULL,
                                                     DATE_FORMAT(o.value_datetime, '%d/%m/%Y'), NULL))
                                )                                                                   AS 'Date Of presentation',
                            GROUP_CONCAT(DISTINCT (IF(
                                                     obs_fscn.name IN ('Outcome of admission committee') AND
                                                     latest_encounter.person_id IS NOT NULL,
                                                     COALESCE(coded_fscn.name, coded_scn.name),
                                                     NULL)))                                        AS 'Outcome of admission committee',
                            GROUP_CONCAT(DISTINCT (IF(
                                                     obs_fscn.name IN ('Requested Admission') AND
                                                     latest_encounter.person_id IS NOT NULL,
                                                     COALESCE(coded_fscn.name, coded_scn.name),
                                                     NULL)))                                        AS 'Requested Admission',
                            GROUP_CONCAT(DISTINCT (IF(
                                                     obs_fscn.name IN ('General comments from admission committee') AND
                                                     latest_encounter.person_id IS NOT NULL,
                                                     o.value_text, NULL))) AS 'comments',
                            GROUP_CONCAT(DISTINCT (IF(
                                                     obs_fscn.name IN ('Treating Surgeon') AND
                                                     latest_encounter.person_id IS NOT NULL,
                                                     o.value_text, NULL))) AS 'MLO'
                     FROM encounter e
                            INNER JOIN obs o ON o.encounter_id = e.encounter_id AND o.voided IS FALSE AND
                                                e.voided IS FALSE AND
                                                (o.form_namespace_and_path like '%Admission Committee%' or
                                               o.form_namespace_and_path like '%MLO Medical Assessment%')
                            INNER JOIN concept_name obs_fscn ON o.concept_id = obs_fscn.concept_id AND
                                                                obs_fscn.name IN ('Date Of presentation',
                                                                                  'Outcome of admission committee',
                                                                                  'Requested Admission',
                                                                                  'General comments from admission committee','Treating Surgeon')
                                                                  AND obs_fscn.voided IS FALSE AND
                                                                obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                            LEFT JOIN concept_name coded_fscn ON coded_fscn.concept_id = o.value_coded AND
                                                                 coded_fscn.concept_name_type = 'FULLY_SPECIFIED' AND
                                                                 coded_fscn.voided IS FALSE
                            LEFT JOIN concept_name coded_scn ON coded_scn.concept_id = o.value_coded AND
                                                                coded_fscn.concept_name_type = 'SHORT' AND
                                                                coded_scn.voided IS FALSE
                            LEFT JOIN (SELECT en.visit_id,
                                              person_id,
                                              obs.concept_id,
                                              max(en.encounter_datetime) AS max_encounter_datetime
                                       FROM obs
                                              INNER JOIN concept_name obs_fscn ON obs.concept_id = obs_fscn.concept_id AND
                                                                                  obs_fscn.name IN ('Date Of presentation',
                                                                                                    'Outcome of admission committee',
                                                                                                    'Requested Admission',
                                                                                                    'General comments from admission committee','Treating Surgeon')
                                                                                    AND obs_fscn.voided IS FALSE AND
                                                                                  obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                              JOIN encounter en ON obs.encounter_id = en.encounter_id AND
                                                                   obs.voided IS FALSE AND
                                                                   en.voided IS FALSE
                                                                     AND en.visit_id IN (select  DISTINCT v.visit_id from visit v join visit_type vt ON v.visit_type_id = vt.visit_type_id and vt.name = 'MLO'
                                                    AND v.date_stopped IS NULL)
                                       GROUP BY obs.person_id, obs.concept_id) latest_encounter
                              ON o.person_id = latest_encounter.person_id AND
                                 o.concept_id = latest_encounter.concept_id
                                   AND latest_encounter.max_encounter_datetime =
                                       e.encounter_datetime
                     GROUP BY o.person_id) final ON final.person_id = pi.patient_id
    where final.`Date Of presentation` is not null
     and final.`Outcome of admission committee` = 'Valid'
    GROUP BY pi.patient_id",
        'valid Patients',
        @uuid);
