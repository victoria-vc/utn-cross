import niveles.*


class Fondo {
    var property position = game.at(0, 0)
    method image() 
}

object fondoMenu inherits Fondo {
    override method image() = "menu/fondoMenu.png"
}

object fondoAyuda1 inherits Fondo {
    override method image() = "menu/ayuda/fondoAyuda1.png"
}

object fondoAyuda2 inherits Fondo {
    override method image() = "menu/ayuda/fondoAyuda2.png"
}

object fondoAyuda3 inherits Fondo {
    override method image() = "menu/ayuda/fondoAyuda3.png"
}

object fondoPasto inherits Fondo {
    override method image() = "pasto.png"
}

