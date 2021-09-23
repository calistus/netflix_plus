import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIUtils {
  static void showToast(String toastMessage) {
    Fluttertoast.showToast(msg: toastMessage, toastLength: Toast.LENGTH_LONG);
  }

  static Widget showCircularLoader(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child:
              const SpinKitWave(color: Colors.blueGrey, type: SpinKitWaveType.start),
        ),
        SizedBox(
          height: 20,
        ),
        Center(child: Text(message)),
      ],
    );
  }

  static Widget showLinearLoader(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 200.0,
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: new LinearProgressIndicator(),
                ),
              ),
              Center(child: Text(message)),
            ],
          ),
        ),
      ],
    );
  }

  static Widget showSimpleLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget showError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: const TextStyle(color: Colors.blueGrey),
        ),
      ),
    );
  }
}
