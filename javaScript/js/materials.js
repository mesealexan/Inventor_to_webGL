function setMaterials(materialName){
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
	    default:
	    	material =  new THREE.MeshPhongMaterial({
		    	color: new THREE.Color("rgb(125,125,125)"),
		    	ambient: new THREE.Color("rgb(125,125,125)"),
		    	specular: new THREE.Color("rgb(255,255,255)"),
		    	map: THREE.ImageUtils.loadTexture("assets/materials/" + materialName + ".jpg"),
		    	bumpMap: THREE.ImageUtils.loadTexture("assets/materials/" + materialName + ".jpg"),
		    	bumpScale: 0.3,
		    	shininess: 11
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