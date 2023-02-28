import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String number;
  final double balance;
  final String name;

  const CardWidget(
      {super.key,
      required this.number,
      required this.balance,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        margin: const EdgeInsets.only(left: 30),
        width: 250,
        height: 150,
        // decoration: const BoxDecoration(
        //     color: Colors.lightBlue,
        //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff08B0EC)),
              // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )
              )
          ),
          onPressed: () {  },
          child: Stack(
            children: [
              Center(
                  child: Text(name,
                      style: const TextStyle(color: Colors.white, fontSize: 24))),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Text("$balance₽",
                      style: const TextStyle(color: Colors.white, fontSize: 24))),
              Positioned(
                  bottom: 10,
                  left: 20,
                  child:
                      Text("...$number", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}
