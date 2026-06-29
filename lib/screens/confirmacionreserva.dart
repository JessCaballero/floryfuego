import 'package:floryfuego/services/guardadolocal.dart';
import 'package:flutter/material.dart';
import 'package:floryfuego/api/api_service.dart';
import 'package:floryfuego/models/reservamodelo.dart';
import 'package:floryfuego/screens/reservarealizada.dart';

class Confirmacionreserva extends StatefulWidget {
  final DateTime fecha;
  final TimeOfDay hora;
  final int personas;
  final String mesa;

   const Confirmacionreserva({
    super.key,
    required this.fecha,
    required this.hora,
    required this.personas,
    required this.mesa,
  });

  @override
   State<Confirmacionreserva> createState() => _ConfirmacionreservaState();
}

class _ConfirmacionreservaState extends State<Confirmacionreserva> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final TextEditingController _controladorNombre = TextEditingController();
  final TextEditingController _controladorEmail = TextEditingController();
  final TextEditingController _controladorTelefono = TextEditingController();
  final TextEditingController _controladorNotas = TextEditingController();

  bool _estaCargando = false;

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  void _cargarPreferencias() async {
    Map<String, String> datos = await GuardadoLocal.obtenerDatosUsuario();
    setState(() {
      _controladorNombre.text = datos['nombre'] ?? '';
      _controladorEmail.text = datos['email'] ?? '';
      _controladorTelefono.text = datos['telefono'] ?? '';
    });
  }

  void _finalizarReservaEnFS() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _estaCargando = true);

      final nuevaReserva = ReservaModelo(
        fecha: widget.fecha,
        hora: widget.hora,
        personas: widget.personas,
        mesa: widget.mesa,
        nombre: _controladorNombre.text,
        email: _controladorEmail.text,
        telefono: _controladorTelefono.text,
        notas: _controladorNotas.text,
      );

    try {
      String? idResult = await _apiService.guardarReserva(nuevaReserva);
      if (idResult != null) {
        await GuardadoLocal.guardarDatosUsuario(
          nuevaReserva.nombre, 
          nuevaReserva.email, 
          nuevaReserva.telefono
        );
        final reservaFinal = nuevaReserva.copyWith(id: idResult);
        if(!mounted) return; 
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Reservarealizada(reserva: reservaFinal)),
          (route) => false,
        );
      }
    } catch (e) {
      if(!mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al conectar con FS: $e")),
      );
    } finally {
      setState(() => _estaCargando = false);
    }
        }
      }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white24.withValues(alpha: 0.2),
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      hintStyle: TextStyle(color: Colors.white60, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.white60),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF211111),
      appBar: AppBar(
        title: Text("Confirmar Reserva", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF211111),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombre Completo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _controladorNombre,
                  style: TextStyle(color: Colors.white),
                  decoration: _inputStyle('Introduce tu nombre'),
                  validator: (v) => (v == null || v.isEmpty) ? 'El nombre es obligatorio' : null,
                ),
                SizedBox(height: 20),
                Text("Correo Electrónico", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _controladorEmail,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputStyle('Introduce tu correo'),
                ),
                SizedBox(height: 20),
                Text("Teléfono", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _controladorTelefono,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: _inputStyle('Introduce tu teléfono'),
                  validator: (v) => (v == null || v.isEmpty) ? 'El teléfono es obligatorio' : null,
                ),
                SizedBox(height: 20),
                Text("Notas / Observaciones", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _controladorNotas,
                  style: TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: _inputStyle('Alergias, petición especial'),
                ),
                SizedBox(height: 100), 
              ],
            ),
          ),
        ),
        if (_estaCargando)
          Center(child: CircularProgressIndicator(color: Colors.red))
        else
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: _finalizarReservaEnFS,
                child: Text(
                  "Confirmar Reserva",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}