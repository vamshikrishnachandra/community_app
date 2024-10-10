class Event {
  String id;
  String title;
  DateTime date;
  String description;

  Event({required this.id, required this.title, required this.date, this.description = ''});
}
