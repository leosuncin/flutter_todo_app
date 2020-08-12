import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const SecondaryButton(
      {Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FlatButton(
      minWidth: double.infinity,
      color: theme.colorScheme.background,
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
