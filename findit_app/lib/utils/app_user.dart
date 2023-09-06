import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/itjobs_api.dart';

class AppUser{
  final String email;
  final String name;
  String picture;
  List <dynamic> favoritesID;
  List <dynamic> favorites;
  List <dynamic> appliedID;
  List <dynamic> applied;

  AppUser({
    required this.email,
    required this.name,
    required this.picture,
    required this.favoritesID,
    required this.favorites,
    required this.appliedID,
    required this.applied,
  });

  Map<String, dynamic> firestoreUpdateAux() {
    return {
      "email": email,
      "name": name,
      "picture": picture,
      "favorites" : favoritesID,
      "applied" : appliedID,
    };
  }

  Future<int> firestoreDelete() async {
    CollectionReference collection = await FirebaseFirestore.instance.collection('Users');
    DocumentReference document = await collection.doc(email);
    await document.delete();
    return 0;
  }

  Future<int> firestoreUpdate() async {
    CollectionReference collection = await FirebaseFirestore.instance.collection('Users');
    DocumentReference document = await collection.doc(email);
    await document.update(firestoreUpdateAux());
    return 0;
  }

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final data = snapshot.data();
    return AppUser(
      email: data?["email"],
      name: data?["name"],
      picture: data?["picture"],
      favoritesID: data?["favorites"], 
      favorites: [],
      appliedID: data?["applied"],
      applied: [],
    );
  }

  void fillFavorites () async{
    favorites = [];
    Set <dynamic> favoritesID_set = favoritesID.toSet();
    List <dynamic> favoritesID_list = favoritesID_set.toList();
    for(int i = 0; i < favoritesID_list.length; i++){
      favorites.add(await getJobsIT(favoritesID_list[i]));
    }
  }
  
  void fillApplied () async{
    applied = [];
    Set <dynamic> appliedID_set = appliedID.toSet();
    List <dynamic> appliedID_list = appliedID_set.toList();
    for(int i = 0; i < appliedID_list.length; i++){
      applied.add(await getJobsIT(appliedID_list[i]));
    }
  }
}