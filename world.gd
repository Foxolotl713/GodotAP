extends MarginContainer

var World=[
	"Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock",
	"Rock","House","Grass","Grass","Grass","House ","Grass","Grass","Grass","Grass","Grass","Rock",
	"Rock","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Rock","Rock","Rock",
	"Rock","Grass","Grass","Old Man","Grass","Grass","Grass","Grass","House    ","Scrub","Dog ","Rock", 
	"Rock","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Rock","Rock","Rock",
	"Rock","Scrub","Rock","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Rock",
	"Rock","Dog","Rock","House  ","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Rock",
	"Rock","Rock","Rock","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Grass","Rock",
	"Rock","Grass","Grass","Grass","Grass","Grass","Grass","House   ","Grass","Grass","Grass","Rock",
	"Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Rock","Shed"
]

var locationIDs= {
	"Old Man 1": 11,
	"Old Man 2": 12,
	"Old Man 3": 13,
	"Old Man 4": 14,
	"House 1": 21,
	"House 2": 22,
	"House 3": 23,
	"House 4": 24,
	"House 5": 25,
	"Dog 1 - 1": 31,
	"Dog 1 - 2": 32,
	"Dog 1 - 3": 33,
	"Dog 2 - 1": 34,
	"Dog 2 - 2": 35,
	"Dog 2 - 3": 36,
	"Dog 2 - 4": 37
}

var Texts={
	"Old Man 1":"The Old man told you that you're stuck in a timeloop and that there's not much time left. There's only enough time to do one thing every iteration.",
	"Old Man 2":"He told you to collect time crystals to fix the time generator",
	"Old Man 3":"He told you that you are not stuck alone but that you are the only one who can move around without immediately resetting.",
	"Old Man 4":"He told you that not everything resets at the end of the day. For example, it matters where you sleep. Memories also persist.",
	"Dog 1":"A corgi is sitting in his little house. It looks quite hungry.",
	"Dog 2":"You feed the corgi and teach it to sit. It looks a lot happier",
	"Dog 3":"You feed the corgi again and teach it to roll over. It looks like it's having the time of its life.",
	"Dog 12":"You spot a collar around the corgis neck with a name tag that says 'Rex'. You pet the corgi and it looks a bit happier.",
	"Home":"You go to sleep and feel anchored.",
	"Scrub":"There is a scrub in the way. Maybe it could be cut down?",
	"FovUp":"It's a small bottle with a strange liquid inside. When you drink it, you feel like you can see further than ever before.",
	"TimeUp":"It's a can of white monster. After drinking it you feel like you can run around longer before passing out.",
	"Machete":"It's a machete! Luckily it didn't hit you, it looks like it's great at cutting.",
	"Machete Manual":"It's a manual for a machete! With this, anyone could learn to use a machete efficiently.",
	"Dog Food":"It's a pack of quality dog food. 'Make your pet happy with snacky!'",
	"Dust":"It's just a bit of dust.",
	"TimeCrystal":"It's a mysterious crystal that seems to be pulsating with energy.",
	"Goal":"You place the time crystals into their box. Immediately, the machine starts shaking and vanishes, taking the box with it. \nSuddenly you feel time shift until everything is back to normal.",
	"NotGoal":"The Machine in the shed seems to need more fuel in the form of time crystals, at least that's what the label on the box next to it says. You dont think you have enough to power such a big thing.",
	"NotGoalDog":"As you approach the machine to place the time crystals in, you think of the corgis and how sad they looked and feel like you should take care of them before worrying about the machine."
}

var worldx=12
var worldy=10
var camx=0
var camy=0
var spawnx=0
var spawny=0
var fov=3
var turns=3
var turnsleft=turns
var item_queue=[]
var conn
var slot_data
var timecrystals=0
var machete=false
var machetemanual=false
var dogfood=false
var oldmanchecks=0
var dogchecks=0
var dogchecks2=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GridContainer.columns=fov
	Archipelago.connected.connect(connected, 2)
	Archipelago.disconnected.connect(disconnected, 0)

