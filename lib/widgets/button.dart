import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final void Function()? onPressed;

  const MyButton({
    super.key,
    this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor) ,
            foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
            shape:
            MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: Theme.of(context).primaryColor, width: 2)
                ))),
        onPressed: onPressed,
        child: const Text('Заказы'),
      ),
    );
  }
}
