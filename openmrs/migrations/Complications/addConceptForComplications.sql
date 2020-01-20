set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

-- Adding Parent concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Patient complication","Patient complication",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Start date of complication","Start date of complication",'Date','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Anemia due to acute blood loss, description","Anemia due to acute blood loss, description",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Antibiotic adverse reaction, description","Antibiotic adverse reaction, description",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Cardiac arrhythmia, description","Cardiac arrhythmia, description",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Flap necrosis, description","Flap necrosis, description",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Bedsores or pressure ulcer, description","Bedsores or pressure ulcer, description",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Description of complication","Description of complication",'Text','Misc',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Grade of complication","Grade of complication",'Coded','Question',false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"CM, Additional comments, complications","Additional comments, complications",'Text','Misc',false);


-- Adding Child concepts
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Acute Kidney Injury","Acute Kidney Injury","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Anemia due to acute blood loss","Anemia due to acute blood loss","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Antibiotic Adverse Reaction","Antibiotic Adverse Reaction","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Bedsores or pressure ulcer","Bedsores or pressure ulcer","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Cardiac Arrhythmia","Cardiac Arrhythmia","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Cellulitis","Cellulitis","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Chest Infection","Chest Infection","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Compartment Syndrome","Compartment Syndrome","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Death","Death","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Deep Venous Thrombosis","Deep Venous Thrombosis","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Delayed union","Delayed union","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Early bone malalignment","Early bone malalignment","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Flap Necrosis","Flap Necrosis","N/A","Misc",false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Heart Failure","Heart Failure","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hematoma or bleeding from surgical site","Hematoma or bleeding from surgical site","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Hospital Acquired Infection","Hospital Acquired Infection","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Iatrogenic Fracture","Iatrogenic Fracture","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Implant Failure","Implant Failure","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Implant failure and re-fracture of bone","Implant failure and re-fracture of bone","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Limb Ischemia","Limb Ischemia","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Nerve Injury","Nerve Injury","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Osteomyelitis, post-operative","Osteomyelitis, post-operative","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pin loosening","Pin loosening","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Pin track infection in the project","Pin track infection in the project","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Re-fracture of bone","Re-fracture of bone","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Septic Shock","Septic Shock","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Seroma without infection","Seroma without infection","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Skin Graft Failure","Skin Graft Failure","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stress Ulcer","Stress Ulcer","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stress Ulcer with bleeding","Stress Ulcer with bleeding","N/A","Misc",false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stroke","Stroke","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Surgical Site Infection","Surgical Site Infection","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Tissue Expander Infection","Tissue Expander Infection","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Venous thromboembolic disease","Venous thromboembolic disease","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Wound Dehiscence","Wound Dehiscence","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"No transfusion","No transfusion","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Transfusion required","Transfusion required","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Severe nausea and vomiting","Severe nausea and vomiting","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Neutropenia","Neutropenia","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Thrombocytopenia","Thrombocytopenia","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Rash","Rash","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Febrile reaction","Febrile reaction","N/A","Misc",false);
-- call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Acute kidney injury","Acute kidney injury","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Anaphylaxis","Anaphylaxis","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Atrial fibrillation","Atrial fibrillation","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"SVT","SVT","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Superficial","Superficial","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Deep","Deep","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Full-thickness","Full-thickness","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stage 1","Stage 1","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stage 2","Stage 2","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stage 3","Stage 3","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Stage 4","Stage 4","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade I - No treatment","Grade I - No treatment","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade II - Requiring drug treatment","Grade II - Requiring drug treatment","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade IIIa - Interventions with local anaesthesia","Grade IIIa - Interventions with local anaesthesia","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade IIIb - Interventions under general anaesthesia","Grade IIIb - Interventions under general anaesthesia","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade IVa - Single-organ dysfunction","Grade IVa - Single-organ dysfunction","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade IVb - Multi-organ dysfunction","Grade IVb - Multi-organ dysfunction","N/A","Misc",false);
call add_concept(@concept_id,@concept_short_id,@concept_full_id,"Grade V - Death of patient","Grade V - Death of patient","N/A","Misc",false);


-- Adding Help text to Concepts
INSERT INTO concept_description (concept_id,description,locale,creator,date_created,changed_by,date_changed,uuid)
VALUES
((select concept_id from concept_name where name = "CM, Grade of complication" and concept_name_type = 'FULLY_SPECIFIED' and locale = 'en' and voided = 0),
 'Clavien-Dindo System:  Grade I: Any deviation from the normal post-operative course not requiring surgical, endoscopic or radiological intervention. This includes the need for certain drugs (e.g. antiemetics, antipyretics, analgesics, diuretics and electrolytes), treatment with physiotherapy and wound infections that are opened at the bedside.  Grade II:  Complications requiring drug treatments other than those allowed for Grade I complications; this includes blood transfusion and total parenteral nutrition (TPN).  Grade IIIa:  Complications requiring surgical, endoscopic or radiological intervention not under general anaesthesia.  Grade IIIb:  Complications requiring surgical, endoscopic or radiological intervention under general anaesthesia.  Grade IVa:  Single organ dysfunction, life-threatening complications; this includes CNS complications (e.g. brain haemorrhage, ischaemic stroke, subarachnoid haemorrhage) which require intensive care, but excludes transient ischaemic attacks (TIAs).  Grade IVb: Multi-organ dysfunction, life-threatening complications; this includes CNS complications (e.g. brain haemorrhage, ischaemic stroke, subarachnoid haemorrhage) which require intensive care, but excludes transient ischaemic attacks (TIAs).  Grade V: Death of patient.','en',1,now(),NULL,NULL,uuid());




