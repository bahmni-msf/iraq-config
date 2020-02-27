UPDATE global_property SET property_value =
("select concept_name.name as concept_names, value as concept_ans, encounter_datetime as enc_date
from (select obs.concept_id,
             coalesce(obs.value_text, (select name
                                       from concept_name
                                       where concept_id = obs.value_coded
                                         and concept_name_type = 'SHORT'
                                         and locale = 'en')) as value,
             latest_encounter_and_date.encounter_datetime
      from (select encounter_id, encounter_datetime
            from encounter
            where encounter_id =
                  (select max(encounter_id) as max_encounter_id
                   from (select *
                         from obs
                         where person_id = (select person_id from person where person.uuid=${patientUuid})
                           and form_namespace_and_path like '%Initial Medical Examination%'
                           and obs.voided = 0) as obs
                   where concept_id in (select distinct concept_id
                                        from concept_name
                                        where name in ('IME, General examination',
                                                       'IME, HEENT examination',
                                                       'IME, Chest examination',
                                                       'IME, Heart examination',
                                                       'IME, Neurologic examination',
                                                       'IME, Locomotor / extremities examination',
                                                       'IME, Functional status on arrival')
                                          and concept_name_type = 'FULLY_SPECIFIED'
                                          and locale = 'en'))) as latest_encounter_and_date
             join obs on obs.encounter_id = latest_encounter_and_date.encounter_id
      where concept_id in (select distinct concept_id
                           from concept_name
                           where name in ('IME, General examination',
                                          'IME, HEENT examination',
                                          'IME, Chest examination',
                                          'IME, Heart examination',
                                          'IME, Neurologic examination',
                                          'IME, Locomotor / extremities examination',
                                          'IME, Functional status on arrival')
                             and concept_name_type = 'FULLY_SPECIFIED'
                             and locale = 'en')
        and voided = 0) as concept_id_and_values
       join concept_name on concept_name.concept_id = concept_id_and_values.concept_id
where concept_name_type = 'SHORT'
  and locale = 'en'"
) where property = 'bahmni.sqlGet.initialClinicalExaminationData';
