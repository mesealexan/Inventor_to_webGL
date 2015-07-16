var imagesArray = [];
	imagesArray.push("assets/plane.jpg");
	imagesArray.push("assets/materials/aura.jpg");
	imagesArray.push("assets/materials/fire red.jpg");
	imagesArray.push("assets/materials/indian impala.jpg");
	imagesArray.push("assets/materials/kashmir gold.jpg");
	imagesArray.push("assets/materials/labrador blue pearl.jpg");
	imagesArray.push("assets/materials/mp white.jpg");
	imagesArray.push("assets/materials/nero impala.jpg");
	imagesArray.push("assets/materials/olive green.jpg");
	imagesArray.push("assets/materials/orion.jpg");
	imagesArray.push("assets/materials/silver paradiso.jpg");
	imagesArray.push("assets/materials/twilight red.jpg");
	imagesArray.push("assets/materials/vanga.jpg");
	imagesArray.push("assets/materials/virginia black.jpg");
	imagesArray.push("img/drag.png");

	imagesArray.push("img/aura.png");
	imagesArray.push("img/fire_red.png");
	imagesArray.push("img/indian_impala.png");
	imagesArray.push("img/kashmir_gold.png");
	imagesArray.push("img/labradorblue.png");
	imagesArray.push("img/mp_white.png");
	imagesArray.push("img/nero_impala.png");
	imagesArray.push("img/olive_green.png");
	imagesArray.push("img/orion.png");
	imagesArray.push("img/silver_paradise.png");
	imagesArray.push("img/twilight_red.png");
	imagesArray.push("img/vanga.png");
	imagesArray.push("img/virginia_black.png");
	
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