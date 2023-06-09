import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:developer';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _pageSize = 5;

  final PagingController<int, CharacterSummary> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
        final newItems = char.sublist(pageKey,pageKey+5);
        log('newItems: ${newItems.toString()})');
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          log('isLastPage: ${newItems.toString()})');
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + newItems.length;
          Future.delayed(const Duration(seconds: 5), () {
            _pagingController.appendPage(newItems, nextPageKey);
            log('finalItems: ${newItems.toString()}');
          });
        }

    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: PagedListView<int, CharacterSummary>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<CharacterSummary>(
            itemBuilder: (context, item, index) => Column(
              children: [
                Text(item.id.toString()),
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.black12,
                ),
                Text(item.name)
              ],
            )
          ),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class CharacterSummary {
  final int id;
  final String name;
  final int pageNo;

  const CharacterSummary({
    required this.id,
    required this.name,
    required this.pageNo,
  });
}

List<CharacterSummary> char = [
  const CharacterSummary(id: 1, name: 'sam', pageNo:1),
  const CharacterSummary(id: 2, name: 'ram', pageNo:1),
  const CharacterSummary(id: 3, name: 'sham',pageNo:1),
  const CharacterSummary(id: 4, name: 'vishal', pageNo:1),
  const CharacterSummary(id: 5, name: 'ketan', pageNo:1),
  const CharacterSummary(id: 6, name: 'sam', pageNo:2),
  const CharacterSummary(id: 7, name: 'ram', pageNo:2),
  const CharacterSummary(id: 8, name: 'sham', pageNo:2),
  const CharacterSummary(id: 9, name: 'vishal', pageNo:2),
  const CharacterSummary(id: 10, name: 'ketan', pageNo:2),
  const CharacterSummary(id: 11, name: 'sam', pageNo:3),
  const CharacterSummary(id: 12, name: 'ram',pageNo:3),
  const CharacterSummary(id: 13, name: 'sham',pageNo:3),
  const CharacterSummary(id: 14, name: 'vishal', pageNo:3),
  const CharacterSummary(id: 15, name: 'ketan', pageNo:3),
];
