import 'package:flutter/material.dart';
import '../models/pedidomodelo.dart';

class CardPedido extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback? alPresionarRepetir; 

  const CardPedido({
    required this.pedido,
    this.alPresionarRepetir,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    final bool esCompletado = pedido.estatusPedido.toLowerCase() == 'entregado';
 Color colorEstatus;
switch (pedido.estatusPedido.toLowerCase()) {
  case 'pendiente':
    colorEstatus = Colors.orange;
    break;
  case 'pagado':
    colorEstatus = Colors.greenAccent;
    break;
  case 'preparacion':
    colorEstatus =  Color.fromARGB(255, 242, 30, 101);
    break;
  case 'listo':
    colorEstatus = Colors.cyanAccent;
    break;
  case 'entregado':
    colorEstatus = Colors.blueAccent;
    break;
  case 'cancelado':
    colorEstatus = Colors.red;
    break;
  default:
   colorEstatus = Colors.white54;
}

final Color fondoEstatus = colorEstatus.withValues(alpha: 0.2);
    
    final IconData iconoPrincipal = esCompletado ? Icons.local_florist_rounded : Icons.local_fire_department;
    final Color colorIcono = esCompletado ? Colors.blueAccent : Colors.amber[800]!;

    return Container(
      margin:  EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:  Color.fromARGB(9, 48, 35, 35).withValues(alpha: 0.7),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), 
                color: esCompletado ?  
                Color.fromARGB(255, 67, 87, 97) :  
                Color.fromARGB(255, 80, 50, 39)
              ),
              width: 40, height: 40,
              child: Icon(iconoPrincipal, color: colorIcono),
            ),
            title: Text(
              "Pedido #${pedido.codigoPedido}", 
              style: TextStyle(
                color: Colors.white
                  )
                ),
            subtitle: Text("${pedido.fecha.replaceAll('-', '/')} - ${pedido.hora}", 
            style: TextStyle(
              color: Colors.white54, 
              fontSize: 10)),
            trailing: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: fondoEstatus,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  pedido.estatusPedido, 
                  style: TextStyle(
                    color: colorEstatus, 
                    fontWeight: FontWeight.bold
                    )
                    ),
              ),
            ),
          ),
          const Divider(indent: 10, endIndent: 10, color: Colors.white24),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${pedido.totalPedido.toStringAsFixed(2)}€", 
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold
                  )),
                InkWell(
                  onTap: () => _mostrarDetalle(context),
                  child: Row(
                    children: [
                      Text("Ver Detalles", 
                      style: TextStyle(
                        color: esCompletado ?
                         Colors.white54 : 
                         Colors.red
                          )
                         ),
                      Icon(
                        esCompletado ? Icons.arrow_forward_ios : Icons.arrow_forward, 
                        color: esCompletado ? Colors.white54 : Colors.red,
                        size: esCompletado ? 13 : 24,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          if (esCompletado && alPresionarRepetir != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: alPresionarRepetir,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color.fromARGB(255, 109, 28, 22).withValues(alpha: 0.4),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Pedir de nuevo"),
                ),
              ),
            ),
        ],
      ),
    );
  }
  _mostrarDetalle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A0F0F),
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Resumen del Pedido", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(color: Colors.white24),
            SizedBox(height: 10),
            Text(pedido.resumen, style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 20),
            Text("Método de pago: ${pedido.metodoPago}", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}


