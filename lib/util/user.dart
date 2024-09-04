import 'package:ddudu/util/show_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../layout/login_view.dart';
import '../main.dart';

final auth = FirebaseAuth.instance;

userCreate(context, id, pw) async {
  try{
    await auth.createUserWithEmailAndPassword(
      email: id,
      password: pw,
    );
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  const LoginView())
    );
  }catch(e){
    showAlertDialog(context, "회원가입에 실패했습니다.\n\n이미 등록된 이메일 입니다.");
  }
}

userLogin(context, id, pw) async {
  try{
    await auth.signInWithEmailAndPassword(
      email: id,
      password: pw,
    );

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const MyApp())
    );
  }catch(e){
    showAlertDialog(context, "로그인에 실패했습니다\n\n아이디 또는 비밀번호를 다시 확인해주세요.");
  }

  return auth;
}

userLogout(context) async {
  await auth.signOut();

  Navigator.push(context,
      MaterialPageRoute(builder: (context) =>  const LoginView())
  );
}

getUserId(){
  return auth.currentUser?.uid;
}