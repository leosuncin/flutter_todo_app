import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/providers/todo_list.dart';

class CreateTaskForm extends StatefulWidget {
  @override
  _CreateTaskFormState createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final _form = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isDone = false;
  bool _hasError = false;
  String text;

  _submit() async {
    if (!_form.currentState.validate()) return;

    setState(() {
      _isSaving = true;
    });
    _form.currentState.save();
    try {
      await _form.currentContext.read<TodoList>().createTodo(text);
      setState(() {
        _isDone = true;
      });
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Form(
        key: _form,
        child: Column(
          children: [
            buildTextField(theme),
            if (!_hasError) SizedBox(height: 10),
            _isSaving
                ? CircularProgressIndicator()
                : MaterialButton(
                    child: _isDone ? Icon(Icons.check) : Text('Create'),
                    color: theme.primaryColorDark,
                    textColor: Colors.white,
                    onPressed: _submit,
                  ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextField(ThemeData theme) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: theme.accentColor,
      ),
    );

    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Task',
        fillColor: Colors.white,
        filled: true,
        enabledBorder: border,
        focusedBorder: border,
      ),
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        setState(() {
          _hasError = value.isEmpty || value.length < 2;
        });

        if (value.isEmpty) {
          return 'Please type something';
        }

        if (value.length < 2) {
          return 'Please type more than 2 characters';
        }

        return null;
      },
      onFieldSubmitted: (_) => _submit(),
      onSaved: (value) {
        setState(() {
          text = value;
        });
      },
    );
  }
}
