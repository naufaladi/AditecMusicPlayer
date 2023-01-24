import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:path/path.dart';

import 'genre_model.dart';

class Track {
  int id;
  String title;
  String artist;
  String album;
  List<GenreModel> genre;
  String fileName;
  String filePath;
  String format;
  DateTime lastModified;
  DateTime lastAccessed;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.album,
    required this.fileName,
    required this.filePath,
    required this.format,
    required this.lastModified,
    required this.lastAccessed,
  });

  factory Track.fromFileSystemEntity({
    required FileSystemEntity file,
    required int itemLength,
    required List<GenreModel> genre,
  }) {
    String filePath = file.path;
    String fileName = basename(filePath);
    String format;
    FileStat fileStat = file.statSync();

    String temp = fileName;
    format = temp.substring(temp.lastIndexOf('.'));
    temp = temp.replaceRange(temp.lastIndexOf('.'), null, '');

    String title = temp;
    String artist = "";
    String album = "";

    int hyphenSeparatorIndex = temp.indexOf("-");

    if (hyphenSeparatorIndex != -1) {
      artist = temp.substring(0, hyphenSeparatorIndex);
      temp = temp.replaceRange(0, hyphenSeparatorIndex + 1, '').trimLeft();

      int doubleSpaceSeparatorIndex = temp.lastIndexOf('  ');

      if (doubleSpaceSeparatorIndex != -1) {
        title = temp.substring(0, doubleSpaceSeparatorIndex);
        temp = temp.replaceFirst("$title  ", '');

        album = temp;
      } else {
        title = temp.substring(0);
      }
    }

    title = title.trim();
    artist = artist.trim();
    album = album.trim();

    // print("artist $artist");
    // print("titles $title");
    // print("\n");

    return Track(
      id: (itemLength + 1),
      title: title,
      artist: artist,
      genre: genre,
      album: album,
      fileName: fileName,
      filePath: filePath,
      format: format,
      lastModified: fileStat.modified,
      lastAccessed: fileStat.accessed,
    );
  }
}
