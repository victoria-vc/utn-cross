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

    method moverA(nuevaPosition) {
    if (direccion.puedeActuar()) {
        if (nuevaPosition.x() > position.x())
            direccion = derecha
        if (nuevaPosition.x() < position.x())
            direccion = izquierda
        if (nuevaPosition.y() > position.y())
            direccion = arriba
        if (nuevaPosition.y() < position.y())
            direccion = abajo

        direccion.mover()
    }
}

    method reiniciarPosicion(){
        position = game.at(10, 0)
    }

    method reiniciar() {
    vidas = 3
    escudoJugador = sinEscudo
    velocidad = 1
    direccion = derecha
    self.reiniciarPosicion()
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

    method perdio() = vidas < 1 

    method perderVida() {
    if (direccion.puedeActuar()) {
        escudoJugador.perderVida(self)
        if (self.perdio()) {
            juego.perder()
        }
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

    method agarrarItem(){
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

object derecha {
    method image() = "jugador/jugador_derecha.png"
    method puedeActuar() = true
    method mover() {
        jugador.velocidad().times({ i => 
            if(mapa.puedeCaminar(jugador.position().right(1))){
                jugador.position(jugador.position().right(1))
            }
        })
    }
}

object izquierda {
    method image() = "jugador/jugador_izquierda.png"
    method puedeActuar() = true
    method mover() {
        jugador.velocidad().times({ i =>
            if(mapa.puedeCaminar(jugador.position().left(1))){
                jugador.position(jugador.position().left(1))
            }
        })
    }
}

object arriba {
    method image() = "jugador/jugador_arriba.png"
    method puedeActuar() = true
    method mover() {
        jugador.velocidad().times({ i =>
            if(mapa.puedeCaminar(jugador.position().up(1))){
                jugador.position(jugador.position().up(1))
            }
        })
    }
}

object abajo {
    method image() = "jugador/jugador_abajo.png"
    method puedeActuar() = true
    method mover() {
        jugador.velocidad().times({ i =>
            if(mapa.puedeCaminar(jugador.position().down(1))){
                jugador.position(jugador.position().down(1))
            }
        })
    }
}

object destrozado {
    method image() = "jugador/jugador_destrozado.png" 
    method mover() {} 
    method puedeActuar() = false
}