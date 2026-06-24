import 'package:flutter/material.dart';

class Metodopago extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final String? subtitulo;
  final bool seleccionado;
  final VoidCallback alSeleccionar;

  const Metodopago({
    required this.titulo,
    required this.icono,
    this.subtitulo,  
    required this.seleccionado,
    required this.alSeleccionar,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: alSeleccionar,
        borderRadius: BorderRadius.circular(8),
        child: Container( 
          height: 80,
          decoration: BoxDecoration(
            color: seleccionado ? Color.fromARGB(255, 109, 28, 22).withValues(alpha: 0.4) : Colors.black45,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: seleccionado ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: ListTile(
              leading: Icon(icono,
              color: seleccionado ? Colors.red : Colors.white70,),
              title: Text(titulo,
                style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70
                  ),
                ),
              subtitle: seleccionado && subtitulo != null ? Text(subtitulo!,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14
                ),
              ) : null,
              trailing: Icon(
                seleccionado ? Icons.radio_button_on_sharp : Icons.radio_button_off_sharp,
              color: seleccionado ? Colors.red : Colors.white,),
              ),
            ),
          ),
        ),
      );
                
  }
}

                