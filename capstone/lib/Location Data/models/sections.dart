import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sections.g.dart';

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
