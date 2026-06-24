import 'package:flutter/material.dart';

class Selectorcomensales extends StatefulWidget {
  final ValueChanged<int>? alSeleccionarComensales;
  final String? valorInicial;
  final int maxComensales;

  const Selectorcomensales({
    super.key,
    this.alSeleccionarComensales,
    this.valorInicial,
    this.maxComensales = 20,
    });

  @override
  State<Selectorcomensales> createState() => _SelectorcomensalesState();
}

class _SelectorcomensalesState extends State<Selectorcomensales> {
  final TextEditingController _controller = TextEditingController();
  int _comensalSeleccionado = 1;

  @override 
  void initState(){
    super.initState();
    if(widget.valorInicial != null){
      _comensalSeleccionado = int.tryParse(widget.valorInicial!) ?? 1;
      _controller.text = widget.valorInicial!;
    }else{
      _controller.text = _comensalSeleccionado.toString();
    }
  }

  void _mostrarSelectorComensales(BuildContext context){
    int tempComensales = _comensalSeleccionado;
    showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          backgroundColor:  Color(0xFF211111),
          title: Text("Número de comensales",
          style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context,setState){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          if(tempComensales > 1){
                            setState(() => tempComensales-- ,);
                          }
                        }, icon: Icon(Icons.remove, color:  Colors.white,),
                      ),
                      SizedBox(width: 20,),
                      Text(
                        "$tempComensales",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      SizedBox(width: 20,),
                      IconButton(
                        onPressed: (){
                            if(tempComensales < widget.maxComensales){
                              setState(() => tempComensales++,);
                            }
                        }, 
                        icon: Icon(Icons.add, color: Colors.white,)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Máximo ${widget.maxComensales} personas por reserva",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  )
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
              style: TextStyle(color: Colors.white70),
              ),
            ),
            FilledButton(
              onPressed: (){
                setState(() {
                  _comensalSeleccionado =tempComensales;
                  _controller.text = tempComensales.toString();
                });
                if(widget.alSeleccionarComensales != null){
                  widget.alSeleccionarComensales!(tempComensales);
                }
                Navigator.pop(context);
              }, 
              style: FilledButton.styleFrom(
                backgroundColor: Color(0xFFEA2A33),
              ),
              child: Text("Aceptar"),
             )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: () => _mostrarSelectorComensales(context),
        decoration: InputDecoration(
          filled: true,
            fillColor: Colors.white24.withValues(alpha: 0.2),
            border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(6)
           ),
           suffixIcon: Icon(Icons.people, color: Colors.white70,),
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