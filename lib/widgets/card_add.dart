import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CardAddWidget extends StatelessWidget {
  const CardAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
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
              onPressed: () {},
              child: const Center(child: Text("Add"))),
        ),
      ),
    );
  }
}
