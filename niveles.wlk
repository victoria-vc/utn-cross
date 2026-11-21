import juego.*
import jugador.*
import enemigos.*
import movimientos.*
import fondos.*
import visuales.*
import powerups.*
import cinematicas.*
import mapa.*
import sonidos.*
import musica.*
import puntaje.*
import pausa.*
import obstaculos.*


object generadorDeNivel {

    method generarFilas() {
        const filas = []
        var calleSeguidas = 0
        var pastoSeguidas = 0

        (0 .. game.height() - 1).forEach({ y =>
            const esBorde = y <= 1 or y == game.height() - 1
            var esCalle = false

            if (!esBorde) {
                if (calleSeguidas >= 2) {
                    esCalle = false
                } else if (pastoSeguidas >= 2) {
                    esCalle = true
                } else {
                    esCalle = 0.randomUpTo(1) > 0.5
                }
            }

            if (esCalle) {
                calleSeguidas += 1
                pastoSeguidas = 0
            } else {
                pastoSeguidas += 1
                calleSeguidas = 0
            }

            filas.add(esCalle)
        })
        return filas   // lista de booleanos: true = calle, false = pasto

    }

}
class Nivel {
	const filasPasto = []
	const filasCalle = []
	const enemigos = []
	const nivelActual

	const generadorEnemigos
	const property ticksGeneracion
	const property probabilidadEnemigos

	const maxEnemigos 
	const maxPorCalle
	const distanciaMinima

	const imagenCamino

	method cargarVisuales(){
		game.addVisual(jugador)
        movimientos.configControles(jugador)
		(0 .. jugador.vidas()).forEach({ i => game.addVisual(new Corazon(indice = i, position = game.at(i, 13))) })
		game.addVisual(new NivelCartel(position = game.at(0, 0), nivel = nivelActual))
		puntaje.mostrarEn(16, 13)
		game.addVisual(iconoMusica)
		game.addVisual(meta)
		game.addVisual(iconoPausa)
        musica.bajarVolumenParaNivel()
        
        juego.cargarCosasGlobales()
	}
		method direccionDeCalle(calle) {
        return if (calle.even()) 1 else -1
    }

    method puedeGenerarEn(calle) {
        const enemigosEnCalle = enemigos.filter({ e => e.position().y() == calle })
        
        if (enemigosEnCalle.size() >= maxPorCalle) {
            return false
        }

        const direccion = self.direccionDeCalle(calle)
        return if (direccion == 1) {
            !enemigosEnCalle.any({ e => e.position().x() < distanciaMinima })
        } else {
            !enemigosEnCalle.any({ e => e.position().x() > game.width() - distanciaMinima })
        }
    }

	method empezar() {
        pausa.activa(false) 
        filasPasto.clear()
        filasCalle.clear()
        enemigos.clear()
        
        const filas = generadorDeNivel.generarFilas();

        (0 .. filas.size() - 1).forEach({ y =>
            const esCalle = filas.get(y)
            
            if (esCalle) { 
                filasCalle.add(y)
                game.addVisual(new Visual(position = game.at(0, y), image = imagenCamino)) 
            } else { 
                filasPasto.add(y)
                game.addVisual(new Visual(position = game.at(0, y), image = "piso/pasto.png")) 
            }
        })


        self.cargarVisuales()

        game.onTick(ticksGeneracion, "generar_enemigos", {
        if (!pausa.activa()) { 
            const callesLibres = filasCalle.filter({ c => self.puedeGenerarEn(c) })

            if (enemigos.size() < maxEnemigos and !callesLibres.isEmpty() and 
                0.randomUpTo(1) < probabilidadEnemigos) {
                
                const calle = callesLibres.anyOne()
                const direccion = self.direccionDeCalle(calle)
                const lado = if (direccion == 1) 0 else game.width()

                const nuevoEnemigo = generadorEnemigos.anyOne().generarEnemigo(game.at(lado, calle), direccion)
                enemigos.add(nuevoEnemigo)
                nuevoEnemigo.agregarAlJuego()
            }
        }
    })

        game.onTick(100, "sacar_enemigos", {
            const autosAfuera = enemigos.filter({enemigo => enemigo.salioDeGrilla()})
            autosAfuera.forEach({enemigo => enemigo.sacarDelJuego()})
            enemigos.removeAll(autosAfuera)
        })

        game.onTick(50, "movimiento_enemigos", {
            if (!pausa.activa()) { 
                enemigos.forEach({enemigo => enemigo.mover()})
            }
        })

		game.onTick(1000, "check_gano", {
			self.pasarDeNivel()
		})

		game.onCollideDo(jugador, { elemento =>
    		elemento.afectarJugador(jugador)
		})

		// Filas de pasto donde pueden aparecer Powerups y Obstáculos
		const filasPastoValidas = filasPasto.filter({ y => y > 1 and y < game.height() - 1 })
		const posicionesOcupadas = []

		if (!filasPastoValidas.isEmpty()) {
			mapa.generarObstaculosEnPasto(filasPastoValidas, 10)

			game.addVisual(new Mate(position = self.posicionLibre(filasPastoValidas, posicionesOcupadas)))
			game.addVisual(new Escudo(position = self.posicionLibre(filasPastoValidas, posicionesOcupadas)))
			game.addVisual(new Monster(position = self.posicionLibre(filasPastoValidas, posicionesOcupadas)))
			game.addVisual(new Lapiz(position = self.posicionLibre(filasPastoValidas, posicionesOcupadas)))
			game.addVisual(new Calculadora(position = self.posicionLibre(filasPastoValidas, posicionesOcupadas)))
			game.addVisual(new Regla(position = self.posicionLibre(filasPastoValidas, posicionesOcupadas)))
		}
	
	} 

