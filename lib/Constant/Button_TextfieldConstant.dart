
import 'package:flutter/material.dart';

class ElevatedButtonBlock
{
  final void Function() elevatedButtonAction;
  ElevatedButtonBlock({required this.elevatedButtonAction});
}


Container CJElevatedBlueButton(String textType,{required ElevatedButtonBlock elevatedButtonBlock})
{
  return Container(color: Colors.white,child:Padding(padding:
  EdgeInsets.only(
      bottom: 20.0,top: 5.0),

      child:Container(height: 55.0,width: 250.0,color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ) // NEW
            ),
            onPressed: ()
            {
              elevatedButtonBlock.elevatedButtonAction();
            },
            child: Text(
              textType,
              style: TextStyle(fontWeight:FontWeight.bold,fontSize: 14.0),
            ),
          ))));
}


InputDecoration getTextFieldDecorationWithSuffixIcon<T>(String iconName,{required ElevatedButtonBlock elevatedButtonBlock}){
  return InputDecoration(
    suffixIcon: Container(
      height: 30.0,
      width: 30.0,

      child: IconButton(
        icon: Image.asset(iconName),
        onPressed: ()
        {
          elevatedButtonBlock.elevatedButtonAction();
        },
      ),

    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.circular(20.0),
    ),
  );
}

InputDecoration getTextFieldDecoration()
{
  return InputDecoration(
      hintStyle: TextStyle(
          fontSize: 14.0),

      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ));
}









