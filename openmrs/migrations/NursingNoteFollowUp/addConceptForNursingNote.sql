set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

-- Adding Parent concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Date recorded","Date recorded",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Location of patient","Location of patient",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Was the dressing changed","Was the dressing changed",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Side of dressing","Side of dressing",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Site of dressing","Site of dressing",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Site of dressing, other","Site of dressing, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Description of wound","Description of wound",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Exudate quantity","Exudate quantity",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Exudate type","Exudate type",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Anticipated date of next dressing change","Anticipated date of next dressing change",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Pain score","Pain score",'Numeric','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Side of pain","Side of pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Site of pain","Site of pain",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Site of pain, other","Site of pain, other",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Type of pain","Type of pain",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, When does the pain occur","When does the pain occur",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"NN, Nursing consultation notes","Nursing consultation notes",'Text','Misc',false);

-- Adding Child Concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Absent","Absent","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bleeding","Bleeding","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Dry wound","Dry wound","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Epithelisation (pink aspect)","Epithelisation (pink aspect)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Fibrin (yellow or green aspect)","Fibrin (yellow or green aspect)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Granulations (red aspect )","Granulations (red aspect )","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Healed","Healed","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Heavy","Heavy","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Infected","Infected","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Light","Light","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Moderate","Moderate","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Necrosis (black aspect)","Necrosis (black aspect)","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Oozing","Oozing","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pus","Pus","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Serous","Serous","N/A","Misc",false);


-- Adding Numeric concepts
INSERT INTO concept_numeric (concept_id,hi_absolute,hi_critical,hi_normal,low_absolute,low_critical,low_normal,units,precise,display_precision)
VALUES ((select concept_id from concept_name where name = "NN, Pain score" and concept_name_type = 'FULLY_SPECIFIED'  and locale = 'en'  and voided = 0),NULL,NULL,10,NULL,NULL,0,"",1,1);

-- Adding Help text to Concepts
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "NN, Pain score" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'For children 3-5 years, use Wong-Baker scale.  For children over 5 years and adults use visual numeric pain scale','en',1,now(),NULL,NULL,uuid());
