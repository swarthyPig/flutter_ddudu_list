import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../layout/content.dart';
import '../util/check_validate.dart';
import '../util/show_dialog.dart';
import '../util/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});

  final PageController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _showClearButton = false;
  bool _isObscure = true;

  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _passController.addListener(() {
      setState(() {
        _showClearButton = _passController.text.isNotEmpty;
      });
    });

    // 회원가입 후 modal창 context 문제로 해당 로직 작성
    // 회원가입 후 자동 로그인 되는듯
    if(auth.currentUser?.uid != null){
      // 회원 가입 후 바로 home으로 이동해도 되지만 통상적으로 그렇게 안함
      // 그래서 회원가입 후 유저정보가 있으면 회원가입 직후 인걸로 판단함
      // 재 로그인 해달라는 modal을 띄우고 로그아웃처리 함(회원가입하면 자동 세션이 생김)

      // initState에서는 context를 사용못함 그래서 Future.delayed를 통해 해결
      // didChangeDependencies를 사용해서 처리해도 무관함.
      Future.delayed(
        Duration.zero,
        () async {
          showAlertDialog(context, "회원가입에 성공했습니다.\n\n다시 로그인 해주세요.");
          await auth.signOut();
        }
      );
    }
  }

  void _getClearButton() {
    _passController.clear();
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Image.asset(
              "assets/image/vector-1.png",
              //width: 413,
              //height: 430,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.54,
              //height: MediaQuery.of(context).size.height,
            ),
          ),
          Container(
            height: ((MediaQuery.of(context).size.height - 430) * 0.1).floorToDouble(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Log In',
                  style: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _emailController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'exam@exam.com',
                    labelStyle: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF837E93),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 2,
                        strokeAlign: 4,
                        color: Color(0xFF9F7BFF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _passController,
                  obscureText: _isObscure,
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF393939),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    labelStyle: const TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xFF837E93),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                        width: 2,
                        color: Color(0xFF9F7BFF),
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:
                      _showClearButton
                          ?
                      [IconButton(
                        onPressed: _getClearButton,
                        icon: const FaIcon(FontAwesomeIcons.circleXmark),
                        iconSize: 13,
                      ),
                        IconButton(
                          onPressed: _toggleObscure,
                          icon: FaIcon(
                            _isObscure
                                ? FontAwesomeIcons.solidEye
                                : FontAwesomeIcons.solidEyeSlash,
                          ),
                          iconSize: 13,
                        )]
                          :
                      [IconButton(
                        onPressed: _toggleObscure,
                        icon: FaIcon(
                          _isObscure
                              ? FontAwesomeIcons.solidEye
                              : FontAwesomeIcons.solidEyeSlash,
                        ),
                        iconSize: 13,
                      )
                      ],
                    )
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        var checkEmail = CheckValidate().validateEmail(_emailController.text);
                        var checkPw = CheckValidate().validatePassword(_passController.text);

                        if(checkEmail != "pass"){
                          showAlertDialog(context, checkEmail);
                        }else{
                          if(checkPw != "pass"){
                            showAlertDialog(context, checkPw);
                          }else{
                            userLogin(context, _emailController.text, _passController.text);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9F7BFF),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      ' 계정이 없으신가요?',
                      style: TextStyle(
                        color: Color(0xFF837E93),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 2.5,
                    ),
                    InkWell(
                      onTap: () {
                        widget.controller.animateToPage(1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: const Text(
                        '회원가입 하기 ',
                        style: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                /*const Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Color(0xFF755DC1),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
