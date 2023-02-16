import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sections.g.dart';

/*
* Model for the sections of each Census data group
*/
@JsonSerializable()
class Sections {
  List<String>? currentSections;

  Sections({this.currentSections});

  Sections copyWith({List<String>? currentSections}) {
    return Sections()
      ..currentSections = currentSections ?? this.currentSections;
  }

  factory Sections.fromJson(Map<String, dynamic> data) =>
      _$SectionsFromJson(data);

  Map<String, dynamic> toJson() => _$SectionsToJson(this);
}

/*
* Holds the state of the user's current sections
*/
class SectionsNotifier extends StateNotifier<Sections> {
  SectionsNotifier(Sections initialState) : super(initialState);

  void specifyCurrentSections(List<String>? currentSections) {
    state = state.copyWith(currentSections: currentSections);
  }

  void clearCurrentSections() {
    state = state.copyWith()..currentSections = null;
  }

  void reset() {
    state = Sections();
  }
}

final sectionsProvider =
    StateNotifierProvider<SectionsNotifier, Sections>((ref) {
  final initialState = Sections();
  return SectionsNotifier(initialState);
});
