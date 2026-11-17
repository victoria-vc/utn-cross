import wollok.game.*
import niveles.*
import juego.*
import sonidos.*
import fondos.*
import musica.*
import puntaje.*
import visuales.*

object cinematicaInicio {
  var t = 0

  method despues(ms, accion) {
    t += ms
    game.schedule(t, accion)
  }

  method caminarProta(pasos, msPorPaso) {
    pasos.times({ i => self.despues(msPorPaso, { protagonistaCine.avanzar() }) })
    self.despues(50, { protagonistaCine.quieto() })
  }

  method caminar(visual, pasos, dx, dy, msPorPaso) {
    pasos.times({ i =>
      self.despues(msPorPaso, { visual.position(visual.position().right(dx).up(dy)) })
    })
  }

  method empezar() {
    t = 0
    self.escenaCasa()
    self.escenaParada()
    self.despues(600, { niveles.pasarNivel() })
  }

  method escenaCasa() {
    game.addVisual(fondoCine)
    game.addVisual(puertaCine)
    game.addVisual(mochilaCine)
    game.addVisual(protagonistaCine)
    //self.despues(0, {})
    self.despues(800, {})
    self.caminarProta( 3, 400)
    self.despues(300, {
      game.removeVisual(mochilaCine)
      protagonistaCine.agarrarMochila()
    })
    self.caminarProta(4, 400)
    self.despues(300, { puertaCine.image("cinematicas/inicio/puerta_abierta.png") })
    self.despues(500, {
    game.removeVisual(protagonistaCine)
    game.removeVisual(puertaCine)
    game.removeVisual(fondoCine)
    game.addVisual(fondoParada)
  })
  }

  method escenaParada() {
    self.despues(600, {
      //game.boardGround("cinematicas/inicio/exterior_parada.png")
      protagonistaCine.position(game.at(4, 3))
      colectivoCine.position(game.at(game.width(), 1))
      game.addVisual(protagonistaCine)
      game.addVisual(colectivoCine)
    })
    self.caminar(colectivoCine, game.width() - 4, -1, 0, 250)
    self.despues(500, { game.removeVisual(protagonistaCine) })
    self.caminar(colectivoCine, 6, -1, 0, 250)
  }
  
}

object protagonistaCine {
  var property position = game.at(2, 1)
  var conMochila = false
  var paso = 0

  method image() = "cinematicas/inicio/pj" + (if (conMochila) "_mochila" else "") + ["", "_paso1", "_paso2"].get(paso) + ".png"

  method agarrarMochila() { conMochila = true }
  method avanzar() {
    position = position.right(1)
    paso = if (paso == 1) 2 else 1
  }
  method quieto() { paso = 0 }

  
}

object puertaCine {
  var property position = game.at(9, 2)
  var property image = "cinematicas/inicio/puerta_cerrada.png"
}

object mochilaCine {
  var property position = game.at(5, 1)
  var property image = "cinematicas/inicio/mochila.png"
}

object colectivoCine {
  var property position = game.at(0, 1)
  var property image = "cinematicas/inicio/colectivo_cine.png"
}

object cinematicaFinal {
  var t = 0

  method despues(ms, accion) {
    t += ms
    game.schedule(t, accion)
  }

  method caminarProtaIzquierda(pasos, msPorPaso) {
    pasos.times({ i => self.despues(msPorPaso, { protagonistaFinal.retroceder() }) })
    self.despues(70, { protagonistaFinal.quieto() })
  }

  method empezar() {
    t = 0
    protagonistaFinal.reiniciar()
    sonidos.musicaGanar()
    game.addVisual(fondoFinal)
    game.addVisual(protagonistaFinal)

    self.despues(500, {})
    self.caminarProtaIzquierda(8, 400)

    self.despues(200, {
      protagonistaFinal.empezarSaludo()
      game.onTick(250, "saludo_animacion", { protagonistaFinal.alternarSaludo() })
    })

    self.despues(6000, {
      game.removeTickEvent("saludo_animacion")
      sonidos.frenarMusicaGanar()
      creditos.empezar()
    })
  }
}

object protagonistaFinal {
  var property position = game.at(18, 2)
  var paso = 0
  var saludando = false
  var frameSaludo = 1

  method image() {
    if (saludando) {
      return "cinematicas/final/pj_saludo" + frameSaludo + ".png"
    } else {
      return "cinematicas/final/pj_mochila_izq" + ["_paso1", "_paso1", "_paso2"].get(paso) + ".png"
    }
  }

  method retroceder() {
    position = position.left(1)
    paso = if (paso == 1) 2 else 1
  }

  method quieto() {
    paso = 0
  }

  method empezarSaludo() {
    saludando = true
  }

  method alternarSaludo() {
    frameSaludo = if (frameSaludo == 1) 2 else 1
  }

  method reiniciar() {
    position = game.at(18, 2)
    paso = 0
    saludando = false
    frameSaludo = 1
  }
  
}

object creditos {
  const items = []
  var scrolleando = false

  method empezar() {
    game.clear()
    items.clear()
    scrolleando = true

    game.addVisual(fondoNegro)
    juego.cargarCosasGlobales()
    musica.subirVolumenParaMenu()

    const imagenes = [
      "cinematicas/creditos/graciasypuntos.png",
      "cinematicas/creditos/creditos1.png",
      "cinematicas/creditos/creditos2.png",
      "cinematicas/creditos/creditos3.png",
      "cinematicas/creditos/creditos4.png",
      "cinematicas/creditos/fondoFinalCreditos.png" 
    ]

    const separacion = 14
    var ultimoItem = null

    (0 .. imagenes.size() - 1).forEach({ i =>
      const yInicial = -separacion - (i * separacion)
      const item = new ItemCredito(
        position = game.at(0, yInicial),
        image = imagenes.get(i)
      )
      items.add(item)
      game.addVisual(item)
      ultimoItem = item

      if (i == 0) {
        items.addAll(puntaje.mostrarEn(9, yInicial + 10))
      }
    })

    if (game.hasVisual(iconoMusica)) {
      game.removeVisual(iconoMusica)
      game.addVisual(iconoMusica)
    }

    game.onTick(60, "scroll_creditos", {
      items.forEach({ item => item.desplazar() })
      if (ultimoItem.position().y() >= 0) {
        self.detenerScroll()
        ultimoItem.position(game.at(0, 0)) 
      }
    })

    keyboard.enter().onPressDo({
      self.detenerScroll()
      juego.volverAlMenu()
    })
  }

  method detenerScroll() {
    if (scrolleando) {
      scrolleando = false
      game.removeTickEvent("scroll_creditos")
    }
  }
}

class ItemCredito {
  var property position
  const property image

  method desplazar() {
    position = position.up(0.16)
  }
}