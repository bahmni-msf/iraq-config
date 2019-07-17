SET FOREIGN_KEY_CHECKS=0;
-- these tables will not be used, so drop their contents 
truncate table concept_proposal_tag_map;
truncate table concept_proposal;
truncate table hl7_in_archive;
truncate table hl7_in_error;
truncate table hl7_in_queue;
truncate table notification_alert_recipient;
truncate table notification_alert;
SET FOREIGN_KEY_CHECKS=1;

-- randomize the person names (given_name and family_name to contain random 8 alpha-numeric characters)
UPDATE person_name
    SET given_name = upper(substring(uuid(),1,8)),
     family_name = upper(substring(uuid(),1,8))
    WHERE person_id NOT IN (SELECT person_id FROM provider);

-- randomize +/- 6 months for persons older than ~15 yrs old
update person set birthdate = date_add(birthdate, interval cast(rand()*182-182 as signed) day) where birthdate is not null and datediff(now(), birthdate) > 15*365;

-- randomize +/- 3 months for persons between 15 and 5 years old
update person set birthdate = date_add(birthdate, interval cast(rand()*91-91 as signed) day) where birthdate is not null and datediff(now(), birthdate) between 15*365 and 5*365;

-- randomize +/- 30 days for persons less than ~5 years old
update person set birthdate = date_add(birthdate, interval cast(rand()*30-30 as signed) day) where birthdate is not null and datediff(now(), birthdate) < 5*365;

update person set birthdate_estimated = cast(rand() as signed);

-- randomize the death date +/- 3 months
update 
	person
set
	death_date = date_add(death_date, interval cast(rand()*91-91 as signed) day)
where 
	death_date is not null;

UPDATE person
SET gender = 'M';

--
-- Clear out login info
--

update users
set	password = '4a1750c8607dfa237de36c6305715c223415189',
	salt = 'c788c6ad82a157b712392ca695dfcf2eed193d7f',
	secret_question = null,
	secret_answer = null
where username NOT IN ('admin', 'superman', 'reports-user');

-- clear out the username/password stored in the db
update global_property set property_value = 'admin' where property like '%.username';
update global_property set property_value = 'test' where property like '%.password';

-- Clearing out all the user properties except favouriteObsTemplates
DELETE FROM user_property
    WHERE property NOT IN ('favouriteObsTemplates');

--
-- Shift the person addresses around
--
update 
	person_address
set
	address1 = concat('address1-', person_id),
	address2 = concat('address2-', person_id),
  address3 = 'Country',
  state_province = 'State',
	latitude = null,
	longitude = null,
	date_created = now(),
	date_voided = now();

--
-- Bahmni customized
--

-- identifiers (Assumes patient_identifier have been truncated)
CREATE TABLE temp_patient_identifier_old(patient_id int, identifier  varchar(256), PRIMARY KEY(patient_id));

INSERT INTO temp_patient_identifier_old 
SELECT patient_id, identifier FROM patient_identifier;

TRUNCATE patient_identifier;

INSERT INTO 
	patient_identifier
	(patient_id, identifier, identifier_type, location_id, preferred, creator, date_created, voided, uuid)
SELECT
	patient_id,
	concat('IQ', patient_id),
	(Select patient_identifier_type_id from patient_identifier_type where name = 'Patient Identifier'),
	9,
	1,
	1,
	'20080101',
	0,
	uuid()
FROM
	patient;

CREATE table temp_person_uuid_old(person_id int, uuid varchar(256), PRIMARY KEY(person_id));

INSERT INTO temp_person_uuid_old 
SELECT person_id, uuid FROM person;

DROP TABLE temp_patient_identifier_old;
DROP TABLE temp_person_uuid_old;

--
-- Bahmni specific
--
TRUNCATE failed_events;

--
-- Amman specific
--

UPDATE person_attribute pa
  INNER JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id
                                      AND pat.name NOT LIKE '%number%' AND pat.format = 'java.lang.String'
SET pa.value = concat(pa.person_id, '-', pat.name);


UPDATE person_attribute pa
  INNER JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id
                                          AND pat.name LIKE '%number%' AND pat.format = 'java.lang.String'
SET pa.value = floor(pow(10, 9) + rand() * (pow(10, 10) - pow(10, 9)));


-- UPDATE person_attribute pa
--   INNER JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id
--                                           AND pat.format = 'org.openmrs.util.AttributableDate'
-- SET pa.value = now();


-- # Setting all countries to Iraq
UPDATE person_attribute pa
  INNER JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id
    AND pat.format = 'org.openmrs.Concept' AND pat.name IN ('nationality1', 'legalRepNationality','nationality2','caretakerNationality')
  SET pa.value = 220;


-- Setting camp address to Emirati Jordanian Camp (Murijep Al Fhoud)
  UPDATE person_attribute pa
  INNER JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id
    AND pat.format = 'org.openmrs.Concept' AND pat.name = 'nameoftheCamp'
  SET pa.value = 618;


