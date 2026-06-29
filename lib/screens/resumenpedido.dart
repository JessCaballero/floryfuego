import 'package:floryfuego/api/api_service.dart';
import 'package:floryfuego/models/pedidomodelo.dart';
import 'package:floryfuego/models/platillomodel.dart';
import 'package:floryfuego/services/guardadolocal.dart';
import 'package:floryfuego/widgets/metodopago.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class Resumenpedido extends StatefulWidget {
  final Map<int, int> carrito;
  final List<Platillo> platillos;

  const Resumenpedido({
    super.key,
    required this.carrito,
    required this.platillos,
  });

  @override
  State<Resumenpedido> createState() => _ResumenpedidoState();
}

class _ResumenpedidoState extends State<Resumenpedido> {
  bool _estaEnviandoPedido = false;
  final TextEditingController _telefonoController = TextEditingController();
  String _metodoPagoSeleccionado = '';
  final Map<int, int> _carritoDeComprasLocal = {};
  final Map<int, Platillo> _catalogoDePlatillosLocal = {};

  @override
  void initState() {
    super.initState();

    _carritoDeComprasLocal.addAll(widget.carrito);
    for (var platillo in widget.platillos) {
      _catalogoDePlatillosLocal[platillo.id] = platillo;
    }
    _cargarTelefonoDePedido();
  }

  void _cargarTelefonoDePedido() async {
    final telefonoGuardado = await GuardadoLocal.obtenerTelefonoPedido();
    if (telefonoGuardado.isNotEmpty && mounted) {
      setState(() {
        _telefonoController.text = telefonoGuardado;
      });
    }
  }

  double _obtenerPrecioDelPlatillo(int identificador) {
    final platilloEncontrado = _catalogoDePlatillosLocal[identificador];
    if (platilloEncontrado != null) {
      return platilloEncontrado.precio.toDouble();
    }
    return 0.0;
  }

  String _obtenerNombreDelPlatillo(int identificador) {
    final platilloEncontrado = _catalogoDePlatillosLocal[identificador];
    if (platilloEncontrado != null) {
      return platilloEncontrado.nombre;
    }
    return "Platillo no encontrado";
  }

  void _seleccionarMetodoDePago(String metodo) {
    setState(() {
      _metodoPagoSeleccionado = metodo;
    });
  }

  void _aumentarCantidadDePlatillo(int identificador) {
    setState(() {
      final cantidadActual = _carritoDeComprasLocal[identificador] ?? 0;
      _carritoDeComprasLocal[identificador] = cantidadActual + 1;
    });
  }

  void _disminuirCantidadDePlatillo(int identificador) {
    setState(() {
      final cantidadActual = _carritoDeComprasLocal[identificador] ?? 0;
      if (cantidadActual > 1) {
        _carritoDeComprasLocal[identificador] = cantidadActual - 1;
      } else {
        _carritoDeComprasLocal.remove(identificador);
      }
    });
  }

  double _calcularSubTotalDelPedido() {
    double totalAcumulado = 0.0;
    _carritoDeComprasLocal.forEach((identificador, cantidad) {
      double precioIndividual = _obtenerPrecioDelPlatillo(identificador);
      totalAcumulado = totalAcumulado + (precioIndividual * cantidad);
    });
    return totalAcumulado;
  }

  double _calcularImpuestoValorAgregado() {
    return _calcularSubTotalDelPedido() * 0.16;
  }

  double _calcularTotalFinalDelPedido() {
    return _calcularSubTotalDelPedido() + _calcularImpuestoValorAgregado();
  }

