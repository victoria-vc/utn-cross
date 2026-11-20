import wollok.game.*

class Obstaculo {
    var property position
    const property tipo = ["conos", "arbusto", "tronco"].anyOne() 

    method image() = "obstaculos/" + tipo + ".png"

    method agregarAlJuego() {
        game.addVisual(self)
    }

    method sacarDelJuego() {
        game.removeVisual(self)
    }

    method esSolido() = true

    method afectarJugador() {}
}