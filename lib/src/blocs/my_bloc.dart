import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:service_background/src/blocs/bloc_provider.dart';
import 'package:service_background/src/event/event.dart';
import 'package:service_background/src/event/event.dart';

import 'bloc_provider.dart';



class MyBloc implements BlocBase {
  final _myController = BehaviorSubject<List<File>>();
  StreamSink<dynamic> get _inMyControllerSink => _myController.sink;
  Stream<dynamic> get myControllerStream => _myController.stream;

  final _myControllerEventController = BehaviorSubject<Event>();
  Sink<Event> get downloadEventSink => _myControllerEventController.sink;

  DownloadBloc() {
    _myControllerEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(Event event) async {
    if (event is EventOne) {
      int temp = 10;
      _inMyControllerSink.add(temp);
    }
  }

  @override
  void dispose() {
    _myController.close();
    _myControllerEventController.close();
  }
}
