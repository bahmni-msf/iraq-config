DELETE FROM global_property where property = 'emrapi.sqlSearch.activePatients';
select uuid() into @uuid;
INSERT INTO global_property (`property`, `property_value`, `description`, `uuid`)
VALUES ('emrapi.sqlSearch.activePatients',
        "SELECT SQL_CACHE
    final.`Date Of Admission`,
    pi.identifier as Identifier,
    concat(pn.given_name, '' '', ifnull(pn.family_name, '''')) as Name,
    final.`Type of Admission`,
    final.`Admission in:`,
    DATE_FORMAT(appointmentData.start_date_time, ''%d/%m/%Y'') as `Date of Appointment`,
    appointmentData.name as `Service Appointment Type`,
    final.`Date of next communication` as `Date of Next Communication`

FROM patient_identifier pi
         JOIN person p ON p.person_id = pi.patient_id AND p.voided IS FALSE AND pi.voided IS FALSE
         JOIN person_name pn ON pn.person_id = pi.patient_id AND pn.voided IS FALSE
         LEFT JOIN (select patient_id, min(start_date_time) as start_date_time, pa.appointment_service_type_id, pa.appointment_service_id,apst.name
                    from patient_appointment pa
                             join appointment_service_type apst on pa.appointment_service_type_id = apst.appointment_service_type_id
                             join appointment_service apps on pa.appointment_service_id = apps.appointment_service_id and apps.name in (''Medical'', ''Physiotherapy OPD'')
                    where pa.start_date_time >= current_timestamp
                    group by patient_id
                    union
                    select patient_id, min(start_date_time) as start_date_time, pa.appointment_service_type_id, pa.appointment_service_id, apps.name
                    from patient_appointment pa
                             join appointment_service apps on pa.appointment_service_id = apps.appointment_service_id and apps.name in (''Medical'', ''Physiotherapy OPD'')
                    where pa.start_date_time < current_timestamp
                    group by patient_id) appointmentData
                   on appointmentData.patient_id = pi.patient_id
         LEFT JOIN (SELECT o.person_id         AS person_id,
                           GROUP_CONCAT(DISTINCT (IF(
                                           obs_fscn.name IN (''IME, Date Of Admission'') AND
                                           latest_encounter.person_id IS NOT NULL,
                                           DATE_FORMAT(o.value_datetime, ''%d/%m/%Y''), NULL))
                               )               AS ''Date Of Admission'',
                           GROUP_CONCAT(DISTINCT (IF(
                                           obs_fscn.name IN (''IME, Type of admission'') AND
                                           latest_encounter.person_id IS NOT NULL,
                                           COALESCE(coded_fscn.name, coded_scn.name),
                                           NULL))) AS ''Type of Admission'',
                           GROUP_CONCAT(DISTINCT (IF(
                                           obs_fscn.name IN (''IME, Patient admitted to:'') AND
                                           latest_encounter.person_id IS NOT NULL,
                                           COALESCE(coded_fscn.name, coded_scn.name),
                                           NULL))) AS ''Admission in:'',
                           GROUP_CONCAT(DISTINCT (IF(
                                           obs_fscn.name IN (''OPN, Date of next communication'') AND
                                           latest_encounter.person_id IS NOT NULL,
                                           DATE_FORMAT(o.value_datetime, ''%d/%m/%Y''), NULL))
                               )               AS ''Date of next communication''

                    FROM encounter e
                             INNER JOIN obs o ON o.encounter_id = e.encounter_id AND o.voided IS FALSE AND
                                                 e.voided IS FALSE AND
                                                 (o.form_namespace_and_path like ''%Initial Medical Examination%'' or
                                                  o.form_namespace_and_path like ''%OPD Progress Note MD%'')
                             INNER JOIN concept_name obs_fscn ON o.concept_id = obs_fscn.concept_id AND
                                                                 obs_fscn.name IN
                                                                 (''IME, Date Of Admission'', ''IME, Type of Admission'',
                                                                  ''OPN, Date of next communication'',''IME, Patient admitted to:'')
                        AND obs_fscn.voided IS FALSE AND
                                                                 obs_fscn.concept_name_type = ''FULLY_SPECIFIED''
                             LEFT JOIN concept_name coded_fscn ON coded_fscn.concept_id = o.value_coded AND
                                                                  coded_fscn.concept_name_type = ''FULLY_SPECIFIED'' AND
                                                                  coded_fscn.voided IS FALSE
                             LEFT JOIN concept_name coded_scn ON coded_scn.concept_id = o.value_coded AND
                                                                 coded_fscn.concept_name_type = ''SHORT'' AND
                                                                 coded_scn.voided IS FALSE

                             LEFT JOIN (SELECT en.visit_id,
                                               person_id,
                                               obs.concept_id,
                                               max(en.encounter_datetime) AS max_encounter_datetime
                                        FROM obs
                                                 INNER JOIN concept_name obs_fscn
                                                            ON obs.concept_id = obs_fscn.concept_id AND
                                                               obs_fscn.name IN
                                                               (''IME, Date Of Admission'', ''IME, Type of Admission'',
                                                                ''OPN, Date of next communication'',''IME, Patient admitted to:'')
                                                                AND obs_fscn.voided IS FALSE AND
                                                               obs_fscn.concept_name_type = ''FULLY_SPECIFIED''
                                                 JOIN encounter en ON obs.encounter_id = en.encounter_id AND
                                                                      obs.voided IS FALSE AND
                                                                      en.voided IS FALSE
                                            AND en.visit_id IN (select  DISTINCT v.visit_id from visit v join visit_type vt ON v.visit_type_id = vt.visit_type_id and vt.name = ''OPD'' or vt.name = ''IPD''
                                                AND v.date_stopped is null)

                                        GROUP BY obs.person_id, obs.concept_id) latest_encounter
                                       ON o.person_id = latest_encounter.person_id AND
                                          o.concept_id = latest_encounter.concept_id
                                           AND latest_encounter.max_encounter_datetime =
                                               e.encounter_datetime
                    GROUP BY o.person_id) final ON final.person_id = pi.patient_id
where final.`Date Of Admission` is not null
GROUP BY pi.patient_id",'Active Patients',@uuid);