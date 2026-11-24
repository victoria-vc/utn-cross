import wollok.game.*
import jugador.*
import pausa.*
import mapa.*

object movimientos {
    method configControles(jugador) {
        keyboard.control().onPressDo({
            pausa.alternar()
        })

        keyboard.enter().onPressDo({
            if (pausa.activa()) {
                pausa.confirmar()
            }
        })

        keyboard.up().onPressDo({
            if (pausa.activa()) {
                pausa.subir()
            } else {
                jugador.mover(arriba)
            }
        })

        keyboard.down().onPressDo({
            if (pausa.activa()) {
                pausa.bajar()
            } else {
                jugador.mover(abajo)
            }
        })

        keyboard.left().onPressDo({
            if (!pausa.activa()) {
                jugador.mover(izquierda)
            }
        })

        keyboard.right().onPressDo({
            if (!pausa.activa()) {
                jugador.mover(derecha)
            }
        })
    }
}

class Direccion {
    method image()
    method puedeActuar() = true
    method siguientePosicion(pos)

   method mover(personaje) {
        personaje.velocidad().times({ i =>
            const siguiente = self.siguientePosicion(personaje.position())
            if (mapa.puedeCaminar(siguiente)) {
                personaje.position(siguiente)
            }
        })
    }
}

object derecha inherits Direccion {
    override method image() = "jugador/jugador_derecha.png"
    override method siguientePosicion(pos) = pos.right(1)
}

object izquierda inherits Direccion {
    override method image() = "jugador/jugador_izquierda.png"
    override method siguientePosicion(pos) = pos.left(1)
}

object arriba inherits Direccion {
    override method image() = "jugador/jugador_arriba.png"
    override method siguientePosicion(pos) = pos.up(1)
}

object abajo inherits Direccion {
    override method image() = "jugador/jugador_abajo.png"
    override method siguientePosicion(pos) = pos.down(1)
}