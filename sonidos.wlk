
import wollok.game.*

object sonidos {
  method agarrarItem() {
    const audio = game.sound("sonidos/agarrarItem.mp3")
    audio.volume(0.5)
    audio.play()
  }

  method choque() {
    const audio = game.sound("sonidos/choque.mp3")
    audio.volume(0.1)
    audio.play()
  }

  method moverPersonaje() {
    const audio = game.sound("sonidos/movimiento.mp3")
    audio.volume(0.1)
    audio.play()
  }

  method pasarNivel() {
    game.sound("sonidos/pasarNivel.mp3").play()
  }

  method ganarVida() {
    game.sound("sonidos/salud.mp3").play()
  }

  method gameOver() {
    game.sound("sonidos/gameOver.mp3").play()
  }

  method cambioBoton() {
    game.sound("sonidos/cambioBoton.mp3").play()
  }

  method selecBoton() {
    game.sound("sonidos/selecBoton.mp3").play()
  }
}
