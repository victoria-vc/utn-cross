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
                self.intentarMover(jugador, jugador.position().up(jugador.velocidad()))
            }
        })

        keyboard.down().onPressDo({
            if (pausa.activa()) {
                pausa.bajar()
            } else {
                self.intentarMover(jugador, jugador.position().down(jugador.velocidad()))
            }
        })

        keyboard.left().onPressDo({
            if (!pausa.activa()) {
                self.intentarMover(jugador, jugador.position().left(jugador.velocidad()))
            }
        })

        keyboard.right().onPressDo({
            if (!pausa.activa()) {
                self.intentarMover(jugador, jugador.position().right(jugador.velocidad()))
            }
        })
    }

    method intentarMover(jugador, nuevaPos) {
        if (mapa.puedeCaminar(nuevaPos)) {
            jugador.position(nuevaPos)
        }
    }
}