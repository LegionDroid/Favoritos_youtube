import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos_youtube/api.dart';
import 'package:favoritos_youtube/models/video.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videosList;

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if (search != null) { 
      _videosController.sink.add([]);
      videosList = await api.search(search);
    } else {
      videosList += await api.nextPage();
    }
    _videosController.sink.add(videosList);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }
}
