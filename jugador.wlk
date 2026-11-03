import niveles.*
import sonidos.*
import juego.*

object jugador {
    var property position = game.at(10, 0)
    var direccion = "derecha"
    var property vidas = 3 
    var property tieneEscudo = false
    var property velocidad = 1

    method image() {
        var asset
        if (direccion == "derecha")
            asset = "derecha.png" 
        if (direccion == "izquierda")
            asset = "izquierda.png"
        if (direccion == "arriba")
            asset = "arriba.png"
        if (direccion == "abajo")
            asset = "abajo.png"
        return asset
    }

    method position(nuevaPosition) {
        const temp = position
        if ( self.estaEnGrilla(nuevaPosition)){
            if (nuevaPosition.x() > position.x())
                direccion = "derecha"

            if (nuevaPosition.x() < position.x())
                direccion = "izquierda"
            
            if (nuevaPosition.y() > position.y())
                direccion = "arriba"

            if (nuevaPosition.y() < position.y())
                direccion = "abajo"

            position = nuevaPosition

            sonidos.moverPersonaje()
        }else{
            position = temp
        }
    }

    method reiniciarPosicion(){
        position = game.at(10, 0)
    }

    method estaEnFacultad() = self.position().y() == game.height() - 1


    method estaEnGrilla(pos) = pos.x() >= 0 and pos.x() <= game.width() - 1 and pos.y() >= 0 and pos.y() <= game.height() - 1

    method activarEscudo(tiempo){
        tieneEscudo = true
        game.schedule(tiempo, { tieneEscudo = false })
    }

    method perdio() = vidas < 1 

    method perderVida() {
        if (!tieneEscudo) {
            vidas -= 1
            sonidos.choque()
            self.reiniciarPosicion()
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

    method esJugador() = true

}