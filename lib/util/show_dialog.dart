import 'package:flutter/material.dart';

showAlertDialog(context, msg){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('알림'),
      content: Text(msg.toString()),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인')),
      ],
    ),
  );
}

showFnDialog(context, msg, callback){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('알림'),
      content: Text(msg.toString()),
      actions: [
        ElevatedButton(
            onPressed: () => callback,
            child: const Text('확인')),
      ],
    ),
  );
}

showConfirmDialog(context, msg, callback){
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('알림'),
      content: Text(msg.toString()),
      actions: [
        ElevatedButton(
            onPressed: () => callback,
            child: const Text('확인')),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소')),
      ],
    ),
  );
}