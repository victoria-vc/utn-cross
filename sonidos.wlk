import wollok.game.*

object sonidos {
  var sonidoGanar = null

  method reproducir(nombre, volumen) {
    const audio = game.sound("sonidos/" + nombre + ".mp3")
    audio.volume(volumen)
    audio.play()
  }

  method reproducirNormal(nombre) {
    self.reproducir(nombre, 1)
  }

  method choque() { self.reproducir("choque", 0.1) }
  method escudo() { self.reproducir("escudo", 0.5) }
  method pasarNivel() { self.reproducirNormal("pasarNivel") }
  method ganarVida() { self.reproducirNormal("salud") }
  method velocidad() { self.reproducirNormal("velocidad") }
  method gameOver() { self.reproducirNormal("gameOver") }
  method cambioBoton() { self.reproducirNormal("cambioBoton") }
  method selecBoton() { self.reproducirNormal("selecBoton") }
  method itemPickup() { self.reproducirNormal("itemPickup") }
  method pausa() { self.reproducirNormal("pausa") }

  method musicaGanar() {
    sonidoGanar = game.sound("sonidos/musicaGanar.mp3")
    sonidoGanar.play()
    game.schedule(9000, { self.frenarMusicaGanar() })
  }

  method frenarMusicaGanar() {
    if (sonidoGanar != null and sonidoGanar.played()) {
      sonidoGanar.stop()
    }
  }
}