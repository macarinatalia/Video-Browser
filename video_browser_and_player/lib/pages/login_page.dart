import 'package:flutter/material.dart';
import 'package:video_browser_and_player/pages/video_list_page.dart';
import '../model/user.dart';
import '../utilities/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _hidePassword = true;
  bool _rememberMe = false;

  User newUser = User();

  final _formKey = GlobalKey<FormState>();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Image.asset('assets/pixabay_logo_icon.png'),
              const SizedBox(height: 15),
              _loginForm(),
              const SizedBox(height: 15),
              _passwordForm(),
              _rememberMeCheckBox(),
              _signInBth(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return TextFormField(
      controller: _loginController,
      decoration: const InputDecoration(
        labelText: 'Login',
        hintText: 'Enter email',
        prefixIcon: Icon(Icons.person),
        enabledBorder: myTextFieldBorderStyle,
        focusedBorder: myTextFieldBorderStyle,
        errorBorder: myTextFieldBorderStyle,
        focusedErrorBorder: myTextFieldBorderStyle,
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => newUser.login = value!,
      validator: _validateLogin,
    );
  }

  Widget _passwordForm() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _hidePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter password',
        prefixIcon: const Icon(Icons.key),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
        enabledBorder: myTextFieldBorderStyle,
        focusedBorder: myTextFieldBorderStyle,
        errorBorder: myTextFieldBorderStyle,
        focusedErrorBorder: myTextFieldBorderStyle,
      ),
      onSaved: (value) => newUser.password = value!,
      validator: _validatePassword,
    );
  }

  Widget _rememberMeCheckBox() {
    return Container(
      child: Row(children: [
        Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value!;
              });
            }),
        const Text('Remember me', style: myLabelSmallStyle),
      ]),
    );
  }

  Widget _signInBth() {
    return TextButton(
      onPressed: _signIn,
      child: const Text(
        'Sign in',
        style: mySignInTextStyle,
      ),
      style: mySignInBtnStyle,
    );
  }

  String? _validateLogin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Login is required';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rassword is required';
    } else {
      return null;
    }
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideoListPage(user: newUser)),
      );
    }
  }
}
