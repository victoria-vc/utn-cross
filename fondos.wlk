import niveles.*


class Fondo {
    var property position = game.at(0, 0)
    method image() 
}

object fondoMenu inherits Fondo {
    override method image() = "menu/fondoMenu.png"
}

object fondoMenuDifuminado1 inherits Fondo {
    override method image() = "menu/ayuda/fondoMenuDifuminado1.png"
}

object fondoMenuDifuminado2 inherits Fondo {
    override method image() = "menu/ayuda/fondoMenuDifuminado2.png"
}

object fondoPasto inherits Fondo {
    override method image() = "pasto.png"
}

