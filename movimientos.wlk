import jugador.*
import enemigos.*
import pausa.*


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
                jugador.position(jugador.position().up(jugador.velocidad()))
            }
        })

        keyboard.down().onPressDo({
            if (pausa.activa()) {
                pausa.bajar()
            } else {
                jugador.position(jugador.position().down(jugador.velocidad()))
            }
        })

        keyboard.left().onPressDo({
            if (!pausa.activa()) {
                jugador.position(jugador.position().left(jugador.velocidad()))
            }
        })

        keyboard.right().onPressDo({
            if (!pausa.activa()) {
                jugador.position(jugador.position().right(jugador.velocidad()))
            }
        })
    }
}