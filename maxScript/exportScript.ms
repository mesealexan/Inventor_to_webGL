-------------------------------------------------------------------------------------
-- ThreeJSExporter.ms
-- Exports geometry from 3ds max to Three.js models in ASCII JSON format v3
-- By alteredq / http://alteredqualia.com
-- modified version with no UI
-------------------------------------------------------------------------------------
fn checkMaterialName nameCheck = 
(
	--valid material names
	names =  #("aura", "fire_red", "indian_impala", "kashmir_gold", "labrador_blue", 
		"mp_white", "nero_impala", "olive_green", "orion", "silver_paradise", "twilight_red", 
		"vanga", "virginia_black")
	
	for n in names do
	(
		if nameCheck == n then return true			
	)
	
	return false
)

ostream

headerFormat = "\"metadata\":
{
\"sourceFile\": \"%\",
\"generatedBy\": \"3ds max ThreeJSExporter\",
\"formatVersion\": 3.1,
\"vertices\": %,
\"normals\": %,
\"colors\": %,
\"uvs\": %,
\"triangles\": %,
\"materials\": %
},

"

vertexFormat = "%,%,%"
vertexNormalFormat = "%,%,%"
UVFormat = "%,%"
triFormat = "%,%,%,%"
triUVFormat = "%,%,%,%,%,%,%"
triNFormat = "%,%,%,%,%,%,%"
triUVNFormat = "%,%,%,%,%,%,%,%,%,%"
footerFormat = "}"

exportUv = true
exportNormal = true
flipYZ = true
exportColor = false
smoothNormal = false
flipUV = false
flipFace = false
autoflipFace = false

-------------------------------------------------------------------------------------
-- Dump vertices

function DumpVertices src =
(

	Format "\"vertices\": [" to:ostream

	num = src.count

	if num > 0 then
	(

		for i = 1 to num do
		(

			vert = src[i]

			if flipYZ then
			(
				x = vert.x
				y = vert.z
				z = vert.y

				z *= -1

			)
			else
			(

				x = vert.x
				y = vert.y
				z = vert.z

			)

			Format vertexFormat x y z to:ostream

			if i < num then Format "," to:ostream

		)

	)

	Format "],\n\n" to:ostream

)

-------------------------------------------------------------------------------------
-- Dump colors

function DumpColors src useColors =
(

	Format "\"colors\": [" to:ostream

	num = src.count

	if num > 0 and useColors then
	(

		for i = 1 to num do
		(

			col = src[i]

			r = col.r as Integer
			g = col.g as Integer
			b = col.b as Integer

			hexNum = ( bit.shift r 16 ) + ( bit.shift g 8 ) + b

			-- hexColor = formattedPrint hexNum format:"#x"
			-- Format "%" hexColor to:ostream

			decColor = formattedPrint hexNum format:"#d"
			Format "%" decColor to:ostream

			if i < num then Format "," to:ostream

		)

	)

	Format "],\n\n" to:ostream

)

-------------------------------------------------------------------------------------
-- Dump normals

function DumpNormals src =
(

	Format "\"normals\": [" to:ostream

	num = src.count

	if num > 0 and exportNormal then
	(

		for i = 1 to num do
		(

			normal = src[i]
			normal = normalize normal as point3

			if flipYZ then
			(

				x = normal.x
				y = normal.z
				z = normal.y

				z *= -1

			)
			else
			(

				x = normal.x
				y = normal.y
				z = normal.z

			)

			Format vertexNormalFormat x y z to:ostream

			if i < num then Format "," to:ostream

		)

	)

	Format "],\n\n" to:ostream

)

-------------------------------------------------------------------------------------
-- Dump uvs

function DumpUvs src =
(

	Format "\"uvs\": [[" to:ostream

	num = src.count

	if num > 0 and exportUv then
	(

		for i = 1 to num do
		(

			uvw = src[i]

			u = uvw.x

			if flipUV then
			(
				v = 1 - uvw.y
			)
			else
			(
				v = uvw.y
			)

			Format UVFormat u v to:ostream

			if i < num then Format "," to:ostream

		)

	)

	Format "]],\n\n" to:ostream

)

-------------------------------------------------------------------------------------
-- Dump faces

