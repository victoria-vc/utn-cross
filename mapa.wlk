import wollok.game.*
import jugador.*
import enemigos.*
import movimientos.*
import fondos.*
import visuales.*
import powerups.*
import cinematicas.*

object mapa {

    method estaEnGrilla(unaPosicion) {
        return unaPosicion.x().between(0, game.width() - 1) and unaPosicion.y().between(0, game.height() - 1)
    }

    method esZonaUI(unaPosicion) {
        const esCartelNivel = unaPosicion.y() == 0 and unaPosicion.x().between(0, 5)
        const esZonaVidas = unaPosicion.y() == 13 and unaPosicion.x().between(0, 2)
        const esZonaPuntaje = unaPosicion.y() == 13 and unaPosicion.x().between(16, 19)
        const esIconoMute = unaPosicion.y() == 0 and unaPosicion.x().between(18, 19)
        const esIconoPausa = unaPosicion.y() == 1 and unaPosicion.x().between(18, 19)

        return esCartelNivel or esZonaVidas or esZonaPuntaje or esIconoMute or esIconoPausa
    }

    method puedeCaminar(unaPosicion) {
        return self.estaEnGrilla(unaPosicion) and !self.esZonaUI(unaPosicion)
    }

    method ganoElNivel(unJugador) {
        return unJugador.position() == game.at(9, 13) or unJugador.position() == game.at(10, 13)
    }

    method enemigoSalioDeGrilla(unEnemigo) {
        return unEnemigo.position().x() < -5 or unEnemigo.position().x() > game.width() + 5
    }
}