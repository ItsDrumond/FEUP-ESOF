import 'package:findit_app/api/itjobs_api.dart';
import 'package:findit_app/pages/company_page.dart';
import 'package:findit_app/utils/job_info.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class JobPage extends StatefulWidget {

  final JobInfo jobInfo;
  late final bool favorite;
  late final bool applied;
  List companyJobs = [];

  // Constructor
  JobPage({super.key, required this.jobInfo, required this.favorite, required this.applied});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {

  ScreenConfig screen = ScreenConfig();

  // Call for API
  Future <void> callForApi() async{

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
      await searchJobsIT(widget.jobInfo.companyName).then((value) => widget.companyJobs = value);
    }catch(e){

      // Display error message
      Fluttertoast.showToast(
        msg: "No more jobs from the company to show.",
        fontSize: 16,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );      
    }

    // remove loading circle
    Navigator.of(context).pop();
  }

  // send email method
  Future <void> sendEmail() async{
    
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
      recipients: [widget.jobInfo.companyEmail],
      cc: [],
      bcc: [],
      subject: "Job Application - ${widget.jobInfo.jobTitle}",
      body: "Dear Hiring Manager, \n\nI am writing to express my interest in the role that is currently available at [Company Name]. I am excited about the opportunity to bring my skills and experience to your team and contribute to your organization's success. \nI have [number of years] of experience in [industry or relevant field], and I believe my expertise and passion for [specific skill or area of interest] would be a valuable asset to your company. In my current role at [Current Company], I have demonstrated my ability to [specific accomplishment or responsibility]. \nI have attached my resume and cover letter for your review. Please do not hesitate to contact me if you require any additional information or if you would like to schedule an interview.\nThank you for your time and consideration. I look forward to the opportunity to discuss my qualifications further. \n\nBest regards, \n[Your Name]",
    );

    try{
      await FlutterEmailSender.send(email);
    } catch(e){

      // Display error message
      Fluttertoast.showToast(
        msg: "An error has occurred. Please try again.",
        fontSize: 16,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );
    }

    // remove loading circle
    Navigator.of(context).pop();
  }

  Widget buildCompanyLogo(){
    return GestureDetector(
      onTap: () async{
        await callForApi();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context){
            return CompanyPage(
              jobInfo: widget.jobInfo,
              companyJobs: widget.companyJobs,
            );
          })
        );
      },
      child: Container(
        color: Colors.white,
        child: Image.network(
          widget.jobInfo.companyLogo,
          ),
      ),
    );
  }

  Widget buildCompanyName(){
    return Text(
      widget.jobInfo.companyName,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color.fromRGBO(163, 118, 122, 1),
        fontFamily: 'Inter',
        fontSize: 20,
        letterSpacing: 0.25,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  Widget buildJobTitle(){
    return Text(
      widget.jobInfo.jobTitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
      color: Color.fromRGBO(249, 240, 241, 1),
      fontFamily: 'Inter',
      fontSize: 26,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      height: 1.0357142857142858,
      ),
    );
  }

  Widget buildJobDescription(){
    return SizedBox(
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: Html(
          data: widget.jobInfo.jobDescription,
          style: {
            'body':Style(color: Colors.white, fontFamily: 'Inter', fontSize: const FontSize(16), textAlign: TextAlign.justify), 
            'p':Style(color: Colors.white, fontFamily: 'Inter', fontSize: const FontSize(16), textAlign: TextAlign.justify),     
            'ul':Style(color: Colors.white, fontFamily: 'Inter', fontSize: const FontSize(16), textAlign: TextAlign.justify),
            'a':Style(color: Colors.white, fontFamily: 'Inter', fontSize: const FontSize(16), textAlign: TextAlign.justify, fontWeight: FontWeight.bold),
          },
        ),
      ),
    );
  }

  Widget buildApplyNow(){
    return SizedBox(
      height: 50,
      width: 130,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(163, 118, 122,1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          sendEmail();
        },
        child: const Text(
          "Apply Now",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(55, 8, 14, 1),
            fontFamily: 'Inter',
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildStar(){
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 157, 121, 123),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.favorite? Icons.star : Icons.star_border,
        color: const Color.fromRGBO(55, 8, 12, 1),
        size: 30,
      ),
    );
  }

  Widget buildCheck(){
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 157, 121, 123),
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.applied ? Icons.check_box_rounded : Icons.check_box_outlined,
        color: const Color.fromRGBO(55, 8, 12, 1),
        size: 30,
      ),
    );
  }

  Widget buildjobLocalization(){
    return Column(
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
            "Localização",
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
          widget.jobInfo.jobLocation,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1
          ),
        ),
      ],
    );
  }

  Widget buildJobType(){
    return Column(
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
            "Type",
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
          widget.jobInfo.jobType,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1
          ),
        ),
      ],
    );
  }

  Widget buildJobContract(){
    return Column(
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
            "Contract",
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
          widget.jobInfo.jobContract,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1
          ),
        ),
      ],
    );
  }

  Widget buildJobWage(){
    return Column(
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
            "Salary",
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
          widget.jobInfo.jobSalary,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1
          ),
        ),
      ],
    );
  }

  Widget buildJobPublishDate(){
    return Column(
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
            "Publish Date",
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
          widget.jobInfo.jobPublishDate,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1
          ),
        ),
      ],
    );
  }

  Widget builJobDetails(){
    return Column(
      children: <Widget> [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildjobLocalization(),
            const SizedBox(
              width: 60,
            ),
            buildJobWage(),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildJobType(),
            const SizedBox(
              width: 60,
            ),
            buildJobContract(),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        buildJobPublishDate(),
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
              buildJobTitle(),
              buildCompanyName(),
              SizedBox(
                height: screen.blockSizeVertical * 2.5
              ),
              Row(
                children: [
                  SizedBox(
                    width: screen.blockSizeHorizontal * 4.7
                  ),
                  buildApplyNow(),
                  SizedBox(
                    width: screen.blockSizeHorizontal * 30.3,
                  ),
                  buildStar(),
                  SizedBox(
                    width: screen.blockSizeHorizontal * 2.5
                  ),
                  buildCheck(),
                ],
              ),
              Divider(
                color: const Color.fromRGBO(163, 118, 122, 1),
                thickness: 1,
                height: screen.blockSizeVertical * 4,
              ),
              builJobDetails(),
               Divider(
                color: const Color.fromRGBO(163, 118, 122, 1),
                thickness: 1,
                height: screen.blockSizeVertical * 4,
              ),
              buildJobDescription(),
            ]
          ),
        ),
      )
    );
  }
}