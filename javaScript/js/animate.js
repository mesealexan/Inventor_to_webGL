function animate(time) {

	frameID = requestAnimationFrame(animate);
	if(imagesArray.length === 28){
		renderer.render(scene, camera);
		TWEEN.update(time);			
	}

} 