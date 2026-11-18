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
                if (!filasCalle.isEmpty() and 0.randomUpTo(1) < probabilidadEnemigos) {
                    const calle = filasCalle.anyOne()
                    
                    const ladoRandom = 0.randomUpTo(1)
                    const lado = if (ladoRandom > 0.5) 0 else game.width()
                    const direccion = if (ladoRandom > 0.5) 1 else -1


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

		// Filas de pasto donde pueden aparecer Powerups
		const filasPastoValidasPU = filasPasto.filter({ y => y > 1 and y < game.height() - 1 })

		// Powerups + Items al azar
		if (!filasPastoValidasPU.isEmpty()) {
			game.addVisual(new Mate(position = game.at((1 .. game.width() - 2).anyOne(), filasPastoValidasPU.anyOne())))
			game.addVisual(new Escudo(position = game.at((1 .. game.width() - 2).anyOne(), filasPastoValidasPU.anyOne())))
			game.addVisual(new Monster(position = game.at((1 .. game.width() - 2).anyOne(),filasPastoValidasPU.anyOne())))
			game.addVisual(new Lapiz(position = game.at((1 .. game.width() - 2).anyOne(),filasPastoValidasPU.anyOne())))
			game.addVisual(new Calculadora(position = game.at((1 .. game.width() - 2).anyOne(),filasPastoValidasPU.anyOne())))
			game.addVisual(new Regla(position = game.at((1 .. game.width() - 2).anyOne(),filasPastoValidasPU.anyOne())))
		}
	
	}
	
	method pasarDeNivel() {
		if(mapa.ganoElNivel(jugador)){
			jugador.reiniciarPosicion()
			niveles.pasarNivel()
		}
	}

}

object niveles{

	var property nivelActual = 0

	const nivel1 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 400, probabilidadEnemigos = 1, generadorEnemigos = [autoFactory], nivelActual = 1)
	const nivel2 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 400, probabilidadEnemigos = 1, generadorEnemigos = [colectivoFactory], nivelActual = 2)
	const nivel3 = new Nivel(imagenCamino = "piso/via.png", ticksGeneracion = 1300, probabilidadEnemigos = 0.8, generadorEnemigos = [trenFactory, premetroFactory], nivelActual = 3)
	const nivel4 = new Nivel(imagenCamino = "piso/calle.png", ticksGeneracion = 1000, probabilidadEnemigos = 0.7, generadorEnemigos = [autoFactory, colectivoFactory], nivelActual = 4)

	var property nivelesCreados = [cinematicaInicio, nivel1, nivel2, nivel3, nivel4, cinematicaFinal]


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

