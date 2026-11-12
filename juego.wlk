import niveles.*
import fondos.*
import visuales.*
import sonidos.*


object juego {

    var opcionSeleccionada = 1

    method iniciar() {
        self.mostrarMenu()
    }

    method mostrarMenu() {

        game.addVisual(fondoMenu)

        // sonidos.musicaIntro()

        const botonEmpezar = new Visual(position = game.at(5, 5), image = "menu/empezar.png")
        const botonAyuda = new Visual(position = game.at(5, 3), image = "menu/comojugar.png")
        const botonSalir = new Visual(position = game.at(5, 1), image = "menu/salir.png")

        game.addVisual(botonEmpezar)
        game.addVisual(botonAyuda)
        game.addVisual(botonSalir)
        game.addVisual(flechaMenu)

        opcionSeleccionada = 1

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
            game.stop() // cerramos el juego ?
        }
    }

    method mostrarAyuda() {
        game.clear()
        game.addVisual(fondoMenuDifuminado)
        
        // game.addVisual(CarteldeAyuda)
    }

    method iniciarNivel() {
        game.clear()
       // sonidos.pararMusicaIntro()
        niveles.empezar()
    }

    method perder() {
        game.clear()
        game.addVisual(cartelPerdiste)
        sonidos.gameOver()
    }
    
}


