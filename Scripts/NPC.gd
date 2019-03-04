extends KinematicBody2D

var NPCdata = preload("res://Scripts//NPCdata.gd")
#create an array of NPC data, npc data can be parsed from a file in _ready()
const arr = ["Farmer","Baker","Shoemaker","Undertaker","Policeman","Gunsmith","Armorer","Doctor"]

var ID
var Name
var processintervals
var velocity

func _ready():
	processintervals = 0.0
	velocity = Vector2(randi()%3-1, randi()%3-1)
	hide()
	
func start(var _id, var pos):
	ID = _id
	Name = arr[ID]
	$Sprites.animation = str(ID)
	position = pos
	print("NPC " + Name + " has been initialized")
	show()

func _process(delta):
	processintervals += delta
	if(processintervals >= 4):
		velocity = Vector2(randi()%3+1, randi()%3+1)
		processintervals -= 4
	move_and_collide(velocity.normalized()*delta*100)
	
func _exit_tree():
	print(Name + " has been deleted")
	