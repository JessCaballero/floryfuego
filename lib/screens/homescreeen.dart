import 'package:floryfuego/api/api_service.dart';
import 'package:floryfuego/models/eventomodel.dart';
import 'package:floryfuego/screens/confirmacionreserva.dart';
import 'package:floryfuego/screens/contactoscreen.dart';
import 'package:floryfuego/screens/menu.dart';
import 'package:floryfuego/screens/pedidosreservas.dart';
import 'package:floryfuego/widgets/cardseventos.dart';
import 'package:floryfuego/widgets/formareservacion.dart';
import 'package:flutter/material.dart';
import '../widgets/mapamesas.dart';

class Homescreeen extends StatefulWidget {
  
  const Homescreeen({super.key});
  @override
  State<Homescreeen> createState() => _HomescreenState();
  
}

class _HomescreenState extends State<Homescreeen> {
  int _currentIndex = 0;
  int? _mesaSeleccionada;
  DateTime? _fechaParaMapa;
  TimeOfDay? _horaParaMapa;
  final ApiService apiService = ApiService();
  final GlobalKey _mapaKey = GlobalKey();

  void _confirmarYGuardarEnFS(DateTime fecha, TimeOfDay hora, int personas) {
    if (_mesaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, selecciona una mesa en el mapa")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Confirmacionreserva(
          fecha: fecha,
          hora: hora,
          personas: personas,
          mesa: '$_mesaSeleccionada', 
        ),
      ),
    );
  }

  _actualizarDatosMapa(DateTime? fecha, TimeOfDay? hora) {
    setState(() {
      _fechaParaMapa = fecha;
      _horaParaMapa = hora;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
    (_mapaKey.currentState as dynamic)?.consultarOcupacionEnFS();
  });
  }

  _actualizaMesaSeleccionada(int? mesaId) {
    setState(() {
      _mesaSeleccionada = mesaId;
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/fondofloryfuego.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                 Positioned(
                  top: 155,
                  left: 15,
                  child: Text(
                    'Flor y Fuego',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                       Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Reserva Rápida",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Formareservacion(
                        alReservar: _confirmarYGuardarEnFS,
                        alCambiarDatos: (fecha, hora) {
                          _actualizarDatosMapa(fecha, hora);
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Mapa de Mesas",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: (_fechaParaMapa != null && _horaParaMapa != null)
                                ? Colors.white.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (_fechaParaMapa != null && _horaParaMapa != null)
                                ? MapaMesas(
                                    key: _mapaKey,
                                    onMesaSeleccionada: _actualizaMesaSeleccionada,
                                    fecha: _fechaParaMapa,
                                    hora: _horaParaMapa,
                                  )
                                : const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_month_outlined,
                                          color: Colors.white38, size: 40),
                                      SizedBox(height: 8),
                                      Text(
                                        "Selecciona fecha y hora para ver Mesas Disponibles",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white60, fontSize: 13),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Calendario de eventos",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           FutureBuilder<List<EventoModel>>(
                                future: apiService.getEventos(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return Text("Error: ${snapshot.error}");
                                  }
                                  final eventos = snapshot.data ?? [];
                                  return Row(
                                    children: eventos.map((e) => Cardseventos(evento: e)).toList(),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),  
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  Menu()));
            } else if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  Pedidosreservas()));
            } else if (index == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  Contactoscreen()));
            } else {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          backgroundColor:  Color(0xFF211111),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined), label: "Menú"),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined), label: "Mi Agenda"),
            BottomNavigationBarItem(icon: Icon(Icons.phone), label: "Contacto"),
          ]),
    );
  }
}