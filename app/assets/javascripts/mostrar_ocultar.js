    function mostrar(elem_id,botton) {
        var miDiv, mostrar;
        miDiv = document.getElementById(elem_id);
        if(miDiv.style.display == "none") {
            miDiv.style.display = "block";
            document.getElementById(botton).src = "/images/iconos/flecha_arriba.png";
        }
        else {
            miDiv.style.display = "none";
            document.getElementById(botton).src = "/images/iconos/flecha_abajo.png";
        }
    }