function DumpFaces src useColors =
(

	Format "\"faces\": [" to:ostream

	num = src.count

	if num > 0 then
	(

		for i = 1 to num do
		(

			zface = src[i]

			fv  = zface[1]
			fuv = zface[2]
			m   = zface[3] - 1
			fc  = zface[4]

			needsFlip = zface[5]

			isTriangle = true
			hasMaterial = true
			hasFaceUvs = false
			hasFaceVertexUvs = ((classof fuv == Point3) and exportUv)
			hasFaceNormals = false
			hasFaceVertexNormals = (exportNormal)
			hasFaceColors = false
			hasFaceVertexColors = ((classof fc == Point3) and useColors)

			faceType = 0
			faceType = bit.set faceType 1 (not isTriangle)
			faceType = bit.set faceType 2 hasMaterial
			faceType = bit.set faceType 3 hasFaceUvs
			faceType = bit.set faceType 4 hasFaceVertexUvs
			faceType = bit.set faceType 5 hasFaceNormals
			faceType = bit.set faceType 6 hasFaceVertexNormals
			faceType = bit.set faceType 7 hasFaceColors
			faceType = bit.set faceType 8 hasFaceVertexColors

			if i > 1 then
			(
				Format "," faceType to:ostream
			)

			Format "%" faceType to:ostream

			if isTriangle then
			(

				va = (fv.x - 1) as Integer
				vb = (fv.y - 1) as Integer
				vc = (fv.z - 1) as Integer

				if flipFace or needsFlip then
				(

					tmp = vb
					vb = vc
					vc = tmp

				)


				Format ",%,%,%" va vb vc to:ostream


				if hasMaterial then
				(

					Format ",%" m to:ostream

				)

				if hasFaceVertexUvs then
				(

					ua = (fuv.x - 1) as Integer
					ub = (fuv.y - 1) as Integer
					uc = (fuv.z - 1) as Integer

					if flipFace or needsFlip then
					(

						tmp = ub
						ub = uc
						uc = tmp

					)

					Format ",%,%,%" ua ub uc to:ostream

				)

				if hasFaceVertexNormals then
				(

					if smoothNormal then
					(

						-- normals have the same indices as vertices

						na = va
						nb = vb
						nc = vc

					)
					else
					(
						-- normals have the same indices as face

						na = i - 1
						nb = na
						nc = na

					)

					if flipFace or needsFlip then
					(

						tmp = nb
						nb = nc
						nc = tmp

					)

					Format ",%,%,%" na nb nc to:ostream

				)


				if hasFaceVertexColors then
				(

					ca = (fc.x - 1) as Integer
					cb = (fc.y - 1) as Integer
					cc = (fc.z - 1) as Integer

					if flipFace or needsFlip then
					(

						tmp = cb
						cb = cc
						cc = tmp

					)

					Format ",%,%,%" ca cb cc to:ostream

				)

			)

		)

	)

	Format "]\n\n" to:ostream

)

-------------------------------------------------------------------------------------
-- Dump color

function DumpColor pcolor label =
(
	r = pcolor.r / 255
	g = pcolor.g / 255
	b = pcolor.b / 255

	fr = formattedPrint r format:".4f"
	fg = formattedPrint g format:".4f"
	fb = formattedPrint b format:".4f"

	Format "\"%\"  : [%, %, %],\n" label fr fg fb to:ostream

)

-------------------------------------------------------------------------------------
-- Dump map

function DumpMap pmap label =
(

	if classof pmap == BitmapTexture then
	(
		bm = pmap.bitmap

		if bm != undefined then
		(

			fname = filenameFromPath bm.filename
			Format "\"%\"    : \"%\",\n" label fname to:ostream

		)

	)

)

-------------------------------------------------------------------------------------
-- Export materials

function ExportMaterials zmaterials zcolors =
(

	Format "\"materials\": [\n" to:ostream

	totalMaterials = zmaterials.count

	for i = 1 to totalMaterials do
	(
		mat = zmaterials[i]

		Format "{\n" to:ostream

		-- debug

		Format "\"DbgIndex\" : %,\n" (i-1) to:ostream

		if classof mat != BooleanClass and classof mat == Standardmaterial then
		(

			useVertexColors = zcolors[i]

			Format "\"DbgName\"  : \"%\",\n" mat.name to:ostream

			-- colors

			 DumpColor mat.diffuse  "colorDiffuse"
			DumpColor mat.ambient  "colorAmbient"
			DumpColor mat.specular "colorSpecular"

			t = mat.opacity / 100
			s = mat.glossiness

			Format "\"transparency\"  : %,\n" t to:ostream
			Format "\"specularCoef\"  : %,\n" s to:ostream

			-- maps

			DumpMap mat.diffuseMap  "mapDiffuse"
			DumpMap mat.ambientMap  "mapAmbient"
			DumpMap mat.specularMap "mapSpecular"
			DumpMap mat.bumpMap 	"mapBump"
			DumpMap mat.opacityMap 	"mapAlpha"

		)
		else
		(

			useVertexColors = false

			Format "\"DbgName\"  : \"%\",\n" "dummy" to:ostream

			DumpColor red "colorDiffuse"

		)

		Format "\"vertexColors\" : %\n" useVertexColors to:ostream
		Format "}" to:ostream

		if ( i < totalMaterials ) then Format "," to:ostream
		Format "\n\n" to:ostream

	)

	Format "],\n\n" to:ostream

)

