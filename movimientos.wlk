import jugador.*
import enemigos.*


object movimientos {
    method configControles(jugador) {
        keyboard.up().onPressDo({jugador.position(jugador.position().up(jugador.velocidad()))})

        keyboard.down().onPressDo({jugador.position(jugador.position().down(jugador.velocidad()))})

        keyboard.left().onPressDo({jugador.position(jugador.position().left(jugador.velocidad()))})

        keyboard.right().onPressDo({jugador.position(jugador.position().right(jugador.velocidad()))})}
    }

