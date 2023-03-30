import 'package:flutter/material.dart';


import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

final saved = <WordPair>[];

class Favoritos extends StatelessWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Voltar'))
        ],
      ),
      body: ListView.builder(
        itemCount: saved.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(saved[index].asPascalCase),
          );
        }
          ),
          ),
       );
  }
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  final suggestions = <WordPair>[];
  final biggerFont = const TextStyle(fontSize: 18);


  String viewType = 'list';

  lista_card(){
    if (viewType == 'list'){
      return const Text('Cards');
    }else{
      return const Text('Lista');
    }
  }

  botao(){
    if (viewType == 'list') {
      viewType = 'grid';
    }
    else{
      viewType = 'list';
    }
    setState(() {});
  }

  body(){
    if (viewType == 'list') {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          final alreadySaved = saved.contains(suggestions[index]);
          return ListTile(
              title: Container(
                child: Dismissible(
                  key: ObjectKey(suggestions[index].asPascalCase),
                  child: Text(
                    suggestions[index].asPascalCase,
                    style: biggerFont,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                    suggestions.removeAt(index);
                    saved.removeAt(index);
                     });  
                  },
                ),
              ),
              trailing: IconButton(
                icon: alreadySaved ? const Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border),
              onPressed: () {
                setState(() {
                  if (alreadySaved){
                    saved.remove(suggestions[index]);
                  } else {
                    saved.add(suggestions[index]);
                  }
                });
                }
              ),
          );
        },
      );
    }
    else{
      return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i >= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          // final alreadySaved = saved.contains(suggestions[i]);
          return Card(
                child: Center(
                  child: Text(
                suggestions[i].asPascalCase,
                style: biggerFont,
                )
                  ,)
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Builder(
        builder: ((context) => 
      Scaffold(
      appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            ElevatedButton(
              onPressed: botao,
              child: lista_card(),
            ),
            IconButton(
              icon: Icon(Icons.star, color: Colors.yellow,),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Favoritos())),
            )
          ]),
      body: body(),
      )),
      ),
      );
  }
}