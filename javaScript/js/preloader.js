var imagesArray = [];
	imagesArray.push("assets/plane.jpg");
	imagesArray.push("assets/materials/aura.jpg");
	imagesArray.push("assets/materials/fire_red.jpg");
	imagesArray.push("assets/materials/indian_impala.jpg");
	imagesArray.push("assets/materials/kashmir_gold.jpg");
	imagesArray.push("assets/materials/labrador_blue.jpg");
	imagesArray.push("assets/materials/mp_white.jpg");
	imagesArray.push("assets/materials/nero_impala.jpg");
	imagesArray.push("assets/materials/olive_green.jpg");
	imagesArray.push("assets/materials/orion.jpg");
	imagesArray.push("assets/materials/silver_paradise.jpg");
	imagesArray.push("assets/materials/twilight_red.jpg");
	imagesArray.push("assets/materials/vanga.jpg");
	imagesArray.push("assets/materials/virginia_black.jpg");
	imagesArray.push("img/drag.png");
	

	for(var i = 0, l = imagesArray.length; i < l; i++){
		var img = new Image();
			img.src = imagesArray[i];
	}

function parseJSON(file) {
	var request = new XMLHttpRequest();
   		request.open("GET", file, false);
   		request.send(null);
   	return JSON.parse(request.responseText);
}