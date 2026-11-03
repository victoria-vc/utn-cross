import jugador.*
import niveles.*
import sonidos.*


class PowerUp {
    var property position

    method image()
    
    method afectarJugador(unJugador)  {
        game.removeVisual(self)
    }

    method initialize() {
        game.onCollideDo(self, { personaje => 
            if(personaje.esJugador()) {
                self.afectarJugador(personaje)
            }
        })
    }

    method esJugador() = false
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
        sonidos.escudo()
    }
}

class Monster inherits PowerUp {
    override method image() = "powerups/monster.png"

    override method afectarJugador(unJugador) {
        super(unJugador)
         unJugador.activarVelocidad()
         sonidos.velocidad()
    }
}