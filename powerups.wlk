import jugador.*
import niveles.*
import sonidos.*


class PowerUp {
    var property position

    method image()
    
    method afectarJugador(unJugador)  {
        game.removeVisual(self)
    }

}

class Mate inherits PowerUp {
    override method image() = "powerups/mate.png"

    override method afectarJugador(unJugador) {
        super(unJugador)
        unJugador.sumarVida()
    }
}

class Escudo inherits PowerUp {
    var property tiempoMs = 6000
    override method image() = "powerups/escudo.png"

    override method afectarJugador(unJugador) {
        super(unJugador)
        unJugador.activarEscudo(tiempoMs)
        sonidos.agarrarItem()
    }
}

class Monster inherits PowerUp {
    override method image() = "powerups/monster.png"

    override method afectarJugador(unJugador) {
        super(unJugador)
         unJugador.activarVelocidad()
    }
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