var background = document.getElementById("background"); 
var width = window.innerWidth, height = window.innerHeight;
aspectRatio = width / height;

var raycaster = new THREE.Raycaster();
var mouse = new THREE.Vector2();

Init();

function Init() {
	if(!webgl_detect()) return;	
	scene = new THREE.Scene();
	addRenderer();
	addCamera();
	addControls();	
	makeTextureCube();
	loadObjects(thumb);
	collision_group = new THREE.Object3D();
	scene.add(collision_group)
	addLight();
	detectOrientationChange();
	animate();

}

function addRenderer() {
	container = document.getElementById( 'webGL' );	
	renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
	renderer.setClearColor( 0xffffff, 0);
	renderer.shadowMapEnabled = true;
	renderer.shadowMapType = THREE.PCFSoftShadowMap;
	renderer.setSize( width, height ); 
	container.appendChild( renderer.domElement );
}

function addLight () {
	var ambientLight = new THREE.AmbientLight( 0xffffff );
	scene.add( ambientLight );

	var spotLight = new THREE.SpotLight( 0xffffff );
	spotLight.position.set( -350, 1611, 300 );
	spotLight.intensity = 0.2;

	spotLight.castShadow = true;
	spotLight.angle = Math.PI/2;
	spotLight.shadowMapWidth = 2048;
	spotLight.shadowMapHeight = 2048;
	spotLight.shadowCameraNear = 500;
	spotLight.shadowCameraFar = 4000;
	spotLight.shadowCameraFov = 10;

	scene.add( spotLight );
}

function addCamera () {	
	//detect initial orientation
	if (window.matchMedia("(orientation: portrait)").matches) 
		{}
	else 
		{}

	camera = new THREE.PerspectiveCamera( fov, width / height, camNear, camFar ); 
	camera.position.set(40, 105, 260);
	camera.lookAt(new THREE.Vector3(0,35,0));
	scene.add( camera );
	new THREEx.WindowResize(renderer, camera);
}

function detectOrientationChange () {
	$(window).on("orientationchange", function(){		
		aspectRatio = width / height;
		
		if(window.orientation == 0){}// Portrait
		else {} // Landscape			
	});
}

function addTestCube () {
	var geometry = new THREE.BoxGeometry( 25, 25, 25 );
	var material = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
	var cube = new THREE.Mesh( geometry, material );
	cube.position.set(0,50,0);
	cube.castShadow = true;
	cube.receiveShadow = true;
	scene.add( cube );
}
