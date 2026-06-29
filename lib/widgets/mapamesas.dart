
import 'package:floryfuego/api/api_service.dart';
import 'package:flutter/material.dart';


class MapaMesas extends StatefulWidget {
  final ValueChanged<int?>? onMesaSeleccionada;
  final DateTime? fecha;
  final TimeOfDay? hora;

  const MapaMesas({
    required this.onMesaSeleccionada,
    this.fecha,
    this.hora,
    super.key,
  });

  @override
  
  State<MapaMesas> createState() => _MapaMesasState();
}

class _MapaMesasState extends State<MapaMesas> {

  int? mesaSeleccionada;
  List<int> idsOcupados = []; 

  @override
  void initState() {
  super.initState();
  consultarOcupacionEnFS();
}

  final List<Map<String, dynamic>> mesas = [
    {'id': 1, 'x': 40, 'y': 30, 'nombre': "Mesa 1 Terraza"},
    {'id': 2, 'x': 110, 'y': 50, 'nombre': "Mesa 2 Terraza"},
    {'id': 3, 'x': 30, 'y': 90, 'nombre': "Mesa 3 Terraza"},
    {'id': 4, 'x': 110, 'y': 110, 'nombre': "Mesa 4 Terraza"},
    {'id': 5, 'x': 50, 'y': 150, 'nombre': "Mesa 5 Terraza"},
    {'id': 6, 'x': 200, 'y': 30, 'nombre': "Mesa 6 Interior"},
    {'id': 7, 'x': 200, 'y': 90, 'nombre': "Mesa 7 Interior"},
    {'id': 8, 'x': 200, 'y': 150, 'nombre': "Mesa 8 Interior"},
    {'id': 9, 'x': 280, 'y': 30, 'nombre': "Mesa 9 Interior"},
    {'id': 10, 'x': 280, 'y': 90, 'nombre': "Mesa 10 Interior"},
    {'id': 11, 'x': 280, 'y': 150, 'nombre': "Mesa 11 Interior"},
  ];


  Future<void> consultarOcupacionEnFS() async {
    if (widget.fecha == null || widget.hora == null) return;

  String f = "${widget.fecha!.year}-${widget.fecha!.month.toString().padLeft(2, '0')}-${widget.fecha!.day.toString().padLeft(2, '0')}";
  String h = "${widget.hora!.hour.toString().padLeft(2, '0')}:${widget.hora!.minute.toString().padLeft(2, '0')}:00";

    try {
      ApiService servicio = ApiService();
     List<int> ocupadas = await servicio.getMesasOcupadas(f, h);
     setState(() {
        idsOcupados = ocupadas;
        mesaSeleccionada = null;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: const Color(0xFF211111).withValues(alpha: 0.5),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                for (var mesa in mesas)
                  Positioned(
                    left: mesa['x'].toDouble(),
                    top: mesa['y'].toDouble(),
                    child: GestureDetector(
                      onTap: () {
                        bool estaOcupada = false;
                        for (int id in idsOcupados) {
                          if (id == mesa['id']) {
                            estaOcupada = true;
                          }
                        }

                        if (estaOcupada == false) {
                          setState(() {
                            mesaSeleccionada = mesa['id'];
                          });
                          if (widget.onMesaSeleccionada != null) {
                            widget.onMesaSeleccionada!(mesa['id']);
                          }
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: idsOcupados.contains(mesa['id']) 
                              ? Colors.red 
                              : (mesaSeleccionada == mesa['id'] ? Colors.amber : Colors.green),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: mesaSeleccionada == mesa['id'] ? Colors.white : Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text('${mesa['id']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 10, 
                  height: 10, 
                  decoration: BoxDecoration(
                    color: Colors.green, 
                    shape: BoxShape.circle
                    )),
                Text(' Disponible', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white)),
              ]),
              Row(children: [
                Container(
                  width: 10, 
                  height: 10, 
                  decoration: BoxDecoration(
                    color: Colors.red, 
                    shape: BoxShape.circle)),
                Text(' Ocupado', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white)),
              ]),
              Row(children: [
                Container(
                  width: 10, 
                  height: 10, 
                  decoration: BoxDecoration
                  (color: Colors.yellow, 
                  shape: BoxShape.circle)),
                Text(' Seleccionado', 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Colors.white)),
              ]),
            ],
          ),
        ),
        SizedBox(height: 4),
        Card(
          color: Color(0xFFEA2A33).withValues(alpha: 0.4), 
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(255, 231, 28, 14), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: (mesaSeleccionada == null)
                    ? Text("Seleccione una mesa disponible", 
                    style: TextStyle(
                      color: Colors.grey
                      ))
                    : Column(
                        children: [
                          Text(
                            mesas[mesaSeleccionada! - 1]['nombre'],
                            style: TextStyle(
                              fontSize: 16, 
                              color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text("Mesa Seleccionada", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Colors.white, 
                              fontSize: 14)
                          ),
                        ],
                      ),
              ),
            ),
          ),
        )
      ],
    );
  }
}