function setMaterials(materialName){
	var material;
	switch(materialName){ 
		case 'Plane':
		    material = new THREE.MeshLambertMaterial({
		    	color: new THREE.Color("rgb(255,255,255)"),
		    	ambient: new THREE.Color("rgb(255,255,255)"),
		    	specular: new THREE.Color("rgb(255,255,255)"),
		    	map: THREE.ImageUtils.loadTexture('assets/plane.jpg')
		    })
	        break;
	    default:
	    	material =  new THREE.MeshNormalMaterial();
        	
	}
	return material;
}