-------------------------------------------------------------------------------------
-- Extract vertices from mesh

function ExtractVertices obj whereto =
(

	n = obj.numVerts

	for i = 1 to n do
	(

		v = GetVert obj i
		append whereto v

	)

)

-------------------------------------------------------------------------------------
-- Extract vertex colors from mesh

function ExtractColors obj whereto =
(

	nColors = GetNumCPVVerts obj

	if nColors > 0 then
	(

		for i = 1 to nColors do
		(

			c = GetVertColor obj i
			append whereto c

		)

	)

)


-------------------------------------------------------------------------------------
-- Extract normals from mesh

function ExtractNormals obj whereto needsFlip =
(

	if smoothNormal then
	(

		num = obj.numVerts

		for i = 1 to num do
		(

			n = GetNormal obj i

			if flipFace or needsFlip then
			(
				n.x *= -1
				n.y *= -1
				n.z *= -1
			)

			append whereto n

		)

	)
	else
	(

		num = obj.numFaces

		for i = 1 to num do
		(

			n = GetFaceNormal obj i

			if flipFace or needsFlip then
			(
				n.x *= -1
				n.y *= -1
				n.z *= -1
			)

			append whereto n

		)

	)

)

-------------------------------------------------------------------------------------
-- Extract uvs from mesh

function ExtractUvs obj whereto =
(
	n = obj.numTVerts

	for i = 1 to n do
	(

		v = GetTVert obj i
		append whereto v

	)

)

-------------------------------------------------------------------------------------
-- Extract faces from mesh

function ExtractFaces objMesh objMaterial whereto allMaterials needsFlip hasVColors offsetVert offsetUv offsetColor =
(
	n = objMesh.numFaces
	hasUVs = objMesh.numTVerts > 0

	useMultiMaterial = false
	materialIDList = #()

	materialClass = classof objMaterial

	if materialClass == StandardMaterial then
	(

		fm = findItem allMaterials objMaterial

	)
	else if materialClass == MultiMaterial then
	(

		useMultiMaterial = true

		for i = 1 to n do
		(

			mID = GetFaceMatID objMesh i
			materialIndex = findItem objMaterial.materialIDList mID

			if materialIndex > 0 then
			(

				subMaterial = objMaterial.materialList[materialIndex]

				mMergedIndex = findItem allMaterials subMaterial

				if mMergedIndex > 0 then
				(

					materialIDList[mID] = mMergedIndex

				)
				else
				(

					materialIDList[mID] = findItem allMaterials false

				)

			)
			else
			(

				materialIDList[mID] = findItem allMaterials false

			)

		)

	)
	else
	(

		-- undefined material

		fm = findItem allMaterials false

	)

	for i = 1 to n do
	(

		zface = #()

		fv = GetFace objMesh i

		fv.x += offsetVert
		fv.y += offsetVert
		fv.z += offsetVert

		if useMultiMaterial then
		(

			mID = GetFaceMatID objMesh i
			fm = materialIDList[mID]

		)

		if hasUVs then
		(

			fuv = GetTVFace objMesh i

			fuv.x += offsetUv
			fuv.y += offsetUv
			fuv.z += offsetUv

		)
		else
		(

			fuv = false

		)

		if hasVColors then
		(

			fc = GetVCFace objMesh i

			fc.x += offsetColor
			fc.y += offsetColor
			fc.z += offsetColor

		)
		else
		(

			fc = false

		)

		append zface fv
		append zface fuv
		append zface fm
		append zface fc
		append zface needsFlip

		append whereto zface

	)

)

-------------------------------------------------------------------------------------
-- Extract materials from eventual multi-material

function ExtractMaterials objMesh objMaterial whereto wheretoColors zname hasVColors =
(

	materialClass = classof objMaterial

	if materialClass == StandardMaterial then
	(

		if ( findItem whereto objMaterial ) == 0 then
		(

			append whereto objMaterial
			append wheretoColors hasVColors

		)

	)
	else if materialClass == MultiMaterial then
	(

		n = objMesh.numFaces

		for i = 1 to n do
		(

			mID = getFaceMatId objMesh i
			materialIndex = findItem objMaterial.materialIDList mID

			if materialIndex > 0 then
			(

				subMaterial = objMaterial.materialList[materialIndex]

				if ( findItem whereto subMaterial ) == 0 then
				(

					append whereto subMaterial
					append wheretoColors hasVColors

				)

			)

		)

	)
	else
	(

		-- unknown or undefined material

		append whereto false
		append wheretoColors false

	)

)

