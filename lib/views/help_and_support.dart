import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waterdrop_supplier/helper/widgets.dart';
import 'package:waterdrop_supplier/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({Key? key}) : super(key: key);

  @override
  _HelpAndSupportState createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  TextEditingController feedback = TextEditingController();
  String salesNo = "+91 96790 66709";
  String customerNo = "+91 63551 29211";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 25,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/undraw_instant_support_re_iw6d 1.svg',
                    width: MediaQuery.of(context).size.width * 0.9),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Contact Us',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                      letterSpacing: 0.8),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      onTap: () async {
                        var url = 'tel:$customerNo';
                        await launch(url);
                      },
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor,
                        child: const Icon(Icons.phone_in_talk_outlined,
                            color: Colors.white, size: 24),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Customer Support 1 ",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "9:00 AM to 5:00 PM",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListTile(
                        onTap: () async {
                          var url = 'tel:$salesNo';

                          await launch(url);
                        },
                        contentPadding: EdgeInsets.zero,
                      dense: true,
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: primaryColor,
                          child: const Icon(
                            Icons.phone_in_talk_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Customer Support 2",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "2:00 PM to 8:00 PM",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Ask For Support',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                      letterSpacing: 0.8),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: feedback,
                  maxLines: 5,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (name) {
                    if (name!.length == 0) {
                      return 'Required';
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        print(feedback.text);
                        String msg = feedback.text;
                        feedback.text = '';
                        DataBaseMethods dataBaseMethods = DataBaseMethods();
                        bool success =
                            await dataBaseMethods.requestForHelp(msg);
                        if (success) {
                          dataBaseMethods.showToastNotification(
                              'Request Sent Successfully');
                        } else {
                          dataBaseMethods
                              .showToastNotification('Failed to send request');
                        }
                      }
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.all(10),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
