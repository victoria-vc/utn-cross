import wollok.game.*
import juego.*
import visuales.*
import fondos.*
import sonidos.*


object pausa {
  var property activa = false
  var opcion = 0 

  method alternar() {
    if (activa) self.reanudar() else self.activar()
  }

  method activar() {
    activa = true
    opcion = 0
    sonidos.pausa()
    if (!game.hasVisual(fondoPausaVisual)) {
      game.addVisual(fondoPausaVisual)
    }
    if (!game.hasVisual(flechaPausa)) {
      game.addVisual(flechaPausa)
    }
    
    if (game.hasVisual(iconoMusica)) {
      game.removeVisual(iconoMusica)
      game.addVisual(iconoMusica)
    }
  }

  method reanudar() {
    activa = false
    if (game.hasVisual(flechaPausa)) game.removeVisual(flechaPausa)
    if (game.hasVisual(fondoPausaVisual)) game.removeVisual(fondoPausaVisual)
  }

  method subir() { 
    opcion = 0
    sonidos.cambioBoton()
     }
  method bajar() { 
    opcion = 1
    sonidos.cambioBoton()
   }
  method opcionActual() = opcion

  method confirmar() {
    if (opcion == 0) {
        sonidos.selecBoton()
        self.reanudar()
    } else {
      sonidos.selecBoton()
      activa = false
      juego.volverAlMenu()
    }
  }
}

object flechaPausa {
  method position() = if (pausa.opcionActual() == 0) game.at(6, 8) else game.at(6, 6)
  method image() = "pausa/flechita.png" 
  method afectarJugador(unJugador) {}
}

