import niveles.*


class Fondo {
    var property position = game.at(0, 0)

    method image() 

    method esAtravesable() = true
}

object fondoMenu inherits Fondo {
    override method image() = "menu/fondoMenu.png"
}

object fondoMenuDifuminado inherits Fondo {
    override method image() = "menu/fondoMenuDifuminado.png"
}

object fondoPasto inherits Fondo {
    override method image() = "pasto.png"
}

