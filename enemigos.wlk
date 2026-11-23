import wollok.game.*
import jugador.*
import niveles.*
import mapa.*

class Enemigo {
    var property position
    var property direccion
    var property velocidad

    method salioDeGrilla() = mapa.enemigoSalioDeGrilla(self)

    method image()

    method afectarJugador(unJugador) = unJugador.perderVida()

    method mover() {
        position = position.right(direccion * velocidad)
    }

    method agregarAlJuego() {
        game.addVisual(self)
    }

    method sacarDelJuego() {
        game.removeVisual(self)
    }

    method estaAfuera() = self.position().x() < -5 or self.position().x() > game.width() + 5
}

class Auto inherits Enemigo {
    var property color
    override method image() = "enemigos/auto_" + color.toString() + ".png"
}

class ColaEnemigoLargo inherits Enemigo {
    const padre
    const indice

    override method image() = "enemigos/transparente.png"
    override method mover() {
        position = padre.posicionCelda(indice)
    }
}

class EnemigoLargo inherits Enemigo {
    const cola = []

    method cantidadCeldas()

    method initialize() {
        self.cantidadCeldas().times({ i =>
            cola.add(new ColaEnemigoLargo(
                padre = self,
                indice = i,
                position = self.posicionCelda(i),
                direccion = direccion,
                velocidad = velocidad
            ))
        })
    }

    method posicionCelda(indice) = if (direccion == 1) position.left(indice) else position.right(indice)

    override method mover() {
        super()
        cola.forEach({ celda => celda.mover() })
    }

    override method agregarAlJuego() {
        game.addVisual(self)
        cola.forEach({ celda => game.addVisual(celda) })
    }

    override method sacarDelJuego() {
        game.removeVisual(self)
        cola.forEach({ celda => game.removeVisual(celda) })
    }

    override method salioDeGrilla() {
        return if (direccion == 1)
            position.x() > game.width() + 5 and
            cola.all({ parte => parte.position().x() > game.width() + 5 })
        else
            position.x() < -5 and
            cola.all({ parte => parte.position().x() < -5 })
    }
}

class Colectivo inherits EnemigoLargo {
    const property linea

    override method cantidadCeldas() = 1
    override method image() = "enemigos/colectivo_" + linea.toString() + "_" + (if (direccion == 1) "derecha" else "izquierda") + ".png"
}

class Tren inherits EnemigoLargo {
    override method image() = "enemigos/tren.png"
    override method cantidadCeldas() = 15

    override method initialize() {
        if (direccion == 1) {
            position = position.left(15)
        }
        super()
    }
}

class Premetro inherits EnemigoLargo {
    override method image() = "enemigos/premetro.png"
    override method cantidadCeldas() = 3
}

object autoFactory {
    method generarEnemigo(posicion, direccion) {
        const color = ["rojo", "azul", "gris", "taxi"].anyOne()
        return new Auto(position = posicion, velocidad = (0.1).randomUpTo(1), direccion = direccion, color = color)
    }
}

object colectivoFactory {
    method generarEnemigo(posicion, direccion) {
        const lineaRandom = ["7", "114", "145"].anyOne()
        return new Colectivo(
            position = posicion,
            velocidad = (0.2).randomUpTo(1.5),
            direccion = direccion,
            linea = lineaRandom
        )
    }
}

object trenFactory {
    method generarEnemigo(posicion, direccion) {
        return new Tren(
            position = posicion,
            velocidad = (0.2).randomUpTo(1.5),
            direccion = direccion
        )
    }
}

object premetroFactory {
    method generarEnemigo(posicion, direccion) {
        return new Premetro(
            position = posicion,
            velocidad = 0.5,
            direccion = direccion
        )
    }
}