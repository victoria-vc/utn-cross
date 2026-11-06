import jugador.*
import niveles.*
import mapa.*


class Enemigo {
    var property position
    var property direccion
    var property velocidad

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
class ColaTren inherits Enemigo {
    override method image() = "enemigos/transparente.png" 
    override method mover() {}   
}

class Tren inherits Enemigo {
    const cantidadVagones = 15
    const cola = []

    method initialize() {
        cantidadVagones.times { i =>
            cola.add(new ColaTren(
                position = self.posicionVagon(i), 
                direccion = direccion, 
                velocidad = velocidad
            ))
        }
    }

    override method image() = "enemigos/tren.png"

    method posicionVagon(indice) = if (direccion == 1) position.left(indice) else position.right(indice)

    override method mover() {
        super()
        (1..cantidadVagones).forEach { i =>
            cola.get(i - 1).position(self.posicionVagon(i))
        }
    }

    override method agregarAlJuego() {
        game.addVisual(self)
        cola.forEach { vagon => game.addVisual(vagon) }
    }

    override method sacarDelJuego() {
        game.removeVisual(self)
        cola.forEach { vagon => game.removeVisual(vagon) }
    }
}

class Piquete inherits Enemigo {
    override method image() = "enemigos/piquete.png"
}

object autoFactory{
    method generarEnemigo(posicion, direccion){
        const color = ["rojo", "azul", "gris"].anyOne()
        return new Auto(position = posicion, velocidad = (0.1).randomUpTo(1), direccion = direccion, color = color)
    }
}

object colectivoFactory{
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