import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/components/shared/primary_button.dart';
import 'package:flutter_todo_app/components/shared/secondary_button.dart';
import 'package:flutter_todo_app/providers/auth.dart';
import 'package:flutter_todo_app/screens/home_screen.dart';
import 'package:flutter_todo_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();
  var email;
  var password;
  var _isLoading = false;

  _submit() async {
    if (_isLoading) return;

    if (_form.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      _form.currentState.save();
      _scaffold.currentState.showSnackBar(SnackBar(
          content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text('Logging...'),
        ],
      )));

      try {
        await context.read<Auth>().login(email, password);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } on LoginException catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Authentication error'),
            content: Text(e.toString()),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('CLOSE'),
              ),
            ],
          ),
        );
      } finally {
        _scaffold.currentState.hideCurrentSnackBar();
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      key: _scaffold,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: mq.orientation == Orientation.portrait
                ? EdgeInsets.all(mq.size.width / 6)
                : EdgeInsets.symmetric(horizontal: mq.size.width / 4),
            child: Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  bottom: 20,
                  left: 20,
                ),
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
                    PrimaryButton(
                      text: 'Sign in',
                      onPressed: _submit,
                    ),
                    SecondaryButton(
                      text: 'Sign up',
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
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
