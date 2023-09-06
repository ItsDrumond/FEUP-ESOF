import 'package:findit_app/utils/screen_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {

  ScreenConfig screen = ScreenConfig();

  // text controllers
  final _emailController = TextEditingController();

  // memory management
  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{

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

    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim()
      );

      // Display Success
      Fluttertoast.showToast(
        msg: "A link was sent to your email.",
        fontSize: 16,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );

      // remove loading circle
      Navigator.of(context).pop();

    } on FirebaseAuthException catch(error){
        
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

  Widget buildEmail(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: screen.blockSizeVertical * 1.5,
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
          height: screen.blockSizeVertical * 7,
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

  Widget buildResetText(){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screen.blockSizeHorizontal * 6
      ),
      child: const Text(
        "Enter your email so we can send you a reset password link",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget buildResetButton(){
    return Center(
      child: SizedBox(
        width: screen.blockSizeHorizontal * 50,
        height: screen.blockSizeVertical * 7.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            passwordReset();
          },
          child: const Text(
            'Reset Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(228, 208, 210, 1),
              fontFamily: 'Inter',
              fontSize: 20,
              letterSpacing: 0.09999990463256836,
              fontWeight: FontWeight.bold,
              height: 1
            ),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: screen.blockSizeVertical * 22,
            ),
            buildResetText(),
            SizedBox(
              height: screen.blockSizeVertical * 5.5,
            ),
            buildEmail(),
            SizedBox(
              height: screen.blockSizeVertical * 4,
            ),
            buildResetButton(),
          ],
        ),
      )   
    );
  }
}