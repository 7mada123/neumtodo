import 'package:flutter/material.dart';

class SearchObject {
  final String searchText;
  final bool isCompetedOnly;
  final DateTimeRange? date;

  const SearchObject({
    required this.isCompetedOnly,
    required this.searchText,
    this.date,
  });

  const SearchObject.init()
      : searchText = '',
        date = null,
        isCompetedOnly = false;

  SearchObject copyWith({
    final String? searchText,
    final DateTimeRange? date,
    final bool? isCompetedOnly,
  }) {
    return SearchObject(
      searchText: searchText ?? this.searchText,
      date: date ?? this.date,
      isCompetedOnly: isCompetedOnly ?? this.isCompetedOnly,
    );
  }

  @override
  bool operator ==(final other) {
    if (identical(this, other)) return true;

    return other is SearchObject &&
        other.searchText == searchText &&
        other.date == date &&
        other.isCompetedOnly == isCompetedOnly;
  }

  @override
  int get hashCode {
    return searchText.hashCode ^ date.hashCode ^ isCompetedOnly.hashCode;
  }
}
