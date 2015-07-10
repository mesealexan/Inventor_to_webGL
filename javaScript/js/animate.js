function animate(time) {
	frameID = requestAnimationFrame(animate);
	renderer.render(scene, camera);
	TWEEN.update(time);	
} 