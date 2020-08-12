import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var email;
  var password;

  _submit() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      debugPrint(email);
      debugPrint(password);
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: mq.orientation == Orientation.portrait
                ? EdgeInsets.all(mq.size.width / 6)
                : EdgeInsets.symmetric(horizontal: mq.size.width / 3),
            child: Container(
              height: 320,
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Email should not be empty';

                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocusNode,
                          onFieldSubmitted: (_) => _submit(),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Password should not be empty';

                            if (value.length < 8)
                              return 'Password too short (at least 8 characters required)';

                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              password = value;
                            });
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
                          onPressed: _submit,
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
        ),
      ),
    );
  }
}
