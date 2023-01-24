// import 'package:flutter/cupertino.dart';
// import 'package:simple_music_player/helpers/constants.dart';

// import '../helpers/helper.dart';
// import '../models/genre_model.dart';
// import '../models/music_model.dart';

// class AssetMusicProvider extends ChangeNotifier {
//   List<SongModel> _items = [];

//   SongModel? _selectedMusic;

//   List<SongModel> get items => _items;
//   SongModel? get selectedMusic => _selectedMusic;

//   Future<void> fetch({String title = '', String artist = ''}) async {
//     // var res = await http.get(
//     //   Uri.parse('$host/songs'),
//     //   headers: {
//     //     'Content-Type': 'application/json',
//     //     'SearchByTitle': title,
//     //     'SearchByArtist': artist,
//     //   },
//     // );

//     // List resBody = jsonDecode(res.body);
//     _items.clear();

//     List resBody = mockDatabase
//         .where(
//           (element) =>
//               (element['title'] as String).toLowerCase().contains(title) &&
//               (element['artist'] as String).toLowerCase().contains(artist),
//         )
//         .toList();
//     print(resBody);

//     for (var song in resBody) {
//       _items.add(
//         SongModel(
//           id: song['id'].toString(),
//           artist: song['artist'],
//           title: song['title'],
//           genre: (song['genre'] as List<Map>)
//               .map((e) => GenreModel(id: e['id'], name: e['name']))
//               .toList(),
//           url: song['url'],
//         ),
//       );
//     }

//     await Future.delayed(
//       Duration.zero,
//       () {
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> selectMusic(String id) async {
//     _selectedMusic = _items.firstWhere((element) => element.id == id);
//     notifyListeners();
//   }

//   Future<void> add({
//     required String title,
//     required String artist,
//     required List<GenreModel> genres,
//   }) async {
//     title = toTitleCase(title);
//     artist = toTitleCase(artist);

//     try {
//       // var reqBody = {
//       //   'title': title,
//       //   'artist': artist,
//       //   'genres': genres.map((e) => e.id).toList(),
//       // };
//       // var res = await http.post(
//       //   Uri.parse('$host/add-song'),
//       //   body: jsonEncode(reqBody),
//       //   headers: {'Content-Type': 'application/json'},
//       // );

//       // var resBody = jsonDecode(res.body);
//       // print(res.statusCode);
//       // print(resBody);

//       _items.add(
//         SongModel(
//           id: (_items.length + 1).toString(), // USE INSERTID
//           artist: artist,
//           title: title,
//           genre: genres,
//           url: 'lol',
//         ),
//       );
//     } catch (e) {
//       rethrow;
//     }

//     notifyListeners();
//   }

//   Future<void> remove(String id) async {
//     try {
//       // var res = await http.delete(
//       //   Uri.parse('$host/songs/$id'),
//       //   headers: {'Content-Type': 'application/json'},
//       // );

//       // var resBody = jsonDecode(res.body);
//       // print(resBody);
//       _items.removeWhere((element) => element.id == id);
//     } catch (e) {
//       rethrow;
//     }
//     notifyListeners();
//   }
// }
