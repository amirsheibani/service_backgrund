
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:service_background/src/blocs/my_bloc.dart';
import 'package:service_background/src/pages/setting.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool permissionStatus = true;

  MyBloc _myBloc = MyBloc();
  Stream _myPreviousStream;

  @override
  void initState() {
    if (_myBloc.myControllerStream != _myPreviousStream) {
      _myPreviousStream = _myBloc.myControllerStream;
      _listen(_myPreviousStream);
    }
    super.initState();
  }

  void _listen(Stream<dynamic> stream) {
    stream.listen((value) async {
      if (value != null) {
        if (value is int) {
          setState(() {
            print(value);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _permissionHandler(context);
    return Device
        .get()
        .isPhone ? _smartPhoneLayout(context) : (Device.width > Device.height ? _tabletLandscapeLayout(context) : _tabletPortraitLayout(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _smartPhoneLayout(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        key: _scaffoldKey,
        body: Center(child: RaisedButton(
          child: Text('Start background'),
          onPressed: (){

          },
        ),)
    );
  }

  Widget _tabletLandscapeLayout(BuildContext context) {
    return _smartPhoneLayout(context);
  }

  Widget _tabletPortraitLayout(BuildContext context) {
    return _smartPhoneLayout(context);
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      elevation: 0.0,
      title: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _goToSettingPage();
                  },
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 28,
                          color: Theme
                              .of(context)
                              .iconTheme
                              .color,
                        ),
                        // Text("Back",style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
              // Image.asset(Utility.getImagePathAssetsForAppBar('logo'),
              //     height: (Device
              //         .get()
              //         .isPhone) ? (AppBar().preferredSize.height * 33) / 100 : (AppBar().preferredSize.height * 60) / 100, fit: BoxFit.cover),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 80,
              ),
            ],
          );
        },
      ),
    );
  }



  void _goToSettingPage() {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: false,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset(0.0, 0.0);
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 47) / 2),
              child: SettingPage(),
            ),
          );
        });
  }

  _permissionHandler(BuildContext context) async {
    if(permissionStatus){
      permissionStatus = false;
      if (await Permission.location.status != PermissionStatus.granted) {
        await Permission.location.request();
      }
      if (await Permission.camera.status != PermissionStatus.granted) {
        await Permission.camera.request();
      }
      // if (await Permission.storage.status != PermissionStatus.granted) {
      //   await Permission.storage.request();
      // }
      // if (await Permission.mediaLibrary.status != PermissionStatus.granted) {
      //   await Permission.mediaLibrary.request();
      // }
      // if (await Permission.photos.status != PermissionStatus.granted) {
      //   await Permission.photos.request();
      // }
      // if (await Permission.sensors != PermissionStatus.granted) {
      //   await Permission.camera.request();
      // }
    }

  }

}