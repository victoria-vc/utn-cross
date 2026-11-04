import niveles.*
import sonidos.*
import juego.*
import mapa.*
import powerups.*

object jugador {
    var property position = game.at(10, 0)
    var direccion = derecha
    var property vidas = 3 
    var property escudoJugador = sinEscudo
    var property velocidad = 1

    method image() = direccion.image()

    method position(nuevaPosition) {
        const temp = position
        if ( mapa.estaEnGrilla(nuevaPosition)){
            if (nuevaPosition.x() > position.x())
                direccion = derecha

            if (nuevaPosition.x() < position.x())
                direccion = izquierda
            
            if (nuevaPosition.y() > position.y())
                direccion = arriba

            if (nuevaPosition.y() < position.y())
                direccion = abajo

            position = nuevaPosition
            sonidos.moverPersonaje()
        }else{
            position = temp
        }
    }

    method reiniciarPosicion(){
        position = game.at(10, 0)
    }

    method activarEscudo(tiempo){
        escudoJugador = escudo
        game.schedule(tiempo, { self.sacarEscudo() })
    }

    method sacarEscudo(){
        escudoJugador = sinEscudo
    }

    method sacarVida(){
        vidas -= 1
    }

    method perdio() = vidas < 1 // sonido de game over

    method perderVida() {
        escudoJugador.perderVida(self)
        if (self.perdio()) {
            juego.perder()
        }
    }

    method sumarVida(){
        vidas += 1
        sonidos.ganarVida()
    }

    method activarVelocidad() {
    velocidad = 2
    game.schedule(5000, {
        velocidad = 1
    })
    }


}

object derecha{
    method image() = "jugador/jugador_derecha.png"
}

object izquierda{
    method image() = "jugador/jugador_izquierda.png"

}
object arriba{
    method image() = "jugador/jugador_arriba.png"

}
object abajo{
    method image() = "jugador/jugador_abajo.png"

}