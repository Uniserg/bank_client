import 'package:client/widgets/products.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CardAddWidget extends StatefulWidget {
  final EdgeInsetsGeometry? margin;

  const CardAddWidget({
    super.key,
    this.margin = const EdgeInsets.only(left:20, right: 20)
  });

  @override
  State<CardAddWidget> createState() => _CardAddWidgetState();
}

class _CardAddWidgetState extends State<CardAddWidget> {
  @override
  Widget build(BuildContext context) {
    var productsList = Scaffold(
        // insetPadding: EdgeInsets.all(5),
        appBar: AppBar(
          title: Row(
            children: const [
              Icon(Icons.account_balance_wallet),
              Text("Продукты")
            ],
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 100, left: 5, right: 5),
          height: 200,
          decoration: const ShapeDecoration(
              color: Color(0xffF5F0E5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
          child: const Center(
            child: ProductList(),
          ),
        ));

    return UnconstrainedBox(
      child: Container(
        margin: widget.margin,
        width: 250,
        height: 150,
        child: DottedBorder(
          color: Colors.lightBlue,
          strokeWidth: 3,
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          dashPattern: const [8, 4],
          child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.transparent),
                )),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => productsList));
              },
              child: const Center(child: Text("Заказать карту"))),
        ),
      ),
    );
  }
}
