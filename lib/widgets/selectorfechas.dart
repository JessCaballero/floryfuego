import 'package:flutter/material.dart';

class Selectorfechas extends StatefulWidget {
  final ValueChanged<DateTime?>? enFechaSeleccionada;
  final String? valorInicial;

   const Selectorfechas({super.key,
   this.enFechaSeleccionada,
   this.valorInicial});

  @override
  State<Selectorfechas> createState() => _SelectorfechasState();
}

class _SelectorfechasState extends State<Selectorfechas> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.valorInicial != null){
      _controller.text = widget.valorInicial!;
    }
  }

  Future _seleccionarFecha(BuildContext context) async{
    final DateTime? fecha = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), 
      lastDate: DateTime(DateTime.now().year +1),
      locale: const Locale('es', 'ES'),
      selectableDayPredicate: (dia) => dia.weekday != 7,
      builder: (context, child){
        return Theme(data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color(0xFFEA2A33),
            onPrimary: Colors.white,
            surface: Color(0xFF211111),
            onSurface: Colors.white, 
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: Color(0xFF211111),
          ),
        ), child: child!);
      }
    );
    if(fecha != null){
      setState(() {
        _controller.text = "${fecha.day}/${fecha.month}/${fecha.year}";   
      });

      if(widget.enFechaSeleccionada != null){
        widget.enFechaSeleccionada!(fecha);
      }
    }
  }
  @override 
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: () => _seleccionarFecha(context),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white24.withValues(alpha: 0.2),
          hintText: 'DD/MM/AAAA',
          hintStyle: TextStyle(color: Colors.white60),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.white70,)
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
    }
    @override
    void dispose(){
      _controller.dispose();
      super.dispose();
    }
}