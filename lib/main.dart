import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ApiProvider(
        api: Api(),
        child: const HomePage(),
      ),
    );
  }
}

class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;
  ApiProvider({
    Key? key,
    required this.api,
    required Widget child,
  })  : uuid = const Uuid().v4(),
        super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }

  getDateAndTime() {}
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey _textkey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApiProvider.of(context).api.dateaTime ?? ""),
      ),
      body: GestureDetector(
        onTap: (() async {
          final api = ApiProvider.of(context);
          final timeAndDate = await api.getDateAndTime();
          setState(() {
            _textkey = ValueKey(timeAndDate);
          });
        }),
        child: SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: DateTimeWidget(key: _textkey),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(
      api.dateaTime ?? 'Tap on screen for the date and time',
    );
  }
}

class Api {
  String? dateaTime;

  Future<String> getData() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then((value) {
      dateaTime = value;
      return value;
    });
  }
}
