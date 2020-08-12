import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

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
          height: 320,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _form,
                autovalidate: true,
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
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Email should not be empty';

                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocusNode,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Password should not be empty';

                        if (value.length < 8)
                          return 'Password too short (at least 8 characters required)';

                        return null;
                      },
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
