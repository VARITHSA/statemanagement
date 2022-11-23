import 'package:flutter/material.dart';

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
  final String name;
  const Contacts({
    required this.name,
  });
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contacts> _contacts = [const Contacts(name: "shouyo")];

  int get length => _contacts.length;

  void add({required Contacts value}) {
    _contacts.add(value);
  }

  void remove({required Contacts value}) {
    _contacts.remove(value);
  }

  Contacts? contacts({required int atIndex}) =>
      _contacts.length > atIndex ? _contacts[atIndex] : null;
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
      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: ((context, index) {
          final value = contactBook.contacts(atIndex: index);
          return ListTile(
            title: Text(value!.name),
          );
        }),
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
            ContactBook().add(value: contact);
            Navigator.of(context).pop();
          },
          child: const Text('Add Contact'),
        )
      ]),
    );
  }
}
