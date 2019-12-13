<script>
function get_wall() {
console.log("Function called");
var wall = document.getElementById("my_wall");
var thisrequest = new XMLHttpRequest();
thisrequest.onreadystatechange = function() {
    if(this.readyState == 4) {
        if(this.status == 200) {
            console.log("Got response");
            var list = document.createElement("ul")
            wall.appendChild(list)
            var response = JSON.parse(this.responseText);
          	response = response.reverse();
            for(var i = 0; i < response.length; i++) {
                var item = document.createElement("li");
                item.innerHTML = response[i];
                list.appendChild(item);
            }
        }
        else {console.log(this.status);};
    }
}
thisrequest.open("GET", "https://rivertonlocalfoodhub.herokuapp.com");
thisrequest.send();
}

document.addEventListener('DOMContentLoaded', get_wall);
window.addEventListener('mercury:load', get_wall);</script>