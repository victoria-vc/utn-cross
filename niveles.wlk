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


object generadorDeNivel {

    method generarFilas() {
        const filas = []
        var calleSeguidas = 0
        var pastoSeguidas = 0

        (0 .. game.height() - 1).forEach({ y =>
            const esBorde = y == 0 or y == game.height() - 1
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
		game.addVisual(new Visual(position = game.at(19, 13), image = "flechaRoja.png"))
		game.addVisual(iconoMusica)
        musica.bajarVolumenParaNivel()
        
        // Reactivamos la M porque el game.clear() del nivel lo borra
        keyboard.m().onPressDo({ 
            musica.alternarMute() 
        })
	}

	method empezar() {

		const filas = generadorDeNivel.generarFilas();

		(0 .. filas.size() - 1).forEach({ y =>
			const esCalle = filas.get(y)
			
			if (esCalle) { 
				filasCalle.add(y)
				game.addVisual(new Visual(position = game.at(0, y), image = imagenCamino)) 
			} else { 
				filasPasto.add(y)
				game.addVisual(new Visual(position = game.at(0, y), image = "pasto.png")) 
			}
		})

		self.cargarVisuales()

		game.onTick(ticksGeneracion, "generar_enemigos", {

			if (!filasCalle.isEmpty() and 0.randomUpTo(1) < probabilidadEnemigos) {
				const calle = filasCalle.anyOne()
				
				const ladoRandom = 0.randomUpTo(1)
				const lado = if (ladoRandom > 0.5) 0 else game.width()
				const direccion = if (ladoRandom > 0.5) 1 else -1

				const nuevoEnemigo = generadorEnemigos.anyOne().generarEnemigo(game.at(lado, calle), direccion)
				enemigos.add(nuevoEnemigo)
				nuevoEnemigo.agregarAlJuego()
			}
		})

		game.onTick(100, "sacar_enemigos", { //saco de la visual y la lista los enemigos que estan fuera de la grilla
			const autosAfuera = enemigos.filter({enemigo => mapa.enemigoSalioDeGrilla(enemigo)})
			autosAfuera.forEach({enemigo => enemigo.sacarDelJuego()})
			enemigos.removeAll(autosAfuera)
		})

		game.onTick(50, "movimiento_enemigos", {
			enemigos.forEach({enemigo => enemigo.mover()})
		})

		game.onTick(1000, "check_gano", {
			self.pasarDeNivel()
		})

		game.onCollideDo(jugador, { elemento =>
    		elemento.afectarJugador(jugador)
		})

		// Filas de pasto donde pueden aparecer Powerups
		const filasPastoValidasPU = filasPasto.filter({ y => y > 0 and y < game.height() - 1 })

		// MATE, ESCUDO y MONSTER al azar
		if (!filasPastoValidasPU.isEmpty()) {
			game.addVisual(new Mate(position = game.at((1 .. game.width() - 2).anyOne(), filasPastoValidasPU.anyOne())))
			game.addVisual(new Escudo(position = game.at((1 .. game.width() - 2).anyOne(), filasPastoValidasPU.anyOne())))
			game.addVisual(new Monster(position = game.at((1 .. game.width() - 2).anyOne(),filasPastoValidasPU.anyOne())))
		}
	
	}
	
	method pasarDeNivel() {
		//jugador.puedePasarDeNivel()
		if(mapa.ganoElNivel(jugador)){
			jugador.reiniciarPosicion()
			niveles.pasarNivel()
		}
	}

}

object niveles{

	var property nivelActual = 0

	const nivel1 = new Nivel(imagenCamino = "calle.png", ticksGeneracion = 1500, probabilidadEnemigos = 0.3, generadorEnemigos = [autoFactory], nivelActual = 1)
	const nivel2 = new Nivel(imagenCamino = "calle.png", ticksGeneracion = 1200, probabilidadEnemigos = 0.4, generadorEnemigos = [colectivoFactory], nivelActual = 2)
	const nivel3 = new Nivel(imagenCamino = "via.png", ticksGeneracion = 2000, probabilidadEnemigos = 0.3, generadorEnemigos = [trenFactory, premetroFactory], nivelActual = 3)
	const nivel4 = new Nivel(imagenCamino = "calle.png", ticksGeneracion = 2000, probabilidadEnemigos = 0.3, generadorEnemigos = [manifestacionFactory, autoFactory], nivelActual = 4)

	var property nivelesCreados = [/*cinematicaInicio, */nivel1, nivel2, nivel3, nivel4]

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
			console.println("Ganaste")
		}
	}

}

