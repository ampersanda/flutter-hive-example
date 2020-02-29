import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveexample/note.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await getApplicationDocumentsDirectory()).path);
//  Hive.initFlutter((await getApplicationDocumentsDirectory()).path);

  Hive.registerAdapter<Note>(NoteAdapter());
  await Future.wait([Hive.openBox<Note>('notes')]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }

  @override
  void dispose() {
    Hive.box('notes').compact();
    Hive.close();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static const String routeName = '';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Box<Note> noteBox = Hive.box('notes');

    return Scaffold(
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: noteBox.listenable(),
        builder: (_, Box<dynamic> noteBox, __) {
          return ListView.builder(
            itemBuilder: (_, int index) {
              return Text(noteBox.getAt(index).title);
            },
            itemCount: noteBox.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          noteBox.add(Note('title', 'content'));
        },
        child: Icon(Icons.title),
      ),
    );
  }
}
