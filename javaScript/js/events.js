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
