class Employee {
  final int id;
  final String name;
  final String role;
  final String joiningDate;
  final String? exitDate;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.joiningDate,
    this.exitDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'joiningDate': joiningDate,
      'exitDate': exitDate,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      joiningDate: map['joiningDate'],
      exitDate: map['exitDate'],
    );
  }
}
