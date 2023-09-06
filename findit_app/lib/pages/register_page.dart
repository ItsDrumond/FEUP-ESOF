import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:findit_app/utils/global.dart' as global;
import '../utils/app_user.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  ScreenConfig screen = ScreenConfig();

  // text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  // memory management
  @override
  void dispose() {
    _nameController .dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  // add user details to firebase
  Future addUserDetails(String email, String name) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('Users').doc(email);

    Map <String, dynamic> user = {
      'email' : email,
      'name' : name,
      'picture' : "https://firebasestorage.googleapis.com/v0/b/findit-65f66.appspot.com/o/images%2Fdefaul.png?alt=media&token=26cfe1cb-0d53-4d02-b05d-a308c830fd40",
      'favorites' : [],
      'applied' : [],
    };
    
    documentReference.set(user);
  }

  // sign up method
  Future signUp() async{

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
    if(_nameController.text.isEmpty){

      // Display error message
      Fluttertoast.showToast(
        msg: "Please provide your first and last name.",
        fontSize: 16,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );

      // remove loading circle
      Navigator.of(context).pop();
    }
    else if(_emailController.text.isEmpty){

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
    else if(_passwordController.text.trim() == _passwordConfirmationController.text.trim()){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
        );

        addUserDetails(_emailController.text.trim(), _nameController.text.trim());

        // remove loading circle
        Navigator.of(context).pop();

      } on FirebaseException catch (error){

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
        msg: "Your password and confirmation password do not match.",
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
    var snapshot = await FirebaseFirestore.instance.collection('Users').doc(_emailController.text.trim()).get();
    if(snapshot.exists){
      global.currentUser = AppUser.fromFirestore(snapshot);
    }
  }

  Widget buildNameWithSignUn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: screen.blockSizeVertical * 2.5,
        ),
        const Text(
          'Name',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: screen.blockSizeVertical * 1.2,
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
          height: screen.blockSizeVertical * 6.2,
          width: screen.blockSizeHorizontal * 90.5,
          child: TextField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            style: const TextStyle(
              color: Colors.black87
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top:14),
              prefixIcon: Icon(
                Icons.account_box,
                color: Color(0xff800000),
              ),
              hintText: 'Name',
              hintStyle: TextStyle(
                color: Colors.black38
              ),
            ),
          ),
        ),
      ],
    );
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
          height: screen.blockSizeVertical * 1.2,
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
          height: screen.blockSizeVertical * 6.2,
          width: screen.blockSizeHorizontal * 90.5,
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
          height: screen.blockSizeVertical * 1.2,
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
          height: screen.blockSizeVertical * 6.2,
          width: screen.blockSizeHorizontal * 90.5,
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

  Widget buildConfirmPassword(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Confirm Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: screen.blockSizeVertical * 1.2,
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
          height: screen.blockSizeVertical * 6.2,
          width: screen.blockSizeHorizontal * 90.5,
          child: TextField(
            controller: _passwordConfirmationController,
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
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                color: Colors.black38
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSignUpButton(){
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
            await signUp();
            await readUser();
          },
          child: const Text(
            'SIGN ME UP',
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

  Widget buildSignIn(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already a member? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),
        ),
        GestureDetector(
          onTap: widget.showLoginPage,
          child: const Text(
          'Sign In',
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

  @override
  Widget build(BuildContext context) {
    screen.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screen.blockSizeVertical * 10.7,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: screen.blockSizeVertical * 7,  
              ),
            ),
            SizedBox(
                height: screen.blockSizeVertical * 4.3,
            ),
            buildNameWithSignUn(),
            SizedBox(
              height: screen.blockSizeVertical * 2.15,
            ),
            buildEmail(),
            SizedBox(
              height: screen.blockSizeVertical * 2.15,
            ),
            buildPassword(),
            SizedBox(
              height: screen.blockSizeVertical * 2.15,
            ),
            buildConfirmPassword(),
            SizedBox(
              height: screen.blockSizeVertical * 3.2,
            ),
            buildSignIn(),
            SizedBox(
              height: screen.blockSizeVertical * 3.2,
            ),
            buildSignUpButton(),
          ]
        ),
      ),
    );
  }
}