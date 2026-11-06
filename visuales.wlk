import jugador.*
import niveles.*

class Visual {
    var property position
    var property image

    method afectarJugador(unJugador){}
}

object flechaMenu inherits Visual(position = game.at(2, 5), image = "menu/flecha.png") {
    method moverArriba() { position = game.at(2, 5) }
    method moverAbajo() { position = game.at(2, 3) }
}

object marcadorVidas {
    var property position = game.at(1, 13)
    method text() = "Vidas: " + jugador.vidas()
    method textColor() = "FFFFFF"
}

class NivelCartel{
    var property nivel
    var property position
    method image() = "nivel" + nivel.toString() + ".png"
}

object cartelPerdiste inherits Visual(position = game.at(7, 7), image = "transparente.png") {
    // Falta imagen para el cartel
    method text() = "PERDISTE"
    method textColor() = "FF0000"
}

class Corazon {
    const indice
    var property position
    method image() = if (jugador.vidas() > indice) "corazon.png" else "transparente.png"
}