func _on_button_pressed(index):
	var text = World[index]
	match text:
		"Scrub":
			if machete:
				World[index]="Grass "
				time(1)
				for child in $GridContainer.get_children():
					child.queue_free()
		"House":
			popup("Home", false, 1)
			spawnx=0
			spawny=0
			Archipelago.collect_location(locationIDs["House 1"])
		"House ":
			popup("Home", false, 1)
			spawnx=4
			spawny=0
			Archipelago.collect_location(locationIDs["House 2"])
		"House  ":
			popup("Home", false, 1)
			spawnx=2
			spawny=5
			Archipelago.collect_location(locationIDs["House 3"])
		"House   ":
			popup("Home", false, 1)
			spawnx=6
			spawny=7
			Archipelago.collect_location(locationIDs["House 4"])
		"House    ":
			popup("Home", false, 1)
			spawnx=7
			spawny=2
			Archipelago.collect_location(locationIDs["House 5"])
		"Old Man":
			time(1)
			if oldmanchecks==0:
				popup("Old Man 1", false, 1)
				Archipelago.collect_location(locationIDs["Old Man 1"])
				oldmanchecks+=1
			elif oldmanchecks==1:
				popup("Old Man 2", false, 1)
				Archipelago.collect_location(locationIDs["Old Man 2"])
				oldmanchecks+=1
			elif oldmanchecks==2:
				popup("Old Man 3", false, 1)
				Archipelago.collect_location(locationIDs["Old Man 3"])
				oldmanchecks+=1
			elif oldmanchecks==3:
				popup("Old Man 4", false, 1)
				Archipelago.collect_location(locationIDs["Old Man 4"])
				oldmanchecks+=1
		"Dog":
			if World[index-worldx]!="Scrub":
				if dogchecks==0:
					popup("Dog 1", false, 1)
					Archipelago.collect_location(locationIDs["Dog 1 - 1"])
					dogchecks+=1
				elif dogfood:
					if dogchecks==1:
						popup("Dog 2", false, 1)
						Archipelago.collect_location(locationIDs["Dog 1 - 2"])
						dogchecks+=1
					elif dogchecks==2:
						popup("Dog 3", false, 1)
						Archipelago.collect_location(locationIDs["Dog 1 - 3"])
						dogchecks+=1
					else:
						popup("Home", false, 1)
				else:
					popup("Dog 1", false, 1)
					
				spawnx=0
				spawny=5
			else:
				popup("Scrub", false, 1)
		"Dog ":
			if World[index-1]!="Scrub":
				if dogchecks2==0:
					popup("Dog 1", false, 1)
					Archipelago.collect_location(locationIDs["Dog 2 - 1"])
					dogchecks2+=1
				elif dogchecks2==1:
					popup("Dog 12", false, 1)
					Archipelago.collect_location(locationIDs["Dog 2 - 2"])
					dogchecks2+=1
				elif dogfood:
					if dogchecks2==2:
						popup("Dog 2", false, 1)
						Archipelago.collect_location(locationIDs["Dog 2 - 3"])
						dogchecks2+=1
					elif dogchecks2==3:
						popup("Dog 3", false, 1)
						Archipelago.collect_location(locationIDs["Dog 2 - 4"])
						dogchecks2+=1
					else:
						popup("Home", false, 1)
				else:
					popup("Dog 11", false, 1)
					
				spawnx=9
				spawny=2
			else:
				popup("Scrub", false, 1)
		"Shed":
			if timecrystals>=slot_data["time_crystals_required_for_goal"]&&((dogchecks==3&&dogchecks2==4)||slot_data["dog_goal"]==0):
				popup("Goal", false, 1)
				Archipelago.set_client_status(AP.ClientStatus.CLIENT_GOAL)
			else:
				if timecrystals<slot_data["time_crystals_required_for_goal"]:
					popup("NotGoal", false, 1)
				else:
					popup("NotGoalDog", false, 1)
		_:
			pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $GridContainer.get_child_count() < fov * fov:
		for j in range(fov):
			for i in range(fov):
				var button_scene = preload("res://button.tscn")
				var button = button_scene.instantiate()
				button.text = World[i + camx + worldx * (j + camy)] #Max 45 Chars
				$GridContainer.add_child(button)
				button.pressed.connect(_on_button_pressed.bind(i + camx + worldx * (j + camy)))

