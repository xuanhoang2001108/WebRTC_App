import 'dart:convert';
import 'package:app/api/meeting-api.dart';
import 'package:app/models/meeting-details.dart';
import 'package:app/pages/join_screen.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting'),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: globalKey,
        child: formUI(),
      ),
    );
  }

  formUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            const SizedBox(height: 20),
            FormHelper.inputFieldWidget(context, "meetingId", "Enter your Id",
                (val) {
              if (val.isEmpty) {
                return "Meeting Id wrong";
              }
              return null;
            }, (onSaved) {
              meetingId = onSaved;
            },
                borderRadius: 10,
                borderFocusColor: Colors.redAccent,
                borderColor: Colors.redAccent,
                hintColor: Colors.grey),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: FormHelper.submitButton("Join Meeting", () {
                  if (validateAndSave()) {
                    validateMeeting(meetingId);
                  }
                })),
                Flexible(
                    child: FormHelper.submitButton("Start Meeting", () async {
                  var response = await startMeeting();
                  final body = json.decode(response!.body);
                  final meetId = body['data'];
                  validateMeeting(meetId);
                })),
              ],
            )
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      var response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetail = MeetingDetail.fromJson(data["data"]);
    } catch (err) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid MeetingID", "Ok", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JoinScreen(
                  meetingDetail: meetingDetail,
                )));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
