import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/Network/api_link.dart';
import 'Screens/courriers/add_courier.dart';
import 'Screens/courriers/important_courier.dart';
import 'Screens/home_sccren/home_screen.dart';
import 'Screens/login/login_page.dart';
import 'Screens/welcome_screen/welcome_page.dart';
int? initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  runApp(MyApp());
}





class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return Wrapper();
  }
}





class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Courier Manager',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home' : (context) => const HomePage(),
        '/onboard' : (context) => const WelcomePage(),
        '/add_courrier' : (context)=>const AddCourier(),
        '/favorits' : (context)=>const ImportantCouriers(),
        '/splash_screen' : (context)=> const SplashScreen(),
      },
      initialRoute: initScreen == 1 ? '/splash_screen' : '/onboard',
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;
  bool isLoggedIn = false;
  CheckLogin() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString('token').toString();
    String refreshToken = pref.getString('refresh_token').toString();
    if(token != null){
      var _link = Uri.parse('$api/Authentication/data');
      var respo = await http.get(_link, headers: {
        "Content-type":"application/json",
        "Accept":"application/json",
        "Authorization" : "Bearer "+token.toString()
      });
      if(respo.statusCode == 401){
        var url = Uri.parse('$api/Authentication/refresh');
        var result = await  http.post(url, headers: {
          "Content-type":"application/json",
          "Accept":"application/json"
        }, body:jsonEncode({
          "refreshToken" : refreshToken
        }));
        if(result.statusCode == 200){
          String newToken = jsonDecode(result.body)['accessToken'];
          String newRefreshToken = jsonDecode(result.body)['refreshToken'];
          pref.setString('token', newToken);
          pref.setString('refresh_token', newRefreshToken);
          isLoggedIn = true;
          setState(() {
            isLoading = false;
          });
        }
        else{
          isLoggedIn = false;
          setState(() {
            isLoading = false;
          });
        }
      }
      else if(respo.statusCode == 200){
        isLoggedIn = true;
        setState(() {
          isLoading = false;
        });
      }
    } else{
      isLoggedIn = false;
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? SafeArea(
          child: Center(
            child: SpinKitWave(color: testColor,)
            ,)
      ) :
      isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
