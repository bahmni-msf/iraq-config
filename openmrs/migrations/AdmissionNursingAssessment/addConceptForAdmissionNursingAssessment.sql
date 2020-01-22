set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;


-- Parent concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Type of assessment","Type of assessment","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Patient allergy","Patient allergy","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Past medical history","Past medical history","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Side of pain","Side of pain","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Site of pain","Site of pain","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Level of consciousness","Level of consciousness","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Respiration","Respiration","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Nutritional Assessment","Nutritional Assessment","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Urinary elimination","Urinary elimination","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Bowel elimination","Bowel elimination","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Skin and mucous","Skin and mucous","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Site of bedsores","Site of bedsores","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Stage of bedsores","Stage of bedsores","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Does the patient need an air mattress","Does the patient need an air mattress","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Surgical wound","Surgical wound","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Site of surgical wounds","Site of surgical wounds","Coded","Question",false);

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Date recorded","Date recorded","Date","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Date of insertion (urinary catheter)","Date of insertion (urinary catheter)","Date","Misc",false);

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Weight","Weight","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Height","Height","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, BMI","BMI","Numeric","Computed",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Systolic blood pressure","Systolic blood pressure","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Diastolic blood pressure","Diastolic blood pressure","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Heart rate (HR)","Heart rate (HR)","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Temperature (Temp.)","Temperature (Temp.)","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Blood oxygen saturation (SatO2)","Blood oxygen saturation (SatO2)","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Respiratory rate (RR)","Respiratory rate (RR)","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Pain score","Pain score","Numeric","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Number of surgical wounds","Number of surgical wounds","Numeric","Misc",false);

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Type of allergy","Type of allergy","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Site of pain, other","Site of pain, other","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Type of pain","Type of pain","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, When does the pain occur","When does the pain occur","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Site of bedsores, other","Site of bedsores, other","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Site of surgical wounds, other","Site of surgical wounds, other","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Description of surgical wounds","Description of surgical wounds","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"ANA, Admission Nurses notes","Admission Nurses notes","Text","Misc",false);


#Child Concepts

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Agitated or Anxious","Agitated or Anxious","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Asthma","Asthma","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bedsores","Bedsores","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bradypnea","Bradypnea","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Buttocks","Buttocks","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"COPD","COPD","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Cardiac","Cardiac","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Chronic bronchitis","Chronic bronchitis","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Constipation","Constipation","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Diabetic diet","Diabetic diet","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Disoriented","Disoriented","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Fecal incontinence","Fecal incontinence","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"HIV","HIV","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Heel","Heel","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Height ² (in metres)","Height ² (in metres)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hepatitis","Hepatitis","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"High Protein","High Protein","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"High cholesterol","High cholesterol","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Kidney problems","Kidney problems","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Low Salt","Low Salt","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Regular","Regular","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Retention of Urine","Retention of Urine","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Somnolent","Somnolent","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Spine","Spine","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Shoulder blades","Shoulder blades","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Tachypnea","Tachypnea","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Tailbone","Tailbone","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Urinary catheter","Urinary catheter","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Urinary incontinence","Urinary incontinence","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Weight (in Kg)","Weight (in Kg)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lower arm","Lower arm","N/A","Misc",false);


call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Blood Pressure","Blood Pressure","N/A","Misc",True);

# Add concept to the numeric concepts (help text)

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Weight" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"kg",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Height" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,1,NULL,NULL,"cm",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, BMI" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"kg/m²",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Systolic blood pressure" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"mmHg",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Diastolic blood pressure" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"mmHg",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Heart rate (HR)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"bpm",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Temperature (Temp.)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"°C",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Blood oxygen saturation (SatO2)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"%",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Respiratory rate (RR)" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Pain score" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),10,NULL,NULL,0,NULL,NULL,"",1,1);

INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "ANA, Number of surgical wounds" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);

# Add description to the concepts (help text)

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "ANA, Does the patient need an air mattress" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'Should be completed for patients who are bedridden and/or who have bedsores','en',1,now(),NULL,NULL,uuid());



INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "ANA, Pain score" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'For children 3-5 years, use Wong-Baker scale.  For children over 5 years and adults use visual numeric pain scale','en',1,now(),NULL,NULL,uuid());