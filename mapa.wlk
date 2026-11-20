import wollok.game.*
import jugador.*
import enemigos.*
import movimientos.*
import fondos.*
import visuales.*
import powerups.*
import cinematicas.*
import obstaculos.*

object mapa {

    const obstaculos = []
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

    method ganoElNivel(unJugador) {
        return unJugador.position() == game.at(9, 13) or unJugador.position() == game.at(10, 13)
    }

    method enemigoSalioDeGrilla(unEnemigo) {
        return unEnemigo.position().x() < -5 or unEnemigo.position().x() > game.width() + 5
    }

    method hayObstaculoEn(unaPosicion) {
        return obstaculos.any({ obs => obs.position() == unaPosicion })
    }

    method puedeCaminar(unaPosicion) {
        return self.estaEnGrilla(unaPosicion) 
            and !self.esZonaUI(unaPosicion) 
            and !self.hayObstaculoEn(unaPosicion)
    }

    method generarObstaculosEnPasto(filasDePasto, cantidad) {
        self.limpiarObstaculos()

        cantidad.times({ i =>
            const pos = self.posicionRandomPasto(filasDePasto)
            if (self.esPosicionValidaParaObstaculo(pos)) {
                const nuevo = new Obstaculo(position = pos)
                obstaculos.add(nuevo)
                nuevo.agregarAlJuego()
            }
        })
    }

    method posicionRandomPasto(filasDePasto) {
        const y = filasDePasto.anyOne()
        const x = if (1.randomUpTo(10) <= 7) {
            (7..12).anyOne()
        } else {
            (1..18).anyOne()
        }
        return game.at(x, y)
    }

    method esPosicionValidaParaObstaculo(pos) {
        const esSpawn = pos == game.at(10, 0)
        const esMeta = pos == game.at(9, 13) or pos == game.at(10, 13)
        return !esSpawn and !esMeta and !self.esZonaUI(pos) and !self.hayObstaculoEn(pos)
    }

    method limpiarObstaculos() {
        obstaculos.forEach({ obs => 
            if (game.hasVisual(obs)) {
                obs.sacarDelJuego()
            }
        })
        obstaculos.clear()
    }

}