func move(direction):
	if self.visible==false:
		return
	match direction:
		"right":
			if camx+fov<worldx:
				camx+=1
				for child in $GridContainer.get_children():
					child.queue_free()
		"left":
			if camx>0:
				camx-=1
				for child in $GridContainer.get_children():
					child.queue_free()
		"up":
			if camy>0:
				camy-=1
				for child in $GridContainer.get_children():
					child.queue_free()
		"down":
			if camy+fov<worldy:
				camy+=1
				for child in $GridContainer.get_children():
					child.queue_free()
	time(1)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_D:
		move("right")
	if event is InputEventKey and event.pressed and event.keycode == KEY_A:
		move("left")
	if event is InputEventKey and event.pressed and event.keycode == KEY_W:
		move("up")
	if event is InputEventKey and event.pressed and event.keycode == KEY_S:
		move("down")

func increase_fov(amount:int):
	if fov+amount<11:
		fov+=amount
		if camx>worldx-fov:
			camx-=1
		if camy>worldy-fov:
			camy-=1
		$GridContainer.columns=fov
		for child in $GridContainer.get_children():
			child.queue_free()

func time(duration: int):
	turnsleft-=duration
	if turnsleft<=0:
		$TextureRect.visible=true
	$Label.text="Time left: "+str(turnsleft)
	
func reset():
	if item_queue.size()==0:
		for child in $GridContainer.get_children():
			child.queue_free()
		$TextureRect.visible=false
		item_queue.clear()
		camx=spawnx
		camy=spawny
		turnsleft=turns
		$Label.text="Time left: "+str(turnsleft)
	else:
		popup(item_queue.pop_front(), true, 2)

func popup(key: String, item: bool, z: int):
	var popupscene=preload("res://InteractionPopup.tscn")
	@warning_ignore("shadowed_variable")
	var popup=popupscene.instantiate()
	popup.visible=true
	popup.z_index=z
	var text=""
	if item:
		text="Something drops out of a weird portal looking thing that immediately closes. It feels like time is slowing down and speeding up at the same time.\n"
		handleItem(key)
	if Texts.keys().has(key):
		text+=Texts[key]
	else:
		print("unknown text:"+key)
	popup.text=text
	popup.clicked.connect(handleClick, 1)
	get_tree().get_first_node_in_group("main").add_child(popup)

func handleItem(item: String):
	match item:
		"FovUp":
			increase_fov(1)
		"TimeUp":
			turns+=1
		"Dog Food":
			dogfood=true
		"Machete":
			machete=true
		"Machete Manual":
			machetemanual=true
		"TimeCrystal":
			timecrystals+=1
		_:
			pass

func queueItem(item):
	@warning_ignore("shadowed_variable_base_class")
	var name = item.get_name()
	item_queue.append(name)

func connected(connection_info, _json):
	conn=connection_info
	conn.obtained_item.connect(queueItem, 1)
	slot_data=conn.slot_data

func disconnected():
	machete=false
	machetemanual=false
	dogfood=false
	dogchecks=0
	dogchecks2=0
	oldmanchecks=0
	spawnx=0
	spawny=0
	camx=0
	camy=0
	timecrystals=0
	turns=3
	item_queue=[]
	for a in range(World.size()):
		if World[a]=="Grass ":
			World[a]="Scrub"
	reset()

func handleClick():
	reset()
