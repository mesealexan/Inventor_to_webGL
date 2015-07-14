function loadObject (name, variable, callback, castShadow, receiveShadow, tileMap, materialName) {
	var mesh;
	var loader = new THREE.JSONLoader();
	var materialsArray = [];

	loader.load( "assets/" + name + ".js", function( geometry, materials ) {
		materials[0] = setMaterials( materialName, tileMap);
		/*
		materialsArray = materials;
		for (var i = materialsArray.length - 1; i >= 0; i--) {
			materialsArray[i] = setMaterials(materialsArray[i].name, tileMap);
		};*/
		geometry.computeFaceNormals();
		geometry.computeVertexNormals();

		var faceMaterial = new THREE.MeshFaceMaterial( materials ); 
 	 		mesh = new THREE.Mesh( geometry, faceMaterial );
 	 		mesh.name = name;



		if(castShadow) mesh.castShadow = castShadow;
		if(receiveShadow) mesh.receiveShadow = receiveShadow;	
		if(name.startsWith('Part_')){mesh.UVRepeat = tileMap;collision_group.add(mesh)}
			else {scene.add(mesh)}
 	});

loader.onLoadComplete = function(){

	};
}

function addToScene (obj, parent) {
	if(parent) parent.add(obj); else scene.add(obj);
 }

 function loadObjects(JSON_List){
 	for(var i=0,l=JSON_List.parts.length;i<l;i++){
 		var mesh;
 		loadObject(JSON_List.parts[i].name,mesh, addToScene, true, false, JSON_List.parts[i].uv, JSON_List.parts[i].material);
 	}
 	loadObject('plane',mesh, addToScene, false, true, 1, 'Plane');
 }

 function placeText(JSON_List){
 	var dummy_text = new THREE.Object3D();
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