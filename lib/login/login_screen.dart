import 'package:dgsys_app/models/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginScreen>{
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool hasFailed = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8,
      children: <Widget>[
        Visibility(
          visible: hasFailed,
          child: Text("Wrong username or password"),
        ),
        inputField(
          emailTextController,
          false,
          'Email'
        ),
        inputField(
          passwordTextController,
          true,
          'Password'
        ),
        ProgressButton(
          defaultWidget:
          Text("Log in"),
          progressWidget: CircularProgressIndicator(),
          onPressed: () async {
            await appState.authenticate(emailTextController.text, passwordTextController.text);
            if (! appState.isAuthenticated){
              setState(() {
                hasFailed = true;
              });
             }
            },
        )]);
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen>{
  final passwordTextController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  /*
  {
    "username": "testmember",
    "first_name": "Gris",
    "last_name": "Kvegesen",
    "email": "kveg@dg.no",
    "membership": 1,
    "membership_label": "Non-Member",
    "account_balance": 1320.0
}
   */
  bool hasFailed = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        body: Stack(
            children: <Widget>[
              Image.asset(
                'assets/login-bg.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                    width: 300,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 8,
                              children: <Widget>[
                                Visibility(
                                  visible: hasFailed,
                                  child: Text("Wrong username or password"),
                                ),
                                inputField(
                                    emailController,
                                    false,
                                    'Username'
                                ),
                                inputField(
                                    passwordTextController,
                                    true,
                                    'Password'
                                ),
                                ProgressButton(
                                  defaultWidget:
                                  Text("Log in"),
                                  progressWidget: CircularProgressIndicator(),
                                  onPressed: () async {
                                    await appState.authenticate(emailController.text, passwordTextController.text);
                                    if (! appState.isAuthenticated){
                                      setState(() {
                                        hasFailed = true;
                                      });
                                    }
                                  },
                                ),
                              ]),
                        ]
                    )
                ),
              )]));
  }
}

Widget inputField(TextEditingController controller, bool obscureText, String hint){
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      contentPadding:
      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
    ),
  );
}

class LoginOrRegisterScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            ),
            RaisedButton(
              child: Text("Register"),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen())
                );
              },
            )
          ],
        ));
  }

  @override
  State<StatefulWidget> createState() {
    return _LoginOrRegisterState();
  }
}

enum loginMode { initial, login, register }

class _LoginOrRegisterState  extends State<LoginOrRegisterScreen>{
  loginMode mode = loginMode.initial;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
        body: Stack(
            children: <Widget>[
              Image.asset(
                'assets/login-bg.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                    width: 300,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 8,
                              children: this.createContents()
                          )]
                    )
                ),
              )]));
  }

  List<Widget> createContents() {
    if (mode == loginMode.initial){
      return [
        RaisedButton(
          child: Text("Login"),
          onPressed: (){
            setState(() {
              mode = loginMode.login;
            });
          },
        ),
        RaisedButton(
          child: Text("Register"),
          onPressed: (){
            setState(() {
              mode = loginMode.register;
            });
          },
        )
      ];
    }
    else if (mode == loginMode.login){
      return [LoginScreen()];
    }
    else if (mode == loginMode.register){
      return [RegisterScreen()];
    }
  }
}