	method posicionLibre(filasValidas, ocupadas) {
		const pos = game.at((1 .. game.width() - 2).anyOne(), filasValidas.anyOne())
		return if (ocupadas.contains(pos) or mapa.hayObstaculoEn(pos)) {
			self.posicionLibre(filasValidas, ocupadas)
		} else {
			ocupadas.add(pos)
			pos
		}
	}
	
	method pasarDeNivel() {
		if(mapa.ganoElNivel(jugador)){
			jugador.reiniciarPosicion()
			niveles.pasarNivel()
		}
	}
} 

object niveles {

	var property nivelActual = 0

	const nivel1 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 400, probabilidadEnemigos = 1, generadorEnemigos = [autoFactory], nivelActual = 1, maxEnemigos = 16, maxPorCalle = 6, distanciaMinima = 2)
	const nivel2 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 400, probabilidadEnemigos = 1, generadorEnemigos = [colectivoFactory], nivelActual = 2, maxEnemigos = 8, maxPorCalle = 4, distanciaMinima = 4)
	const nivel3 = new Nivel(imagenCamino = "piso/via.png", ticksGeneracion = 2500, probabilidadEnemigos = 0.6, generadorEnemigos = [trenFactory, premetroFactory], nivelActual = 3, maxEnemigos = 5, maxPorCalle = 2, distanciaMinima = 4)
	const nivel4 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 1000, probabilidadEnemigos = 0.7, generadorEnemigos = [autoFactory, colectivoFactory], nivelActual = 4, maxEnemigos = 8, maxPorCalle = 8, distanciaMinima = 3)
    const nivel5 = new Nivel(imagenCamino = "piso/via.png", ticksGeneracion = 2500, probabilidadEnemigos = 0.8, generadorEnemigos = [trenFactory], nivelActual = 5, maxEnemigos = 5, maxPorCalle = 4, distanciaMinima = 3)
    const nivel6 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 1000, probabilidadEnemigos = 0.7, generadorEnemigos = [autoFactory, colectivoFactory], nivelActual = 12, maxEnemigos = 14, maxPorCalle = 5, distanciaMinima = 3)

	var property nivelesCreados = [cinematicaInicio, nivel1, nivel2, nivel3, nivel4, nivel5, nivel6, cinematicaFinal]


	method empezar(){
		nivelesCreados.get(0).empezar()
	}

	method pasarNivel(){
		nivelActual += 1
		sonidos.pasarNivel()
		game.clear()
		if(nivelActual < nivelesCreados.size()){
			nivelesCreados.get(nivelActual).empezar()
		}else{
			cinematicaFinal.empezar()
			}
	}

	method reiniciar() {
		nivelActual = 0
	}

}

