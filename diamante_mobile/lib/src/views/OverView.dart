import 'package:diamante_mobile/src/models/auxiliars/Responsive.dart';
import 'package:diamante_mobile/src/widgets/Header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.5 * vw),
        child: ListView(
          children: [
            Header(page: 0),
            SizedBox(
              width: 95 * vw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COTIZACIÓN',
                        style: TextStyle(
                            fontSize: 1.6 * vw, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 1 * vw),
                      Row(
                        children: [
                          Text(
                            'CLIENTE:  ',
                            style: TextStyle(
                                fontSize: 1.2 * vw,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Paul Flores',
                            style: TextStyle(
                              fontSize: 1.2 * vw,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5 * vw),
                      Row(
                        children: [
                          Text(
                            'FECHA:  ',
                            style: TextStyle(
                                fontSize: 1.2 * vw,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 1.2 * vw,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5 * vw),
                      Row(
                        children: [
                          Text(
                            'Lugar:  ',
                            style: TextStyle(
                                fontSize: 1.2 * vw,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Cabo San Lucas',
                            style: TextStyle(
                              fontSize: 1.2 * vw,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1 * vw),
                      Text(
                        '*Catalogo expresado en dolares americanos a tipo de cambio vigente. Precios no incluyen IVA.',
                        style: TextStyle(
                            fontSize: 1.1 * vw, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 15 * vw,
                  )
                ],
              ),
            ),
            SizedBox(height: 1.5 * vw),
            Container(
              width: 95 * vw,
              height: 4 * vw,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Concepto',
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).splashColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: 10 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Tipo de unidad',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).splashColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: 10 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Cantidad',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).splashColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: 12.5 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Precio unitario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).splashColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: 12.5 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Importe total',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).splashColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 95 * vw,
              height: 4 * vw,
              decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  border: Border(
                      bottom: BorderSide(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 0.075 * vw,
                  ))),
              child: Row(
                children: [
                  Container(
                    width: 50 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Concepto',
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: 10 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Concepto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: 10 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Concepto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: 12.5 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Concepto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: 12.5 * vw,
                    padding: EdgeInsets.symmetric(horizontal: 1 * vw),
                    child: Text(
                      'Concepto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 1.2 * vw,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
