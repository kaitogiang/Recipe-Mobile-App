import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../shared/confirm_dialog.dart';

import 'auth_manager.dart';

enum AuthMode { signup, login }

class AuthCard extends StatefulWidget {
  const AuthCard({
    super.key,
  });

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        // Sign user up
        await context.read<AuthManager>().signup(
              _authData['email']!,
              _authData['password']!,
            );
      }
    } catch (error) {
      if (context.mounted) {
        showErrorDialog(
            context,
            (error is HttpException)
                ? error.toString()
                : 'Authentication failed');
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.sizeOf(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signup ? 570 : 350,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.85,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _authMode == AuthMode.login ?
                Text('ĐĂNG NHẬP', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
                ),) : Text('ĐĂNG KÝ TÀI KHOẢN', style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
                ),),
                const SizedBox(height: 20,),
                _buildEmailField(),
                const SizedBox(height: 20,),
                _buildPasswordField(),
                if (_authMode == AuthMode.signup) const SizedBox(height: 20,),
                if (_authMode == AuthMode.signup) _buildPasswordConfirmField(),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isSubmitting,
                  builder: (context, isSubmitting, child) {
                    if (isSubmitting) {
                      return const CircularProgressIndicator();
                    }
                    return _buildSubmitButton();
                  },
                ),
                _buildAuthModeSwitchButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return TextButton(
      onPressed: _switchAuthMode,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child:
          Text('${_authMode == AuthMode.login ? 'TẠO TÀI KHOẢN MỚI' : 'QUAY VỀ ĐĂNG NHẬP'}'),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
        fixedSize: Size(300, 50)
      ),
      child: Text(_authMode == AuthMode.login ? 'ĐĂNG NHẬP' : 'ĐĂNG KÝ'),
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      enabled: _authMode == AuthMode.signup,
      decoration: const InputDecoration(labelText: 'Xác nhận mật khẩu', border: OutlineInputBorder(), 
      prefixIcon: Stack(alignment: Alignment.center,children: [Icon(Icons.lock_outline), Padding(
        padding: EdgeInsets.only(left: 6, bottom: 3),
        child: Icon(Icons.check),
      )],)),
      obscureText: true,
      validator: _authMode == AuthMode.signup
          ? (value) {
              if (value != _passwordController.text) {
                return 'Mật khẩu không khớp!';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Mật khẩu', border: OutlineInputBorder(), prefixIcon: Icon(Icons.lock)),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'E-Mail',border: OutlineInputBorder(), prefixIcon: Icon(Icons.mail)),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }
}
