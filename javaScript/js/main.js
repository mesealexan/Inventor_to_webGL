var background = document.getElementById("background"); 
var width = window.innerWidth, height = window.innerHeight;
aspectRatio = width / height;

var raycaster = new THREE.Raycaster();
var mouse = new THREE.Vector2();



function Init(folder) {
	if(!webgl_detect()) return;	
	scene = new THREE.Scene();
	addRenderer();
	addCamera();
	addControls();
	path = "assets/" + folder + "/";
	console.log("Loading: " + path + "parts.JSON")
	thumb = parseJSON(path + "parts.JSON");
	collision_group = new THREE.Object3D();
	scene.add(collision_group);
	makeTextureCube();
	loadObjects(thumb, path);
	placeText(thumb);
	addLight();
	detectOrientationChange();
	animate();
	
}

function addRenderer() {
	container = document.getElementById( 'webGL' );	
	renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
	renderer.setClearColor( 0xffffff, 0);
	renderer.shadowMapEnabled = true;
	renderer.shadowMapType = THREE.PCFShadowMap;
	renderer.setSize( width, height ); 
	renderer.shadowMapCullFace = THREE.CullFaceBack;
	container.appendChild( renderer.domElement );
}

function addLight () {
	var ambientLight = new THREE.AmbientLight( 0xffffff );
	scene.add( ambientLight );

	var spotLight = new THREE.SpotLight( 0xffffff );
	spotLight.position.set( -90,420,170 );
	spotLight.intensity = 0.2;

	spotLight.castShadow = true;
	spotLight.angle = Math.PI/2;
	spotLight.shadowMapWidth = 1024;
	spotLight.shadowMapHeight = 1024;
	spotLight.shadowCameraNear = 100;
	spotLight.shadowCameraFar = 600;
	spotLight.shadowCameraFov = 35;
	spotLight.shadowBias = -0.001;
	scene.add( spotLight );

	var spotLight2 = new THREE.SpotLight( 0xffffff );
	spotLight2.position.set( -235, 297, 183 );
	spotLight2.intensity = 0.2;
	scene.add( spotLight2 );

	var spotLight3 = new THREE.SpotLight( 0xffffff );
	spotLight3.position.set( 247, 132, 263 );
	spotLight3.intensity = 0.2;
	scene.add( spotLight3 );
}

function addCamera () {	
	//detect initial orientation
	if (window.matchMedia("(orientation: portrait)").matches) 
		{}
	else 
		{}

	camera = new THREE.PerspectiveCamera( fov, width / height, camNear, camFar ); 
	camera.position.set(40, 105, 260);
	camera.lookAt(new THREE.Vector3(0,45,0));
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
