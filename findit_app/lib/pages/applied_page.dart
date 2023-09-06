import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:findit_app/utils/global.dart' as global;
import '../utils/job_card.dart';

class AppliedPage extends StatefulWidget {
  const AppliedPage({super.key});

  @override
  State<AppliedPage> createState() => _AppliedPageState();
}

class _AppliedPageState extends State<AppliedPage> {

  ScreenConfig screen = ScreenConfig();

  Widget buildEmptyState(){
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: screen.blockSizeVertical * 10.75,
        width: screen.blockSizeHorizontal * 81.5,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(83, 45, 49, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
        ),
        child: const Text(
          "You haven't applied to any jobs yet.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget buildJobDisplay(){
    return SizedBox(
      height: screen.blockSizeHorizontal * 162.9,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: global.currentUser.applied.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index){
          return JobCard(
            job: global.currentUser.applied[index],
            favorite: global.currentUser.favoritesID.contains(global.currentUser.applied[index]["id"]),
            applied: true,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screen.init(context);
    return Scaffold(
      extendBody: false,
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
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: screen.blockSizeVertical * 1.1,
            ),
            if(global.currentUser.appliedID.isEmpty)...[
              SizedBox(
                height: screen.blockSizeVertical * 26.9,
              ),
              buildEmptyState(),
            ]
            else...[
              buildJobDisplay(),
            ]
          ],
        ),
      ),
    );
  }
}