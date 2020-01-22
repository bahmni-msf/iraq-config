DELETE
FROM global_property
where property = 'emrapi.sqlSearch.validPatients';
select uuid()
into @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.validPatients',
        "select SQL_CACHE
        date_of_presentation              AS PATIENT_LISTING_QUEUES_DATE_OF_PRESENTATION,
       identifier,
       name                 AS PATIENT_LISTING_QUEUES_HEADER_NAME,
       requested_admission AS PATIENT_LISTING_QUEUES_REQUESTED_ADMISSION,
       uuid,
       comments             AS PATIENT_LISTING_QUEUES_COMMENTS,
       mlo                  AS PATIENT_LISTING_QUEUES_TREATING_SURGEON
from (
         SELECT mlo_visit.`Date Of Presentation`           as date_of_presentation,
                pi.identifier                              as identifier,
                concat(pn.given_name, ' ', COALESCE(pn.family_name,'')) AS name,
                mlo_visit.`Requested Admission`            as requested_admission,
                p.uuid                                     as uuid,
                mlo_visit.`comments`                       as comments,
                mlo_visit.`MLO`                            as mlo,
                pi.patient_id                              as patientId
         FROM patient_identifier pi
                  JOIN person p ON
                 p.person_id = pi.patient_id
                 AND p.voided IS FALSE
                 AND pi.voided IS FALSE
                  JOIN person_name pn ON
                 pn.person_id = pi.patient_id
                 AND pn.voided IS FALSE
                  LEFT JOIN (
             SELECT o.person_id                       AS person_id,
                    GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('Date Of presentation')
                                                  AND latest_encounter.person_id IS NOT NULL,
                                              DATE_FORMAT(o.value_datetime, '%d/%m/%Y'),
                                              NULL))) AS 'Date Of presentation',
                    GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('Outcome of admission committee')
                                                  AND latest_encounter.person_id IS NOT NULL,
                                              COALESCE(coded_fscn.name,
                                                       coded_scn.name),
                                              NULL))) AS 'Outcome of admission committee',
                    GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('Requested Admission')
                                                  AND latest_encounter.person_id IS NOT NULL,
                                              COALESCE(coded_fscn.name,
                                                       coded_scn.name),
                                              NULL))) AS 'Requested Admission',
                    GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('General comments from admission committee')
                                                  AND latest_encounter.person_id IS NOT NULL,
                                              o.value_text,
                                              NULL))) AS 'comments',
                    GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('Treating Surgeon')
                                                  AND latest_encounter.person_id IS NOT NULL,
                                              o.value_text,
                                              NULL))) AS 'MLO',
                    e.encounter_datetime              AS 'Encounter time'
             FROM encounter e
                      INNER JOIN obs o ON
                     o.encounter_id = e.encounter_id
                     AND o.voided IS FALSE
                     AND e.voided IS FALSE
                     AND (o.form_namespace_and_path like '%Admission Committee%'
                     or o.form_namespace_and_path like '%MLO Medical Assessment%'
                     or o.form_namespace_and_path like '%Initial Medical Examination%')
                      INNER JOIN concept_name obs_fscn ON
                     o.concept_id = obs_fscn.concept_id
                     AND obs_fscn.name IN ('Date Of presentation',
                                           'Outcome of admission committee',
                                           'Requested Admission',
                                           'General comments from admission committee',
                                           'Treating Surgeon')
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
                         AND obs_fscn.name IN ('Date Of presentation',
                                               'Outcome of admission committee',
                                               'Requested Admission',
                                               'General comments from admission committee',
                                               'Treating Surgeon')
                         AND obs_fscn.voided IS FALSE
                         AND obs_fscn.concept_name_type = 'FULLY_SPECIFIED'
                          JOIN encounter en ON
                         obs.encounter_id = en.encounter_id
                         AND obs.voided IS FALSE
                         AND en.voided IS FALSE
                         AND en.visit_id IN (
                         select max(v.visit_id)
                         from visit v
                                  join visit_type vt on
                                 v.visit_type_id = vt.visit_type_id
                                 and vt.name = 'MLO'
                         group by v.patient_id)
                 GROUP BY obs.person_id,
                          obs.concept_id) latest_encounter ON
                     o.person_id = latest_encounter.person_id
                     AND o.concept_id = latest_encounter.concept_id
             WHERE latest_encounter.max_encounter_datetime = e.encounter_datetime
             GROUP BY o.person_id) mlo_visit ON
             mlo_visit.person_id = pi.patient_id
                  LEFT JOIN (
             SELECT o.person_id                       AS person_id,
                    GROUP_CONCAT(DISTINCT (IF(obs_fscn.name IN ('IME, Date of admission')
                                                  AND latest_encounter.person_id IS NOT NULL,
                                              DATE_FORMAT(o.value_datetime, '%d/%m/%Y'),
                                              NULL))) AS 'Date Of Admission',
                    e.encounter_datetime              as 'Encounter time'
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
                         AND en.visit_id IN (
                         select max(v.visit_id)
                         from visit v
                                  join visit_type vt on
                                 v.visit_type_id = vt.visit_type_id
                                 and vt.name in ('OPD',
                                                 'IPD')
                         group by v.patient_id)
                 GROUP BY obs.person_id,
                          obs.concept_id) latest_encounter ON
                     o.person_id = latest_encounter.person_id
                     AND o.concept_id = latest_encounter.concept_id
             WHERE latest_encounter.max_encounter_datetime = e.encounter_datetime
             GROUP BY o.person_id) other_visit ON
             other_visit.person_id = pi.patient_id
         where (mlo_visit.`Encounter time` > COALESCE(other_visit.`Encounter time`,
                                                      '01-01-0000')
             and mlo_visit.`Outcome of admission committee` = 'Valid'
             and mlo_visit.`Date Of presentation` is not null)
            or (mlo_visit.`Encounter time` < other_visit.`Encounter time`
             and other_visit.`Date Of Admission` is null
             and mlo_visit.`Outcome of admission committee` = 'Valid'
             and mlo_visit.`Date Of presentation` is not null)
         GROUP BY pi.patient_id) final
         left outer join (
    select patient_id
    from visit v
    where (
              select visit_type_id
              from visit
              where visit_id = (
                  select MAX(second_max_visit.visit_id)
                  from visit second_max_visit
                  WHERE second_max_visit.visit_id NOT IN (
                      SELECT MAX(max_visit.visit_id)
                      from visit max_visit
                      where max_visit.patient_id = v.patient_id
                        and max_visit.visit_type_id = 4)
                    and second_max_visit.patient_id = v.patient_id)) = 4
    GROUP by patient_id
    ) latest_opd_patients on
    final.patientId = latest_opd_patients.patient_id
where latest_opd_patients.patient_id IS null 
ORDER BY STR_TO_DATE(date_of_presentation,'%d/%m/%Y') DESC",
        'valid Patients',
        @uuid);
