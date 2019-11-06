DELETE FROM global_property WHERE property = 'bahmni.sqlGet.medicalDiagnosisData';
SELECT uuid() INTO @uuid;

INSERT INTO global_property (property, property_value, description, uuid)
 VALUES ('bahmni.sqlGet.medicalDiagnosisData',
"SELECT
  p.person_id,
  medical_diagnosis
FROM
  person p
INNER JOIN (
  SELECT
    e.patient_id,
    medical_diagnosis
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
        AND v.voided IS FALSE
        AND vt.retired IS FALSE
      GROUP BY
        v.patient_id) latestHospitalVist ON
      v.patient_id = latestHospitalVist.patient_id
      AND v.date_created = latestHospitalVist.date_created) hospitalVisit ON
    hospitalVisit.visit_id = e.visit_id
    AND e.patient_id = hospitalVisit.patient_id
  INNER JOIN (
    SELECT
      CONCAT_WS(' , ', surgical_diagnosis.diagnosis_coded) AS medical_diagnosis,
      surgical_diagnosis.encounter_id
    FROM
      (
      SELECT
        diagnosis.encounter_id AS encounter_id,
        diagnosis.obs_group_id AS obs_group_id,
        GROUP_CONCAT(DISTINCT daignosis_answer_cn.name SEPARATOR ', ') AS diagnosis_coded
      FROM
        obs diagnosis
      INNER JOIN concept_name diagnosis_cn ON
        diagnosis_cn.concept_name_type = 'FULLY_SPECIFIED'
        AND diagnosis_cn.voided IS FALSE
        AND diagnosis_cn.name = 'IME, Medical Diagnoses (if any)'
      LEFT OUTER JOIN obs surgical_diagnosis_proc ON
        surgical_diagnosis_proc.encounter_id = diagnosis.encounter_id
        AND surgical_diagnosis_proc.concept_id = diagnosis_cn.concept_id
        AND surgical_diagnosis_proc.voided IS FALSE
      LEFT OUTER JOIN concept_name daignosis_answer_cn ON
        daignosis_answer_cn.concept_id = surgical_diagnosis_proc.value_coded
        AND daignosis_answer_cn.concept_name_type = 'FULLY_SPECIFIED'
        AND daignosis_answer_cn.voided IS FALSE
      where
        diagnosis.concept_id = (
        select
          concept_id
        from
          concept_name
        where
          name = 'IME, Medical Diagnoses (if any)'
          and concept_name_type = 'FULLY_SPECIFIED')
      GROUP BY
        diagnosis.encounter_id) surgical_diagnosis) diagnosis ON
    diagnosis.encounter_id = e.encounter_id) diagnosisData ON
  diagnosisData.patient_id = p.person_id
  WHERE p.uuid = ${patientUuid};"
, 'medical diagnosis data for patients', @uuid);
