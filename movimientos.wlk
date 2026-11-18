import wollok.game.*
import jugador.*
import enemigos.*
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
                jugador.moverA(jugador.position().up(1))
            }
        })

        keyboard.down().onPressDo({
            if (pausa.activa()) {
                pausa.bajar()
            } else {
                jugador.moverA(jugador.position().down(1))
            }
        })

        keyboard.left().onPressDo({
            if (!pausa.activa()) {
                jugador.moverA(jugador.position().left(1))
            }
        })

        keyboard.right().onPressDo({
            if (!pausa.activa()) {
                jugador.moverA(jugador.position().right(1))
            }
        })
    }

    method intentarMover(jugador, nuevaPos) {
        if (mapa.puedeCaminar(nuevaPos)) {
            jugador.position(nuevaPos)
        }
    }
}