  String _generarResumenParaFacturaScripts() {
    List<String> listaDeNombres = [];
    _carritoDeComprasLocal.forEach((identificador, cantidad) {
      final nombrePlatillo = _obtenerNombreDelPlatillo(identificador);
      listaDeNombres.add("$cantidad x $nombrePlatillo");
    });
    return listaDeNombres.join(", ");
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
          "Resumen del Pedido",
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
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _carritoDeComprasLocal.length,
                    itemBuilder: (context, index) {
                      final identificador =
                          _carritoDeComprasLocal.keys.elementAt(index);
                      final cantidad = _carritoDeComprasLocal[identificador]!;
                      final precioUnitario =
                          _obtenerPrecioDelPlatillo(identificador);
                      final subTotal = precioUnitario * cantidad;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              _obtenerNombreDelPlatillo(identificador),
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '$precioUnitario€ x $cantidad = ${subTotal.toStringAsFixed(2)}€',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _disminuirCantidadDePlatillo(
                                      identificador),
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                      backgroundColor:
                                          Colors.red.withValues(alpha: 0.4)),
                                ),
                                SizedBox(width: 8),
                                Text('$cantidad',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                SizedBox(width: 8),
                                IconButton(
                                  onPressed: () => _aumentarCantidadDePlatillo(
                                      identificador),
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                      backgroundColor:
                                          Colors.green.withValues(alpha: 0.4)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    "Método de Pago",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                Metodopago(
                    titulo: "Efectivo",
                    icono: Icons.payments_outlined,
                    subtitulo: "Paga al recibir tu pedido",
                    seleccionado: _metodoPagoSeleccionado == 'efectivo',
                    alSeleccionar: () => _seleccionarMetodoDePago('efectivo')),
                Metodopago(
                    titulo: "Pago con Qr",
                    icono: Icons.qr_code,
                    subtitulo: "Escanea el código en caja",
                    seleccionado: _metodoPagoSeleccionado == 'qr',
                    alSeleccionar: () => _seleccionarMetodoDePago('qr')),
                Metodopago(
                    titulo: "PayPal",
                    icono: Icons.payment,
                    subtitulo: "Pago rápido y seguro",
                    seleccionado: _metodoPagoSeleccionado == 'paypal',
                    alSeleccionar: () => _seleccionarMetodoDePago('paypal')),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Datos de contacto",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _telefonoController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            hintText: "Escribe tu número de teléfono",
                            hintStyle: TextStyle(color: Colors.white54),
                            prefixIcon: Icon(Icons.phone, color: Colors.red),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8)),
                          color: Colors.black45,
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Subtotal",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      "${_calcularSubTotalDelPedido().toStringAsFixed(2)}€",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "IVA",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    "${_calcularImpuestoValorAgregado().toStringAsFixed(2)}€",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white54,
                              indent: 3,
                              endIndent: 3,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total a pagar",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "${_calcularTotalFinalDelPedido().toStringAsFixed(2)}€",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ]),
                        )),
                  ),
                ),
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
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF211111),
              ),
              child: ElevatedButton(
                  onPressed: _estaEnviandoPedido
                      ? null
                      : () async {
                        final messenger = ScaffoldMessenger.of(context);

                          String telefonoLimpio =
                              _telefonoController.text.trim();
                          if (telefonoLimpio.isEmpty ||
                              telefonoLimpio.length < 8) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Por favor, ingresa un número de móvil válido'),
                              backgroundColor: Colors.redAccent,
                            ));
                            return;
                          }
                          if (_metodoPagoSeleccionado.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Por favor, selecciona un método de pago'),
                                backgroundColor:
                                    const Color.fromARGB(255, 252, 148, 12)));
                            return;
                          }
                          setState(() => _estaEnviandoPedido = true);
                          await GuardadoLocal.guardarTelefonoPedido(
                            telefonoLimpio,
                          );

                          final random = Random();
                          final numeroAzar = random.nextInt(9000) + 1000;
                          final String codigoGenerado = 'FF-$numeroAzar';
                          String estatusAutomatico =
                              (_metodoPagoSeleccionado == 'efectivo')
                                  ? 'Pendiente'
                                  : 'Pagado';

                          final nuevoPedido = Pedido(
                            idpedido: 0,
                            codigoPedido: codigoGenerado,
                            fecha:
                                "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
                            hora:
                                "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:00",
                            totalPedido: _calcularTotalFinalDelPedido(),
                            metodoPago: _metodoPagoSeleccionado,
                            estatusPedido: estatusAutomatico,
                            resumen: _generarResumenParaFacturaScripts(),
                            telefono: telefonoLimpio,
                          );

                          final codigoRecibido =
                              await ApiService().guardarPedido(nuevoPedido);
                              if(!mounted) return;
                              setState(() => _estaEnviandoPedido = false);

                          if (codigoRecibido != null) {
                            messenger.showSnackBar(SnackBar(
                              content: Text(
                                  '¡Pedido #$codigoRecibido enviado con éxito!'),
                              backgroundColor: Colors.green,
                            ));
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
                    "Confirmar Pedido",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
        )
      ]),
    );
  }
}
