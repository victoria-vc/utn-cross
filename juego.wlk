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

        const botonEmpezar = new Visual(position = game.at(4, 5), image = "menu/empezar.png")
        const botonSalir = new Visual(position = game.at(4, 3), image = "menu/salir.png")
        //const botonAyuda = new Visual(position = game.at(4, 3), image = "menu/ayuda.png")
        //const botonSalir = new Visual(position = game.at(4, 1), image = "menu/salir.png")
        game.addVisual(botonEmpezar)
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
        opcionSeleccionada = 1
        flechaMenu.moverArriba()
    }

    method abajo() {
        opcionSeleccionada = 2
        flechaMenu.moverAbajo()
    }

    method seleccionar() {
        if (opcionSeleccionada == 1) {
            self.iniciarNivel()
        }
    }

    method iniciarNivel() {
        game.clear()
        niveles.empezar()
    }

    method perder() {
        game.clear()
        game.addVisual(cartelPerdiste)
        sonidos.gameOver()
    }
    
}


