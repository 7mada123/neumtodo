class TodoObject {
  final int id;
  final int addedDate;
  final int completeDate;
  final DateTime shouldCompleteDate;
  final int year;
  final int month;
  final int day;
  final String title;
  final String description;
  final bool isCompleted;

  const TodoObject({
    required this.id,
    required this.addedDate,
    required this.completeDate,
    required this.shouldCompleteDate,
    required this.year,
    required this.month,
    required this.day,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  TodoObject copyWith({
    final int? id,
    final int? addedDate,
    final int? completeDate,
    final DateTime? shouldCompleteDate,
    final int? year,
    final int? month,
    final int? day,
    final String? title,
    final String? description,
    final bool? isCompleted,
  }) {
    return TodoObject(
      id: id ?? this.id,
      addedDate: addedDate ?? this.addedDate,
      completeDate: completeDate ?? this.completeDate,
      shouldCompleteDate: shouldCompleteDate ?? this.shouldCompleteDate,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addedDate': addedDate,
      'completeDate': completeDate,
      'shouldCompleteDate': shouldCompleteDate.millisecondsSinceEpoch,
      'year': year,
      'month': month,
      'day': day,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory TodoObject.empty() {
    final date = DateTime.now();
    return TodoObject(
      id: -1,
      addedDate: 0,
      completeDate: 0,
      shouldCompleteDate: date,
      year: date.year,
      month: date.month - 1,
      day: date.day,
      title: '',
      description: '',
      isCompleted: false,
    );
  }

  factory TodoObject.fromMap(final Map<String, dynamic> map) {
    return TodoObject(
      id: map['id'],
      addedDate: map['addedDate'],
      completeDate: map['completeDate'],
      shouldCompleteDate: DateTime.fromMillisecondsSinceEpoch(
        map['shouldCompleteDate'],
      ),
      year: map['year'],
      month: map['month'],
      day: map['day'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
    );
  }

  @override
  bool operator ==(final other) {
    if (identical(this, other)) return true;

    return other is TodoObject &&
        other.id == id &&
        other.addedDate == addedDate &&
        other.completeDate == completeDate &&
        other.shouldCompleteDate == shouldCompleteDate &&
        other.year == year &&
        other.month == month &&
        other.day == day &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        addedDate.hashCode ^
        completeDate.hashCode ^
        shouldCompleteDate.hashCode ^
        year.hashCode ^
        month.hashCode ^
        day.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isCompleted.hashCode;
  }
}
