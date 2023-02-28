import 'package:client/card.dart';
import 'package:client/card_add.dart';
import 'package:client/search.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Row(
              children: const [
                SizedBox(width: 15,),
                Expanded(
                    child: SearchWidget()
                ),
                SizedBox(width: 15),
                CircleAvatar(radius: 30,),
                SizedBox(width: 15),
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 100, left: 5, right: 5),
                height: 200,
                decoration: const ShapeDecoration(
                    color: Color(0xffF5F0E5),
                    shape: RoundedRectangleBorder(
                        // side: BorderSide(color: Color(0xffD8AC42), width: 4),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    )
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CardWidget(name: "First card", number: "1234", balance: 100,),
                    CardWidget(name: "Second card", number: "4939", balance: 150,),
                    CardWidget(name: "Third card", number: "4930", balance: 10,),
                    CardWidget(name: "Fourth card", number: "3939", balance: 5,),
                    CardAddWidget()
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
