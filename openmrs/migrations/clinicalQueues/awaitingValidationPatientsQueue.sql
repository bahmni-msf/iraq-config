DELETE FROM global_property where property = 'emrapi.sqlSearch.awaitingValidation';
 select uuid() into @uuid;


 INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
 VALUES ('emrapi.sqlSearch.awaitingValidation',
"SELECT SQL_CACHE
                 final.`Date Of Assessment`                 AS PATIENT_LISTING_QUEUES_DATE_OF_ASSESSMENT,
                 pi.identifier                              AS identifier,
                 concat(pn.given_name, ' ', pn.family_name) AS PATIENT_LISTING_QUEUES_HEADER_NAME,
                 final.`Hospital of Origin`                 AS PATIENT_LISITIN_QUEUES_HOSPITAL_OF_ORIGIN,
                 p.uuid                                     AS uuid
FROM patient_identifier pi
         JOIN person p ON p.person_id = pi.patient_id AND p.voided IS FALSE AND pi.voided IS FALSE
         JOIN person_name pn ON pn.person_id = pi.patient_id AND pn.voided IS FALSE


         LEFT JOIN (SELECT o.person_id AS person_id,
                           GROUP_CONCAT(DISTINCT (IF(
                                       obs_fscn.name IN ('Date Of presentation') AND
                                       latest_encounter.person_id IS NOT NULL,
                                       DATE_FORMAT(o.value_datetime, '%d/%m/%Y'), NULL))
                               )       AS 'Date Of presentation',
                           GROUP_CONCAT(DISTINCT (IF(
                                       obs_fscn.name IN ('Date of Assessment') AND
                                       latest_encounter.person_id IS NOT NULL,
                                       DATE_FORMAT(o.value_datetime, '%d/%m/%Y'), NULL))
                               )       AS 'Date Of Assessment',
                           GROUP_CONCAT(DISTINCT (IF(obs_fscn.name = 'Hospital of Origin' AND
                                                     latest_encounter.person_id IS NOT NULL,
                                                     COALESCE(coded_fscn.name, coded_scn.name),
                                                     NULL))
                               )       AS 'Hospital of Origin'
                    FROM encounter e
                             INNER JOIN obs o
                                        ON o.encounter_id = e.encounter_id AND o.voided IS FALSE AND
                                           e.voided IS FALSE
                                            AND
                                           (o.form_namespace_and_path like '%Admission Committee%' or
                                            o.form_namespace_and_path like '%MLO Medical Assessment%')
                             INNER JOIN concept_name obs_fscn
                                        ON o.concept_id = obs_fscn.concept_id AND
                                           obs_fscn.name IN
                                           ('Hospital of Origin',
                                            'Date of Assessment',
                                            'Date Of presentation')
                                            AND obs_fscn.voided IS FALSE AND
                                           obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                             LEFT JOIN concept_name coded_fscn
                                       ON coded_fscn.concept_id = o.value_coded AND
                                          coded_fscn.concept_name_type = 'FULLY_SPECIFIED' AND
                                          coded_fscn.voided IS FALSE
                             LEFT JOIN concept_name coded_scn
                                       ON coded_scn.concept_id = o.value_coded AND
                                          coded_fscn.concept_name_type = 'SHORT' AND
                                          coded_scn.voided IS FALSE
                             LEFT JOIN (SELECT en.visit_id,
                                               person_id,
                                               obs.concept_id,
                                               max(en.encounter_datetime) AS max_encounter_datetime
                                        FROM obs
                                                 INNER JOIN concept_name obs_fscn
                                                            ON obs.concept_id = obs_fscn.concept_id AND
                                                               obs_fscn.name IN
                                                               ('Hospital of Origin',
                                                                'Date of Assessment',
                                                                'Date Of presentation')
                                                                AND obs_fscn.voided IS FALSE AND
                                                               obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                                 JOIN encounter en
                                                      ON obs.encounter_id = en.encounter_id AND
                                                         obs.voided IS FALSE AND
                                                         en.voided IS FALSE
                                                          AND en.visit_id IN (select max(v.visit_id)
                                                                              FROM visit v
                                                                                       JOIN visit_type vt
                                                                                            ON v.visit_type_id = vt.visit_type_id
                                                                                                AND
                                                                                               vt.name = 'MLO'
                                                                              group by v.patient_id)
                                        GROUP BY obs.person_id, obs.concept_id) latest_encounter
                                       ON o.person_id = latest_encounter.person_id AND
                                          o.concept_id = latest_encounter.concept_id
                                           AND latest_encounter.max_encounter_datetime =
                                               e.encounter_datetime
                    GROUP BY o.person_id
) final ON final.person_id = pi.patient_id


where final.`Date Of Assessment` is not null
  and final.`Date Of presentation` is null
GROUP BY pi.patient_id ORDER BY final.`Date Of Assessment`", 'awaiting Validation',@uuid);
