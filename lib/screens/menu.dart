import 'package:floryfuego/screens/resumenpedido.dart';
import 'package:floryfuego/widgets/mostrarentradas.dart';
import 'package:floryfuego/widgets/mostrarfavoritos.dart';
import 'package:floryfuego/widgets/mostrarpostres.dart';
import 'package:floryfuego/widgets/mostrarprincipal.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/platillomodel.dart';
import '../services/guardadolocal.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final TextEditingController _searchController = TextEditingController();
  List<Platillo> _platillosFiltrados = []; 
  List<Platillo> _platillosBackend = [];
  String _seccionActual = 'todo';
  final Set<int> _favoritos = {};
  final Map<int,int> _carrito = {};

_agregarAlCarrito(int platilloId){
  setState(() {
    _carrito[platilloId]= (_carrito[platilloId] ?? 0) +1;
  });
}
int _obtenerTotalCarrito(){
  return _carrito.values.fold(0,(sum, cantidad) => sum + cantidad);
}

void _filtrarBusqueda(String consulta) {
  setState(() {
    if (consulta.isEmpty) {
      _platillosFiltrados = _platillosBackend;
    } else {

      _platillosFiltrados = _platillosBackend
          .where((platillo) => platillo.nombre.toLowerCase().contains(consulta.toLowerCase()))
          .toList();
    }
  });
}

@override 
  void initState(){
    super.initState();
    _cargarDatosDeFacturaScripts();
    _cargarFavoritosMovil();
  }

  Future<void> _cargarDatosDeFacturaScripts() async {
    try {
      final api = ApiService();
      final datos = await api.getPlatillos();
      setState(() {
        _platillosBackend = datos;
        _platillosFiltrados = datos;
       
      });
    } catch (e) {   
      print("Error al conectar: $e");
    }
  }

  Future<void> _cargarFavoritosMovil() async {
  final guardados = await GuardadoLocal.obtenerFavoritos();
  setState(() {
    for (var platillo in guardados) {
      _favoritos.add(platillo.id); 
    }
  });
}

  void _alternarFavorito(int id) async{
    setState(() {
      if (_favoritos.contains(id)) {
        _favoritos.remove(id);
      } else {
        _favoritos.add(id);
      }
    });
 
    List<Platillo> favoritosGuardados = _platillosBackend
    .where((platillo)=>_favoritos.contains(platillo.id)).toList();
    await GuardadoLocal.guardarFavoritos(favoritosGuardados);
   }

  bool _esFavorito(int id) {
    return _favoritos.contains(id);
  }
 
  List<Map<String, dynamic>> _obtenerListaFavoritos() {
  return _platillosBackend
      .where((platillo) => _favoritos.contains(platillo.id))
      .map((platillo) => {
        'id': platillo.id,
        'titulo': platillo.nombre,
        'descripcion': platillo.descripcion,
        'precio': '${platillo.precio}€',
        'categoria': platillo.categoria,
        'imagen': platillo.imagen, 
      }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF211111),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Menú",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: TextFormField(
                    controller: _searchController,
                    onChanged: _filtrarBusqueda,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.2),
                        hintText: 'Buscar un platillo',
                        hintStyle: TextStyle(color:  Colors.white54),
                        prefixIcon: Icon(Icons.search, color: Colors.white54,),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              _seccionActual = 'todo';
                            });
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: _seccionActual == 'todo'
                                  ? Colors.red
                                  : Colors.grey[850],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: Text('Menú')),
                      SizedBox(
                        width: 8,
                      ),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              _seccionActual = 'favoritos';
                            });
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: _seccionActual == 'favoritos'
                                  ? Colors.red
                                  : Colors.grey[850],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: Icon(Icons.favorite_border)),
                      SizedBox(
                        width: 8,
                      ),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              _seccionActual = 'entradas';
                            });
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: _seccionActual == 'entradas'
                                  ? Colors.red
                                  : Colors.grey[850],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: Text("Entradas")),
                      SizedBox(
                        width: 8,
                      ),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              _seccionActual = 'principal';
                            });
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: _seccionActual == 'principal'
                                  ? Colors.red
                                  : Colors.grey[850],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: Text("Plato Principal")),
                      SizedBox(
                        width: 8,
                      ),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              _seccionActual = 'postres';
                            });
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: _seccionActual == 'postres'
                                  ? Colors.red
                                  : Colors.grey[850],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                          child: Text("Postres")),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if(_searchController.text.isNotEmpty)
                  Mostrarprincipal(
                    platillos: _platillosFiltrados,
                    esFavorito: _esFavorito,
                    alternarFavorito: _alternarFavorito,
                    agregarAlCarrito: _agregarAlCarrito,
                  )
                else Column( children:[ 
                if (_seccionActual == 'todo' || _seccionActual == 'entradas')
                  Mostrarentradas(
                    platillos: _platillosBackend.where((platillo) => platillo.categoria == 'Entradas').toList(),
                    esFavorito:  _esFavorito,
                    alternarFavorito: _alternarFavorito,
                    agregarAlCarrito: _agregarAlCarrito,
                  ),
                if (_seccionActual == 'todo' || _seccionActual == 'principal')
                  Mostrarprincipal(
                    platillos: _platillosBackend.where((platillo) => platillo.categoria == 'Principal').toList(),
                    esFavorito:  _esFavorito,
                    alternarFavorito: _alternarFavorito,
                    agregarAlCarrito: _agregarAlCarrito,
                  ),
                if (_seccionActual == 'todo' || _seccionActual == 'postres')
                  Mostrarpostres(
                    platillos: _platillosBackend.where((platillo) => platillo.categoria == 'Postres').toList(),
                    esFavorito: _esFavorito,
                    alternarFavorito: _alternarFavorito,
                    agregarAlCarrito: _agregarAlCarrito,
                  ),
                if (_seccionActual == 'favoritos') 
                Mostrarfavoritos(
                  favoritos: _obtenerListaFavoritos(),
                  esFavorito: _esFavorito,
                  alternarFavorito: _alternarFavorito,
                  agregarAlCarrito: _agregarAlCarrito,
                ),
                ],),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF211111),
              ),
              child: ElevatedButton(
                  onPressed: () {
                    if(_obtenerTotalCarrito() >0){
                     Navigator.push(context, 
                     MaterialPageRoute(
                      builder: (context)=>Resumenpedido(
                          carrito: _carrito, platillos: _platillosBackend,) ));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Agrega platillos a tu pedido primero"),
                        backgroundColor: Colors.red,
                        )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Text(
                    _obtenerTotalCarrito() >0 
                    ? "Ir a mi pedido(${_obtenerTotalCarrito()})"
                    : "Ir a mi pedido",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            )
          )
      ]),
    );
  }  
}
