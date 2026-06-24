class Pedido {
  final int idpedido;
  final String codigoPedido;
  final String fecha;
  final String hora;
  final double totalPedido;
  final String metodoPago;
  final String estatusPedido;
  final String resumen;
  final String telefono;

  Pedido({
    required this.idpedido,
    required this.codigoPedido,
    required this.fecha,
    required this.hora,
    required this.totalPedido,
    required this.metodoPago,
    required this.estatusPedido,
    required this.resumen,
    required this.telefono,

  });

  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      idpedido: int.parse(json['idpedido'].toString()),
      codigoPedido: json['codigo_pedido'] ?? '',
      fecha: json['fecha'] ?? '',
      hora: json['hora'] ?? '',
      totalPedido: double.parse(json['total_pedido'].toString()),
      metodoPago: json['metodo_pago'] ?? '',
      estatusPedido: json['estatus_pedido'] ?? 'Pendiente',
      resumen: json['resumen'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  Map<String, dynamic> alMapa() {
  return {
    'idpedido': idpedido,
    'codigo_pedido': codigoPedido,
    'fecha': fecha,
    'hora': hora,
    'total_pedido': totalPedido,
    'metodo_pago': metodoPago,
    'estatus_pedido': estatusPedido,
    'resumen': resumen,
    'telefono': telefono, 
  };
}

  static Pedido desdeMapa(Map<String, dynamic> datos) {
    return Pedido(
      idpedido: datos['idpedido'],
      codigoPedido: datos['codigo_pedido'],
      fecha: datos['fecha'],
      hora: datos['hora'],
      totalPedido: datos['total_pedido'],
      metodoPago: datos['metodo_pago'],
      estatusPedido: datos['estatus_pedido'],
      resumen: datos['resumen'],
      telefono: datos['telefono'],
    );
  }
}