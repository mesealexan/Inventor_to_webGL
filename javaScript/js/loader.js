function loadObject (name, variable, callback, castShadow, receiveShadow, tileMap, materialName, path) {
	var mesh;
	var loader = new THREE.JSONLoader();
	var materialsArray = [];
	loader.load( path + name + ".js", function( geometry, materials ) {
		materials[0] = setMaterials( materialName, tileMap);
		geometry.computeFaceNormals();
		geometry.computeVertexNormals();

		var faceMaterial = new THREE.MeshFaceMaterial( materials ); 
 	 		mesh = new THREE.Mesh( geometry, faceMaterial );
 	 		mesh.name = name;

		if(castShadow) mesh.castShadow = castShadow;
		if(receiveShadow) mesh.receiveShadow = receiveShadow;	
		
 	});

loader.onLoadComplete = function(){
	if(name.startsWith('Part_')){mesh.UVRepeat = tileMap;collision_group.add(mesh)}
		else {scene.add(mesh)}
			console.log("Finished Loading: " + path + name + ".js")
	};
}

function addToScene (obj, parent) {
	if(parent) parent.add(obj); else scene.add(obj);
 }

function loadObjects(JSON_List, path){
 	for(var i=0,l=JSON_List.parts.length;i<l;i++){
 		var mesh;
 		loadObject(JSON_List.parts[i].name,mesh, addToScene, true, true, JSON_List.parts[i].uv, JSON_List.parts[i].material, path);
 	}
 	loadObject('plane',mesh, addToScene, true, true, 1, 'Plane', "assets/");
}

function placeText(JSON_List){
 	if(dummy_text) scene.remove(dummy_text);
 	if(JSON_List.text){
	 		dummy_text = new THREE.Object3D();
	 	var size = JSON_List.text.size, height = 0.3, curveSegments = 10;

	 	var first_name = new THREE.TextGeometry( JSON_List.text.first_name, {
			size: size,
			height: height,
			curveSegments: curveSegments,
		});
			first_name.center();
		var first_name_mesh = new THREE.Mesh( first_name, setMaterials( JSON_List.text.material, 1));
			first_name_mesh.position.y += 2 * size + 2;
			dummy_text.add( first_name_mesh );

	 	var last_name = new THREE.TextGeometry( JSON_List.text.last_name, {
			size: size,
			height: height,
			curveSegments: curveSegments,
		});
			last_name.center();
		var last_name_mesh = new THREE.Mesh( last_name, setMaterials( JSON_List.text.material, 1));
			last_name_mesh.position.y += size + 1;
			dummy_text.add( last_name_mesh );

	 	var birth = new THREE.TextGeometry( JSON_List.text.birth, {
			size: size,
			height: height,
			curveSegments: curveSegments,
		});
			birth.center();
		var birth_mesh = new THREE.Mesh( birth, setMaterials( JSON_List.text.material, 1));
			birth_mesh.position.y -= size + 1;
			dummy_text.add( birth_mesh );

	 	var death = new THREE.TextGeometry( JSON_List.text.death, {
			size: size,
			height: height,
			curveSegments: curveSegments,
		});
			death.center();
		var death_mesh = new THREE.Mesh( death, setMaterials( JSON_List.text.material, 1));
			death_mesh.position.y -= 2 * size + 2;
			dummy_text.add( death_mesh );

		dummy_text.position.set(JSON_List.text.position.x,JSON_List.text.position.z,-JSON_List.text.position.y)
		scene.add(dummy_text);
	}
}

function changeText(){
 	var form = document.getElementById('info')
 	thumb.text.first_name = form.children[0][0].value;
 	thumb.text.last_name = form.children[0][1].value;
 	thumb.text.birth = form.children[1][0].value;
 	thumb.text.death = form.children[1][1].value;

	placeText(thumb)
}