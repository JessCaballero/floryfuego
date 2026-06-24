import 'package:flutter/material.dart';

class Mostrarfavoritos extends StatelessWidget {
 final List<Map<String,dynamic>> favoritos;
 final bool Function(int) esFavorito;
 final Function(int) alternarFavorito;  
 final Function(int) agregarAlCarrito;

const Mostrarfavoritos({
  super.key,
  required this.favoritos,
  required this.esFavorito,
  required this.alternarFavorito,
  required this.agregarAlCarrito
  });


  @override
  Widget build(BuildContext context) {

    if (favoritos.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Favoritos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 50,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Aún no tienes favoritos agregados ",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Agrega platillos a favoritos tocando el corazón",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Favoritos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(
            color: Colors.white30,
          ),
          itemCount: favoritos.length,
          itemBuilder: (context, index) {
            final platillo = favoritos[index];
            final id = int.parse(platillo['id'].toString());
            final bool esFavorito = this.esFavorito(id);
            return ListTile(
              leading: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                  image: (platillo['imagen'] != null && platillo['imagen'].toString().isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(platillo['imagen'].toString(),
                          headers: {
                                    'Token': '96SYpiWMIbOYeyfiQ6YJ'},),
                          fit: BoxFit.cover,
                        ) : null
                ),
              ),
              title: Text(
                platillo['titulo'].toString(),
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platillo['descripcion'].toString(),
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        platillo['precio'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          platillo['categoria'].toString(),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      )
                    ],
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
                          shape: BoxShape.circle,
                        ),
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
                      onTap: () {
                        alternarFavorito(id);
                      },
                      customBorder: CircleBorder(),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          esFavorito ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: esFavorito ? Colors.red : Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }



}