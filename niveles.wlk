//import juego.*
import jugador.*
import enemigos.*
import movimientos.*
import fondos.*
import visuales.*
import powerups.*
import cinematicas.*

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

	const creadorBloque = { pos => new Visual(position = pos, image = "calle.png") }

	method cargarVisuales(){
		game.addVisual(jugador)
        movimientos.configControles(jugador)
		(0 .. jugador.vidas()).forEach({ i => game.addVisual(new Corazon(indice = i, position = game.at(i, 13))) })
		game.addVisual(new NivelCartel(position = game.at(0, 0), nivel = nivelActual))
		game.addVisual(new Visual(position = game.at(19, 13), image = "flechaRoja.png"))
	}

	method empezar() {

		const filas = generadorDeNivel.generarFilas();

		(0 .. filas.size() - 1).forEach({ y =>
            const esCalle = filas.get(y)
			if (esCalle) { filasCalle.add(y) } else { filasPasto.add(y) }
            (0 .. game.width() - 1).forEach({ x =>
                if (esCalle) {
                    game.addVisual(creadorBloque.apply(game.at(x, y)))
                } else {
                    game.addVisual(new Visual(position = game.at(x, y), image = "pasto.png"))
                }
            })
		})

		self.cargarVisuales()

		game.onTick(ticksGeneracion, "generar_enemigos", {

			if (!filasCalle.isEmpty() and 0.randomUpTo(1) < probabilidadEnemigos) {
				const calle = filasCalle.anyOne()
				
				const ladoRandom = 0.randomUpTo(1)
				const lado = if (ladoRandom > 0.5) 0 else game.width()
				const direccion = if (ladoRandom > 0.5) 1 else -1

				const nuevoEnemigo = generadorEnemigos.apply(game.at(lado, calle), direccion)
				enemigos.add(nuevoEnemigo)
				nuevoEnemigo.agregarAlJuego()
			}
		})

		game.onTick(100, "sacar_enemigos", { //saco de la visual y la lista los enemigos que estan fuera de la grilla
			const autosAfuera = enemigos.filter({enemigo => enemigo.estaAfuera()})
			autosAfuera.forEach({enemigo => enemigo.sacarDelJuego()})
			enemigos.removeAll(autosAfuera)
		})

		game.onTick(50, "movimiento_enemigos", {
			enemigos.forEach({enemigo => enemigo.mover()})
		})

		game.onTick(1000, "check_gano", {
			self.pasarDeNivel()
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
		if(jugador.estaEnFacultad()){
			jugador.reiniciarPosicion()
			niveles.pasarNivel()
		}
	}

}

object niveles{

	var property nivelActual = 0

	const nivel1 = new Nivel(ticksGeneracion = 1500, probabilidadEnemigos = 0.3, generadorEnemigos = { pos, dir => generadorEnemigos.generarAuto(pos, dir) }, nivelActual = 1, creadorBloque = { pos => new Visual(position = pos, image = "calle.png") })

    const nivel2 = new Nivel(ticksGeneracion = 1200, probabilidadEnemigos = 0.4, generadorEnemigos = { pos, dir => generadorEnemigos.generarColectivo(pos, dir) }, nivelActual = 2, creadorBloque = { pos => new Visual(position = pos, image = "calle.png") })

	const nivel3 = new Nivel(ticksGeneracion = 2000, probabilidadEnemigos = 0.3, generadorEnemigos = { pos, dir => generadorEnemigos.generarAuto(pos, dir) }, nivelActual = 3, creadorBloque = { pos => new Visual(position = pos, image = "via.png") })

	var property nivelesCreados = [cinematicaInicio, nivel1, nivel2, nivel3]

	method empezar(){
		nivelesCreados.get(0).empezar()
	}

	method pasarNivel(){
		nivelActual += 1
		game.clear()
		if(nivelActual < nivelesCreados.size()){
			nivelesCreados.get(nivelActual).empezar()
		}else{
			console.println("Ganaste")
		}
	}

}

