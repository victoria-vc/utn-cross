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

object fondoAyuda4 inherits Fondo {
    override method image() = "menu/ayuda/fondoAyuda4.png"
}

object fondoAyuda5 inherits Fondo {
    override method image() = "menu/ayuda/fondoAyuda5.png"
}

object fondoPasto inherits Fondo {
    override method image() = "piso/pasto.png"
}

object fondoPerder inherits Fondo {
    override method image() = "cinematicas/final/gameover.png"
}

object fondoParada inherits Fondo {
    override method image() = "cinematicas/inicio/exterior_parada.png"
}

 object fondoCine inherits Fondo {
    override method image() = "cinematicas/inicio/interior_casa.png"
} 

object fondoNegro inherits Fondo {
    override method image() = "cinematicas/creditos/fondoNegro.png"
}

 object fondoFinal inherits Fondo {
    override method image() = "cinematicas/final/facultad_exterior.jpg"
} 

object fondoPausaVisual inherits Fondo {
  override method image() = "pausa/fondoPausa.png"
}

