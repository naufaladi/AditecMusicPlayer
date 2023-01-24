// import 'package:file_manager/file_manager.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_music_player/helpers/helper.dart';
import 'package:simple_music_player/models/track.dart';

class LocalMusicProvider extends ChangeNotifier {
  List<Track> _allItems = [];
  List<Track> _displayedItems = [];
  List<int> _playingQueueId = [];
  int _currentQueueIndex = 0;
  Track? _selectedTrack;
  SortMethod _selectedSortMethod = SortMethod.chronologicalDsc;

  List<Track> get allItems => _allItems;
  List<Track> get displayedItems => _displayedItems;
  List<int> get playingQueueId => _playingQueueId;
  Track? get selectedTrack => _selectedTrack;
  int get currentQueueIndex => _currentQueueIndex;
  SortMethod get selectedSortMethod => _selectedSortMethod;

  Future<void> fetch() async {
    if (await Permission.storage.status.isGranted) {
      print('YOU GOT ACCESS');
      List<Directory> dirs = [];

      dirs.add(Directory('storage/emulated/0/Music'));
      // dirs.add(Directory('storage/emulated/0/Download'));

      _allItems.clear();

      for (Directory dir in dirs) {
        String sourcePath = dir.toString();
        print('sourcePath: $sourcePath');

        List<FileSystemEntity> files = dir.listSync(recursive: true, followLinks: false);

        for (FileSystemEntity track in files) {
          String path = track.path;

          if (path.endsWith('.mp3') ||
              path.endsWith('.wav') ||
              path.endsWith('.flac') ||
              path.endsWith('.aac')) {
            int trackCounts = _allItems.length;

            _allItems.add(Track.fromFileSystemEntity(
              file: track,
              itemLength: trackCounts,
              genre: [],
            ));

            _playingQueueId.add((trackCounts + 1));
          }
        }
      }
      _displayedItems = _allItems;
      _displayedItems.sort((a, b) => b.lastModified.compareTo(a.lastModified));
    } else {
      print('REQUESTING APPROVAL');
      await Permission.storage.request();
      fetch();
    }

    notifyListeners();
  }

  Future<void> deleteFile(String filePath) async {
    print('ok we will delete $filePath');
    try {
      if (await File(filePath).exists()) {
        print('found the file!');
        await File(filePath).delete().catchError((e) => print('error $e'));
        print('file deleted');
      } else {
        print('that file doesnt exist');
      }
    } catch (e) {
      print('bruh something went wrong while deleting');
      throw ("Error file not found");
    }
    fetch();
  }

  Future<void> renameFile({required String filePath, required String newFileName}) async {
    String parentDirectory = filePath.substring(0, filePath.lastIndexOf('/') + 1);
    String newPathName = parentDirectory + newFileName;

    try {
      if (await File(filePath).exists()) {
        print('found the file!');
        File file = File(filePath);
        await file.copy(newPathName);
        await file.delete();

        // await file.rename(newPathName);

        print('file renamed');
      } else {
        print('that file doesnt exist');
      }
    } catch (e) {
      print(e);
    }
  }

  void sort(SortMethod sortMethod) {
    if (sortMethod == _selectedSortMethod && sortMethod != SortMethod.random) return;
    _selectedSortMethod = sortMethod;

    switch (_selectedSortMethod) {
      case SortMethod.alphabeticalAsc:
        _displayedItems.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortMethod.alphabeticalDsc:
        _displayedItems.sort((a, b) => b.title.compareTo(a.title));
        break;
      case SortMethod.chronologicalAsc:
        _displayedItems.sort((a, b) => a.lastModified.compareTo(b.lastModified));
        break;
      case SortMethod.chronologicalDsc:
        _displayedItems.sort((a, b) => b.lastModified.compareTo(a.lastModified));
        break;
      case SortMethod.random:
        _displayedItems.shuffle();
        break;
      default:
    }

    notifyListeners();
  }

  void search({required String title, required String artist}) {
    print('title keyword is "$title"');
    print('artist keyword is "$artist"');

    _displayedItems = _allItems.where((element) {
      return element.title.toLowerCase().contains(title.toLowerCase()) &&
          element.artist.toLowerCase().contains(artist.toLowerCase());
    }).toList();

    print(_displayedItems.length);

    notifyListeners();
  }

  Future<void> setSelectedTrack(int id) async {
    _selectedTrack = _allItems.firstWhere((element) => element.id == id);

    notifyListeners();
  }

  void goNextQueue() {
    bool isLast = _currentQueueIndex == _playingQueueId.length - 1;
    if (isLast) {
      _currentQueueIndex = 0;
    } else {
      _currentQueueIndex++;
    }

    setSelectedTrack(_playingQueueId[_currentQueueIndex]);
  }

  void goPreviousQueue() {
    bool isFirst = _currentQueueIndex == 0;
    if (isFirst) {
      _currentQueueIndex = _playingQueueId.length - 1;
    } else {
      _currentQueueIndex--;
    }

    setSelectedTrack(_playingQueueId[_currentQueueIndex]);
  }

  void setPlayingQueue(int currentTrackId) {
    _playingQueueId.shuffle();
    _playingQueueId[0] = currentTrackId;

    _currentQueueIndex = 0;
    setSelectedTrack(_playingQueueId[_currentQueueIndex]);
  }
}
