import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import '../models/disponibilidadmodelo.dart';

class Selectorhora extends StatefulWidget {
  final ValueChanged<TimeOfDay?>? enHoraSeleccionada;
  final DateTime? fechaSeleccionada;
  final String? valorInicial;

  const Selectorhora({
    super.key,
    this.enHoraSeleccionada,
    this.fechaSeleccionada,
    this.valorInicial,
  });

  @override
  State<Selectorhora> createState() => _SelectorhoraState();
}

class _SelectorhoraState extends State<Selectorhora> {
  final TextEditingController _controller = TextEditingController();
  TimeOfDay? _horaSeleccionada;

  @override
  void initState() {
    super.initState();
    if (widget.valorInicial != null) {
      _controller.text = widget.valorInicial!;
    }
  }

  void _mostrarSelectorBloques(BuildContext context) {
    if (widget.fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Primero selecciona una fecha'),
          backgroundColor: Color(0xFFEA2A33),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF211111),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Selecciona un horario de tu preferencia",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              FutureBuilder<List<DisponibilidadModelo>>(
                future: ApiService().getDisponibilidad(
                    widget.fechaSeleccionada!.toIso8601String().split('T')[0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(color: Color(0xFFEA2A33)));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error al cargar horarios",
                            style: TextStyle(color: Colors.white70)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text("No hay horarios disponibles",
                            style: TextStyle(color: Colors.white70)));
                  }

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: snapshot.data!.map((item) {
                      final bool esElSeleccionado = _controller.text == item.hora;

                      return SizedBox(
                        width: 88,
                        child: ChoiceChip(
                          label: Text(item.hora),
                          selected: esElSeleccionado,
                          onSelected: item.libre
                              ? (selected) {
                                  setState(() {
                                    _controller.text = item.hora;
                                    final partes = item.hora.split(':');
                                    _horaSeleccionada = TimeOfDay(
                                        hour: int.parse(partes[0]),
                                        minute: int.parse(partes[1]));
                                  });
                                 
                                  if (widget.enHoraSeleccionada != null) {
                                    widget.enHoraSeleccionada!(_horaSeleccionada);
                                  }
                                  Navigator.pop(context);
                                }
                              : null,
                         
                          backgroundColor: Color(0xFF3D3D3D),
                          disabledColor: Color(0xFF1A0F0F),
                          selectedColor: Color(0xFFEA2A33),
                          labelStyle: TextStyle(
                            color: item.libre
                                ? Colors.white
                                : Color(0xFF5A2D2D), 
                            fontWeight: item.libre ? FontWeight.bold : FontWeight.normal,
                            decoration: item.libre ? null : TextDecoration.lineThrough,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: item.libre ? Colors.white12 : Colors.transparent,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor:  Colors.white24.withValues(alpha: 0.2),
          hintText: 'Hora',
          hintStyle: TextStyle(color: Colors.white60),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          suffixIcon: Icon(Icons.access_time, color: Colors.white70),
        ),
        onTap: ()  {
            _mostrarSelectorBloques(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}