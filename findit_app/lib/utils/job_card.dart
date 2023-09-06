import 'package:findit_app/pages/job_page.dart';
import 'package:findit_app/utils/job_info.dart';
import 'package:flutter/material.dart';
import 'package:findit_app/utils/global.dart' as global;

class JobCard extends StatefulWidget {

  // Parameters
  final dynamic job;
  late final JobInfo jobInfo;
  late final String title;
  late final String companyName;
  late final bool favorite;
  late final bool applied;

  // Constructor
  JobCard({super.key, required this.job, required this.favorite, required this.applied}){

    jobInfo = JobInfo(
      job: job,
    );

    try{
      String titleCheck = jobInfo.jobTitle;
      if(titleCheck.length > 24){
        title = titleCheck.substring(0,24);
      }
      else{
        title = titleCheck;
      }
    } catch(e){
      title = "Not Specified";
    }

    try{
      String companyCheck = jobInfo.companyName;
      if(companyCheck.length > 20){
        companyName = companyCheck.substring(0,20);
      }
      else{
        companyName = companyCheck;
      }
    } catch(e){
      companyName = "Not Specified";
    }
  }

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {

  // Selected Favorites
  late bool _isFavorite;

  // Selected Applied
  late bool _isApllied = false;

  // Changes the isFavorite value
  void _toggleFavorite(){
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  // Changes the isApplied value
  void _toggleApplied(){
    setState(() {
      _isApllied = !_isApllied;
    });
  }

  @override
  void initState() {
    _isFavorite = widget.favorite;
    _isApllied = widget.applied;
    super.initState();
  }

  Widget buildStarPressed(){
    return Positioned(
      top: 60,
      right: 65,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 157, 121, 123),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.star),
          color: const Color.fromRGBO(55, 8, 12, 1),
          iconSize: 30,
          onPressed: () {
            _toggleFavorite();
            global.currentUser.favoritesID.remove(widget.jobInfo.jobID);
            global.currentUser.firestoreUpdate();
            global.currentUser.fillFavorites();
          },
        ),
      ),
    );
  }

  Widget buildStarNotPressed(){
    return Positioned(
      top: 60,
      right: 65,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 157, 121, 123),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.star_border),
          color: const Color.fromRGBO(55, 8, 12, 1),
          iconSize: 30,
          onPressed: () {
            _toggleFavorite();
            global.currentUser.favoritesID.add(widget.jobInfo.jobID);
            global.currentUser.firestoreUpdate();
            global.currentUser.fillFavorites();
          },
        ),
      ),
    );
  }

  Widget buildAppliedPressed(){
    return Positioned(
      top: 60,
      right: 15,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 157, 121, 123),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.check_box_rounded),
          color: const Color.fromRGBO(55, 8, 12, 1),
          iconSize: 30,
          onPressed: () {
            _toggleApplied();
            global.currentUser.appliedID.remove(widget.jobInfo.jobID);
            global.currentUser.firestoreUpdate();
            global.currentUser.fillApplied();
          },
        ),
      ),
    );
  }

  Widget buildAppliedNotPressed(){
    return Positioned(
      top: 60,
      right: 15,
      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 157, 121, 123),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: const EdgeInsets.all(0),
          icon: const Icon(Icons.check_box_outlined),
          color: const Color.fromRGBO(55, 8, 12, 1),
          iconSize: 30,
          onPressed: () {
            _toggleApplied();
            global.currentUser.appliedID.add(widget.jobInfo.jobID);
            global.currentUser.firestoreUpdate();
            global.currentUser.fillApplied();
          },
        ),
      ),
    );
  }

  Widget buildJobTitle(){
    return Positioned(
      top: 10,
      left: 10,
      child: Text(
        widget.title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Color.fromRGBO(249, 240, 241, 1),
          fontFamily: 'Inter',
          fontSize: 25,
          letterSpacing: 0.5,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }

  Widget buildCompanyName(){
    return Positioned(
      top: 32,
      left: 10,
      child: Text(
        widget.companyName,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Color.fromRGBO(163, 118, 122, 1),
          fontFamily: 'Inter',
          fontSize: 22,
          letterSpacing: 0.25,
          fontWeight: FontWeight.normal,
          height: 1.25,
        ),
      ),
    );
  }

  Widget buildJobLocation(){
    return Positioned(
      top: 60,
      left: 10,
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Color.fromRGBO(163, 118, 122, 1),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
              widget.jobInfo.jobLocation,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color.fromRGBO(249, 240, 241, 1),
                fontFamily: 'Inter',
                fontSize: 20,
                letterSpacing: 0,
                fontWeight: FontWeight.normal,
                height: 1.53,
              ),
          ),
        ],
      ),
    );
  }

  Widget buildJobContract(){
    return Positioned(
      top: 90,
      left: 10,
      child: Row(
        children: [
          const Icon(
            Icons.paste_outlined,
            color: Color.fromRGBO(163, 118, 122, 1),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            widget.jobInfo.jobContract,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color.fromRGBO(249, 240, 241, 1),
              fontFamily: 'Inter',
              fontSize: 20,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.53,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJobType(){
    return Positioned(
      top: 120,
      left: 10,
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: Color.fromRGBO(163, 118, 122, 1),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            widget.jobInfo.jobType,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color.fromRGBO(249, 240, 241, 1),
              fontFamily: 'Inter',
              fontSize: 20,
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              height: 1.53,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        top: 12,
        bottom: 12,
        ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
            return JobPage(
              jobInfo: widget.jobInfo,
              favorite: _isFavorite,
              applied: _isApllied,
            );
            }),
          );
        },
        child: Container(
          width: 335,
          height: 160,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(83, 45, 49, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Stack(
            children: [
              if(global.currentUser.favoritesID.contains(widget.jobInfo.jobID))...[
                buildStarPressed()
              ]
              else...[
                buildStarNotPressed()
              ],
              if(global.currentUser.appliedID.contains(widget.jobInfo.jobID))...[
                buildAppliedPressed()
              ]
              else...[
                buildAppliedNotPressed()
              ],
              buildJobTitle(),
              buildCompanyName(),
              buildJobLocation(),
              buildJobContract(),
              buildJobType(),
            ],
          ),
        ),
      ),
    );
  }
}