import 'package:findit_app/utils/screen_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  ScreenConfig screen = ScreenConfig();

  Future signOut() async{
    FirebaseAuth.instance.signOut();
  }

  Widget buildLogOutButton(){
    return Center(
      child: SizedBox(
        width: screen.blockSizeHorizontal * 55,
        height: screen.blockSizeVertical * 10,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: () {
            signOut();
          },
          child: const Text(
            'Logout',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromRGBO(228, 208, 210, 1),
                fontFamily: 'Inter',
                fontSize: 28,
                letterSpacing: 0.09999990463256836,
                fontWeight: FontWeight.bold,
                height: 1),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screen.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          height: screen.blockSizeVertical * 3.22,
          ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: screen.blockSizeVertical * 28,
          ),
          buildLogOutButton(),
        ],
      ),
    );
  }
}