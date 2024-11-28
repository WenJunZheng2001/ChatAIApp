import 'package:bloc_test/data/role/role_exceptions.dart';
import 'package:firebase_database/firebase_database.dart';

import '../auth/auth_service.dart';

class RoleProvider {
  Future<String> assignRoleFromFirebaseDatabase() async {
    try {
      final uid = AuthService.firebase().currentUser?.uid;
      String role = "";

      if (uid != null) {
        final databaseReference = FirebaseDatabase.instance.ref();
        const utentiString = "utenti";
        const ruoloString = "ruolo";
        final roleSnapshot = await databaseReference
            .child('$utentiString/$uid/$ruoloString')
            .get();
        if (roleSnapshot.value != null) {
          //prendo ruolo da database
          role = roleSnapshot.value.toString();
        } else {
          // creo ruolo su database e lo metto a guest
          DatabaseReference databaseUserUidReference =
              FirebaseDatabase.instance.ref("$utentiString/$uid");
          await databaseUserUidReference.set({
            "ruolo": "guest",
          });
          role = "guest";
        }

        return role;
      } else {
        return role;
      }
    } catch (e) {
      throw RoleFailedAssignRoleException();
    }
  }
}
