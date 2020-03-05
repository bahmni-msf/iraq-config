UPDATE global_property SET property_value =
        ("SELECT
            p.person_id,
            surgical_diagnosis,
            side_site
        FROM
            person p
        INNER JOIN (
            SELECT
                e.patient_id,
                diagnoses_data.surgical_diagnosis,
                diagnoses_data.side_site
            FROM
                encounter e
            INNER JOIN (
                SELECT
                    v.visit_id,
                    v.patient_id
                FROM
                    visit v
                INNER JOIN (
                    SELECT
                        patient_id,
                        max(v.date_created) AS `date_created`
                    FROM
                        visit v
                    INNER JOIN visit_type vt ON
                        v.visit_type_id = vt.visit_type_id
                        AND vt.name in ('OPD',
                        'IPD', 'MLO')
                        AND v.voided IS FALSE
                        AND vt.retired IS FALSE
                    GROUP BY
                        v.patient_id ) latestHospitalVist ON
                    v.patient_id = latestHospitalVist.patient_id
                    AND v.date_created = latestHospitalVist.date_created ) hospitalVisit ON
                hospitalVisit.visit_id = e.visit_id
                AND e.patient_id = hospitalVisit.patient_id
            INNER JOIN (
                select
  person_id,
  encounter_id,
  group_concat(distinct main_diagnosis)                         as surgical_diagnosis,
  CONCAT(side, ' ', GROUP_CONCAT(DISTINCT site SEPARATOR ', ')) AS `side_site`,
  path
from (
       select
         side_diagnosis_obs.person_id,
         side_diagnosis_obs.encounter_id,
         main_diagnosis,
         side,
         site,
         get_parent_form_field_path(side_diagnosis_obs.form_namespace_and_path) as path
       from

         (select
            person_id,
            encounter_id,
            (select name
             from concept_name
             where
               concept_id = value_coded and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en') as main_diagnosis,
            form_namespace_and_path
          from obs
          where form_namespace_and_path like 'Bahmni^Initial Medical Examination%' and voided=0
                and concept_id in (select concept_name.concept_id
                                   from concept_name
                                   where
                                     name in ('IME, Main Diagnosis (surgical)') and
                                     concept_name_type = 'FULLY_SPECIFIED' and
                                     voided = 0 and locale = 'en')) main_diagnosis_obs
         join (
                select
                  person_id,
                  encounter_id,
                  (select name
                   from concept_name
                   where concept_id = value_coded and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en') as side,
                  form_namespace_and_path
                from obs
                where form_namespace_and_path like 'Bahmni^Initial Medical Examination%' and voided=0
                      and concept_id in (select concept_name.concept_id
                                         from concept_name
                                         where name in ('IME, Side of diagnosis')
                                               and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 and
                                               locale = 'en')
              ) side_diagnosis_obs
           on side_diagnosis_obs.encounter_id = main_diagnosis_obs.encounter_id

         join (
                select
                  person_id,
                  encounter_id,
                  (select name
                   from concept_name
                   where concept_id = value_coded and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 and
                         locale = 'en') as site,
                  form_namespace_and_path
                from obs
                where form_namespace_and_path like 'Bahmni^Initial Medical Examination%' and voided=0
                      and concept_id in (select concept_name.concept_id
                                         from concept_name
                                         where name in ('IME, Site of diagnosis')
                                               and concept_name_type = 'FULLY_SPECIFIED' and voided = 0 and
                                               locale = 'en')
              ) site_diagnosis_obs
           on site_diagnosis_obs.encounter_id = main_diagnosis_obs.encounter_id

       order by side_diagnosis_obs.encounter_id, side_diagnosis_obs.form_namespace_and_path
     ) as aa
group by encounter_id, path ) diagnoses_data ON
                diagnoses_data.encounter_id = e.encounter_id ) total_data ON
            total_data.patient_id = p.person_id
        WHERE
            (surgical_diagnosis is not null
            or side_site is not null)
            AND (side_site != ''
            or surgical_diagnosis != '')
            AND p.uuid = ${patientUuid}"
)
          WHERE property = 'bahmni.sqlGet.surgicalDiagnosisData';