-------------------------------------------------------------------------------------
-- Hack to figure out if normals are messed up

function NeedsFaceFlip node =
(
	needsFlip = false

	local tmp = Snapshot node

	face_normal = normalize ( getfacenormal tmp 1 )

	face = getface tmp 1

	va = getvert tmp face[1]
	vb = getvert tmp face[2]
	vc = getvert tmp face[3]

	computed_normal = normalize ( cross (vc - vb)  (va - vb) )

	if distance computed_normal face_normal > 0.1 then needsFlip = true

	delete tmp

	return needsFlip
)

-------------------------------------------------------------------------------------
-- Extract only things that either already are or can be converted to meshes

function ExtractMesh node =
(

	if SuperClassOf node == GeometryClass then
	(
		needsFlip = false
		hasVColors = false

		zmesh = SnapshotAsMesh node

		if autoflipFace then
		(

			needsFlip = NeedsFaceFlip node

		)

		if exportColor and ( getNumCPVVerts zmesh ) > 0 then
		(

			hasVColors = true

		)

		return #( zmesh, node.name, node.material, needsFlip, hasVColors )

	)

	-- Not geometry ... could be a camera, light, etc.

	return #( false, node.name, 0, false, false )

)

-------------------------------------------------------------------------------------
-- Export scene

