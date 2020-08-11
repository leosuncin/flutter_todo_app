import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocusNode,
                    ),
                    SizedBox.fromSize(
                      size: Size(double.infinity, 30),
                    ),
                    FlatButton(
                      minWidth: double.infinity,
                      color: theme.colorScheme.primary,
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: theme.accentTextTheme.button.color,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    FlatButton(
                      minWidth: double.infinity,
                      color: theme.colorScheme.background,
                      child: Text('Sign up'),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
