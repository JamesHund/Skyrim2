extends MarginContainer

var selected_quest
var difficulty = ["Very Easy","Easy","Normal","Hard","Very Hard"]

func _ready():
	hide()
	$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect.hide()

func _set_quest(var id):
	selected_quest = id
	if QuestHandler.quests[id].quest_state == 0:
		_set_quest_text(_generate_quest_text())
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect.show()
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect/RichTextLabel.set_text("   Accept")
	elif QuestHandler.quests[id].quest_state == 1:
		_set_quest_text(_generate_quest_text())
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect.hide()
	elif QuestHandler.quests[id].quest_state == 2:
		_set_quest_text("Thank you for finding it for me! Here is your reward!")
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect.show()
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect/RichTextLabel.set_text("   Reward")
	else:
		_set_quest_text("Thank you for finding it for me!")
	$VBoxContainer/NinePatchRect/RichTextLabel.set_text("   Questgiver: " + NPCdata.npc_list[QuestHandler.quests[id].NPC].get("name"))
		
func _generate_quest_text():
	var quest = QuestHandler.quests[selected_quest]
	var text = "Help! Help!"
	text += "\nThe Goblins stole my " + ItemUtils._get_item_name(quest.quest_item) + " when I was passing by the " + quest.location_name + "!\n"
	text += "PLease get it for me I will reward you greatly!\n\n" 
	text += "The difficulty of this quest is " + difficulty[quest.difficulty] + "."
	return text
	
func _set_quest_text(var text):
	$VBoxContainer/MarginContainer2/RichTextLabel.set_text(text)
	


func _on_TextureButton_pressed():
	print("Accept/rewrd button pressed")
	if QuestHandler.quests[selected_quest].quest_state == 0:
		_set_quest_text(_generate_quest_text())
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect.hide()
		QuestHandler._activate_quest(selected_quest)
	if QuestHandler.quests[selected_quest].quest_state == 2:
		$VBoxContainer/MarginContainer/HBoxContainer/NinePatchRect.hide()
		QuestHandler._complete_quest(selected_quest)
