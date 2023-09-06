import 'package:findit_app/authentication/main_page.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  ScreenConfig screen = ScreenConfig();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    screen.init(context);
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: screen.blockSizeVertical * 21,
          ),
          Center(
            child: SvgPicture.asset(
              'assets/images/logo_with_text.svg'
            ),
          ),
          SizedBox(
            height: screen.blockSizeVertical * 13,
          ),
          Center(
            child: SizedBox(
              width: screen.blockSizeHorizontal * 65,
              height: screen.blockSizeVertical * 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () async{
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("showLoginPage", true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const MainPage();
                      },
                    ),
                  );
                },
                child: const Text(
                  'Get Started',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(228, 208, 210, 1),
                      fontFamily: 'Inter',
                      fontSize: 28,
                      letterSpacing: 0.10000000149011612,
                      fontWeight: FontWeight.bold,
                      height: 0.7142857142857143),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
