import 'package:findit_app/api/itjobs_api.dart';
import 'package:findit_app/utils/job_card.dart';
import 'package:findit_app/utils/screen_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:findit_app/utils/global.dart' as global;

class SearchPage extends StatefulWidget {

  // Constructor
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  ScreenConfig screen = ScreenConfig();

  // Text controllers
  final _searchController = TextEditingController();

  // Job list
  List jobsAvailable = [];

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
      await searchJobsIT(_searchController.text.trim()).then((value) => jobsAvailable = value);
      setState(() {});
    } on TypeError{
      
      // Display error message
      Fluttertoast.showToast(
        msg: "Your search was invalid or there were no results to be shown.",
        fontSize: 16,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );      
    } catch(e){

      // Display error message
      Fluttertoast.showToast(
        msg: "An error has ocurred. Please try again.",
        fontSize: 16,
        timeInSecForIosWeb: 5,
        backgroundColor: const Color.fromRGBO(108, 80, 82, 1),
        gravity: ToastGravity.CENTER,
      );      
    }

    // remove loading circle
    Navigator.of(context).pop();
  }

  Widget buildSearch(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color:const Color.fromARGB(255, 189, 171, 171),
          borderRadius: BorderRadius.circular(35),
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
          onSubmitted: (value) {
            callForApi();
          },
          cursorColor: const Color.fromRGBO(55, 8, 12, 1),
          controller: _searchController,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            color: Color.fromRGBO(55, 8, 12, 1),
            fontSize: 18.5
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top:14),
            prefixIcon: Icon(
              Icons.search,
              size: screen.blockSizeVertical * 4.2,
              color: const Color.fromRGBO(55, 8, 12, 1),
            ),
            hintText: 'Search',
            hintStyle: const TextStyle(
              color: Color.fromRGBO(55, 8, 12, 1)
            ),
          ),
        ),
      ),
    ],
  );
}

  Widget buildJobDisplay(){
    return SizedBox(
      height: screen.blockSizeVertical * 64.7,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: jobsAvailable.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index){
          return JobCard(
            job: jobsAvailable[index],
            favorite: global.currentUser.favoritesID.contains(jobsAvailable[index]["id"]),
            applied: global.currentUser.appliedID.contains(jobsAvailable[index]["id"]),
          );
        },
      ),
    );
  }

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
          "Search here for the latest job offers.",
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
              height: screen.blockSizeVertical * 3.25,
            ),
            buildSearch(),
            if(jobsAvailable.isEmpty)...[
              SizedBox(
                height: screen.blockSizeVertical * 17.7,
              ),
                buildEmptyState(),
            ]
            else...[
              SizedBox(
                height: screen.blockSizeVertical * 1.32,
              ),
              buildJobDisplay(),
            ]
          ],
        ),
      ),
    );
  }
}