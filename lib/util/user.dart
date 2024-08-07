import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

userCreate(id, pw) async {
  try{
    var user = await auth.createUserWithEmailAndPassword(
      email: id,
      password: pw,
    );
  }catch(e){
    print(e);
  }
}

userLogin(id, pw) async {
  try{
    await auth.signInWithEmailAndPassword(
      email: id,
      password: pw,
    );
  }catch(e){
    print(e);
  }
}

userLogout() async {
  await auth.signOut();
}