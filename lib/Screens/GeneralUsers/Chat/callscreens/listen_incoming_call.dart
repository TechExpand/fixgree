import 'package:fixme/Model/Message.dart';
import 'package:fixme/Screens/GeneralUsers/Chat/callscreens/pickup_screen.dart';
import 'package:fixme/Services/call_service.dart';
import 'package:fixme/Services/network_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallApi callApi = CallApi();

  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    var network = Provider.of<WebServices>(context);
    return StreamBuilder<List<Message>>(
      stream: callApi.getCallLogs(network.mobile_device_token),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? !snapshot.data.isEmpty
                ? PickupScreen(message: snapshot.data[0])
                : scaffold
            :scaffold;
      },
    );
  }
}
