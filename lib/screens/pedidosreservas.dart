import 'package:floryfuego/models/pedidomodelo.dart';
import 'package:floryfuego/widgets/cardpedido.dart';
import 'package:flutter/material.dart';
import 'package:floryfuego/models/reservamodelo.dart';
import 'package:floryfuego/services/guardadolocal.dart';
import 'package:floryfuego/api/api_service.dart';

class Pedidosreservas extends StatefulWidget {
  final ReservaModelo? nuevaReserva;
  const Pedidosreservas({super.key, this.nuevaReserva});

  @override
  State<Pedidosreservas> createState() => _PedidosreservasState();
}

class _PedidosreservasState extends State<Pedidosreservas> {
  Future<List<Pedido>>? _operacionPedidos;

  final ApiService _apiService = ApiService();
  late Future<List<ReservaModelo>> _operacionReservas;

  @override
  void initState() {
    super.initState();
    _operacionReservas = _obtenerReservasReales();
    _operacionPedidos = _obtenerPedidosReales();
  }

  Future<List<ReservaModelo>> _obtenerReservasReales() async {
    try {
      final datos = await GuardadoLocal.obtenerDatosUsuario();
      if (datos['email'] == null) {
        debugPrint("Advertencia: No se encontró un usuario válido guardado.");
        return [];
      }

      final String emailParaBuscar = datos['email'].toString();
      return await _apiService.getReservasPorEmail(emailParaBuscar);
    } catch (error) {
      debugPrint("Error detectado para evitar crash: $error");
      return [];
    }
  }

  Future<List<Pedido>> _obtenerPedidosReales() async {
    try {
      final String telefono = await GuardadoLocal.obtenerTelefonoPedido();

      if (telefono.isNotEmpty) {
        return await _apiService.getPedidosPorTelefono(telefono);
      }
    } catch (error) {
      debugPrint("Error en la carga de pedidos: $error");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF120808),
      appBar: AppBar(
        backgroundColor: Color(0xFF211111),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Mi Agenda", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tus Reservas",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Text("Historial", style: TextStyle(color: Colors.red)),
                ],
              ),
              SizedBox(height: 15),
              FutureBuilder<List<ReservaModelo>>(
                future: _operacionReservas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.red),
                    ));
                  }

                  final listaReal = snapshot.data ?? [];
                  if (listaReal.isEmpty) {
                    return Text("No hay reservas activas",
                        style: TextStyle(color: Colors.white54));
                  }

                  return Column(
                    children: listaReal.map((reserva) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color.fromARGB(9, 48, 35, 35)
                              .withValues(alpha: 0.7),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(reserva.fechaBien,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 61, 103, 176)
                                          .withValues(alpha: 0.4),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Text("CONFIRMADA",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.lightBlueAccent)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(reserva.horaBien,
                                      style: TextStyle(
                                          color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                              SizedBox(height: 15),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(7, 56, 41, 41)
                                      .withValues(alpha: 0.9),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.people, color: Colors.white54),
                                      SizedBox(width: 8),
                                      Text("${reserva.personas} personas",
                                          style:
                                              TextStyle(color: Colors.white60)),
                                      SizedBox(width: 15),
                                      Icon(Icons.table_restaurant_outlined,
                                          color: Colors.white54),
                                      SizedBox(width: 8),
                                      Text("Mesa ${reserva.mesa}",
                                          style:
                                              TextStyle(color: Colors.white60)),
                                      Spacer(),
                                      Text(reserva.codigo,
                                          style: TextStyle(
                                              color: Colors.white24,
                                              fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final messenger = ScaffoldMessenger.of(
                                            context); 
                                        bool? confirmar = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text("¿Cancelar reserva?"),
                                            content: Text(
                                                "Esta acción no se puede deshacer."),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: Text("No")),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: Text("Sí, cancelar")),
                                            ],
                                          ),
                                        );

                                        if (confirmar != true) return;

                                        bool exito = await _apiService
                                            .eliminarReservacion(reserva.id);

                                        if (!mounted) return;

                                        if (exito) {
                                          setState(() {
                                            _operacionReservas =
                                                _obtenerReservasReales();
                                          });
                                          messenger.showSnackBar(SnackBar(
                                              content: Text(
                                                  "Reserva cancelada correctamente")));
                                        } else {
                                          messenger.showSnackBar(SnackBar(
                                              content: Text(
                                                  "Error al cancelar la reserva")));
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: Text("Cancelar",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
              Divider(indent: 5, endIndent: 5, color: Colors.white30),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tus Pedidos",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  Text("Ver todo", style: TextStyle(color: Colors.red)),
                ],
              ),
              SizedBox(height: 15),
              FutureBuilder<List<Pedido>>(
                future: _operacionPedidos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.red));
                  }

                  final listaPedidos = snapshot.data ?? [];

                  if (listaPedidos.isEmpty) {
                    return const Text("No tienes pedidos registrados",
                        style: TextStyle(color: Colors.white54));
                  }

                  return Column(
                    children: listaPedidos.map((pedido) {
                      return CardPedido(
                        pedido: pedido,
                        alPresionarRepetir: () {},
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
