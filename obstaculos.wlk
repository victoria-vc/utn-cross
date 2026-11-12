/* import jugador.*
import niveles.*
import sonidos.*


class Obstaculo {
    var property position

    method image()
    
    method afectarJugador(unJugador)  { 
        unJugador.retroceder()
    }

    method esAtravesable() = false

}

class Cono inherits Obstaculo {
    override method image() = "obstaculos/cono.png"
} */