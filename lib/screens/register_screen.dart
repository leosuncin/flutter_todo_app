import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/components/shared/primary_button.dart';
import 'package:flutter_todo_app/components/shared/secondary_button.dart';
import 'package:flutter_todo_app/providers/auth.dart';
import 'package:flutter_todo_app/screens/home_screen.dart';
import 'package:flutter_todo_app/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _screen = GlobalKey<ScaffoldState>();
  var name;
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
      _screen.currentState.showSnackBar(SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Registering...'),
          ],
        ),
      ));

      try {
        await context.read<Auth>().register(name, email, password);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } on RegisterException catch (e) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Validation error'),
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
        _screen.currentState.hideCurrentSnackBar();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return Scaffold(
      key: _screen,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: mq.orientation == Orientation.portrait
                ? EdgeInsets.all(mq.size.width / 6)
                : EdgeInsets.symmetric(horizontal: mq.size.width / 3),
            height: 400,
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
                          labelText: 'Name',
                        ),
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Name should not be empty';

                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocusNode,
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
                      PrimaryButton(
                        text: 'Sign up',
                        onPressed: _submit,
                      ),
                      SecondaryButton(
                        text: 'Sign in',
                        onPressed: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          }
                        },
                      ),
                    ],
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
