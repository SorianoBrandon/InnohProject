import 'package:flutter/material.dart';
import 'package:innohproject/src/env/current_log.dart';

class ClientView extends StatelessWidget {
  const ClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${CurrentLog.client!.name} ${CurrentLog.client!.lname}"),
    );
  }
}
