import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/platillomodel.dart'; 

class GuardadoLocal {

  static Future<void> guardarDatosUsuario(String nombre, String email, String telefono) async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.setString('user_nombre', nombre);
    await preferencias.setString('user_email', email);
    await preferencias.setString('user_telefono', telefono);
  }
  
  static Future<Map<String, String>> obtenerDatosUsuario() async {
    final preferencias = await SharedPreferences.getInstance();
    return {
      'nombre': preferencias.getString('user_nombre') ?? '',
      'email': preferencias.getString('user_email') ?? '',
      'telefono': preferencias.getString('user_telefono') ?? '',
    };
  }

  static Future<void> guardarFavoritos(List<Platillo> listaDeFavoritos) async {
    final preferencias = await SharedPreferences.getInstance();
    List<String> listaDeFavs = listaDeFavoritos.map((platillo) {
      return json.encode(platillo.alMapa());
    }).toList();
    await preferencias.setStringList('mis_favoritos', listaDeFavs);
  }

  static Future<List<Platillo>> obtenerFavoritos() async {
    final preferencias = await SharedPreferences.getInstance();
    List<String> listadosFavs = preferencias.getStringList('mis_favoritos') ?? [];
    return listadosFavs.map((textoJson) {
      return Platillo.desdeMapa(json.decode(textoJson));
    }).toList();
  }

  static Future<void> guardarTelefonoPedido(String telefono) async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.setString('user_telefono_carrito', telefono);
  }

  static Future<String> obtenerTelefonoPedido() async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.getString('user_telefono_carrito') ?? '';
  }

}