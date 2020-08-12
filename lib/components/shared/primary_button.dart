import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const PrimaryButton({Key key, @required this.text, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FlatButton(
      minWidth: double.infinity,
      color: theme.colorScheme.primary,
      child: Text(
        text,
        style: TextStyle(
          color: theme.accentTextTheme.button.color,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
