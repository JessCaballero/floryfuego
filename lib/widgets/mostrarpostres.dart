import 'package:flutter/material.dart';

import '../models/platillomodel.dart';

class Mostrarpostres extends StatelessWidget {
  final List<Platillo> platillos;
  final bool Function(int) esFavorito;
  final Function(int) alternarFavorito;
  final Function(int) agregarAlCarrito;
   final String titulo;

  const Mostrarpostres({
    super.key,
    required this.platillos,
    required this.esFavorito,
    required this.alternarFavorito,
    required this.agregarAlCarrito,
    this.titulo = "Postres"});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white)),
        ListView.separated(
          itemCount: platillos.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(color: Colors.white30),
          itemBuilder: (context, index) {
            final platillo = platillos[index];
            final id = platillo.id;
            final esFavorito = this.esFavorito(id);
            return ListTile(
                leading: Container(
                  height: 80,
                  width: 80,
                 decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                                image: NetworkImage(
                                  platillo.imagen,
                                  headers: {
                                    'Token': '96SYpiWMIbOYeyfiQ6YJ', 
                                  },
                                ),
                                fit: BoxFit.cover,
                              ),  
                    ),
                ),
                title: Text(
                  platillo.nombre,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(platillo.descripcion),
                    Text(
                      "${platillo.precio}€",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                trailing: SizedBox(
                  height: 80,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => agregarAlCarrito(id),
                          customBorder: CircleBorder(),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.4),
                                shape: BoxShape.circle),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        InkWell(
                          onTap: () => alternarFavorito(id),
                          customBorder: CircleBorder(),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: Colors.grey[800], 
                                shape: BoxShape.circle),
                            child: Icon(
                              esFavorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: esFavorito ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ));
          },
        ),
      ],
    );
  }
  }
