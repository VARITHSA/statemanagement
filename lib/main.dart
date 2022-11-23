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
      home: const HomePage(),
      routes: {'/newcontact': (context) => const NewContactView()},
    );
  }
}

class Contacts {
  final String id;
  final String name;
  Contacts({
    required this.name,
  }) : id = const Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contacts>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contacts> _contacts = [];

  int get length => value.length;

  void add({required Contacts contact}) {
    value.add(contact);
    notifyListeners();
  }

  void remove({required Contacts contact}) {
    final contacts = value;
    if (contacts.contains(contact)) {
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contacts? contacts({required int atIndex}) =>
      value.length > atIndex ? value[atIndex] : null;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final contactBook = ContactBook();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: ((context, index) {
              final value = contacts[index];
              return Dismissible(
                onDismissed: (direction) {
                  ContactBook().remove(contact: value);
                },
                key: ValueKey(value.id),
                child: Material(
                  color: Colors.white,
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(value.name),
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/newcontact');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add contacts"),
      ),
      body: Column(children: [
        TextField(
          controller: textEditingController,
          decoration: const InputDecoration(
              hintText: 'Enter the new contact to be added'),
        ),
        TextButton(
          onPressed: () {
            final contact = Contacts(name: textEditingController.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
          },
          child: const Text('Add Contact'),
        )
      ]),
    );
  }
}
