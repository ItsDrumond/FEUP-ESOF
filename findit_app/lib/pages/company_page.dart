import 'package:findit_app/pages/map_page.dart';
import 'package:findit_app/utils/job_card.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/job_info.dart';
import 'package:findit_app/utils/global.dart' as global;

class CompanyPage extends StatefulWidget {

  final JobInfo jobInfo;

  List companyJobs;
  late LatLng companyLocation;

  // Constructor
  CompanyPage({super.key, required this.jobInfo, required this.companyJobs}){
    for(int i = 0; i < companyJobs.length; i++){
      if(jobInfo.jobID == companyJobs[i]["id"]){
        companyJobs.removeAt(i);
      }
    }
  }

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {

  ScreenConfig screen = ScreenConfig();

  // Launch company website method
  Future <void> openURL() async{

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

    final Uri url = Uri.parse(widget.jobInfo.companyURL);
    
    if(url.toString() != "Not Specified" && await canLaunchUrl(url)){
      await launchUrl(url);
    }
    else{
      Fluttertoast.showToast(
        msg: "Unable to access the company website.",
        fontSize: 16,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );
    }
    
    // remove loading circle
    Navigator.of(context).pop();
  }

  // Launch contact method
  Future <void> openContact() async{

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

    final Uri contact = Uri.parse('tel:${widget.jobInfo.companyPhone}');
      
    if(contact.toString() != "Not Specified" && await canLaunchUrl(contact)){
      await launchUrl(contact);
    }
    else{
      Fluttertoast.showToast(
        msg: "Contact is not valid.",
        fontSize: 16,
        timeInSecForIosWeb: 3,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );
    }

    // remove loading circle
    Navigator.of(context).pop();
  }

  // Launch company email method
  Future <void> openEmail (String destination) async {

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

    final Email email = Email(
      recipients: [destination],
      cc: [""],
      bcc: [""],
      subject: "",
      body: "",
    );

    try{
      await FlutterEmailSender.send(email);
    } catch(e){

      // Display error message
      Fluttertoast.showToast(
        msg: "Email is not valid.",
        fontSize: 16,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );
    }

    // remove loading circle
    Navigator.of(context).pop();
  }

  // Gives coordinates of company address
  Future getCoordinatesFromAddress() async{

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
      List <Location> locations = await locationFromAddress(widget.jobInfo.companyAddress);
      widget.companyLocation = LatLng(locations.first.latitude, locations.first.longitude);

      // remove loading circle
      Navigator.of(context).pop();
    
    } catch(e){
      widget.companyLocation = const LatLng(0,0);

      // Display error message
      Fluttertoast.showToast(
      msg: "Could not find any result for the supplied address.",
      fontSize: 16,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
      gravity: ToastGravity.CENTER,
      );

      // remove loading circle
      Navigator.of(context).pop();
    }
  }

  Widget buildCompanyLogo(){
    return Container(
      color: Colors.white,
      child: Image.network(
        widget.jobInfo.companyLogo,
        ),
    );
  }

  Widget buildCompanyName(){
    return Text(
      widget.jobInfo.companyName,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Inter',
        fontSize: 30,
        letterSpacing: 0.25,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget buildCompanyAddress(){
    return GestureDetector(
      onTap: () async {
        await getCoordinatesFromAddress();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context){
            return MapPage(
              jobInfo: widget.jobInfo,
              companyLocation: widget.companyLocation,
            );
          })
        );
      },
      child: Column(
        children: [
          Container(
            width: 110,
            height: 25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100)
              ),
            color: Color.fromRGBO(163, 118, 122, 1),
            ),
            child: const Text(
              "Address",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(55, 8, 14, 1),
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 310,
            child: Text(
              textAlign: TextAlign.center,
              widget.jobInfo.companyAddress,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompanyPhone(){
    return GestureDetector(
      onTap: () {
        openContact();
      },
      child: Column(
        children: [
          Container(
            width: 110,
            height: 25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100)
              ),
            color: Color.fromRGBO(163, 118, 122, 1),
            ),
            child: const Text(
              "Phone",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(55, 8, 14, 1),
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.jobInfo.companyPhone,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompanyEmail(){
    return GestureDetector(
      onTap: () {
        openEmail(widget.jobInfo.companyEmail);
      },
      child: Column(
        children: [
          Container(
            width: 110,
            height: 25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100)
              ),
            color: Color.fromRGBO(163, 118, 122, 1),
            ),
            child: const Text(
              "Email",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(55, 8, 14, 1),
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.jobInfo.companyEmail,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompanyURL(){
    return GestureDetector(
      onTap: () {
        openURL();
      },
      child: Column(
        children: [
          Container(
            width: 110,
            height: 25,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(100)
              ),
            color: Color.fromRGBO(163, 118, 122, 1),
            ),
            child: const Text(
              "Website",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(55, 8, 14, 1),
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.jobInfo.companyURL,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 14,
              height: 1
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCompanyDescription(){
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          child: Text(
            "About",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color.fromRGBO(163, 118, 122, 1),
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.jobInfo.companyDescription,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 16,
            letterSpacing: 0.25,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
  
  Widget buildJobDisplay(){
    return Column(
      children: [
         Text(
          "More jobs from ${widget.jobInfo.companyName}",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(163, 118, 122, 1),
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 550,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.companyJobs.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index){
              return JobCard(
                job: widget.companyJobs[index],
                favorite: global.currentUser.favoritesID.contains(widget.companyJobs[index]["id"]),
                applied: global.currentUser.appliedID.contains(widget.companyJobs[index]["id"]),
              );
            },
          ),
        ),
      ],
    );
  }
  

  Widget buildCompanyDetails(){
    return Column(
      children: <Widget> [
        buildCompanyURL(),
        SizedBox(
          height: screen.blockSizeVertical * 2.4,
        ),
        buildCompanyPhone(),
        SizedBox(
          height: screen.blockSizeVertical * 2.4,
        ),
        buildCompanyEmail(),
        SizedBox(
          height: screen.blockSizeVertical * 2.4,
        ),
        buildCompanyAddress(),
      ],
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            children: <Widget> [
              buildCompanyLogo(),
              SizedBox(
                height: screen.blockSizeVertical * 2.5,
              ),
              buildCompanyName(),
              SizedBox(
                height: screen.blockSizeVertical * 1.1,
              ),
              Divider(
                color: const Color.fromRGBO(163, 118, 122, 1),
                thickness: 1,
                height: screen.blockSizeVertical * 3.7,
              ),
              buildCompanyDetails(),
              Divider(
                color: const Color.fromRGBO(163, 118, 122, 1),
                thickness: 1,
                height: screen.blockSizeVertical * 3.7,
              ),
              buildCompanyDescription(),
              Divider(
                color: const Color.fromRGBO(163, 118, 122, 1),
                thickness: 1,
                height: screen.blockSizeVertical * 3.7,
              ),
              buildJobDisplay(),
            ],
          ),
        ),
      ),
    );
  }
}