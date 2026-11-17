import jugador.*
import sonidos.*
import niveles.*
import puntaje.*
import wollok.game.*

class PowerUp {
    var property position

    method image()
    method puntos()

    method afectarJugador(unJugador) {
        game.removeVisual(self)
        puntaje.sumarPuntos(self.puntos())
        self.aplicarEfecto(unJugador)
    }

    method aplicarEfecto(unJugador) {
        unJugador.agarrarItem()
    }
}

class Mate inherits PowerUp {
    override method image() = "powerups/mate.png"
    override method puntos() = 100

    override method aplicarEfecto(unJugador) {
        unJugador.sumarVida()
    }
}

class Escudo inherits PowerUp {
    var property tiempoMs = 6000
    override method image() = "powerups/escudo.png"
    override method puntos() = 150

    override method aplicarEfecto(unJugador) {
        unJugador.activarEscudo(tiempoMs)
        sonidos.escudo()
    }
}

class Monster inherits PowerUp {
    override method image() = "powerups/monster.png"
    override method puntos() = 150

    override method aplicarEfecto(unJugador) {
        unJugador.activarVelocidad()
        sonidos.velocidad()
    }
}

class Lapiz inherits PowerUp {
    override method image() = "powerups/lapiz.png"
    override method puntos() = 200

    override method aplicarEfecto(unJugador) {
        unJugador.agarrarItem()
    }
}

class Regla inherits PowerUp {
    override method image() = "powerups/regla.png"
    override method puntos() = 600
}

class Calculadora inherits PowerUp {
    override method image() = "powerups/calculadora.png"
    override method puntos() = 1000
}
object escudo{
    method perderVida(unJugador){
        unJugador.sacarEscudo()
    }
}

object sinEscudo{
    method perderVida(unJugador){
        console.println("perder vida")
        jugador.reiniciarPosicion()
        unJugador.sacarVida()
        sonidos.choque()
    }
}



