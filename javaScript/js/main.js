var background = document.getElementById("background"); 
var width = window.innerWidth, height = window.innerHeight;
aspectRatio = width / height;

Init();

function Init() {
	if(!webgl_detect()) return;	
	scene = new THREE.Scene();
	addRenderer();
	addCamera();
	addControls();	
	addLight();
	detectOrientationChange();
	animate();
}

function addRenderer() {
	container = document.getElementById( 'webGL' );	
	renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
	renderer.setClearColor( 0x000000, 0);
	renderer.setSize( width, height ); 
	container.appendChild( renderer.domElement );
}

function addLight () {
	var ambientLight = new THREE.AmbientLight( 0x999999 );
	scene.add( ambientLight );
}

function addCamera () {	
	//detect initial orientation
	if (window.matchMedia("(orientation: portrait)").matches) 
		{}
	else 
		{}

	camera = new THREE.PerspectiveCamera( fov, width / height, camNear, camFar ); 
	camera.position.set(0, 10, 15);
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
	var geometry = new THREE.BoxGeometry( 5, 5, 5 );
	var material = new THREE.MeshBasicMaterial( {color: 0x00ff00} );
	var cube = new THREE.Mesh( geometry, material );
	scene.add( cube );
}
