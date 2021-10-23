import 'package:dataverse_sample/shared/show_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

openLink(BuildContext context, String url) async {
  if (await canLaunch(url)) {
    html.window.open(url, '_self');
    // await launch(url);
  } else {
    showPopup(context, 'couldn\'t launch url');
  }
}
