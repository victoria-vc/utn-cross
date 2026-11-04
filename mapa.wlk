import jugador.*
import enemigos.*
import movimientos.*
import fondos.*
import visuales.*
import powerups.*
import cinematicas.*

object mapa{


    method estaEnGrilla(unaPosicion){
        return unaPosicion.x() >= 0 and unaPosicion.x() <= game.width() - 1 and unaPosicion.y() >= 0 and unaPosicion.y() <= game.height() - 1
    }

    method ganoElNivel(unJugador){
        return unJugador.position().y() == game.height() - 1
    }

    method enemigoSalioDeGrilla(unEnemigo){
        return unEnemigo.position().x() < -5 or unEnemigo.position().x() > game.width() + 5
    }
}