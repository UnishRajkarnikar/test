import 'dart:developer';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:offline_storage_prj/database.dart';
import 'package:offline_storage_prj/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  List<Person> personList = [];

  @override
  initState() {
    super.initState();
    getPersonList();
    // getPersonList().then((value) => {personList = value});
  }

  void addPerson(String name) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_person.db').build();

    final personDao = database.personDao;
    Person person = Person(name: name);
    await personDao.insertPerson(person);
    print(name);
  }

  void deletePerson(int id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_person.db').build();

    final personDao = database.personDao;
    await personDao.deletePerson(id);
    print('Person with id: $id deleted...');
  }

  void deleteAll() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_person.db').build();

    final personDao = database.personDao;
    await personDao.deletePersonTable();
    setState(() {
      getPersonList().then((value) => personList = []);
    });
    log('All Deleted');
  }

  Future<List<Person>> getPersonList() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_person.db').build();

    final personDao = database.personDao;
    final persons = await personDao.findAllPersons();
    setState(() {
      personList = persons;
    });
    print(personList);
    return persons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: deleteAll,
        child: const Icon(Icons.delete_forever_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: personList == List.empty()
                  ? const Center(
                      child: Text(
                        'NO DATA AVAILABLE',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: personList.length,
                      itemBuilder: (_, index) => Row(
                        children: [
                          // Text(
                          //   '${personList[index].id}. ',
                          //   style: const TextStyle(
                          //     fontSize: 30,
                          //   ),
                          // ),
                          Text(
                            personList[index].name,
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              deletePerson(personList[index].id!);
                              setState(() {
                                getPersonList()
                                    .then((value) => personList = value);
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            TextField(
              controller: _nameController,
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text != '') {
                  addPerson(_nameController.text);
                  setState(() {
                    getPersonList().then((value) => personList = value);
                  });
                }
              },
              child: const Text(
                'Add Person',
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
