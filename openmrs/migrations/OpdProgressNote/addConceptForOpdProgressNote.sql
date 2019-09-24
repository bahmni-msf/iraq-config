set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Date recorded","Date recorded",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Reason for visit","Reason for visit",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Summary of follow-up consultation","Summary of follow-up consultation",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Type of pain experienced by the patient","Type of pain experienced by the patient",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Pain score","Pain score",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Burning","Burning",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Painful cold","Painful cold",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Electrical Shocks","Electrical Shocks",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Tingling","Tingling",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Pins and Needles","Pins and Needles",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Numbness","Numbness",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Itching","Itching",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Hypoaesthesia to touch","Hypoaesthesia to touch",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Hypoaesthesia to pinprick","Hypoaesthesia to pinprick",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Light brushing","Light brushing",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Neuropathic pain score","Neuropathic pain score",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Date of next DN4 assessment","Date of next DN4 assessment",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Side of pain","Side of pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Site of pain","Site of pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Site of pain, other","Site of pain, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, When does the pain occur","When does the pain occur",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, When does the pain occur, other","When does the pain occur, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Occurrence of the pain","Occurrence of the pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, What triggers or makes the pain worse","What triggers or makes the pain worse",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, What helps or relieves the pain","What helps or relieves the pain",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Current pain medication","Current pain medication",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Comments and notes about pain status of patient","Comments and notes about pain status of patient",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Evolution of patient ","Evolution of patient ",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Medical transmission to treating surgeon","Medical transmission to treating surgeon",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Communication received from the surgeon","Communication received from the surgeon",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Response from surgeon","Response from surgeon",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Notes or medications to be followed in OPD","Notes or medications to be followed in OPD",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Date of next communication","Date of next communication",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Date of next communication (IPD)","Date of next communication (IPD)",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Comments about transfer from OPD to IPD","Comments about transfer from OPD to IPD",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Date of discharge","Date of discharge",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Significant events in OPD","Significant events in OPD",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Discharge status","Discharge status",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Treatment prescribed upon exit ","Treatment prescribed upon exit ",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Discharge summary ","Discharge summary ",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"OPN, Reason for visit, other","Reason for visit, other",'Text','Misc',false);




call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Follow-up","Follow-up",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pain Visit","Pain Visit",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Mutual session","Mutual session",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"wound follow up","wound follow up",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Communication with surgeon","Communication with surgeon",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Transfer to IPD","Transfer to IPD",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Discharge","Discharge",'N/A','Misc',false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Other","Other",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Nociceptive","Nociceptive",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Neuropathic","Neuropathic",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Mixed","Mixed",'N/A','Misc',false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Yes","Yes",'N/A','Misc',false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"No","No",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Right","Right",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Left","Left",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bilateral","Bilateral",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Groin","Groin",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Gluteal","Gluteal",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hip","Hip",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Thigh","Thigh",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Knee","Knee",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Leg","Leg",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Ankle","Ankle",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Foot","Foot",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Toe","Toe",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Shoulder","Shoulder",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Axilla","Axilla",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Arm","Arm",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Elbow","Elbow",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Forearm","Forearm",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Wrist","Wrist",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hand","Hand",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Finger","Finger",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Breast","Breast",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Trunk","Trunk",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Abdomen","Abdomen",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Chest","Chest",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Upper back","Upper back",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lower back","Lower back",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stump","Stump",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Eye","Eye",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Eyelid","Eyelid",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Ear","Ear",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Nose","Nose",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Lip","Lip",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Mouth","Mouth",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Jaw","Jaw",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Cheek","Cheek",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Chin","Chin",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Scalp","Scalp",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Neck","Neck",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Face","Face",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Forehead including eyebrow","Forehead including eyebrow",'N/A','Misc',false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Other","Other",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"With physiotherapy","With physiotherapy",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"With dressing change","With dressing change",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"At night","At night",'N/A','Misc',false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Other","Other",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Continuous","Continuous",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Intermittent ","Intermittent ",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Medication","Medication",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Isolation","Isolation",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Wound care","Wound care",'N/A','Misc',false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Other","Other",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Discharged treatment complete","Discharged treatment complete",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Referred back to orthopedic surgeon","Referred back to orthopedic surgeon",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Referred for surgical complication","Referred for surgical complication",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Referred to Amman RSP","Referred to Amman RSP",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Discharge against medical advice","Discharge against medical advice",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Defaulter","Defaulter",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Deceased","Deceased",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Referred to other facility for specialized care","Referred to other facility for specialized care",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Therapeutic break","Therapeutic break",'N/A','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Geographic relocation","Geographic relocation",'N/A','Misc',false);

-- Adding Numeric concepts
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "OPN, Pain score" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);


INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "OPN, Neuropathic pain score" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);


-- Adding Help text to Concepts
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "OPN, Neuropathic pain score" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'If the score is equal or greater than 4/10, the test is positive','en',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "OPN, Communication received from the surgeon" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'Answer yes, if the treating surgeon for the patient has sent a response','en',1,now(),NULL,NULL,uuid());

INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "OPN, Treatment prescribed upon exit" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),'If patient is receiving medication at discharge, specify amount given and duration','en',1,now(),NULL,NULL,uuid());




