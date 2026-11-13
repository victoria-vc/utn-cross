import niveles.*
import fondos.*
import visuales.*
import sonidos.*
import wollok.game.*

object juego {

    var opcionSeleccionada = 1
    var mostrandoAyuda = false
    
    const slidesAyuda = [fondoAyuda1, fondoAyuda2, fondoAyuda3]
    var indiceSlide = 0 

    method iniciar() {
        self.mostrarMenu()
    }

    method mostrarMenu() {
        
        game.addVisual(fondoMenu) 
        sonidos.musicaIntro()

        const botonEmpezar = new Visual(position = game.at(5, 5), image = "menu/empezar.png")
        const botonAyuda = new Visual(position = game.at(5, 3), image = "menu/comojugar.png")
        const botonSalir = new Visual(position = game.at(5, 1), image = "menu/salir.png")

        game.addVisual(botonEmpezar)
        game.addVisual(botonAyuda)
        game.addVisual(botonSalir)
        
        flechaMenu.position(game.at(3, 5))
        game.addVisual(flechaMenu)

        opcionSeleccionada = 1
        mostrandoAyuda = false

        keyboard.up().onPressDo({
            if (!mostrandoAyuda) {
                sonidos.cambioBoton()
                self.arriba()
            }
        })

        keyboard.down().onPressDo({
            if (!mostrandoAyuda) {
                sonidos.cambioBoton()
                self.abajo()
            }
        })

        keyboard.enter().onPressDo({
            if (!mostrandoAyuda) {
                sonidos.selecBoton()
                self.seleccionar()
            }
        })
        
        keyboard.right().onPressDo({
            if (mostrandoAyuda) {
                sonidos.cambioBoton()
                self.siguienteSlide()
            }
        })

        keyboard.left().onPressDo({
            if (mostrandoAyuda) {
                sonidos.cambioBoton()
                self.anteriorSlide()
            }
        })

        keyboard.control().onPressDo({
            if (mostrandoAyuda) {
                sonidos.selecBoton()
                self.ocultarAyuda()
            }
        })
    }

    method arriba() {
        if (opcionSeleccionada > 1) {
            opcionSeleccionada -= 1
            flechaMenu.position(flechaMenu.position().up(2))
        }
    }

    method abajo() {
        if (opcionSeleccionada < 3) {
            opcionSeleccionada += 1
            flechaMenu.position(flechaMenu.position().down(2))
        }
    }

    method seleccionar() {
        if (opcionSeleccionada == 1) {
            self.iniciarNivel()
        } else if (opcionSeleccionada == 2) {
            self.mostrarAyuda()
        } else if (opcionSeleccionada == 3) {
            game.stop() 
        }
    }

    method mostrarAyuda() {
        mostrandoAyuda = true
        indiceSlide = 0 
        game.addVisual(slidesAyuda.get(indiceSlide)) 
    }

    method siguienteSlide() {
        if (indiceSlide < slidesAyuda.size() - 1) {
            game.removeVisual(slidesAyuda.get(indiceSlide)) 
            indiceSlide += 1                                
            game.addVisual(slidesAyuda.get(indiceSlide))    
        }
    }

    method anteriorSlide() {
        if (indiceSlide > 0) {
            game.removeVisual(slidesAyuda.get(indiceSlide))
            indiceSlide -= 1
            game.addVisual(slidesAyuda.get(indiceSlide))
        }
    }

    method ocultarAyuda() {
        game.removeVisual(slidesAyuda.get(indiceSlide)) 
        mostrandoAyuda = false
    }


    method iniciarNivel() {
        game.clear()
        sonidos.pararMusicaIntro()
        niveles.empezar()
    }

    method perder() {
        game.clear()
        game.addVisual(cartelPerdiste)
        sonidos.gameOver()
    }
}