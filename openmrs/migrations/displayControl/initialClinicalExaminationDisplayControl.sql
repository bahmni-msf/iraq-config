DELETE FROM global_property WHERE property = 'bahmni.sqlGet.initialClinicalExaminationData';
SELECT uuid() INTO @uuid;

INSERT INTO global_property (property, property_value, description, uuid)
VALUES ('bahmni.sqlGet.initialClinicalExaminationData',
        "SELECT
            concept_short_name AS concept_names,
            con_answers AS concept_ans,
            latest_enc_data.enc_date
        FROM
            person p
        INNER JOIN (
            select
                raw_data.*,
                case
                    when con_names = 'IME, General examination' THEN '1'
                    when con_names = 'IME, HEENT examination' THEN '2'
                    when con_names = 'IME, Chest examination' THEN '3'
                    when con_names = 'IME, Heart examination' THEN '4'
                    when con_names = 'IME, Neurologic examination' THEN '5'
                    when con_names = 'IME, Locomotor / extremities examination' THEN '6'
                    when con_names = 'IME, Functional status on arrival' THEN '7'
                END AS display_order
            from
                (
                select
                    distinct diagnosis.person_id persn_id,
                    diagnosis.encounter_id enc_ids,
                    COALESCE(coded_ans.coded_ans_name,
                    diagnosis.value_text) con_answers,
                    COALESCE(general_exam.name,
                    heent_exam.name,
                    chest_exam.name,
                    heart_exam.name,
                    neuro_exam.name,
                    loco_exam.name,
                    coded_ans.main_con_name) con_names
                FROM
                    obs diagnosis
                LEFT OUTER JOIN concept_name general_exam ON
                    general_exam.concept_id = diagnosis.concept_id
                    AND general_exam.concept_name_type = 'FULLY_SPECIFIED'
                    AND general_exam.voided IS FALSE
                    AND diagnosis.voided IS FALSE
                    AND general_exam.name = 'IME, General examination'
                LEFT OUTER JOIN concept_name heent_exam ON
                    heent_exam.concept_id = diagnosis.concept_id
                    AND heent_exam.concept_name_type = 'FULLY_SPECIFIED'
                    AND heent_exam.voided IS FALSE
                    AND diagnosis.voided IS FALSE
                    AND heent_exam.name = 'IME, HEENT examination'
                LEFT OUTER JOIN concept_name chest_exam ON
                    chest_exam.concept_id = diagnosis.concept_id
                    AND chest_exam.concept_name_type = 'FULLY_SPECIFIED'
                    AND chest_exam.voided IS FALSE
                    AND diagnosis.voided IS FALSE
                    AND chest_exam.name = 'IME, Chest examination'
                LEFT OUTER JOIN concept_name heart_exam ON
                    heart_exam.concept_id = diagnosis.concept_id
                    AND heart_exam.concept_name_type = 'FULLY_SPECIFIED'
                    AND heart_exam.voided IS FALSE
                    AND diagnosis.voided IS FALSE
                    AND heart_exam.name = 'IME, Heart examination'
                LEFT OUTER JOIN concept_name neuro_exam ON
                    neuro_exam.concept_id = diagnosis.concept_id
                    AND neuro_exam.concept_name_type = 'FULLY_SPECIFIED'
                    AND neuro_exam.voided IS FALSE
                    AND diagnosis.voided IS FALSE
                    AND neuro_exam.name = 'IME, Neurologic examination'
                LEFT OUTER JOIN concept_name loco_exam ON
                    loco_exam.concept_id = diagnosis.concept_id
                    AND loco_exam.concept_name_type = 'FULLY_SPECIFIED'
                    AND loco_exam.voided IS FALSE
                    AND diagnosis.voided IS FALSE
                    AND loco_exam.name = 'IME, Locomotor / extremities examination'
                LEFT OUTER JOIN (
                    select
                        functional_arrive_ans.encounter_id enc_id,
                        functional_arrive_ans.concept_id con_id,
                        functional_arrive.name main_con_name,
                        functional_arrive_ans.value_coded ,
                        answer_cn.concept_short_name coded_ans_name
                    from
                        concept_name functional_arrive
                    INNER JOIN obs functional_arrive_ans ON
                        functional_arrive_ans.concept_id = functional_arrive.concept_id
                        AND functional_arrive_ans.voided IS FALSE
                        AND functional_arrive.concept_name_type = 'FULLY_SPECIFIED'
                        AND functional_arrive.voided IS FALSE
                        AND functional_arrive_ans.voided IS FALSE
                        AND functional_arrive.name = 'IME, Functional status on arrival'
                    LEFT OUTER JOIN concept_view answer_cn ON
                        answer_cn.concept_id = functional_arrive_ans.value_coded
                        AND answer_cn.retired IS FALSE ) coded_ans ON
                    coded_ans.enc_id = diagnosis.encounter_id
                    AND coded_ans.con_id = diagnosis.concept_id
                where
                    COALESCE(general_exam.name,
                    heent_exam.name,
                    chest_exam.name,
                    heart_exam.name,
                    neuro_exam.name,
                    loco_exam.name,
                    coded_ans.main_con_name) is not null) raw_data
            order by
                display_order ) clinical_data ON
            clinical_data.persn_id = p.person_id
        INNER JOIN (
            select
                encounter_id,
                visit_id,
                encdata.patient_id,
                encdata.encountermaxdate enc_date
            from
                encounter en
            inner join (
                SELECT
                    v.patient_id,
                    max(e.date_created) as encountermaxdate
                FROM
                    visit v
                INNER JOIN encounter e ON
                    e.visit_id = v.visit_id
                INNER JOIN visit_type vt ON
                    v.visit_type_id = vt.visit_type_id
                    AND vt.name in ('OPD',
                    'IPD')
                    AND v.voided IS FALSE
                    AND vt.retired IS FALSE
                group by
                    v.patient_id ) encdata on
                encdata.encountermaxdate = en.date_created ) latest_enc_data ON
            latest_enc_data.encounter_id = clinical_data.enc_ids
        INNER JOIN (
            SELECT
                v.patient_id,
                max(v.visit_id) as maxvisit_id
            FROM
                visit v
            INNER JOIN visit_type vt ON
                v.visit_type_id = vt.visit_type_id
                AND vt.name in ('OPD',
                'IPD')
                AND v.voided IS FALSE
                AND vt.retired IS FALSE
            group by
                v.patient_id ) latest_visit ON
            latest_visit.patient_id = latest_enc_data.patient_id
            AND latest_visit.maxvisit_id = latest_enc_data.visit_id
            AND latest_visit.patient_id = p.person_id
        INNER JOIN concept_view conceptshortnames ON
            conceptshortnames.concept_full_name = clinical_data.con_names
        WHERE p.uuid = ${patientUuid};"
           , 'Initial Clinical Examination data for patient', @uuid);
