class Platillo {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final String categoria;

  Platillo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.categoria,
  });

  static Platillo fromJson(Map<String, dynamic> json) {
    return Platillo(
      id: int.parse(json['idplatillo'].toString()),
      nombre: json['nombre_platillo'] ?? '',
      descripcion: json['descripcion_platillo'] ?? '',
      precio: double.parse(json['precio_platillo'].toString()),
      imagen: json['imagen_platillo'] ?? '',
      categoria: json['categoria_platillo'] ?? 'Entrada', 
    );
   }
   
  Map<String, dynamic> alMapa() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'imagen': imagen,
      'categoria': categoria,
    };
  }

  static Platillo desdeMapa(Map<String, dynamic> datos) {
    return Platillo(
      id: datos['id'],
      nombre: datos['nombre'],
      descripcion: datos['descripcion'],
      precio: datos['precio'],
      imagen: datos['imagen'],
      categoria: datos['categoria'],
    );
  }
}