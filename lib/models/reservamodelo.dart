import 'dart:math';
import 'package:flutter/material.dart';

class ReservaModelo {
  final DateTime fecha;
  final TimeOfDay hora;
  final int personas;
  final String? mesa;
  final String nombre;
  final String email;
  final String telefono;
  final String? notas;
  final String id;
  final String codigo;

  ReservaModelo({
    required this.fecha,
    required this.hora,
    required this.personas,
    this.mesa,
    required this.nombre,
    required this.email,
    required this.telefono,
    this.notas,
    String? id, 
    String? codigo,
  }) : id = id ?? "0",
  codigo = codigo ?? _generarId();


  ReservaModelo copyWith({
    DateTime? fecha,
    TimeOfDay? hora,
    int? personas,
    String? mesa,
    String? nombre,
    String? email,
    String? telefono,
    String? notas,
    String? id,
    String? codigo,
  }) {
    return ReservaModelo(
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      personas: personas ?? this.personas,
      mesa: mesa ?? this.mesa,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      notas: notas ?? this.notas,
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
    );
  }

  static String _generarId(){
    const letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numeros = '0123456789';
    final random = Random();

    final parte1 = "FYF";
    final parte2 = List.generate(3, (_)=> letras[random.nextInt(letras.length)]).join();
    final parte3 = List.generate(3, (_)=> numeros[random.nextInt(numeros.length)]).join();
    return '$parte1-$parte2-$parte3'; 
  }

  String get fechaBien {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  String get horaBien {
    final esPm = hora.hour >=12;
    final hora12 = hora.hour %12;
    final horaFinal = hora12 == 0 ? 12 :hora12;
    final minuto = hora.minute.toString().padLeft(2,'0');
    return '$horaFinal:$minuto ${esPm ? 'PM': 'AM'}';
  }

 /* Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'personas': personas,
      'fecha': "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
      'hora': "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}",
      'observaciones': notas,
      'mesa': mesa,
    };
  }*/
}