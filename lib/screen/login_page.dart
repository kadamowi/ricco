import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'alert_dialog.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String messageErr = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 15.0),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Column(
              children: const [
                SizedBox(height: 10),
                Center(child: Text('Reksio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
              ],
            ),
          ),
          // Logo
          const Expanded(
            child: SizedBox(
                child: Image(
                  image: AssetImage('images/Reksio.png'),
                )
            ),
          ),
          Form(
            key: _formStateKey,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      icon: Icon(Icons.person),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Wprowadź email';
                      }
                      return null;
                    },
                    onSaved: (value) => email = value!.trim().toLowerCase(),
                    maxLength: 50,
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Hasło",
                      icon: Icon(Icons.lock),
                      counterText: "",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Wprowadź hasło';
                      }
                      return null;
                    },
                    onSaved: (value) => password = value!.trim(),
                    maxLength: 20,
                  ),
                  Visibility(
                    visible: MediaQuery.of(context).viewInsets.bottom == 0,
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              child: const Text('Zapomniałeś hasła ?',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  )),
                              onTap: () {
                                _formStateKey.currentState!.save();
                                if (email.length <= 3) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const CustomAlertDialog(
                                        type: AlertDialogType.error,
                                        title: "Reksio",
                                        content: "Nie podałeś adresu mailowego",
                                      );
                                    },
                                  );
                                } else {
                                  FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                        type: AlertDialogType.info,
                                        title: "Reksio",
                                        content: "Na podany adres: $email został wysłany link do zmiany hasła",
                                      );
                                    },
                                  );
                                }
                              }),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  // LOGIN
                  Container(
                    //margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formStateKey.currentState!.validate()) {
                          _formStateKey.currentState!.save();
                          messageErr = '';
                          print('signInWithEmailAndPassword: $email / $password');
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(userEmail: email), //HomeScreen(),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              print('FirebaseAuth: '+e.code);
                              switch (e.code) {
                                case 'user-not-found':
                                  messageErr = 'Brak użytkownika';
                                  break;
                                case 'wrong-password':
                                  messageErr = 'Błędne hasło';
                                  break;
                                case 'invalid-email':
                                  messageErr = 'Błędny email';
                                  break;
                                default:
                                  messageErr = e.code;
                              }
                            });
                          }
                        }
                      },
                      child: const Text("Zaloguj się",
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ),
                  ),
                  Visibility(
                    visible: messageErr.isNotEmpty,
                    child: Text(
                      messageErr,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
