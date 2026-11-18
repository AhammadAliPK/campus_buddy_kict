class CampusNote {
  const CampusNote({required this.subject, required this.body});

  final String subject;
  final String body;

  CampusNote copyWith({String? subject, String? body}) {
    return CampusNote(
      subject: subject ?? this.subject,
      body: body ?? this.body,
    );
  }
}
