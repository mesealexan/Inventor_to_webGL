function addControls() {	
    controls = new THREE.OrbitControls( camera, renderer.domElement );

    hammer = new Hammer(container);
    //pan in all directions
    hammer.get('pan').set({ direction: Hammer.DIRECTION_ALL });
    //hammer.on('panstart', function(ev) { });
	//hammer.on('panend', function(ev) { });
}            

function cancelAllTweens () {
    TWEEN.removeAll();
}

function toggleInput (bool) {
    controls.enabled = bool;
    hammer.set({ enable: bool});
}

var current_selection;
document.addEventListener("dragstart", function(event) {
	if(event.target && event.target.alt){
		current_selection = event.target;
		event.dataTransfer.effectAllowed = "copy";
		var img = document.createElement("img");
    		img.src = "img/drag.png";
    		event.dataTransfer.setDragImage(img, 16, 16);
	}


});

container = document.getElementById( 'webGL' )
console.log(container)
var clientX, clientY;
container.addEventListener("dragover", function(event) {
	clientX = event.clientX;
	clientY = event.clientY;
});

document.addEventListener("drag", function(event) {
	if(current_selection && current_selection.alt && clientX){
		mouse.x = (clientX / window.innerWidth ) * 2 - 1;
		mouse.y = - (clientY / window.innerHeight ) * 2 + 1;	
		raycaster.setFromCamera( mouse, camera );	
		var intersects = raycaster.intersectObjects( collision_group.children );
		if(intersects.length){
			//intersects[0].object.material.materials[0].ambient =  new THREE.Color("rgb(255,0,0)")
		}

	}
});



document.addEventListener("dragend", function(event) {
	if(current_selection && current_selection.alt && clientX){
		mouse.x = (clientX / window.innerWidth ) * 2 - 1;
		mouse.y = - (clientY / window.innerHeight ) * 2 + 1;	
		raycaster.setFromCamera( mouse, camera );	
		var intersects = raycaster.intersectObjects( collision_group.children );
		if(intersects.length){
			intersects[0].object.material.materials[0] = setMaterials(current_selection.alt);
		}
	}
});
