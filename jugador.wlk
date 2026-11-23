import niveles.*
import sonidos.*
import juego.*
import movimientos.*
import powerups.*

object jugador {
    var property position = game.at(10, 0)
    var direccion = derecha
    var property vidas = 3 
    var property escudoJugador = sinEscudo
    var property velocidad = 1

    method image() = direccion.image()

    method mover(nuevaDireccion) {
        if (direccion.puedeActuar()) {
            direccion = nuevaDireccion
            direccion.mover(self)
        }
    }

    method reiniciarPosicion() {
        position = game.at(10, 0)
    }

    method reiniciar() {
        vidas = 3
        escudoJugador = sinEscudo
        velocidad = 1
        direccion = derecha
        self.reiniciarPosicion()
    }

    method activarEscudo(tiempo) {
        escudoJugador = escudo
        game.schedule(tiempo, { self.sacarEscudo() })
    }

    method sacarEscudo() {
        escudoJugador = sinEscudo
    }

    method sacarVida() {
        vidas -= 1
    }

    method perdio() = vidas < 1 

    method perderVida() {
        if (direccion.puedeActuar()) {
            escudoJugador.perderVida(self)
            if (self.perdio()) {
                juego.perder()
            }
        }
    }

    method sumarVida() {
        vidas += 1
        sonidos.ganarVida()
    }

    method activarVelocidad() {
        velocidad = 2
        game.schedule(5000, {
            velocidad = 1
        })
    }

    method agarrarItem() {
        sonidos.itemPickup()
    }

    method mostrarChoque() {
        direccion = destrozado
        game.schedule(500, { 
            direccion = derecha
            self.reiniciarPosicion()
        })
    }
}

object destrozado {
    method image() = "jugador/jugador_destrozado.png" 
    method mover(personaje) {} 
    method puedeActuar() = false
}