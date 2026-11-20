object puntaje {
    var property puntos = 0

    method sumarPuntos(cantidad) {
        puntos = (puntos + cantidad).min(9999)
    }

    method reiniciar() {
        puntos = 0
    }

    method mostrarEn(xInicial, y) {
        const divisores = [1000, 100, 10, 1]
        const digitos = []
        (0 .. divisores.size() - 1).forEach({ i =>
            const digito = new DigitoPuntaje(
                position = game.at(xInicial + i, y),
                divisor = divisores.get(i)
            )
            digitos.add(digito)
            game.addVisual(digito)
        })
        return digitos
    }
}

class DigitoPuntaje {
    var property position
    const divisor

    method digitoActual() = puntaje.puntos().div(divisor) % 10

    method image() = "numeros/" + self.digitoActual() + ".png"

    method desplazar() {
        position = position.up(0.16)
    }
}