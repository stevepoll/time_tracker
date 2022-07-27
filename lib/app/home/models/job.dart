class Job {
  Job({
    required this.name,
    required this.ratePerHour,
  });

  final String name;
  final double ratePerHour;

  Job.fromMap(Map<String, dynamic> data)
      : name = data['name'],
        ratePerHour = data['ratePerHour'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
