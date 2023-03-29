// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final saved = <WordPair>{};
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
              title: Text(
                suggestions[index].asPascalCase,
                style: biggerFont,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              onTap: () {
                setState(() {
                  if (alreadySaved){
                    saved.remove(suggestions[index]);
                  } else {
                    saved.add(suggestions[index]);
                  }
                });
                }
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
                
              // ),
              // trailing: Icon(
              //   alreadySaved ? Icons.favorite : Icons.favorite_border,
              //   color: alreadySaved ? Colors.red : null,
              //   semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              // ),
              // onTap: () {
              //   setState(() {
              //     if (alreadySaved) {
              //       saved.remove(suggestions[i]);
              //     } else {
              //       saved.add(suggestions[i]);
              //     }
              //   });
              // }
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
            ElevatedButton(
              onPressed: botao,
              child: lista_card(),
            ),
          ]),
      body: body(),
      ),
    );
  }
}