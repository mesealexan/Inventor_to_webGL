function loadObject (name, variable, callback, castShadow, receiveShadow) {
	var mesh;
	var loader = new THREE.JSONLoader();
	var materialsArray = [];

	loader.load( "assets/" + name + ".js", function( geometry, materials ) {
		materialsArray = materials;
		for (var i = materialsArray.length - 1; i >= 0; i--) {
			materialsArray[i] = setMaterials(materialsArray[i].name);
		};
		geometry.computeFaceNormals();
		geometry.computeVertexNormals();

		var faceMaterial = new THREE.MeshFaceMaterial( materialsArray ); 
 	 		mesh = new THREE.Mesh( geometry, faceMaterial );
 	 		mesh.name = name;

		if(castShadow) mesh.castShadow = castShadow;
		if(receiveShadow) mesh.receiveShadow = receiveShadow;	
 	});

loader.onLoadComplete = function(){
		if(name.startsWith('Part_')) collision_group.add(mesh)
			else scene.add(mesh)
	};
}

function addToScene (obj, parent) {
	if(parent) parent.add(obj); else scene.add(obj);
 }

 function loadObjects(JSON_List){
 	for(var i=0,l=JSON_List.parts.length;i<l;i++){
 		var mesh;
 		loadObject(JSON_List.parts[i].name,mesh, addToScene, false, true);
 		console.log(JSON_List.parts[i].name)
 	}
 }