
function addItem() {
  alert("bkd");
}
var addedDish = document.getElementsByClassName("glyphicon");
for(var i=0; i<addedDish.length; i++){
  addedDish[i].addEventListener("click", addItem);
}
