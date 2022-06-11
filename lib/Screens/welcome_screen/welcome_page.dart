import 'package:flutter/material.dart';
import 'package:sfe_courrier/Screens/components/constatnts.dart';
import 'package:sfe_courrier/Screens/components/welcome_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  int i = 0;
  bool _isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: welcomePrimaryColor,
        elevation: 0,
        actions: [
          Visibility(
            visible: _isVisible,
            child: TextButton(
                onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    )
                  );
                },
                child: const Text(
                    "Passer",
                  style: TextStyle(
                    color: Colors.white
                  ),
                )
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i){
              setState(() {
                if(_controller.page!.round() > 1){
                  _isVisible = false;
                }
                else{
                  _isVisible = true;
                }
              });
            },
            children: const [
              WelcomeWidget(numPage: 1,
                assetPath: "assets/13651-removedbg.png",
                title: "Bienvenue",
                titleColor: Colors.white,
                bottomTitle: "Courier Manager",
                bodyContent: "Bienvenue sur Courier Manager, clicker sur suivant pour connecter",
                textColor: Colors.white70,
              ),
              WelcomeWidget(numPage: 2,
                assetPath: "assets/person (1).png",
                title: "Bienvenue",
                titleColor: Colors.white,
                bottomTitle: "Courier Manager",
                bodyContent: "Courier Manager est un application de gestion des courriers online realiser pour faciliter l'accée aux courriers et leur gestions",
                textColor: Colors.white70,
              ),
              LoginPage(
                numPage: 3,
              ),
            ],
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              alignment: const Alignment(0, 0.75),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const  WormEffect(
                  dotColor: Colors.black,
                  activeDotColor: Colors.white,
                  dotWidth: 10,
                  dotHeight: 10
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              alignment: const Alignment(0.90,0.95),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: IconButton(
                    onPressed: (){
                      setState(() {
                        i +=1;
                        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                      });
                    },
                    icon: Icon(Icons.arrow_forward_ios, color: accentWelcomeColor,),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
