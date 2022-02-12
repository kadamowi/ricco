import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screen/login_page.dart';
import 'screen/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pl')],
      title: 'Reksio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.yellow[200],
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Reksio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          //print(snapshot.error);
          return Text('Problem autoryzacji: $snapshot.error');
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          User? user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return const LoginPage();
          } else {
            //print('Zalogowany: ${user.email}');
            String userName = 'KA';
            if (user.email != 'kadamowi@gmail.com') {
              userName = user.email?.substring(2).toUpperCase()??'XX';
            }
            return HomePage(userEmail: user.email.toString());
          }
        }
        return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: const Image(
              image: AssetImage('images/Reksio.png'),
            ));
      },
    );
  }
}
