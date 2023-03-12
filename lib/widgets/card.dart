import 'package:client/vars/decorations.dart';
import 'package:client/vars/my_colors_dev.dart';
import 'package:flutter/material.dart';

class CardShape extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final Color? color;

  const CardShape({
    super.key,
    this.child,
    this.width = 250,
    this.height = 150,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.all(
            Radius.circular(20.0) //                 <--- border radius here
            ),
      ),
      child: child,
    );
  }
}

class CardWidget extends StatelessWidget {
  final String? number;
  final double? balance;
  final List<int>? logo;
  final String name;
  final void Function()? onPressed;

  final EdgeInsetsGeometry? margin;

  const CardWidget(
      {required this.name,
      super.key,
      this.number = "",
      this.logo,
      this.balance,
      this.onPressed,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(
        margin: margin,
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: const BorderRadius.all(
              Radius.circular(20.0) //                 <--- border radius here
              ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(myLightBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            children: [
              Center(
                  child: Text(name,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 24))),
              Positioned(
                  bottom: 10,
                  right: 20,
                  child: Text((balance == null) ? "" : "$balance₽",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 24))),
              Positioned(
                  bottom: 10,
                  left: 20,
                  child: Text("$number",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountRequisitesWidget extends StatelessWidget {

  final String cardNumber;

  const AccountRequisitesWidget({
    super.key,
    required this.cardNumber
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Реквизиты счета"),
      ),
    );
  }

}


class CardDetailsWidget extends StatelessWidget {
  final String number;
  final String holderName;
  final String expirationDate;
  final int cvv;
  final bool isActive;
  final String productName;

  const CardDetailsWidget(
      {super.key,
      required this.number,
      required this.holderName,
      required this.expirationDate,
      required this.cvv,
      required this.isActive,
      required this.productName});

  @override
  Widget build(BuildContext context) {

    var cardShape = Container(
      margin: const EdgeInsets.all(20),
      child: CardShape(
        width: 120,
        height: 80,
        color: Theme.of(context).colorScheme.primary,
        child: Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.all(8),
          child: Text(
            number.substring(number.length - 4),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );

    var actionsButtons = [
      TextButton(
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_rounded,
                color: Theme.of(context).colorScheme.primary),
            Text("Пополнить",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
      TextButton(
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_circle_right,
              color: Theme.of(context).colorScheme.primary,
            ),
            Text("Перевести",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
      TextButton(
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contactless_sharp,
                color: Theme.of(context).colorScheme.primary),
            Text("Оплатить",
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    ];

    var accountOperationsButton = Flexible(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 100,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(beige),
            shape:
            MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Операции по счету",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );

    var accountRequisites = Flexible(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 100,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => AccountRequisitesWidget(cardNumber: number)
            )
            );
          },
          style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(beige),
            shape:
            MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Реквизиты счета",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );

    var accountActions =  SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 340,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            accountOperationsButton,
            accountRequisites
          ],
        ),
      ),
    );

    var cardRequisites = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: beigeGoldFieldDecoration,
        child: Column(
          children: [

            Row(
              children: [
                Text(
                  "Реквизиты карты",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),

                Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {  },
                          child: Text(
                            "Показать",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary
                            ),
                          ),
                        )
                    )
                )
              ],
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: lightGoldFieldDecoration,
              child: Row(
                children: [
                  SelectableText(
                    number,
                    style: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.copy,
                          color: Colors.grey,
                        )),
                  )
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    decoration: lightGoldFieldDecoration,
                    child: Row(
                      children: [
                        SelectableText(
                          expirationDate,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.copy,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    height: 50,
                    decoration: lightGoldFieldDecoration,
                    child: Row(
                      children: [
                        SelectableText(
                          cvv.toString(),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.copy,
                                color: Colors.grey,
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              cardShape,
              Container(
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 340,
                    decoration: beigeGoldFieldDecoration,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: actionsButtons),
                  ),
                ),
              ),
              accountActions,
              cardRequisites
            ],
          ),
        ),
      ),
    );
  }
}
