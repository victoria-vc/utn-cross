
import niveles.*
import fondos.*
import visuales.*
import sonidos.*
import musica.*
import jugador.*
import puntaje.*


object juego {

    method iniciar() {
        musica.iniciarPlaylistAleatoria()
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
        game.addVisual(fondoPerder)
        puntaje.mostrarEn(14, 0)
        self.cargarCosasGlobales()
        keyboard.enter().onPressDo({ self.volverAlMenu() })
        sonidos.gameOver()
    }

    method volverAlMenu() {
        jugador.reiniciar()
        niveles.reiniciar()
        puntaje.reiniciar()
        game.clear()
        musica.subirVolumenParaMenu()
        menuPrincipal.reiniciarSeleccion()
        menuPrincipal.mostrar()
    }

    method ganar() {
        game.clear()
        game.addVisual(cartelGanaste) // esto no va
        self.cargarCosasGlobales()
        keyboard.enter().onPressDo({ self.volverAlMenu() })
    }

    method cargarCosasGlobales() {
        if (!game.hasVisual(iconoMusica)) {
            game.addVisual(iconoMusica)
        }
        
        keyboard.m().onPressDo({ 
            musica.alternarMute()
        })

        game.onTick(1000, "control_musica", {
            musica.verificarSiguiente()
        })
    }
}

object menuPrincipal {

    var opcionSeleccionada = 1

    method mostrar() {
        game.addVisual(fondoMenu) 
        juego.cargarCosasGlobales() 
        self.mostrarBotones() 

        self.posicionarFlecha() 
        game.addVisual(flechaMenu)

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
            game.clear() 
            pantallaAyuda.mostrar()
        } else if (opcionSeleccionada == 3) {
            game.stop()
        }
    }

    method reiniciarSeleccion() {
        opcionSeleccionada = 1
    }
}

object pantallaAyuda {

    const slides = [fondoAyuda1, fondoAyuda2, fondoAyuda3, fondoAyuda4, fondoAyuda5]
    var indiceSlide = 0

    method mostrar() {
        indiceSlide = 0
        juego.cargarCosasGlobales() 
        self.mostrarSlideActual()
        self.configurarControles()
    }

    method mostrarSlideActual() {
        game.addVisual(slides.get(indiceSlide))

        if (game.hasVisual(iconoMusica)) {
            game.removeVisual(iconoMusica)
        }
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
        game.clear() 
        sonidos.selecBoton()
        menuPrincipal.mostrar()
    }
}
