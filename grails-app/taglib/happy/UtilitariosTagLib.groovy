package happy

class UtilitariosTagLib {

    static namespace = "util"

    Closure clean = { attrs ->
        def replace = [
                "&aacute;": "á",
                "&eacute;": "é",
                "&iacute;": "í",
                "&oacute;": "ó",
                "&uacute;": "ú",
                "&ntilde;": "ñ",
                "&Aacute;": "Á",
                "&Eacute;": "É",
                "&Iacute;": "Í",
                "&Oacute;": "Ó",
                "&Uacute;": "Ú",
                "&Ntilde;": "Ñ",
        ]
        def str = attrs.str

        replace.each { busca, nuevo ->
            str = str.replaceAll(busca, nuevo)
        }
        out << str
    }

    Closure capitalize = { attrs, body ->
        def str = body()
        if (str == "") {
            str = attrs.string
        }
        str = str.replaceAll(/[a-zA-Z_0-9áéíóúÁÉÍÓÚñÑüÜ]+/, {
            it[0].toUpperCase() + ((it.size() > 1) ? it[1..-1].toLowerCase() : '')
        })
        out << str
    }

    Closure nombrePersona = { attrs, body ->
        def persona = attrs.persona
        def str = ""
        if (persona instanceof happy.seguridad.Persona) {
            str = capitalize(string: (persona.titulo ? persona.titulo + " " : "") + persona.nombre + " " + persona.apellido)
        }
        out << str
    }

    Closure numero = { attrs ->
        if (attrs.debug == "true" || attrs.debug == true) {
            println "AQUI: " + attrs
        }
        if (!attrs.decimales) {
            if (!attrs["format"]) {
                attrs["format"] = "##,##0"
            }
            if (!attrs.minFractionDigits) {
                attrs.minFractionDigits = 2
            }
            if (!attrs.maxFractionDigits) {
                attrs.maxFractionDigits = 2
            }
        } else {
            def dec = attrs.remove("decimales").toInteger()

            attrs["format"] = "##,##0"
            if (dec > 0) {
                attrs["format"] += "."
            }
            dec.times {
                attrs["format"] += "#"
            }

//            attrs["format"] = "##"
//            if (dec > 0) {
//                attrs["format"] += ","
//                dec.times {
//                    attrs["format"] += "#"
//                }
//                attrs["format"] += "0"
//            }
            attrs.maxFractionDigits = dec
            attrs.minFractionDigits = dec
        }
        if (!attrs.locale) {
            attrs.locale = "ec"
        }
        if (attrs.debug == "true" || attrs.debug == true) {
            println attrs
            println g.formatNumber(attrs)
            println g.formatNumber(number: attrs.number, maxFractionDigits: 3, minFractionDigits: 3, format: "##.###", locale: "ec")
            println g.formatNumber(number: attrs.number, maxFractionDigits: 3, minFractionDigits: 3, format: "##,###.###", locale: "ec")
        }
        if (attrs.cero == "false" || attrs.cero == false || attrs.cero == "hide") {
            if (attrs.number) {
                if (attrs.number.toDouble() == 0.toDouble()) {
                    out << ""
                    return
                }
            } else {
                out << ""
                return
            }
        }
        out << g.formatNumber(attrs)
    }

    Closure fechaConFormato = { attrs ->
        def fecha = attrs.fecha
        def formato = attrs.formato ?: "dd-MMM-yy"
        def meses = ["", "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
        def mesesLargo = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        def strFecha = ""
//        println ">>" + fecha + "    " + formato
        if (fecha) {
            switch (formato) {
                case "MMM-yy":
                    strFecha = meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yy")
                    break;
                case "dd-MM-yyyy":
                    strFecha = "" + fecha.format("dd-MM-yyyy")
                    break;
                case "dd-MMM-yyyy":
                    strFecha = "" + fecha.format("dd") + "-" + meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yyyy")
                    break;
                case "dd-MMM-yy":
                    strFecha = "" + fecha.format("dd") + "-" + meses[fecha.format("MM").toInteger()] + "-" + fecha.format("yy")
                    break;
                case "dd MMMM yyyy":
                    strFecha = "" + fecha.format("dd") + " de " + mesesLargo[fecha.format("MM").toInteger()] + " de " + fecha.format("yyyy")
                    break;
                default:
                    strFecha = "Formato " + formato + " no reconocido"
                    break;
            }
        }
//        println ">>>>>>" + strFecha
        out << strFecha
    }

}
