import 'package:flutter/material.dart';

class ErrorsViews{
  static Widget getErrorWidget([String? err]){
    return Text("${err ?? "There was an unkown error."}");
  }

}