function ExportScene =
(

	-- Extract meshes

	meshObjects = #()

	mergedVertices = #()
	mergedNormals = #()
	mergedColors = #()

	mergedUvs = #()
	mergedFaces = #()

	mergedMaterials = #()
	mergedMaterialsColors = #()

	sceneHasVColors = false

	for obj in selection do
	(

		result = ExtractMesh obj
		meshObj = result[1]

		if ClassOf meshObj == TriMesh then
		(

			meshName     = result[2]
			meshMaterial = result[3]
			needsFlip    = result[4]
			hasVColors   = result[5]

			sceneHasVColors = sceneHasVColors or hasVColors

			append meshObjects result

			vertexOffset = mergedVertices.count
			uvOffset = mergedUvs.count
			colorOffset = mergedColors.count

			ExtractMaterials meshObj meshMaterial mergedMaterials mergedMaterialsColors meshName hasVColors

			ExtractVertices meshObj mergedVertices
			ExtractNormals meshObj mergedNormals needsFlip
			ExtractColors meshObj mergedColors

			ExtractUvs meshObj mergedUvs

			ExtractFaces meshObj meshMaterial mergedFaces mergedMaterials needsFlip hasVColors vertexOffset uvOffset colorOffset

		)

	)

	totalVertices = mergedVertices.count
	totalFaces = mergedFaces.count
	totalMaterials = mergedMaterials.count

	totalColors = 0
	totalNormals = 0
	totalUvs = 0

	useColors = false

	if sceneHasVColors and exportColor then
	(

		totalColors = mergedColors.count
		useColors = true

	)

	if exportNormal then
	(

		totalNormals = mergedNormals.count

	)

	if exportUv then
	(

		totalUvs = mergedUvs.count

	)


	-- Dump objects (debug)

	-- Format "// Source objects:\n\n" to:ostream

	-- i = 0

	-- for obj in meshObjects do
	-- (

	-- 	meshName = obj[2]
	-- 	Format "// %: %\n" i meshName to:ostream
	-- 	i += 1

	-- )

	-- Dump model

	Format "{\n\n" to:ostream

	-- Dump header

	Format headerFormat maxFileName totalVertices totalNormals totalColors totalUvs totalFaces totalMaterials to:ostream

	-- Dump all materials in the scene

	ExportMaterials mergedMaterials mergedMaterialsColors

	-- Dump merged data from all selected geometries

	DumpVertices mergedVertices
	DumpNormals mergedNormals
	DumpColors mergedColors useColors
	DumpUvs mergedUvs
	DumpFaces mergedFaces useColors

	-- Dump footer

	Format footerFormat to:ostream

)
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
rollout buttons "Inventor to webGL"
(
	
	local h = 20
	local w = 80
	
	button sceneSetupButton "Scene setup"
		pos:[5,15]
		height:h width:w 
	
	button exportButton "Export"
	pos:[90,15]
	height:h width:w 		
	
	progressbar doit_prog color:blue visible:false 
	pos:[5,30]
	width:165	
	
fn findText = 
(
		for o in objects do 
		(
			if o.name == "Text" then return o.position
		)
		
	return undefined
)

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

fn removeMod boArray =
(
	for bo in boArray do
	(
		for index = bo.modifiers.count to 1 by -1 do deleteModifier bo index	
	)
)

fn explodeGrp boArray =
(
	select boArray
	explodeGroup $
	max select none
)

fn makePartsJSON savePath BO_array = 
(	
	output_file = CreateFile (savePath + "\parts.JSON")
	boArray = BO_array
	index = 0
	count = boArray.count
	UV_size_division = 100
	textObj = findText()
	
	explodeGrp boArray
	
	format  "{\n\t\"parts\": [\n" to:output_file 	
	
	for obj in boArray do 
	(		
		format "\t  {\n" to:output_file 	
		format "\t\t\"name\": \"%\",\n" obj.name to:output_file 			
		format "\t\t\"uv\": %,\n" ((obj.modifiers[uvwmap].length / UV_size_division) as integer) to:output_file 	
		
		matName = "Default"
		if (obj.material != undefined) do 
		(
			matName = obj.material.name 
			if (checkMaterialName matName != true) then matName = "Default"
		)
		format "\t\t\"material\": \"%\"" matName to:output_file 
		
		format "\n\t  }" to:output_file 		
		
		select obj
		ostream = CreateFile (savePath + "\\" +  "Part_" + (index as string) + ".js")
		
		ExportScene()
		close ostream			
		
		index += 1
		if (index < count) do format ",\n" to:output_file 	
		
		doit_prog.value = 100 * index / boArray.count
	)	
	
	format  "\n\t]" to:output_file
	
	if (textObj != undefined) then
	(
		format  ",\n\t\"text\": {\n" to:output_file 	
		format  "\t\t\"first_name\": \".\",\n" to:output_file 	
		format  "\t\t\"last_name\": \".\",\n" to:output_file 	
		format  "\t\t\"birth\": \".\",\n" to:output_file 	
		format  "\t\t\"death\": \".\",\n" to:output_file 	
		format  "\t\t\"size\": 2.5,\n" to:output_file 	
		format  "\t\t\"material\": \"Text\",\n" to:output_file 	
		format  "\t\t\"position\": {\"x\": %, \"y\": %, \"z\": %}\n" textObj.x textObj.y textObj.z to:output_file 	
		format "\t}\n}" to:output_file 	
	)
	else format "\n}" to:output_file  	
		
	close output_file
			
	removeMod boArray
)

fn round num = 
(
	--snap to superior x100 limit
	return floor((num + 99) / 100) * 100;
)

fn addUVW prepareForExport boArray =
(
	nameNum = 0;
	
	for obj in boArray do 
	(		
		m = uvwmap() 
		m.maptype = 4		
		size = 100		
		tu = turn_to_poly()
		
		if(prepareForExport) do
		(		
			--add custom sized UVW gizmo for three.js
			prepareObj(obj)
			bbSize = obj.max - obj.min
			size = amax #(round(bbSize[1]), round(bbSize[2]), round(bbSize[3]))
		)
			
		m.length = m.width = m.height = size

		addmodifier obj m		
		if(prepareForExport) do addmodifier obj tu	
			
		obj.name = "Part_" + nameNum as string
		nameNum += 1
	)
)

fn sceneSetup = 
(
	--just set up the scene, no custom UVW size, default to 100 sided cube
	boArray = returnBO_Array()	
	explodeGrp boArray
	removeMod boArray	
	addUVW false boArray	
	
	MessageBox "Scene setup successful!"
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
	sceneSetupButton.pos=[5,5]	
	exportButton.pos=[90,5]	
	doit_prog.value = 0;
	savePath = getSavepath()	
	if savePath == undefined then 
	(
		MessageBox "Couldn't open file for writing !"
		doit_prog.visible = false
		return undefined
	)
	
	BO_array = returnBO_Array()
	
	removeMod BO_array	
	addUVW true BO_array
	makePartsJSON savePath BO_array
	
	MessageBox "Export successful!"
	doit_prog.visible = false
	sceneSetupButton.pos=[5,15]	
	exportButton.pos=[90,15]	
)
	on sceneSetupButton pressed do sceneSetup() 
	on exportButton pressed do 
	(
		doit_prog.visible = true
		export()
	)
)

createDialog buttons 185 60
cui.RegisterDialogBar buttons