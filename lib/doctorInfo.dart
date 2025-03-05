class Doctor {
  final String id;
  final String firstName;
  final String lastName;
  final String specialization;
  final String email;
  final String phoneNumber;
  final Map<String, String> officeAddress;
  final List<Map<String, String>> availability;
  final int consultationFee;
  final String createdAt;
  final String updatedAt;

  Doctor(
    this.id,
    this.firstName,
    this.lastName,
    this.specialization,
    this.email,
    this.phoneNumber,
    this.officeAddress,
    this.availability,
    this.consultationFee,
    this.createdAt,
    this.updatedAt,
  );
}
