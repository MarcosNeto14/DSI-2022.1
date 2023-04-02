import 'package:flutter/material.dart';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyWidget());

final saved = <WordPair>[];
final listaNome = <WordPair>[];
final suggestions = <WordPair>[];
var palavraVez = "";
int qtdPalavras = 40;

class Argumentos {
  final WordPair nome;
  Argumentos(this.nome);
}
class Repositorio {
  WordPair nomePalavra;

  Repositorio(this.nomePalavra);
}



class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MyApp(),
        TelaEditar.routeName: (context) => const TelaEditar(),
      },
    );
  }
}

class Favoritos extends StatelessWidget {
  const Favoritos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: Text('Voltar'))
        ],
      ),
      body: ListView.builder(
          itemCount: saved.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(saved[index].asPascalCase),
            );
          }),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final biggerFont = const TextStyle(fontSize: 18);

  String viewType = 'list';


  lista_card() {
    if (viewType == 'list') {
      return const Text('Cards');
    } else {
      return const Text('Lista');
    }
  }

  botao() {
    if (viewType == 'list') {
      viewType = 'grid';
    } else {
      viewType = 'list';
    }
    setState(() {});
  }

  body() {
    if (viewType == 'list') {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: qtdPalavras,
        itemBuilder: /*1*/ (conext, i) {
          final index = i ~/ 2; /*3*/
          // if(suggestions.length <= 20) {
            if (i.isOdd) return const Divider(); /*2*/

            if (index <= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(20)); /*4*/
          }
          // }
          
          final alreadySaved = saved.contains(suggestions[index]);
          return ListTile(
              title: Dismissible(
                key: ObjectKey(suggestions[index].asPascalCase),
                child: 
                    Text( 
                      suggestions[index].asPascalCase,
                      style: biggerFont,
                    ),
                onDismissed: (direction) {
                  setState(() {
                    suggestions.removeAt(index);
                    // print(suggestions);
                    // saved.removeAt(index);
                  });
                },
              ),
              trailing: IconButton(
                  icon: alreadySaved
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      if (alreadySaved) {
                        saved.remove(suggestions[index]);
                      } else {
                        saved.add(suggestions[index]);
                      }
                    });
                  }),
              onTap: () {
                Navigator.pushNamed(context, '/editar',
                    arguments: Argumentos(
                      suggestions[index],
                    ));
              }
              );
              
        },
      );
    } else {
      return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i >= suggestions.length) {
            suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return Card(
            child: Center(
                child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/editar',
                    arguments: Argumentos(
                      suggestions[i],
                    ));
              },
              child: Text(
                suggestions[i].asPascalCase,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            )),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Startup Name Generator', style: TextStyle(fontSize:16),), actions: [
        ElevatedButton(
          onPressed: botao,
          child: lista_card(),
        ),
        IconButton(
          icon: const Icon(
            Icons.star,
            color: Colors.yellow,
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Favoritos())),
        ),
      ]),
      body: body(),
    );
  }
}

class TelaEditar extends StatefulWidget {
  static const routeName = '/editar';

  const TelaEditar({Key? key}) : super(key: key);

  @override
  State<TelaEditar> createState() => _TelaEditarState();
}

class _TelaEditarState extends State<TelaEditar> {


  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as Argumentos;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Palavra "),
      ),
      body: Column(
        children: [
          const Center(
              child: Text(
            "Palavra que será editada: ",
            style: TextStyle(fontSize: 20),
          )),
          Center(
              child: Text(argumentos.nome.asPascalCase,
                  style: const TextStyle(fontSize: 32, color: Colors.red))),
          
        ],
      ),
    );
  }
}
