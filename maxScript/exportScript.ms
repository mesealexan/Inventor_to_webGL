fn selectAllBody =
(
	bo_array = #()
	for o in geometry where classOf o == Body_Object do 
		append bo_array o
	select bo_array
	
	local size = 100
	m = uvwmap() 
	m.maptype = 4
	m.length = m.width = m.height = size	
	addmodifier bo_array m
)

rollout buttons "Inventor to webGL"
(
	local h = 20
	local w = 80
	
	button selectButton "Select all"
		pos:[5,5]
		height:h width:w 
	
		button exportButton "Export"
		pos:[90,5]
		height:h width:w 	
	
	on selectButton pressed do selectAllBody()
)

createDialog buttons 185 35
cui.RegisterDialogBar buttons