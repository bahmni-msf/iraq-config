DELETE
FROM global_property
where property = 'emrapi.sqlSearch.validPatients';
select uuid()
into @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.validPatients',
        "select identifier, PATIENT_LISTING_QUEUES_HEADER_NAME, PATIENT_LISTING_QUEUES_REQUESTED_ADMISSION, uuid,PATIENT_LISTING_QUEUES_COMMENTS,
       PATIENT_LISTING_QUEUES_TREATING_SURGEON
from (SELECT mlo_visit.`Date Of Presentation`,
                       pi.identifier                              AS identifier,
                       concat(pn.given_name, ' ', pn.family_name) AS PATIENT_LISTING_QUEUES_HEADER_NAME,
                       mlo_visit.`Requested Admission`                AS PATIENT_LISTING_QUEUES_REQUESTED_ADMISSION,
                       p.uuid                                     AS uuid,
                       mlo_visit.`comments`                           AS PATIENT_LISTING_QUEUES_COMMENTS,
                       mlo_visit.`MLO`                                AS PATIENT_LISTING_QUEUES_TREATING_SURGEON,
                       pi.patient_id                                   AS patientId
      FROM patient_identifier pi
               JOIN person p ON p.person_id = pi.patient_id AND p.voided IS FALSE AND pi.voided IS FALSE
               JOIN person_name pn ON pn.person_id = pi.patient_id AND pn.voided IS FALSE
               LEFT JOIN (SELECT o.person_id          AS person_id,
                                 GROUP_CONCAT(DISTINCT (IF(
                                             obs_fscn.name IN ('Date Of presentation') AND
                                             latest_encounter.person_id IS NOT NULL,
                                             DATE_FORMAT(o.value_datetime, '%d/%m/%Y'), NULL))
                                     )                AS 'Date Of presentation',
                                 GROUP_CONCAT(DISTINCT (IF(
                                             obs_fscn.name IN ('Outcome of admission committee') AND
                                             latest_encounter.person_id IS NOT NULL,
                                             COALESCE(coded_fscn.name, coded_scn.name), NULL)))
                                                      AS 'Outcome of admission committee',
                                 GROUP_CONCAT(DISTINCT (IF(
                                             obs_fscn.name IN ('Requested Admission') AND
                                             latest_encounter.person_id IS NOT NULL,
                                             COALESCE(coded_fscn.name, coded_scn.name), NULL)))
                                                      AS 'Requested Admission',
                                 GROUP_CONCAT(DISTINCT (IF(
                                                 obs_fscn.name IN ('General comments from admission committee') AND
                                                 latest_encounter.person_id IS NOT NULL,
                                                 o.value_text, NULL))) AS 'comments',
                                 GROUP_CONCAT(DISTINCT (IF(
                                                 obs_fscn.name IN ('Treating Surgeon') AND
                                                 latest_encounter.person_id IS NOT NULL,
                                                 o.value_text, NULL))) AS 'MLO',
                                 e.encounter_datetime AS 'Encounter time'
                          FROM encounter e
                                   INNER JOIN obs o
                                              ON o.encounter_id = e.encounter_id AND o.voided IS FALSE AND
                                                 e.voided IS FALSE AND
                                                 (o.form_namespace_and_path like '%Admission Committee%' or
                                                  o.form_namespace_and_path like '%MLO Medical Assessment%' or
                                                  o.form_namespace_and_path like '%Initial Medical Examination%')
                                   INNER JOIN concept_name obs_fscn
                                              ON o.concept_id = obs_fscn.concept_id AND
                                                 obs_fscn.name IN
                                                 ('Date Of presentation',
                                                  'Outcome of admission committee',
                                                  'Requested Admission',
                                                  'General comments from admission committee',
                                                  'Treating Surgeon')
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
                                                                     ('Date Of presentation',
                                                                      'Outcome of admission committee',
                                                                      'Requested Admission',
                                                                      'General comments from admission committee',
                                                                      'Treating Surgeon')
                                                                      AND obs_fscn.voided IS FALSE AND
                                                                     obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                                       JOIN encounter en
                                                            ON obs.encounter_id = en.encounter_id AND
                                                               obs.voided IS FALSE AND
                                                               en.voided IS FALSE
                                                                AND en.visit_id IN (select max(v.visit_id)
                                                                                    from visit v
                                                                                             join visit_type vt
                                                                                                  on v.visit_type_id = vt.visit_type_id
                                                                                                      and
                                                                                                     vt.name = 'MLO'
                                                                                    group by v.patient_id)
                                              GROUP BY obs.person_id, obs.concept_id) latest_encounter
                                             ON o.person_id = latest_encounter.person_id AND
                                                o.concept_id = latest_encounter.concept_id
                          WHERE latest_encounter.max_encounter_datetime = e.encounter_datetime
                          GROUP BY o.person_id) mlo_visit ON mlo_visit.person_id = pi.patient_id
               LEFT JOIN (SELECT o.person_id                                                                  AS person_id,
                                 GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('IME, Date of admission')
                                                               AND latest_encounter.person_id IS NOT NULL,
                                                           DATE_FORMAT(o.value_datetime, '%d/%m/%Y'),
                                                           NULL)))                                            AS 'Date Of Admission',
                                 e.encounter_datetime                                                         as 'Encounter time'

                          FROM encounter e
                                   INNER JOIN obs o ON
                                  o.encounter_id = e.encounter_id
                                  AND o.voided IS FALSE
                                  AND e.voided IS FALSE
                                  AND (o.form_namespace_and_path like '%Initial Medical Examination%')
                                   INNER JOIN concept_name obs_fscn ON
                                  o.concept_id = obs_fscn.concept_id
                                  AND obs_fscn.name IN ('IME, Date of admission')
                                  AND obs_fscn.voided IS FALSE
                                  AND obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                   LEFT JOIN concept_name coded_fscn ON
                                  coded_fscn.concept_id = o.value_coded
                                  AND coded_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                  AND coded_fscn.voided IS FALSE
                                   LEFT JOIN concept_name coded_scn ON
                                  coded_scn.concept_id = o.value_coded
                                  AND coded_fscn.concept_name_type = 'SHORT'
                                  AND coded_scn.voided IS FALSE
                                   LEFT JOIN (
                              SELECT en.visit_id,
                                     person_id,
                                     obs.concept_id,
                                     max(en.encounter_datetime) AS max_encounter_datetime
                              FROM obs
                                       INNER JOIN concept_name obs_fscn ON
                                      obs.concept_id = obs_fscn.concept_id
                                      AND obs_fscn.name IN ('IME, Date of admission')
                                      AND obs_fscn.voided IS FALSE
                                      AND obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                                       JOIN encounter en ON
                                      obs.encounter_id = en.encounter_id
                                      AND obs.voided IS FALSE
                                      AND en.voided IS FALSE
                                      AND en.visit_id IN (select max(v.visit_id)
                                                          from visit v
                                                                   join visit_type vt on
                                                                  v.visit_type_id = vt.visit_type_id
                                                                  and vt.name in ('OPD', 'IPD')
                                                          group by v.patient_id)
                              GROUP BY obs.person_id, obs.concept_id) latest_encounter ON
                                  o.person_id = latest_encounter.person_id
                                  AND o.concept_id = latest_encounter.concept_id
                          WHERE latest_encounter.max_encounter_datetime = e.encounter_datetime
                          GROUP BY o.person_id) other_visit ON other_visit.person_id = pi.patient_id
      where (mlo_visit.`Encounter time` > COALESCE(other_visit.`Encounter time`, '01-01-2001') and
             mlo_visit.`Outcome of admission committee` = 'Valid' and mlo_visit.`Date Of presentation` is not null)
         or (mlo_visit.`Encounter time` < other_visit.`Encounter time` and other_visit.`Date Of Admission` is null and
             mlo_visit.`Outcome of admission committee` = 'Valid' and mlo_visit.`Date Of presentation` is not null)
      GROUP BY pi.patient_id) final
         INNER JOIN (select patient_id
                     from (select patient_id, visit_type_id, count(distinct (visit_type_id))
                           from visit
                           group by patient_id
                           having count(distinct (visit_type_id)) = 1) fin
                     where fin.visit_type_id = (select visit_type_id from visit_type where name = 'MLO')
                     union
                     select mloVisits.patient_id
                     # START of COMMENT4: Finds all patients whose latest visit is OPD and last but one is MLO
                     from (
                              # START of COMMENT5: Finds all patients whose latest visit is OPD
                              select v.patient_id, v.visit_type_id, v.visit_id
                              from visit v
                                       inner join (select patient_id, max(date_started) as date_started
                                                   from visit
                                                   group by patient_id) fin on fin.patient_id = v.patient_id and
                                                                               v.date_started = fin.date_started and
                                                                               v.visit_type_id = 4) opdVisits
                              # END of COMMENT5:
                              inner join
                          # START of COMMENT6: Finds all patients whose latest but one visit is MLO
                              (select groupedVisits.visit_id, groupedVisits.patient_id, groupedVisits.visit_type_id
                               from (select max(visit_id) as visit_id, patient_id, visit_type_id
                                     from visit
                                     where date_stopped is not null
                                     group by patient_id, visit_type_id) as groupedVisits
                                        join (
                                   select max(visit_id) as visit_id, patient_id
                                   from (select max(visit_id) as visit_id, patient_id, visit_type_id
                                         from visit
                                         where date_stopped is not null
                                         group by patient_id, visit_type_id) x
                                   group by patient_id) groupedVisits1
                               where groupedVisits.patient_id = groupedVisits1.patient_id
                                 and groupedVisits.visit_id = groupedVisits1.visit_id
                                 and groupedVisits.visit_type_id = 6) mloVisits
                              # END of COMMENT6
                          on opdVisits.patient_id = mloVisits.patient_id)
                        # END of COMMENT4
                        latest_opd on latest_opd.patient_id = final.patientId",
        'valid Patients',
        @uuid);
