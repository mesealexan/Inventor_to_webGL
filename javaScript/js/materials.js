function setMaterials(materialName, repeat){
	var material;
	switch(materialName){ 
		case 'Plane':
		    material = new THREE.MeshLambertMaterial({
		    	color: new THREE.Color("rgb(255,255,255)"),
		    	ambient: new THREE.Color("rgb(255,255,255)"),
		    	specular: new THREE.Color("rgb(255,255,255)"),
		    	map: THREE.ImageUtils.loadTexture(imagesArray[0])
		    })
	        break;
	    case 'Default':
		    material = new THREE.MeshPhongMaterial({
		    	color: new THREE.Color("rgb(125,125,125)"),
		    	ambient: new THREE.Color("rgb(125,125,125)"),
		    	specular: new THREE.Color("rgb(255,255,255)"),
		    	bumpScale: 0.3,
		    	shininess: 11
		    })
	        break;
	    case 'Text':
		    material = new THREE.MeshPhongMaterial({
		    	color: new THREE.Color("rgb(16,16,16)"),
		    	ambient: new THREE.Color("rgb(16,16,16)"),
		    	specular: new THREE.Color("rgb(255,255,255)")
		    })
	        break;
	    default:
	    var texture = THREE.ImageUtils.loadTexture("assets/materials/" + materialName + ".jpg");
			texture.wrapS = THREE.RepeatWrapping;
			texture.wrapT = THREE.RepeatWrapping;
			if(repeat) texture.repeat.set( repeat, repeat );
	    	material =  new THREE.MeshPhongMaterial({
		    	color: new THREE.Color("rgb(125,125,125)"),
		    	ambient: new THREE.Color("rgb(125,125,125)"),
		    	specular: new THREE.Color("rgb(255,255,255)"),
		    	//envMap: textureCube,
		    	map: texture,
		    	bumpMap: texture,
		    	bumpScale: 0.1,
		    	shininess: 16
	    	});
        	
	}
	return material;
}

var imagePrefix = "assets/skybox/Cube_";
var directions  = ["r", "l", "u", "d", "f", "b"]; 
var imageSuffix = ".jpg";


function makeTextureCube() {
	var urls = [];
	for (var i = 0; i < 6; i++)
		urls.push(imagePrefix + directions[i] + imageSuffix);

	textureCube = THREE.ImageUtils.loadTextureCube( urls, THREE.CubeRefractionMapping );
}