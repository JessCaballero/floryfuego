import 'dart:convert';
import 'package:floryfuego/models/disponibilidadmodelo.dart';
import 'package:floryfuego/models/eventomodel.dart';
import 'package:floryfuego/models/pedidomodelo.dart';
import 'package:floryfuego/models/reservamodelo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/platillomodel.dart';

class ApiService {
  final String baseUrl = "http://localhost/FloryFuego/api/3";
  final String apiKey = "96SYpiWMIbOYeyfiQ6YJ";
  final String domain = "http://localhost/FloryFuego";

  Future<List<Platillo>> getPlatillos() async {
    var url = Uri.parse('$baseUrl/platillos');
    var response = await http.get(url, headers: {'Token': apiKey});
    if (response.statusCode == 200) {
      final List<dynamic> registros = json.decode(response.body);
      for (var row in registros) {
        if (row['imagen_platillo'] != null && row['imagen_platillo'] != "") {
          String nombreArchivo = row['imagen_platillo'];
          row['imagen_platillo'] = "$baseUrl/ver-platillo?filename=$nombreArchivo";
        }
      }
      return registros.map<Platillo>((row) => Platillo.fromJson(row)).toList();
    } else {
      throw ("Error al conseguir platillos: ${response.statusCode}");
    }
  }

