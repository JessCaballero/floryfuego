import 'package:floryfuego/widgets/selectorcomensales.dart';
import 'package:floryfuego/widgets/selectorfechas.dart';
import 'package:flutter/material.dart';
import 'selectorhora.dart';

class Formareservacion extends StatefulWidget {
  final Function(DateTime, TimeOfDay, int) alReservar;
  final Function(DateTime?, TimeOfDay?)? alCambiarDatos;
  final Function(DateTime?, TimeOfDay?)? onCambioProgramacion;

  const Formareservacion({
    super.key,
    required this.alReservar,
    this.onCambioProgramacion,
    this.alCambiarDatos,    
  });

  @override
  State<Formareservacion> createState() => _FormareservacionState();
}

class _FormareservacionState extends State<Formareservacion> {
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  int _numPersonas = 1;

  _manejarReservacion() { 
    if (_fechaSeleccionada == null || _horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, complete todos los datos'),
            backgroundColor: Color(0xFFEA2A33)),
      );
      return;
    }
    widget.alReservar(_fechaSeleccionada!, _horaSeleccionada!, _numPersonas);
  }
  
  _cambioEnHS() {
    if (widget.alCambiarDatos != null) {
      widget.alCambiarDatos!(_fechaSeleccionada, _horaSeleccionada);
    }
    if (widget.onCambioProgramacion != null) {
      widget.onCambioProgramacion!(_fechaSeleccionada, _horaSeleccionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Fecha",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Selectorfechas(
                      enFechaSeleccionada: (date) {
                        setState(() {
                          _fechaSeleccionada = date;
                        });
                        _cambioEnHS(); 
                      },
                    )
                  ],
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Selectorhora(
                      key: ValueKey(_fechaSeleccionada), 
                      fechaSeleccionada: _fechaSeleccionada, 
                      enHoraSeleccionada: (time) {
                        setState(() {
                          _horaSeleccionada = time;
                        });
                        _cambioEnHS(); 
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Personas",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Selectorcomensales(
                      alSeleccionarComensales: (comensal) {
                        setState(() => _numPersonas = comensal);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),        
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: FilledButton(
              onPressed: _manejarReservacion,
              style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFFEA2A33),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
              child: Text(
                "Reservar ahora",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}