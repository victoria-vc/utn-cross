
import niveles.*
import fondos.*
import visuales.*
import sonidos.*
import musica.*


object juego {

    method iniciar() {
        musica.iniciarPlaylistAleatoria()

        keyboard.m().onPressDo({ // M
            musica.alternarMute()
        })

        menuPrincipal.mostrar()
    }

    method iniciarNivel() {
        game.clear()
        musica.saltarCancion()
        musica.bajarVolumenParaNivel()
        niveles.empezar()
    }

    method perder() {
        game.clear()
        self.cargarCosasGlobales()
        game.addVisual(cartelPerdiste)
        sonidos.gameOver()
    }

    method cargarCosasGlobales() {
        game.addVisual(iconoMusica)
    }
}

object menuPrincipal {

    var opcionSeleccionada = 1

    method mostrar() {
        game.addVisual(fondoMenu)
        juego.cargarCosasGlobales()

        self.mostrarBotones()
        self.posicionarFlecha()

        self.configurarControles()
    }

    method mostrarBotones() {
        game.addVisual(new Visual(
            position = game.at(5, 5),
            image = "menu/empezar.png"
        ))

        game.addVisual(new Visual(
            position = game.at(5, 3),
            image = "menu/comojugar.png"
        ))

        game.addVisual(new Visual(
            position = game.at(5, 1),
            image = "menu/salir.png"
        ))
    }

    method posicionarFlecha() {
        flechaMenu.position(game.at(3, 7 - (opcionSeleccionada * 2)))
        game.addVisual(flechaMenu)
    }

    method configurarControles() {
        keyboard.up().onPressDo({
            sonidos.cambioBoton()
            self.arriba()
        })

        keyboard.down().onPressDo({
            sonidos.cambioBoton()
            self.abajo()
        })

        keyboard.enter().onPressDo({
            sonidos.selecBoton()
            self.seleccionar()
        })
    }

    method arriba() {
        if (opcionSeleccionada > 1) {
            opcionSeleccionada -= 1
            self.posicionarFlecha()
        }
    }

    method abajo() {
        if (opcionSeleccionada < 3) {
            opcionSeleccionada += 1
            self.posicionarFlecha()
        }
    }

    method seleccionar() {
        if (opcionSeleccionada == 1) {
            juego.iniciarNivel()
        } else if (opcionSeleccionada == 2) {
            pantallaAyuda.mostrar()
        } else if (opcionSeleccionada == 3) {
            game.stop()
        }
    }

    method reiniciarSeleccion() {
        opcionSeleccionada = 1
        self.posicionarFlecha()
    }
}

object pantallaAyuda {

    const slides = [fondoAyuda1, fondoAyuda2, fondoAyuda3]
    var indiceSlide = 0

    method mostrar() {
        indiceSlide = 0
        self.mostrarSlideActual()

        self.configurarControles()
    }

    method mostrarSlideActual() {
        game.addVisual(slides.get(indiceSlide))

        // Mantiene el icono de música por encima del fondo
        game.removeVisual(iconoMusica)
        game.addVisual(iconoMusica)
    }

    method configurarControles() {
        keyboard.right().onPressDo({ // ->
            self.siguienteSlide()
        })

        keyboard.left().onPressDo({ // <-
            self.anteriorSlide()
        })

        keyboard.control().onPressDo({ // Ctrl
            self.ocultar()
        })
    }

    method siguienteSlide() {
        if (indiceSlide < slides.size() - 1) {
            sonidos.cambioBoton()
            game.removeVisual(slides.get(indiceSlide))
            indiceSlide += 1
            self.mostrarSlideActual()
        }
    }

    method anteriorSlide() {
        if (indiceSlide > 0) {
            sonidos.cambioBoton()
            game.removeVisual(slides.get(indiceSlide))
            indiceSlide -= 1
            self.mostrarSlideActual()
        }
    }

    method ocultar() {
        game.removeVisual(slides.get(indiceSlide))
        menuPrincipal.reiniciarSeleccion()
        menuPrincipal.mostrar()
    }
}
