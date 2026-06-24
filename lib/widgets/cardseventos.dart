import 'package:floryfuego/models/eventomodel.dart';
import 'package:flutter/material.dart';

class Cardseventos extends StatelessWidget {
  final EventoModel evento; 
  const Cardseventos({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
   
    return SizedBox(
      width: 230,
      height: 210,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
         color:  Colors.white.withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 230,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: evento.imagenEvento.isNotEmpty ? 
                      DecorationImage(
                        image: NetworkImage(
                          evento.imagenEvento,
                          headers: {
                            'Token': '96SYpiWMIbOYeyfiQ6YJ', 
                          },
                        ),
                        fit: BoxFit.cover,
                      ) : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(evento.titulo,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
        
                    ),
                    ),
                    SizedBox(height: 4,),
                       Text(evento.fecha,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 8
                    ),
                  )
                  ],
                ),
              ),
           
            ],
            )
        ),
      )
      );
    }
  }