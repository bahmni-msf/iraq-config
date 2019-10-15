set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;


-- Parent concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Bone spur","Bone spur","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Does the patient have phantom pain","Does the patient have phantom pain","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Neuroma","Neuroma","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Sensitivity to light touch or pressure","Sensitivity to light touch or pressure","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Side of amputation","Side of amputation","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Small or conical, stump description","Small or conical, stump description","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Stump deformation","Stump deformation","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Stump shape","Stump shape","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Type of amputation","Type of amputation","Coded","Question",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Type of assessment","Type of assessment","Coded","Question",false);

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Date of amputation","Date of amputation","Date","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Date of fitting","Date of fitting","Date","Misc",false);

call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Description of balance","Description of balance","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Description of general patient state","Description of general patient state","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Description of global posture","Description of global posture","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Description of phantom pain","Description of phantom pain","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Description of walking","Description of walking","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Global appearance of stump","Global appearance of stump","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, LCI score","LCI score","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Other type of amputation","Other type of amputation","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, P and O center","P&O center","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, Skin and scar condition","Skin and scar condition","Text","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, From:","From:","Text","Misc",false);


call add_concept(@concept_id,@concept_short_id,@concept_full_id,"AA, cm:","cm:","Numeric","Misc",false);


INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision) VALUES ((select concept_id from concept_name where name = "AA, cm:" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,NULL,NULL,NULL,NULL,"",1,1);


-- ADDING CHILD CONCEPTS




call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at elbow level","Amputation at elbow level","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at hip joint","Amputation at hip joint","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at knee level","Amputation at knee level","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at level between elbow and wrist","Amputation at level between elbow and wrist","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at level between knee and ankle","Amputation at level between knee and ankle","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at level between shoulder and elbow","Amputation at level between shoulder and elbow","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation at shoulder joint","Amputation at shoulder joint","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation between hip and knee","Amputation between hip and knee","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation involving multiple body regions","Amputation involving multiple body regions","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation of foot at ankle level","Amputation of foot at ankle level","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation of hand at wrist level","Amputation of hand at wrist level","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation of other parts of foot","Amputation of other parts of foot","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Amputation of two or more fingers alone, complete or partial","Amputation of two or more fingers alone, complete or partial","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Big or bulbous","Big or bulbous","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Follow-up (post-fitting)","Follow-up (post-fitting)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Initial assessment (pre-fitting)","Initial assessment (pre-fitting)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Long","Long","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"No hesitancy = 1","No hesitancy = 1","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Short","Short","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Small or conical","Small or conical","N/A","Misc",false);


INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) VALUES ((select concept_id from concept_name where name = "AA, Skin and scar condition" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),"Description of general wound, edema, etc.",'en',1,now(),NULL,NULL,uuid());
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) VALUES ((select concept_id from concept_name where name = "AA, Description of general patient state" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),"Comment on endurance, motivation, comprehension",'en',1,now(),NULL,NULL,uuid());
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid) VALUES ((select concept_id from concept_name where name = "AA, Description of walking" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),"Include gait pattern and use of assistive device",'en',1,now(),NULL,NULL,uuid());
