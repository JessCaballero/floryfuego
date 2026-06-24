class EventoModel {
  int idEvento;
  String titulo;
  String fecha;
  String hora;
  int capacidad;
  String descripcion;
  String imagenEvento;

  EventoModel({
    this.idEvento = 0,
    this.titulo = '',
    this.fecha = '',
    this.hora = '',
    this.capacidad = 0,
    this.descripcion = '',
    this.imagenEvento = '',
  });

  EventoModel.fromJson(Map<String, dynamic> json)
      : idEvento = int.tryParse(json['id_evento'].toString()) ?? 0,
        titulo = json['titulo']?.toString() ?? '',
        fecha = (json['fecha']?.toString() ?? '').replaceAll('-', '/'),
        hora = json['hora']?.toString() ?? '',
        capacidad = int.tryParse(json['capacidad'].toString()) ?? 0,
        descripcion = json['descripcion']?.toString() ?? '',
        imagenEvento = json['imagen_evento']?.toString() ?? '';
}