DELETE FROM global_property WHERE property = 'bahmni.sqlGet.surgicalDiagnosisData';
SELECT uuid() INTO @uuid;

INSERT INTO global_property (property, property_value, description, uuid)
VALUES ('bahmni.sqlGet.surgicalDiagnosisData',
        "SELECT
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
                        'IPD')
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
                    encounter_id,
                    GROUP_CONCAT(DISTINCT surgical_diagnosis SEPARATOR ', ') AS `surgical_diagnosis`,
                    CONCAT(side, ' ', GROUP_CONCAT(DISTINCT site SEPARATOR ', ')) AS `side_site`,
                    path
                from
                    (
                    select
                        distinct diagnosis.encounter_id,
                        daignosis_answer_cn.name AS `surgical_diagnosis`,
                        COALESCE(site_coded_answer_cn.concept_short_name,
                        site_coded_answer_cn.concept_full_name,
                        '') AS site,
                        COALESCE(side_coded_answer_cn.name,
                        '') AS side,
                        get_parent_form_field_path(diagnosis.form_namespace_and_path) AS `path`
                    FROM
                        obs diagnosis
                    INNER JOIN concept_name diagnosis_cn ON
                        diagnosis_cn.concept_name_type = 'FULLY_SPECIFIED'
                        AND diagnosis_cn.voided IS FALSE
                        AND diagnosis_cn.name = 'IME, Main Diagnosis (surgical)'
                    INNER JOIN concept_name site_of_diagnosis ON
                        site_of_diagnosis.concept_name_type = 'FULLY_SPECIFIED'
                        AND site_of_diagnosis.voided IS FALSE
                        AND site_of_diagnosis.name = 'IME, Site of diagnosis'
                    INNER JOIN concept_name side_of_diagnosis_cn ON
                        side_of_diagnosis_cn.concept_name_type = 'FULLY_SPECIFIED'
                        AND side_of_diagnosis_cn.voided IS FALSE
                        AND side_of_diagnosis_cn.name = 'IME, Side of diagnosis'
                    LEFT OUTER JOIN obs surgical_diagnosis_proc ON
                        diagnosis.encounter_id = surgical_diagnosis_proc.encounter_id
                        AND get_parent_form_field_path(diagnosis.form_namespace_and_path) = get_parent_form_field_path(surgical_diagnosis_proc.form_namespace_and_path)
                        AND surgical_diagnosis_proc.concept_id = diagnosis_cn.concept_id
                        AND surgical_diagnosis_proc.voided IS FALSE
                    LEFT OUTER JOIN concept_name daignosis_answer_cn ON
                        daignosis_answer_cn.concept_id = surgical_diagnosis_proc.value_coded
                        AND daignosis_answer_cn.concept_name_type = 'FULLY_SPECIFIED'
                        AND daignosis_answer_cn.voided IS FALSE
                    LEFT OUTER JOIN obs site_of_surgical_procedure ON
                        diagnosis.encounter_id = site_of_surgical_procedure.encounter_id
                        AND get_parent_form_field_path(diagnosis.form_namespace_and_path) = get_parent_form_field_path(site_of_surgical_procedure.form_namespace_and_path)
                        AND site_of_surgical_procedure.concept_id = site_of_diagnosis.concept_id
                        AND site_of_surgical_procedure.voided IS FALSE
                    LEFT OUTER JOIN concept_view site_coded_answer_cn ON
                        site_coded_answer_cn.concept_id = site_of_surgical_procedure.value_coded
                        AND site_coded_answer_cn.retired IS FALSE
                    LEFT OUTER JOIN obs side_of_surgical_diagnosis ON
                        diagnosis.encounter_id = side_of_surgical_diagnosis.encounter_id
                        AND get_parent_form_field_path(diagnosis.form_namespace_and_path) = get_parent_form_field_path(side_of_surgical_diagnosis.form_namespace_and_path)
                        AND side_of_surgical_diagnosis.concept_id = side_of_diagnosis_cn.concept_id
                        AND side_of_surgical_diagnosis.voided IS FALSE
                    LEFT OUTER JOIN concept_name side_coded_answer_cn ON
                        side_coded_answer_cn.concept_id = side_of_surgical_diagnosis.value_coded
                        AND side_coded_answer_cn.concept_name_type = 'FULLY_SPECIFIED'
                        AND side_coded_answer_cn.voided IS FALSE
                    where
                        diagnosis.concept_id in (
                        select
                            concept_id
                        from
                            concept_name
                        where
                            name in ('IME, Main Diagnosis (surgical)',
                            'IME, Site of diagnosis',
                            'IME, Side of diagnosis')
                            and diagnosis_cn.concept_name_type = 'FULLY_SPECIFIED') ) PQR
                group by
                    PQR.path,
                    PQR.encounter_id ) diagnoses_data ON
                diagnoses_data.encounter_id = e.encounter_id ) total_data ON
            total_data.patient_id = p.person_id
        WHERE
            (surgical_diagnosis is not null
            or side_site is not null)
            AND (side_site != ''
            or surgical_diagnosis != '')
            AND p.uuid = ${patientUuid}"
           , 'surgical diagnosis data for patient', @uuid);