import wollok.game.*

class Cancion {
    const rutaArchivo
    const property duracion
    const sonido = game.sound(rutaArchivo)

    method play() { sonido.play() }
    method stop() { sonido.stop() }
    method volume(volumen) { sonido.volume(volumen) }
}

object musica {
    
    const musica1 = new Cancion(rutaArchivo="sonidos/musica1.mp3", duracion=69000)
    const musica2 = new Cancion(rutaArchivo="sonidos/musica2.mp3", duracion=93000)
    const musica3 = new Cancion(rutaArchivo="sonidos/musica3.mp3", duracion=93000)
    const musica4 = new Cancion(rutaArchivo="sonidos/musica4.mp3", duracion=72000)

    const playlist = [musica1, musica2, musica3, musica4]
    
    var property estaMuteado = false
    var volumenActual = 0.7 
    var cancionSonando = null 

    method iniciarPlaylistAleatoria() {
        const ultimaCancion = cancionSonando
        
        const opciones = playlist.filter({ cancion => cancion != ultimaCancion })
        cancionSonando = opciones.anyOne()
        
        cancionSonando.volume(self.volumenCheck())
        cancionSonando.play()
        
        game.schedule(cancionSonando.duracion(), {
            self.iniciarPlaylistAleatoria() 
        })
    }

    method volumenCheck() = if (estaMuteado) 0.0 else volumenActual

    method aplicarVolumen() {
        if (cancionSonando != null) {
            cancionSonando.volume(self.volumenCheck())
        }
    }

    method subirVolumenParaMenu() {
        volumenActual = 0.7 
        self.aplicarVolumen()
    }

    method bajarVolumenParaNivel() {
        volumenActual = 0.1 
        self.aplicarVolumen()
    }

    method alternarMute() {
        estaMuteado = !estaMuteado
        self.aplicarVolumen()
    }

    method saltarCancion() {
        if (cancionSonando != null) {
            cancionSonando.stop() 
        }
        self.iniciarPlaylistAleatoria() 
    }
}