import 'dart:io';
import 'dart:math';

import 'package:dataverse_sample/keys.dart';
import 'package:dataverse_sample/pages/error/error_page.dart';
import 'package:dataverse_sample/pages/main/main_cubit.dart';
import 'package:dataverse_sample/pages/main/main_page.dart';
import 'package:dataverse_sample/shared/open_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'configure_nonweb.dart' if (dart.library.html) 'configure_web.dart';

//https://login.microsoftonline.com/common/oauth2/authorize?resource=https://org913ac1eb.api.crm4.dynamics.com&response_type=token&client_id=a257962a-097c-4f0d-8128-f1f3dd0e0c29&redirect_uri=http%3A%2F%2Flocalhost%3A8080
//http://localhost:8080/#access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6Imwzc1EtNTBjQ0g0eEJWWkxIVEd3blNSNzY4MCIsImtpZCI6Imwzc1EtNTBjQ0g0eEJWWkxIVEd3blNSNzY4MCJ9.eyJhdWQiOiJodHRwczovL29yZzkxM2FjMWViLmFwaS5jcm00LmR5bmFtaWNzLmNvbSIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0LzAwMTg3MDZkLTY2YmItNDhlYS1hMDg1LWM1OGI5NGM3ZGMxOS8iLCJpYXQiOjE2MzQ0NjU1ODQsIm5iZiI6MTYzNDQ2NTU4NCwiZXhwIjoxNjM0NDY5NDg0LCJhY3IiOiIxIiwiYWlvIjoiRTJaZ1lIakFubkZQNjNIQVUrazQxVzQzRDNaVnAzTjlzVHZ5K3dTK3QzWm5zeS82V0E4QSIsImFtciI6WyJwd2QiXSwiYXBwaWQiOiJhMjU3OTYyYS0wOTdjLTRmMGQtODEyOC1mMWYzZGQwZTBjMjkiLCJhcHBpZGFjciI6IjAiLCJmYW1pbHlfbmFtZSI6IlNhZ2VldiIsImdpdmVuX25hbWUiOiJWbGFkaXNsYXYiLCJpcGFkZHIiOiIyMTIuNDUuMTUuMTA1IiwibmFtZSI6IlZsYWRpc2xhdiBTYWdlZXYiLCJvaWQiOiIyMjYwMzBhZi1mNWQ4LTQ2YmEtODYyZi0wY2QzNzE3NjE3YzIiLCJwdWlkIjoiMTAwMzIwMDE5NTAzNkNDRSIsInJoIjoiMC5BUzhBYlhBWUFMdG02a2lnaGNXTGxNZmNHU3FXVjZKOENRMVBnU2p4ODkwT0RDa3ZBRTAuIiwic2NwIjoidXNlcl9pbXBlcnNvbmF0aW9uIiwic3ViIjoiaE9GWHl0bG5DcTg1T20yOHVWVks0RTBSTWRMLXo0NHJMZUwwaGNlQVpCQSIsInRpZCI6IjAwMTg3MDZkLTY2YmItNDhlYS1hMDg1LWM1OGI5NGM3ZGMxOSIsInVuaXF1ZV9uYW1lIjoic3ZzYW1wbGVkb21Ac3ZzYW1wbGVkb20ub25taWNyb3NvZnQuY29tIiwidXBuIjoic3ZzYW1wbGVkb21Ac3ZzYW1wbGVkb20ub25taWNyb3NvZnQuY29tIiwidXRpIjoiSlR4QmZ2SUlxa3k3MjItZ1NkSmZBQSIsInZlciI6IjEuMCJ9.dW0CsTaR4r0edoq35wt8OuN1GQ-OhThIpL5Z5a14AR4B9V9_ZNS7tb17Uax4KN_WUaZdBu3nS8IqTEGEzhSMJpBFjlsL6hXR8d5JmH1Lfm05t00zK2piVuMcMZ-TMASTDUtwLdIYpmUk4wWy3EvfDJKwSVHjS63NL0VADzESA4G6AGfkwoYyIVwZuBGQ_OHLtDxmjgAReMGcDM02QWKeaf6zYJe8JGVai4kxgKiEeUKy905A9KbXZbjy8kLZR_TRQrDjfI-ZTc6-RW6lKnv4__klllORaSJTtLop-UrLQ4kNy2ns0ra31PrfDapWkFjj8sC2XLiA_c7ihwodnhrIAw&token_type=Bearer&expires_in=3599&session_state=9bd4dba2-ca00-4430-8a4a-c7e66fa69a02

void main() {
  configureApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        var accessToken = "";
        // print(settings.arguments);
        try {
          // print("name:" + settings.name.toString());
          var accessTokenParam = settings.name?.split('&')[0];
          // print("str: "+accessTokenParam.toString());
          accessToken = accessTokenParam == null
              ? "null"
              : accessTokenParam.split('=')[1];
          // print("token: " + accessToken.toString());
        } catch (e) {}

        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) {
            openLink(context,
                "https://login.microsoftonline.com/common/oauth2/authorize?resource=https://${appUrl}&response_type=token&client_id=${clientId}&redirect_uri=http%3A%2F%2Flocalhost%3A8080");

            return Container();
          });
        }

        if (accessToken != "") {
          return MaterialPageRoute(builder: (context) {
            return BlocProvider(
              create: (context) => MainCubit('Bearer ' + accessToken),
              child: const MainPage(),
            );
          });
        }

        return MaterialPageRoute(builder: (context) => const ErrorPage());
      },
    );
  }
}
