package happy.tramites

class Departamento implements Serializable {
    String descripcion
    Direccion direccion
    String permisos

    String codigo

    Integer documento
    Date fechaUltimoDoc

    static mapping = {
        table 'dpto'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dpto__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dpto__id'
            descripcion column: 'dptodscr'
            direccion column: 'dire__id'
            permisos column: 'dptoprms'
            codigo column: 'dptocdgo'
            documento column: 'dptodcmt'
            fechaUltimoDoc column: 'dptofcud'
        }
    }

    static constraints = {
        descripcion(size: 1..63, blank: false, attributes: [title: 'descripcion'])
        direccion(blank: true, attributes: [title: 'Direccion'])
        permisos(blank: true, nullable: true, size: 1..124)
        codigo(maxSize: 4, blank: false, unique: true, attributes: [title: 'codigo'])
        documento(blank: false, attributes: [title: 'documento'])
        fechaUltimoDoc(blank: true, nullable: true)
    }

    String toString() {
        "${direccion.nombre} - ${descripcion}"
    }

}
