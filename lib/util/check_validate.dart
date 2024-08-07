class CheckValidate{
  String validateEmail(String value){
    if(value.isEmpty){
      return '이메일을 입력하세요.';
    }else {
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern.toString());
      if(!regExp.hasMatch(value)){
        return '잘못된 이메일 형식입니다.';
      }else{
        return "pass";
      }
    }
  }

  String validatePassword(String value){
    if(value.isEmpty){
      return '비밀번호를 입력하세요.';
    }else {
      Pattern pattern = r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{8,15}$';
      RegExp regExp = RegExp(pattern.toString());
      if(!regExp.hasMatch(value)){
        return '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
      }else{
        return "pass";
      }
    }
  }

  String validateComparePassword(String pw1, String pw2){
    if(pw1 != pw2){
      return '확인 비밀번호가 일치하지 않습니다.';
    }else {
      return "pass";
    }
  }

}