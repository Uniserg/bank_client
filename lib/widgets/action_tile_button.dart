import 'package:flutter/material.dart';

class ActionTileButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  final bool endIcon;
  final Color? textColor;

  const ActionTileButton(
      {super.key,
        required this.title,
        required this.icon,
        required this.onTap,
        this.endIcon = true,
        this.textColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title,
          style:
          Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
      trailing: endIcon
          ? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey.withOpacity(0.1)),
          child: const Icon(Icons.keyboard_arrow_right))
          : null,
    );
  }
}