-- Setting 'caretakerGender', 'legalRepGender' to Male
  UPDATE person_attribute pa
  INNER JOIN person_attribute_type pat on pat.person_attribute_type_id = pa.person_attribute_type_id
    AND pat.format = 'org.openmrs.Concept' AND pat.name IN ('caretakerGender', 'legalRepGender')
  SET pa.value = 231;

--  as the following comments fiels having some sensitive info
UPDATE obs
    SET value_text = 'annonimized comment'
WHERE concept_id IN (SELECT DISTINCT concept_id
                     FROM concept_name WHERE name IN ('Adt Notes',
                            'Document(s) needed to be complete',
                            'Comments:',
                            'Comments about postpone reason',
                            'Type of medical information needed for next submission',
                            'Comments about refusal',
                            'Comments about next follow-up',
                            'PMIPA, Comments on FV',
                            'Comments about Aneasthesia validation',
                            'Comments about further stage admission',
                            'VS, Comments about baseline vital signs',
                            'SMH, Other medical problems',
                            'ONN, Description',
                            'SMH, Nursing notes',
                            'HE, Education learning needs',
                            'HE, Referral care Plan',
                            'AIA, Comments about adverse reaction',
                            'AIA, Describe',
                            'Remarks-anaesthetist',
                            'PHIA, Other type of assistive device',
                            'PHIA, Comments about assistive device or orthosis',
                            'PHIA, Comments about amputation',
                            'PHIA, Comment about prostheses usage',
                            'PHIA, Comment about new prosthesis or modification',
                            'PHIA, Physiotherapy remarks initial assessment',
                            'PIA, Comments about expectations',
                            'PIA, Comments from counsellor',
                            'PIA, By who (NGO / private) ccp',
                            'PIA, By who (NGO / private) ccf',
                            'PIA, By who (NGO / private) pcp',
                            'PIA, By who (NGO / private) pcf',
                            'PIA, Drug',
                            'MD, Chief complaint',
                            'MD, History of present illness',
                            'MD, Comments (neural injury)',
                            'MD, Comments (vascular injury)',
                            'MD, Comment of procedure',
                            'MD, Comments about previous infection',
                            'MD, Other type of fixation',
                            'MD, Description and duration of symptom (general)',
                            'MD, Other ROS general symptoms',
                            'MD, Description and duration of symptom (cardiopulmonary)',
                            'MD, Other ROS cardiopulmonary symptoms',
                            'MD, Description and duration of symptom (gastrointestinal)',
                            'MD, Other ROS gastrointestinal symptoms',
                            'MD, Description and duration of symptom (genitourinary)',
                            'MD, Other ROS genitourinary symptoms',
                            'MD, Description and duration of symptom (central nervous system)',
                            'MD, Other ROS central nervous system symptoms',
                            'MD, Description and duration of symptom (HEENT)',
                            'MD, Other ROS HEENT symptoms',
                            'MD, Description and duration of symptom (musculoskeletal)',
                            'MD, Other ROS musculoskeletal symptoms',
                            'SAP, Surgical summary',
                            'SAP, Objectives of physiotherapy',
                            'SAP, Comments of uncertainty',
                            'SAP, Comments about sugical objectives',
                            'SAP, Other consultation needed',
                            'ANA, Reason for admission, other',
                            'ANA, Patient mood, other',
                            'ANA, Description',
                            'ANA, Nutritional Assessment, other',
                            'ANA, Admission Nursing Notes',
                            'ONN, Description of wound, other',
                            'ONN, Dressing, comments',
                            'ONN, Condition of tissue expander',
                            'ONN, Nursing consultation notes',
                            'WWN, Change Position',
                            'WWN, Description of wound, other',
                            'WWN, Dressing, comments',
                            'WWN, Comments, peripheral line',
                            'WWN, Comments, dressing PICC line',
                            'WWN, Condition of tissue expander',
                            'WWN, Nursing consultation notes',
                            'CC, Description of complication',
                            'PPN, Patient complaints, other',
                            'PPN, Description of wound, other',
                            'PPN, Drainage, other',
                            'PPN, Assessment of patient, other',
                            'PPN, Surgical ward patient care plan, other',
                            'PE, General examination',
                            'PE, HEENT examination',
                            'PE, Chest examination',
                            'PE, Heart examination',
                            'PE, Abdomen examination',
                            'PE, Rectal and genitalia examination',
                            'PE, Extremities examination',
                            'PE, Neurologic examination'
                     ));

--  Updating the documentUrls to 'document url'
UPDATE obs
SET value_text = 'document url'
WHERE concept_id IN (SELECT DISTINCT concept_id
                     FROM concept_name WHERE name IN (
                         'Document'
                     ));

-- defaulting the Referrer and MLO to concept 304
UPDATE obs
SET value_coded = 304
WHERE concept_id IN (SELECT DISTINCT concept_id
                     FROM concept_name WHERE name IN (
                         'Referred by',
                         'Name Of MLO'
                     ));