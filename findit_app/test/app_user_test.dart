import 'package:flutter_test/flutter_test.dart';
import 'package:findit_app/utils/app_user.dart';


void main(){
  group('API Utils', () {
    final AppUser testUtil = AppUser(email:'email@test.com', name: 'Drumond', picture: 'picture', favoritesID: [1,2,3,4],appliedID: [5,6,7,8],favorites:['job 1', 'job 2', 'job 3', 'job 4'], applied:['job 5', 'job 6', 'job 7', 'job 8']);

    test('Update', () {
      Map<String, dynamic> result = {"email": testUtil.email, "name": testUtil.name, "picture": testUtil.picture, "favorites":testUtil.favoritesID, "applied": testUtil.appliedID};
      expect(testUtil.firestoreUpdateAux(), result);
    });
  });
}