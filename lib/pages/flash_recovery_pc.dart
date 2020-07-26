import 'dart:convert';
import 'dart:io';
import 'package:file_chooser/file_chooser.dart';
import 'package:flash_tool/config/toolkit_colors.dart';
import 'package:flash_tool/provider/devices_state.dart';
import 'package:flash_tool/themes/text_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FlashRecoveryPC extends StatefulWidget {
  @override
  _FlashRecoveryPCState createState() => _FlashRecoveryPCState();
}

class _FlashRecoveryPCState extends State<FlashRecoveryPC> {
  String termOut = '';
  String recPath = '';
  @override
  Widget build(BuildContext context) {
    // debugPrintWithColor(
    //   '   Rec路径====>$recPath   ',
    //   backgroundColor: PrintColor.green,
    //   fontColor: PrintColor.black,
    // );

    DevicesState devicesState = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          '刷写Rec====>${devicesState.curDevice}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: TextColors.fontColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10.w.toDouble(),
                height: 40.w.toDouble(),
                color: MToolkitColors.candyColor[0],
              ),
              SizedBox(
                width: 16.w.toDouble(),
              ),
              Text(
                'Rec路径',
                style: TextStyle(
                  fontSize: 18.w.toDouble(),
                  fontWeight: FontWeight.bold,
                  color: TextColors.fontColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(16.w.toDouble()),
                decoration: BoxDecoration(
                  color: Color(0xFFF0F1F3),
                  borderRadius: BorderRadius.circular(
                    12.w.toDouble(),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 4 / 5,
                height: 64.w.toDouble(),
                child: Center(
                  child: Text(
                    '$recPath',
                    style: TextStyle(
                      fontSize: 18.w.toDouble(),
                      fontWeight: FontWeight.bold,
                      color: TextColors.fontColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  FileChooserResult fileChooserResult = await showOpenPanel(
                    allowedFileTypes: [
                      FileTypeFilterGroup(label: 'img', fileExtensions: ['img'])
                    ],
                  );
                  recPath = fileChooserResult.paths.first;
                  setState(() {});
                  print(fileChooserResult.paths);
                },
                child: Container(
                  margin: EdgeInsets.all(16.w.toDouble()),
                  decoration: BoxDecoration(
                    color: MToolkitColors.candyColor[1],
                    borderRadius: BorderRadius.circular(
                      12.w.toDouble(),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 8,
                  height: 64.w.toDouble(),
                  child: Center(
                    child: Text(
                      '选择',
                      style: TextStyle(
                        fontSize: 20.w.toDouble(),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              devicesState.setLock();
              Process.start(
                'fastboot',
                [
                  'flash',
                  'recovery',
                  recPath,
                ],
                runInShell: true,
                environment: <String, String>{
                  'Path': 'D:\\SDK\\Android\\platform-tools',
                },
              ).then((value) {
                // value.stdout.transform(utf8.decoder).listen((String out) {
                //   print('====>$out');
                // });
                value.stderr.transform(utf8.decoder).listen((String out) {
                  termOut += out;
                  setState(() {});
                  print('====>$out');
                });
              });

              devicesState.unLock();
            },
            child: Container(
              margin: EdgeInsets.all(16.w.toDouble()),
              decoration: BoxDecoration(
                color: MToolkitColors.candyColor[3],
                borderRadius: BorderRadius.circular(
                  16.w.toDouble(),
                ),
              ),
              width: MediaQuery.of(context).size.width / 4,
              height: 64.w.toDouble(),
              child: Center(
                child: Text(
                  '开始刷入',
                  style: TextStyle(
                    fontSize: 20.w.toDouble(),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.w.toDouble()),
            decoration: BoxDecoration(
              color: Color(0xFFF0F1F3),
              borderRadius: BorderRadius.circular(
                12.w.toDouble(),
              ),
            ),
            width: MediaQuery.of(context).size.width * 4 / 5,
            child: Padding(
              padding: EdgeInsets.all(8.w.toDouble()),
              child: Text(
                termOut == '' ? '等待刷入' : '${termOut.trim()}',
                style: TextStyle(
                  fontSize: 18.w.toDouble(),
                  fontWeight: FontWeight.bold,
                  color: TextColors.fontColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
