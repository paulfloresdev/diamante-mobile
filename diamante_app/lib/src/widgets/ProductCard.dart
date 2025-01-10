import 'package:flutter/material.dart';

import '../models/auxiliars/Responsive.dart';

class ProductCard extends StatefulWidget {
  final bool isPicked;
  final bool isOpen;
  final Map<String, dynamic> product;
  final void Function() onLongPress;
  final void Function() onPick;
  final void Function() onTap;
  const ProductCard({
    super.key,
    required this.isPicked,
    required this.isOpen,
    required this.product,
    required this.onLongPress,
    required this.onPick,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    var responsive = Responsive(context);
    var vw = responsive.viewportWidth;

    return Container(
      width: 73.5 * vw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onLongPress: widget.onLongPress,
            onTap: widget.onTap,
            child: Container(
              width: widget.isOpen ? 69.5 * vw : 73.5 * vw,
              padding: EdgeInsets.all(1.5 * vw),
              margin: EdgeInsets.only(top: 1.5 * vw),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.1 * vw,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.product['concepto'],
                    style: TextStyle(
                      fontSize: 1.4 * vw,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 0.75 * vw),
                  Row(
                    children: [
                      Text(
                        'Unidad: ',
                        style: TextStyle(
                          fontSize: 1.2 * vw,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        widget.product['tipo_unidad'],
                        style: TextStyle(
                          fontSize: 1.2 * vw,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.75 * vw),
                  Row(
                    children: [
                      Text(
                        'Cantidad: ',
                        style: TextStyle(
                          fontSize: 1.2 * vw,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        widget.product['cantidad'].toString(),
                        style: TextStyle(
                          fontSize: 1.2 * vw,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.75 * vw),
                  Row(
                    children: [
                      Text(
                        'Precio unitario: ',
                        style: TextStyle(
                          fontSize: 1.2 * vw,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        '\$${widget.product['precio_unitario']}',
                        style: TextStyle(
                          fontSize: 1.2 * vw,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.25 * vw),
                  Text(
                    '\$${widget.product['importe_total']}',
                    style: TextStyle(
                      fontSize: 1.4 * vw,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.isOpen
              ? GestureDetector(
                  onTap: widget.onPick,
                  child: Container(
                    width: 2.5 * vw,
                    height: 2.5 * vw,
                    padding: EdgeInsets.all(0.25 * vw),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 0.1 * vw,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    child: widget.isPicked
                        ? Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          )
                        : null,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
