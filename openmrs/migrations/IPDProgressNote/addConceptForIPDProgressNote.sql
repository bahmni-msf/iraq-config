set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Date recorded","Date recorded",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Isolation status","Isolation status",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Patient complaint","Patient complaint",'Coded','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Patient complaints, other","Patient complaints, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Assessment of vital signs","Assessment of vital signs",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Description of abnormal vital signs","Description of abnormal vital signs",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, DVT prophylaxis","DVT prophylaxis",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Side of wound","Side of wound",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Site of wound","Site of wound",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Site of wound, other","Site of wound, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Description of wound","Description of wound",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Exudate quantity","Exudate quantity",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Exudate type","Exudate type",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Frequency of dressing","Frequency of dressing",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Frequency of dressing, other","Frequency of dressing, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Wound assessment, summary of findings","Wound assessment, summary of findings",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Type of pain experienced by the patient","Type of pain experienced by the patient",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Pain score","Pain score",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Burning","Burning",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Painful cold","Painful cold",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Electrical Shocks","Electrical Shocks",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Tingling","Tingling",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Pins and Needles","Pins and Needles",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Numbness","Numbness",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Itching","Itching",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Hypoaesthesia to touch","Hypoaesthesia to touch",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Hypoaesthesia to pinprick","Hypoaesthesia to pinprick",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Light brushing","Light brushing",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Neuropathic pain score","Neuropathic pain score",'Numeric','Computed',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Date of next DN4 assessment","Date of next DN4 assessment",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Side of pain","Side of pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Site of pain","Site of pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Site of pain, other","Site of pain, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, When does the pain occur","When does the pain occur",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, When does the pain occur, other","When does the pain occur, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Occurrence of the pain","Occurrence of the pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, What triggers or makes the pain worse","What triggers or makes the pain worse",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, What helps or relieves the pain","What helps or relieves the pain",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Current pain medication","Current pain medication",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Comments and notes about pain status of patient","Comments and notes about pain status of patient",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Communication needed for patient","Communication needed for patient",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Medical transmission to treating surgeon","Medical transmission to treating surgeon",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Communication received from the surgeon","Communication received from the surgeon",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Response from surgeon","Response from surgeon",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Date of next communication","Date of next communication",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Exit from IPD","Exit from IPD",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Date of next communication (OPD)","Date of next communication (OPD)",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Notes or medications to be followed in OPD","Notes or medications to be followed in OPD",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Comments about exit from IPD","Comments about exit from IPD",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Date of discharge","Date of discharge",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Discharge summary","Discharge summary",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Discharge status","Discharge status",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Treatment prescribed upon exit","Treatment prescribed upon exit",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"IPN, Summary of consultation","Summary of consultation",'Text','Misc',false);


call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Abdominal Pain","Abdominal Pain","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Deisolated","Deisolated","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Diarrhea","Diarrhea","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Dyspnea","Dyspnea","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Every other day","Every other day","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Fever","Fever","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Fibrinous","Fibrinous","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Granulations (red aspect)","Granulations (red aspect)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Haemopurulent","Haemopurulent","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hemorrhagic","Hemorrhagic","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Isolated","Isolated","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Nausea and vomiting","Nausea and vomiting","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Not isolated","Not isolated","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Once daily","Once daily","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pain","Pain","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Purulent","Purulent","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Seropurulent","Seropurulent","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Serosanguinous","Serosanguinous","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Transfer to OPD","Transfer to OPD","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Twice daily","Twice daily","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Twice weekly","Twice weekly","N/A","Misc",false);

-- Adding Numeric concepts
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "IPN, Pain score" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);


INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "IPN, Neuropathic pain score" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);


-- Adding Help text to Concepts
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "IPN, Neuropathic pain score" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'If the score is equal or greater than 4/10, the test is positive','en',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "IPN, Isolation status" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'Specify whether or not the patient is under isolation.','en',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "IPN, Communication needed for patient" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'Answer yes, if a communication needs to be sent to the treating surgeon for the patient','en',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "IPN, Communication received from the surgeon" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'Answer yes, if the treating surgeon for the patient has sent a response','en',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "IPN, Treatment prescribed upon exit" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'If patient is receiving medication at discharge, specify amount given and duration','en',1,now(),NULL,NULL,uuid());