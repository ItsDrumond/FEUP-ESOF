import 'dart:io';

import 'package:findit_app/utils/screen_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:findit_app/utils/global.dart' as global;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  ScreenConfig screen = ScreenConfig();
  final user = FirebaseAuth.instance.currentUser!;
  File? image;

  Future deleteUserAccount() async{

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
      await user.delete();
    } catch(e){
      
      // Display error message
      Fluttertoast.showToast(
        msg: "Please log in again and remake this request so we can be sure that you want your account deleted.",
        fontSize: 16,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );
    }
    // remove loading circle
    Navigator.of(context).pop();
  }

  Future deleteUserData() async{
    await global.currentUser.firestoreDelete();
  }

  Future pickImage(ImageSource source) async{

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
      final image = await ImagePicker().pickImage(source: source);
      if(image == null){
        return;
      }
      
      String uniqueFileName =   DateTime.now().microsecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDir = referenceRoot.child('images');

      if(global.currentUser.picture != "https://firebasestorage.googleapis.com/v0/b/findit-65f66.appspot.com/o/images%2Fdefaul.png?alt=media&token=26cfe1cb-0d53-4d02-b05d-a308c830fd40"){
        await FirebaseStorage.instance.refFromURL(global.currentUser.picture).delete();
      }

      Reference referenceImage = referenceDir.child(uniqueFileName);
      await referenceImage.putFile(File(image.path));
      global.currentUser.picture = await referenceImage.getDownloadURL();
      global.currentUser.firestoreUpdate();

      setState (() => this.image = File(image.path));
      
    } on PlatformException catch(error){

      // Display error message
      Fluttertoast.showToast(
        msg: error.message.toString(),
        fontSize: 16,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );
    }

    // remove loading circle
    Navigator.of(context).pop();
  }

  Widget buildProfilePic(){
    return Stack(
      children: [
        CircleAvatar(
          radius: screen.blockSizeHorizontal * 28,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: screen.blockSizeHorizontal * 26.5,
            backgroundColor: const Color.fromARGB(255, 157, 121, 123),
            backgroundImage: Image.network(global.currentUser.picture).image,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(160, 160, 0, 0),
              child: RawMaterialButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: screen.blockSizeVertical * 20,
                        color: const Color.fromARGB(255, 157, 121, 123),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(55, 8, 12, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed:() {
                                  pickImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Browse Gallery',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing: 0.09999990463256836,
                                    height: 1
                                  ),
                                ),
                              ),
                              const Text(
                                'OR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  letterSpacing: 0.09999990463256836,
                                  fontWeight: FontWeight.bold,
                                  height: 1
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromRGBO(55, 8, 12, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed:() {
                                  pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Use the Camera',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    letterSpacing: 0.09999990463256836,
                                    height: 1
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screen.blockSizeVertical * 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                elevation: 0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 30,
                  color: Color.fromRGBO(55, 8, 12, 1),
                )
              )
            ),
          ),
        ),
      ] 
    );
  }

  Widget buildUserName(){
    return Center(
      child: Text(
        'Name: ${global.currentUser.name}',
        style: const TextStyle(
          color: Colors.white, 
          fontFamily: 'Inter',
          fontSize: 20,
        ),
      ),
    );
  }

  Widget buildUserFavoritesNumber(){
    return Text(
      'Total Favorites: ${global.currentUser.favoritesID.length}',
      style: const TextStyle(
        color: Colors.white, 
        fontFamily: 'Inter',
        fontSize: 20,
      ),
    );
  }

  Widget buildUserAppliedNumber(){
    return Text(
      'Total Applied Jobs: ${global.currentUser.appliedID.length}',
      style: const TextStyle(
        color: Colors.white, 
        fontFamily: 'Inter',
        fontSize: 20,
      ),
    );
  }

  Widget buildUserInfo(){
    return Container(
      height: screen.blockSizeVertical * 16,
      width: screen.blockSizeHorizontal * 75,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(83, 45, 49, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          const SizedBox(
            height: 5,
          ),
          buildUserName(),
          const SizedBox(
            height: 5,
          ),
          buildUserFavoritesNumber(),
          const SizedBox(
            height: 5,
          ),
          buildUserAppliedNumber(),
          const SizedBox(
            height: 5,
          )
        ]
      ),
    );
  }

  Widget buildDeleteAccount(){
    return SizedBox(
      width: screen.blockSizeHorizontal * 50,
      height: screen.blockSizeVertical * 8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Delete Account',
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
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: screen.blockSizeVertical * 20,
                color: const Color.fromARGB(255, 157, 121, 123),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: screen.blockSizeVertical * 1,
                      ),
                      const Text(
                        'Are you sure? This action is IRREVERSIBLE.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 16,
                          letterSpacing: 0.09999990463256836,
                          height: 1
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(55, 8, 12, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed:() async{
                          await deleteUserData();
                          await deleteUserAccount();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            letterSpacing: 0.09999990463256836,
                            height: 1
                          ),
                        ),
                      ),
                      const Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          letterSpacing: 0.09999990463256836,
                          fontWeight: FontWeight.bold,
                          height: 1
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(55, 8, 12, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Inter',
                            fontSize: 16,
                            letterSpacing: 0.09999990463256836,
                            height: 1
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screen.blockSizeVertical * 4,
              ),
              buildProfilePic(),
              SizedBox(
                height: screen.blockSizeVertical * 7,
              ),
              buildUserInfo(),
              SizedBox(
                height: screen.blockSizeVertical * 8,
              ),
              buildDeleteAccount(),
            ]
          ),
        ),
      ),
    );
  }
}