  Future<List<DisponibilidadModelo>> getDisponibilidad(String fecha) async {
    var url = Uri.parse('$domain/ApiDisponibilidad?fecha=$fecha');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> registros = json.decode(response.body);
      return registros.map((row) => DisponibilidadModelo(
        hora: row['hora'],
        libre: row['libre'],
      )).toList();
    } else {
      throw ("Error al conseguir disponibilidad: ${response.statusCode}");
    }
  }

  Future<List<int>> getMesasOcupadas(String fecha, String hora) async {
    var url = Uri.parse('$domain/ApiMesasOcupadas?fecha=$fecha&hora=$hora');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> registros = json.decode(response.body);
      List<int> ocupadas = [];
      for (var row in registros) {
        if (row['mesa'] != null) {
          ocupadas.add(int.parse(row['mesa'].toString()));
        }
      }
      return ocupadas;
    } else {
      throw ("Error al conseguir ocupación: ${response.statusCode}");
    }
  }

  Future<String?> guardarReserva(ReservaModelo reserva) async {
    final url = Uri.parse('$baseUrl/reservas-app');  
    try {
      final response = await http.post(
        url,
        headers: {
          "Token": apiKey, 
          "Content-Type": "application/x-www-form-urlencoded",
          },
        body: {
          'codigo': reserva.codigo,
          'nombre_cliente': reserva.nombre,
          'fecha': "${reserva.fecha.year}-${reserva.fecha.month.toString().padLeft(2,'0')}-${reserva.fecha.day.toString().padLeft(2,'0')}",
          'hora': "${reserva.hora.hour.toString().padLeft(2,'0')}:${reserva.hora.minute.toString().padLeft(2,'0')}:00",
          'id_mesa': reserva.mesa ?? 'Indiferente',
          'num_personas': reserva.personas.toString(), 
          'email': reserva.email,                        
          'telefono': reserva.telefono,                 
          'observaciones': reserva.notas ?? '',              
        },      
      );

      if (response.statusCode == 200) {
        return reserva.codigo; 
      } else {
        debugPrint("FALLO FS: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error de red: $e");
      return null;
    }
  }

  Future<List<ReservaModelo>> getReservasPorEmail(String emailUsuario) async {
    final String urlCompleta = '$baseUrl/mis-reservas?email=$emailUsuario';
    final Uri uri = Uri.parse(urlCompleta);
  
    try {
      final response = await http.get(uri, headers: {"Token": apiKey});
      if (response.statusCode == 200) {
        final List<dynamic> listaDeRegistros = json.decode(response.body);
        final List<ReservaModelo> listaDeReservas = [];

        for (var registro in listaDeRegistros) {
          List<String> partesDeLaFecha = registro['fecha'].toString().split('-');
          int dia = int.parse(partesDeLaFecha[0]);
          int mes = int.parse(partesDeLaFecha[1]);
          int anio = int.parse(partesDeLaFecha[2]);
          DateTime fechaFormateada = DateTime(anio, mes, dia);

          List<String> partesDeLaHora = registro['hora'].toString().split(':');
          int hora = int.parse(partesDeLaHora[0]);
          int minuto = int.parse(partesDeLaHora[1]);
          TimeOfDay horaFormateada = TimeOfDay(hour: hora, minute: minuto);

          ReservaModelo reservaIndividual = ReservaModelo(
            id: registro['id_reservacion'].toString(),
            codigo: registro['codigo']?.toString()  ?? 'S/C',
            nombre: registro['nombre_cliente'] ?? '',
            email: registro['email'] ?? '',
            telefono: registro['telefono'] ?? '',
            fecha: fechaFormateada,
            hora: horaFormateada,
            personas: int.parse(registro['num_personas'].toString()),
            mesa: registro['mesa']?.toString() ?? 'Indiferente',
            notas: registro['observaciones'] ?? '',
          );
          listaDeReservas.add(reservaIndividual);
        }
        return listaDeReservas;
      }
    } catch (errorDePeticion) {
      debugPrint("Error al recuperar reservaciones: $errorDePeticion");
    }
    return [];
  }

 Future<bool> eliminarReservacion(String idDeLaReservacion) async {
  final String urlCompleta = '$baseUrl/mis-reservas';  
  try {
    final response = await http.post(
      Uri.parse(urlCompleta),
      headers: {
        "Token": apiKey,
        "Content-Type": "application/json",
      },
      body: json.encode({
        'accion': 'eliminar',
        'id': idDeLaReservacion,
      }),
    );
    debugPrint("Respuesta del servidor: ${response.body}");
    if (response.statusCode == 200) {
      return response.body.contains('correctamente');
    }
    return false;
  } catch (e) {
    return false;
    }
  }

  Future<List<EventoModel>> getEventos() async {
    var url = Uri.parse('$baseUrl/eventos'); 
    var response = await http.get(url, headers: {'Token': apiKey});

    if (response.statusCode == 200) {
      final List<dynamic> registros = json.decode(response.body);
      
      for (var row in registros) {
        if (row['imagen_evento'] != null && row['imagen_evento'] != "") {
          String nombreArchivo = row['imagen_evento'];
          row['imagen_evento'] = "$baseUrl/img-evento?filename=$nombreArchivo";
        }
          }
          return registros.map<EventoModel>((row) => EventoModel.fromJson(row)).toList();
        } else {
          throw ("Error al conseguir eventos: ${response.statusCode}");
        }
  }

  Future<String?> guardarPedido(Pedido pedido) async {
    final url = Uri.parse('$baseUrl/pedidos-app'); 
    try {
      final response = await http.post(
        url,
        headers: {
          "Token": apiKey,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'codigo_pedido': pedido.codigoPedido,
          'fecha': pedido.fecha,
          'hora': pedido.hora,
          'total_pedido': pedido.totalPedido.toString(),
          'metodo_pago': pedido.metodoPago,
          'estatus_pedido': pedido.estatusPedido,
          'resumen': pedido.resumen,
          'telefono': pedido.telefono,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> respuesta = json.decode(response.body);
        debugPrint("Pedido guardado: ${respuesta['codigo']}");
        return respuesta['codigo']?.toString(); 
      } else {
        debugPrint("Error en FS: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error de red: $e");
      return null;
    }
  }

  Future<List<Pedido>> getPedidosPorTelefono(String telefonoUsuario) async {  
    final String urlCompleta = '$baseUrl/pedidos-app?telefono=$telefonoUsuario';
    final Uri uri = Uri.parse(urlCompleta);
    try {
      final response = await http.get(uri, headers: {"Token": apiKey});
      if (response.statusCode == 200) {
        final List<dynamic> listaDeRegistros = json.decode(response.body);
        return listaDeRegistros.map((registro) => Pedido.fromJson(registro)).toList();
      } else {
        debugPrint("Error FS al obtener pedidos: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("Error de red al recuperar pedidos: $e");
      return [];
    }
  }
}