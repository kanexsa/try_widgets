import 'package:flutter/material.dart';
import 'package:try_widgets/effects/nested_navigation/select_device_page.dart';
import 'package:try_widgets/effects/nested_navigation/waiting_page.dart';
import 'package:try_widgets/main.dart';

import 'finished_page.dart';

class SetupFlow extends StatefulWidget {
  const SetupFlow({super.key, required this.setupPageRoute});

  final String setupPageRoute;

  @override
  State<SetupFlow> createState() => _SetupFlowState();
}

class _SetupFlowState extends State<SetupFlow> {
  //kullanıcı appbardaki geri düğmesine tıklayınca tüm veri akışını kaybedeceğinden buna basınca bir onay kutusu göteriyoruz.
  //Androidde de geri tuşuna basması da bu etkiyi sağlar.
  Future<void> _onExitPressed() async {
    final isConfirmed = await _isExitDesired();

    if (isConfirmed && mounted) {
      _exitSetup();
    }
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                  'If you exit device setup, your progress will be lost'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Leave'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Stay'),
                )
              ],
            );
          },
        ) ??
        false;
  }

  void _exitSetup() {
    Navigator.of(context).pop();
  }

  final _navigatorKey = GlobalKey<NavigatorState>();

  void _onDiscoveryComplete() {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupSelectDevicePage);
  }

  void _onDeviceSelected(String deviceId) {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupConnectingPage);
  }

  void _onConnectionEstablished() {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupFinishedPage);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
          appBar: _buildFlowAppBar(),
          body: Navigator(
            key: _navigatorKey,
            initialRoute: widget.setupPageRoute,
            onGenerateRoute: _onGenerateRoute,
          )),
    );
  }

  Route _onGenerateRoute(RouteSettings routeSettings) {
    late Widget page;

    switch (routeSettings.name) {
      case routeDeviceSetupStartPage:
        page = WaitingPage(
          message: 'Searching for nearby bulb...',
          onWaitComplete: _onDiscoveryComplete,
        );
        break;
      case routeDeviceSetupSelectDevicePage:
        page = SelectDevicePage(
          onDeviceSelected: _onDeviceSelected,
        );
        break;
      case routeDeviceSetupConnectingPage:
        page = WaitingPage(
          message: 'Connecting...',
          onWaitComplete: _onConnectionEstablished,
        );
        break;
      case routeDeviceSetupFinishedPage:
        page = FinishedPage(
          onFinishPressed: _exitSetup,
        );
        break;
    }

    return MaterialPageRoute<dynamic>(
        builder: (context) {
          return page;
        },
        settings: routeSettings);
  }

  PreferredSizeWidget _buildFlowAppBar() {
    return AppBar(
      title: const Text('Bulb Setup'),
    );
  }
}
