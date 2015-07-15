fn returnBO_Array = 
(
	BO_array = #()
	for o in geometry where classOf o == Body_Object do
		append BO_array o
	return BO_array
)

fn setFineQuality obj = 
(
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.HighQualityVDS = on
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
	obj.LowQualityVDS = off
	obj.MediumQualityVDS = off
	obj.HighQualityVDS = on
	obj.IsoAngleDS = 3
	obj.IsoChordHeightVDS = 0
	obj.FaceApproxAngleVDS = 10
	obj.EdgeApproxAngleVDS = 0
	obj.FaceChordHeightVDS = 0.02
	obj.EdgeChordHeightVDS = 0
	obj.MaxEdgeLengthPctVDS = 0
)

fn prepareObj obj =
(
	setFineQuality(obj)
	obj.DisplayRadioVDS = 1
	--ConvertTo obj Editable_Poly
)

fn makePartsJSON  savePath = 
(	
	output_file = CreateFile (savePath + "\parts.JSON")
	boArray = returnBO_Array()
	index = 1
	count = boArray.count
	
	format  "{\n\t\"parts\": [\n" to:output_file 	
	
	for obj in boArray do 
	(		
		format "\t  {\n" to:output_file 	
		format "\t\t\"name\": \"%\",\n" obj.name to:output_file 			
		format "\t\t\"uv\": %,\n" ((obj.modifiers[uvwmap].length / 100) as integer) to:output_file 	
		
		matName = "Default"
		if (obj.material != undefined) do matName = obj.material.name 
		format "\t\t\"material\": \"%\"" matName to:output_file 
		
		format "\n\t  }" to:output_file 		
		index += 1
		if (index <= count) do format ",\n" to:output_file 
	)	
	
	format  "\n\t],\n" to:output_file
	format  "\t\"text\": {\n" to:output_file 	
	format  "\t\t\"first_name\": \"\",\n" to:output_file 	
	format  "\t\t\"last_name\": \"\",\n" to:output_file 	
	format  "\t\t\"birth\": \"\",\n" to:output_file 	
	format  "\t\t\"death\": \"\",\n" to:output_file 	
	format  "\t\t\"size\": \"\",\n" to:output_file 	
	format  "\t\t\"material\": \"\",\n" to:output_file 	
	format  "\t\t\"position\": \"\"\n" to:output_file 	
	format "\t}\n}" to:output_file 	
		
	close output_file
)

fn round num = 
(
	--snap to superior x100 limit
	return floor((num + 99) / 100) * 100;
)

fn addUVW prepareForExport =
(
	nameNum = 0;
	boArray = returnBO_Array()
	
	for obj in boArray do 
	(		
		m = uvwmap() 
		m.maptype = 4		
		size = 100
		
		if(prepareForExport) do
		(		
			--add custom sized UVW gizmo for three.js
			prepareObj(obj)
			bbSize = obj.max - obj.min
			size = amax #(round(bbSize[1]), round(bbSize[2]), round(bbSize[3]))
		)
			
		m.length = m.width = m.height = size
		addmodifier obj m			
			
		obj.name = "Part_" + nameNum as string
		nameNum += 1
	)
)

fn sceneSetup = 
(
	--just set up the scene, no custom UVW size, default to 100 sided cube
	addUVW(false)
)

fn trimName n = 
(
	--remove slashes from name, they cause subfolder behaviour
	while findstring n "/" != undefined do
	( 
		n = replace n (findstring n "/") 1 " "
	)
	
	return n
)

fn export =
(
	savePath = getSavepath()	
	if savePath == undefined then 
	(
		MessageBox "Couldn't open file for writing !"
		return undefined
	)
	
	makePartsJSON(savePath)
	addUVW(true)	
	
	filein "ThreeJSExporter.ms"	
	
	nameNum = 0
	for mat in scenematerials do 
	(
		obj_list = #()
		for obj in Geometry do
		(
			if obj.material == mat do  
			append obj_list obj 
		)
		select obj_list		
		--ostream = CreateFile (savePath + "\\" +  trimName(mat.name) + ".js")
		ostream = CreateFile (savePath + "\\" +  "Part_" + (nameNum as string) + ".js")
		nameNum += 1
		ExportScene()
		close ostream
	)	
)

rollout buttons "Inventor to webGL"
(
	local h = 20
	local w = 80
	
	button sceneSetupButton "Scene setup"
		pos:[5,5]
		height:h width:w 
	
		button exportButton "Export"
		pos:[90,5]
		height:h width:w 	
	
	on sceneSetupButton pressed do sceneSetup() 
	on exportButton pressed do export()
)

createDialog buttons 185 35
cui.RegisterDialogBar buttons