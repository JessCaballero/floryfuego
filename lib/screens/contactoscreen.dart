import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contactoscreen extends StatelessWidget {
  const Contactoscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Flor y Fuego",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "CONTACTO & UBICACIÓN",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white30, width: 1)),
                child: ListTile(
                  tileColor: Colors.white12.withValues(alpha: 0.1),
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red.withValues(alpha: 0.4),
                      child:  Icon(
                        Icons.phone,
                        color: Colors.red,
                      )),
                  title: const Text(
                    "RESERVAS",
                    style: TextStyle(fontSize: 14, color: Colors.white60),
                  ),
                  subtitle: Text(
                    "+34 65 659 8841",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white30, width: 1)),
                child: ListTile(
                  tileColor: Colors.white12.withValues(alpha: 0.1),
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red.withValues(alpha: 0.4),
                      child: Icon(
                        Icons.email,
                        color: Colors.red,
                      )),
                  title: Text(
                    "EMAIL",
                    style: TextStyle(fontSize: 14, color: Colors.white60),
                  ),
                  subtitle: Text(
                    "contacto@floryfuego.com",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Ubicación",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Calle Doña Leonor de Guzmán',
                          style: TextStyle(color: Colors.white60)),
                      Text("Talavera de la Reina, 45600",
                          style: TextStyle(color: Colors.white60)),
                      Text("España", style: TextStyle(color: Colors.white60)),
                      SizedBox(
                        height: 13,
                      )
                    ],
                  ),
                ],
              ),
       
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white30, width: 1),
                    image:  DecorationImage(
                      image: AssetImage('assets/ubicacion.jpeg'),
                      fit: BoxFit.cover
                    )),
                
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: 220,
                    child: ElevatedButton(
                        onPressed: () async {
                          String url = "https://www.google.com/maps/search/?api=1&query=Calle+Doña+Leonor+de+Guzmán,+Talavera+de+la+Reina,+45600";
                          final Uri uri = Uri.parse(url);
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map),
                            Text(
                              "Abrir en Google Maps",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Horarios",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white12.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white30, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Lunes-Jueves",
                                style: TextStyle(color: Colors.white60)),
                            Text("13:00-23:00",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                      Divider(
                        indent: 3,
                        endIndent: 3,
                        color: Colors.white54,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Viernes-Sábado",
                                style: TextStyle(color: Colors.white60)),
                            Text("13:00-01:00",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.home,
                    color: Colors.white54,
                  )),
              Text(
                "Inicio",
                style: TextStyle(fontSize: 12, color: Colors.white54),
              )
            ],
          ),
        ),
      ),
    ));
  }
}