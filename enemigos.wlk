import jugador.*
import niveles.*


class Enemigo {
    var property position
    var property direccion
    var property velocidad

    method initialize() {
        game.onCollideDo(self, { personaje => 
            if(personaje.esJugador()) {
                self.afectarJugador(personaje)
            }
        })
    }

    method image()

    method afectarJugador(unJugador) = unJugador.perderVida()

    method mover(){
        position = position.right(direccion * velocidad)
    }

    method agregarAlJuego(){
        game.addVisual(self)
    }

    method sacarDelJuego(){
        game.removeVisual(self)
    }

    method estaAfuera() = self.position().x() < -5 or self.position().x() > game.width() + 5 //agrego 5 a los dos lados para que no se borren antes de aparecer

    method esJugador() = false
}


class Auto inherits Enemigo{
    var property color
    override method image() = "enemigos/auto_" + color.toString() + ".png" 
}

class ColaColectivo inherits Enemigo {
    const property colectivo

    override method image() = "enemigos/transparente.png"
    override method mover() {}   // la mueve el colectivo, no se mueve sola
}

class Colectivo inherits Enemigo {
    const property linea // linea base
    const cola = new ColaColectivo(colectivo = self, position = self.posicionCola(), direccion = direccion, velocidad = velocidad)

    override method image() = "enemigos/colectivo_" + linea.toString() + "_" + (if (direccion == 1) "derecha" else "izquierda") + ".png"
    method posicionCola() = if (direccion == 1) position.right(1) else position.left(1)

    override method mover() {
        super()
        cola.position(self.posicionCola())
    }

    override method agregarAlJuego() {
        game.addVisual(self)
        game.addVisual(cola)
    }

    override method sacarDelJuego() {
        game.removeVisual(self)
        game.removeVisual(cola)
    }
}

class Tren inherits Enemigo {
    override method image() = "enemigos/tren.png"
}

class Piquete inherits Enemigo {
    override method image() = "enemigos/piquete.png"
}

object barrera {
    var abierta = true
    var property position = game.at(1,1)

    method esEnemigo() = false

    method image(){
        if(abierta){
            return "abierta.png"
        }
        else{
            return "cerrada.png"
        }
    }

    method alternar(){
        abierta = !abierta
    }
}

object generadorEnemigos {

    method generarAuto(posicion, direccion) {
        const color = ["rojo", "azul", "gris"].anyOne()
        return new Auto(position = posicion, velocidad = 0.1.randomUpTo(1), direccion = direccion, color = color)
    }

    method generarColectivo(posicion, direccion) {
        const lineaRandom = ["7", "114", "145"].anyOne() 
        return new Colectivo(
            position = posicion, 
            velocidad = 0.2.randomUpTo(1.5), 
            direccion = direccion, 
            linea = lineaRandom
        )
    }
}

/* method generarTren(posicion, direccion) {
        return new Tren(position = posicion, velocidad = 0.5, direccion = direccion)
    } */
