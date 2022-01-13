import 'package:floor/floor.dart';

@entity
class Person {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  Person({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  String toString() {
    return 'Person{id:$id, name: $name}';
  }
}

@dao
abstract class PersonDao {
  @Query('SELECT * FROM Person')
  Future<List<Person>> findAllPersons();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person?> findPersonById(int id);

  @insert
  Future<void> insertPerson(Person person);

  @Query('DELETE FROM Person WHERE id = :id')
  Future<void> deletePerson(int id);

  @Query('DELETE FROM Person')
  Future<void> deletePersonTable();
}
