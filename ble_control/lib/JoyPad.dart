import 'dart:async';
import 'package:control_pad/control_pad.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:responsive/flex_widget.dart';
import 'dart:convert' show utf8;

import 'package:responsive/responsive_row.dart';

class JoyPad extends StatefulWidget {
  @override
  _JoyPadState createState() => _JoyPadState();
}

class _JoyPadState extends State<JoyPad> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubScription;

  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristic;

  String connectionText = "";

  final serviceUuid = "ab0828b1-198e-4351-b779-901fa0e0371e";
  final characteristicUuid = "4ac8a682-9736-4e5d-932b-e9b31405049c";
  final targetBleDevice = "R9 - Robô Gol";
  bool robotConnected = false;

  final buttons = [
    PadButtonItem(index: 0, buttonText: "B", backgroundColor: Colors.red, pressedColor: Colors.black),
    PadButtonItem(index: 1, buttonText: "A", backgroundColor: Colors.lightGreen, pressedColor: Colors.black),
    PadButtonItem(index: 2, buttonText: "X", backgroundColor: Colors.lightBlue, pressedColor: Colors.black),
    PadButtonItem(index: 3, buttonText: "Y", backgroundColor: Colors.yellowAccent, pressedColor: Colors.black),
  ];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  startScan() {
    setState(() {
      connectionText = "Procurando dispositivo.";
    });

    scanSubScription = flutterBlue.scan().listen((scanResult) {
      if (scanResult.device.name == targetBleDevice) {
        print("Robê encontrado!");
        stopScan();
        setState(() {
          connectionText = "Robô encontrado!";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    scanSubScription?.cancel();
    scanSubScription = null;
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "Conectando ao Robô!";
    });

    await targetDevice.connect();
    print("Robô conectado!");
    setState(() {
      connectionText = "Robô conectado!";
      robotConnected = true;
    });

    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();

    setState(() {
      connectionText = "Robô desconectado";
      robotConnected = false;
    });
  }

  discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == serviceUuid) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == characteristicUuid) {
            targetCharacteristic = characteristic;
            writeData("Robô conectado!");
            setState(() {
              connectionText = "Robô pronto";
            });
          }
        });
      }
    });
  }

  writeData(String data) async {
    if (targetCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    await targetCharacteristic.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: missing_return
    JoystickDirectionCallback onDirectionChanged(double degrees, double distance) {
      if (degrees == 0.0 || distance < 0.3) {
        writeData("p");
        print("Centro");
      } else if ((degrees >= 1.0 && degrees <= 50.0) || (degrees >= 1.0 && degrees >= 320.0)) {
        writeData("f");
        print("Frente");
      } else if (degrees >= 50.1 && degrees <= 130.0) {
        writeData("d");
        print("Direita");
      } else if (degrees >= 130.1 && degrees <= 220.0) {
        writeData("v");
        print("Volta");
      } else {
        writeData("e");
        print("Esquerda");
      }
    }

    // ignore: missing_return
    PadButtonPressedCallback padButtonPressedCallback(int index, Gestures gestures) {
      if (index == 2 || index == 3) {
        writeData("p");
      } else {
        writeData("c");
      }
    }

    return Scaffold(
      appBar: robotConnected
          ? null
          : AppBar(
              title: Text(connectionText),
            ),
      body: Container(
          child: Center(
        child: ResponsiveRow(
          columnsCount: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            FlexWidget(
              child: JoystickView(
                onDirectionChanged: onDirectionChanged,
              ),
              xs: 4,
              xsLand: 4,
              sm: 3,
              smLand: 3,
            ),
            FlexWidget(
              child: Padding(
                padding: EdgeInsets.only(bottom: 180),
                child: Image.asset(
                  "images/xbox_logo.png",
                  height: 150,
                  width: 150,
                ),
              ),
              xs: 4,
              xsLand: 4,
              sm: 3,
              smLand: 3,
            ),
            FlexWidget(
              child: PadButtonsView(
                buttons: this.buttons,
                padButtonPressedCallback: padButtonPressedCallback,
              ),
              xs: 4,
              xsLand: 4,
              sm: 3,
              smLand: 3,
            ),
          ],
        ),
      )),
    );
  }
}
