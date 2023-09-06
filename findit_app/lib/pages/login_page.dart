import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_app/pages/reset_page.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:findit_app/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_user.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;


  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late AppUser appUser;
  ScreenConfig screen = ScreenConfig();

  // remember user details
  bool isChecked = false;
  
  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if((prefs.getString('email') != null) && (prefs.getString('password') != null)){
      _emailController.text = prefs.getString('email')!;
      _passwordController.text = prefs.getString('password')!;
      isChecked = true;
      setState(() {});
    }
  }

  void rememberUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(isChecked){
      prefs.setString('email', _emailController.text);
      prefs.setString('password', _passwordController.text);
    }
    else{
      prefs.remove('email');
      prefs.remove('password');
    }
  }

  // sign in method
  Future signIn() async{
    
    // loading circle
    showDialog(
      context: context,
      builder: (context){
        return Center(
          child: CircularProgressIndicator(
            color: const Color.fromRGBO(108, 80, 82, 1),
            backgroundColor: Colors.grey.shade100,
          ),
        );
      }
    );
    if((_emailController.text.isNotEmpty)){
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
        );
        
        // remove loading circle
        Navigator.of(context).pop();
      
      } on FirebaseAuthException catch (error){
        
        // Display error message
        Fluttertoast.showToast(
          msg: error.message.toString(),
          fontSize: 16,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
          gravity: ToastGravity.CENTER,
        );

        // remove loading circle
        Navigator.of(context).pop();
      }
    }
    else{

      // Display error message
      Fluttertoast.showToast(
      msg: "An email adress must be provided.",
      fontSize: 16,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
      gravity: ToastGravity.CENTER,
      );

      // remove loading circle
      Navigator.of(context).pop();
    }
  }

  // retrieve user information from firebase
  Future<void> readUser() async{

    // loading circle
    showDialog(
      context: context,
      builder: (context){
        return Center(
          child: CircularProgressIndicator(
            color: const Color.fromRGBO(108, 80, 82, 1),
            backgroundColor: Colors.grey.shade100,
          ),
        );
      }
    );
    if(_emailController.text.isNotEmpty){
      try{
        var snapshot = await FirebaseFirestore.instance.collection('Users').doc(_emailController.text.trim()).get();
        if(snapshot.exists){
          global.currentUser = AppUser.fromFirestore(snapshot);
        }

        // remove loading circle
        Navigator.of(context).pop();

      } on FirebaseAuthException catch (error){
        
        // Display error message
        Fluttertoast.showToast(
          msg: error.message.toString(),
          fontSize: 16,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
          gravity: ToastGravity.CENTER,
        );

        // remove loading circle
        Navigator.of(context).pop();
      }
    }
    else{

      // Display error message
      Fluttertoast.showToast(
      msg: "An email adress must be provided.",
      fontSize: 16,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
      gravity: ToastGravity.CENTER,
      );

      // remove loading circle
      Navigator.of(context).pop();
    }
  }

  // check shared preferences
  @override
  void initState() {
    getData();
    super.initState();
  }

  // memory management
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget buildEmail(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Sign In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: screen.blockSizeVertical * .1,
      ),
      const Text(
        'Email',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: screen.blockSizeVertical * 1.05,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0,2)
            ),
          ]
        ),
        height: screen.blockSizeVertical * 6.5,
        width: screen.blockSizeHorizontal * 90,
        child: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            color: Colors.black87
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top:14),
            prefixIcon: Icon(
              Icons.email,
              color: Color(0xff800000),
            ),
            hintText: 'Email',
            hintStyle: TextStyle(
              color: Colors.black38
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget buildPassword(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        'Password',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: screen.blockSizeVertical * 1.05,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0,2)
            ),
          ]
        ),
        height: screen.blockSizeVertical * 6.5,
        width: screen.blockSizeHorizontal * 90,
        child: TextField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(
            color: Colors.black87
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top:14),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff800000),
            ),
            hintText: 'Password',
            hintStyle: TextStyle(
              color: Colors.black38
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget buildRemember(){
  return SizedBox(
    height: screen.blockSizeVertical * 2.2,
    child: Row(
      children: <Widget> [
        SizedBox(
          width: screen.blockSizeHorizontal * 2,
        ),
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            value: isChecked,
            checkColor: const Color(0xff800000),
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
        ),
        const Text(
          'Remember Me',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

  Widget buildForgot(){
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
              return const ResetPage();
              }),
            );
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget buildSignUp(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),
        ),
        GestureDetector(
          onTap: widget.showRegisterPage,
          child: const Text(
          'Sign Up',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton(){
    return Center(
      child: SizedBox(
        width: screen.blockSizeHorizontal * 65,
        height: screen.blockSizeVertical * 9.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          onPressed: () async{
            await readUser();
            await signIn();
            rememberUser();
            global.currentUser.fillFavorites();
            global.currentUser.fillApplied();
          },
          child: const Text(
            'LOGIN',
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    screen.init(context);
    return Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: screen.blockSizeVertical * 19.3,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: screen.blockSizeVertical * 7,
              ),
            ),
            SizedBox(
              height: screen.blockSizeVertical * 8.6,
            ),
            buildEmail(),
            SizedBox(
              height: screen.blockSizeVertical * 2.15,
            ),
            buildPassword(),
            SizedBox(
              height: screen.blockSizeVertical * 1.65,
            ),
            Row(
              children: [
                buildRemember(),
                SizedBox(
                  width: screen.blockSizeHorizontal * 29,
                ),
                buildForgot(),
              ],
            ),
            SizedBox(
              height: screen.blockSizeVertical * 3.2,
            ),
            buildSignUp(),
            SizedBox(
              height: screen.blockSizeVertical * 6.5,
            ),
            buildLoginButton(),
          ],
        ),
      ),
    );
  }
}
