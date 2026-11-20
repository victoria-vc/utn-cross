import jugador.*
import niveles.*
import musica.*

class Visual {
    var property position
    var property image

    method afectarJugador(unJugador){}
}

object iconoMusica {
    var property position = game.at(18, 0) 

    method z() = 99 // para que este encima de TODO

    method image() {
        if (musica.estaMuteado()) {
            return "interfaz/musicaOFF.png" 
        } else {
            return "interfaz/musicaON.png"  
        }
    }
}

object flechaMenu inherits Visual(position = game.at(3, 5), image = "menu/flecha.png") {
    method moverArriba() { position = game.at(3, 5) }
    method moverAbajo() { position = game.at(3, 3) }
}

object meta inherits Visual(position = game.at(9, 13), image = "interfaz/meta.png") {
}

object iconoPausa inherits Visual(position = game.at(18, 1), image = "interfaz/iconoPausa.png") {
}

object iconoEnter inherits Visual(position = game.at(18, 1), image = "interfaz/iconoEnter.png") {
}

object iconoAbajo inherits Visual(position = game.at(18, 2), image = "interfaz/iconoAbajo.png") {
}

object iconoArriba inherits Visual(position = game.at(18, 3), image = "interfaz/iconoArriba.png") {
}

class NivelCartel{
    var property nivel
    var property position
    method image() = "nivel/nivel" + nivel.toString() + ".png"
}

class Corazon {
    const indice
    var property position
    method image() = if (jugador.vidas() > indice) "interfaz/corazon.png" else "transparente.png"
}


