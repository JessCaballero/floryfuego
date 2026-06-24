import 'package:floryfuego/models/reservamodelo.dart';
import 'package:floryfuego/screens/homescreeen.dart';
import 'package:flutter/material.dart';

class Reservarealizada extends StatelessWidget {
  final ReservaModelo reserva;

  const Reservarealizada({
    required this.reserva,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.withValues(alpha: 0.4),
              child: Icon(Icons.check_circle_outline,
              size: 35,
              color: Colors.greenAccent),
            ),
            Text("¡Reserva confirmada!",
            style: TextStyle(
              fontSize: 33,
              fontWeight: FontWeight.bold,
              color: Colors.white
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Puedes ver y cancelar tus reservas en 'Mi Agenda'.",
              style: TextStyle(              
                color: Colors.white54,
                fontSize: 13
                ),
              maxLines: 2,), )  
                  ],
                )
              ),
            Container(
              width: double.infinity,
              decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8)
                ),
                color: Colors.white10
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Detalles de la Reserva",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Fecha",
                          style: TextStyle(
                            color: Colors.white38
                          ),),
                          Text(reserva.fechaBien,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ),
                     Padding(
                       padding: const EdgeInsets.all(3.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Hora",
                          style: TextStyle(
                            color: Colors.white38
                          ),),
                          Text(reserva.horaBien,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                        ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(3.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Personas",
                          style: TextStyle(
                            color: Colors.white38
                          ),),
                          Text("${reserva.personas} personas",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                          ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(3.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Mesa",
                          style: TextStyle(
                            color: Colors.white38
                          ),),
                          Text(reserva.mesa ?? 'Indiferente',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),)
                        ],
                        ),
                     ),
                Divider(
                  indent: 5,
                  endIndent: 5,
                  color: Colors.black45
                ),
                SizedBox(height: 8,),
                Center(
                  child: Column(
                    children: [
                      Text("Id de Reserva",
                      style: TextStyle(
                        color: Colors.white38
                      ),),
                      SizedBox(height: 6,),
                      Container(
                        width: 120,
                        height: 45,
                        decoration: ShapeDecoration(shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8)
                        ),
                        color: Colors.black54
                        ),
                        child: Center(
                          child: Text(reserva.id,
                          style: TextStyle(
                            color: Colors.white),),
                        ),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                )
                ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.2),
                         borderRadius: BorderRadius.circular(10),
                      ),
                      
                      child: TextButton(onPressed: (){}, 
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,
                          color: Colors.white,),
                          SizedBox(width: 8,),
                          Text("Agregar a calendario",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                          ),
                        ),
                        ],
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withValues(alpha: 0.2),
                         borderRadius: BorderRadius.circular(10),
                      ),
                      
                      child: TextButton(onPressed: (){}, 
                      child: Row(
                        children: [
                          Icon(Icons.share,
                          color: Colors.white,),
                          SizedBox(width: 8,),
                          Text("Compartir Detalles",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                          ),),
                        ],
                      )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 80,),
          Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                    color: Color(0xFF211111),
                    ),
                    child: ElevatedButton(
                    onPressed: () {
                   Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context)=> Homescreeen()));
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: Text("Volver a Inicio",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
           )
          ],
        ),
      ),
    );
  }
}