import 'package:docdoc/features/home/data/model/doctor.dart';
import 'package:docdoc/features/home/data/model/specialty.dart';

abstract class DoctorRepository {
  List<Doctor> getDoctors();

  List<Specialty> getSpecialties();

  List<Doctor> search({String? specialty, String query = ''});
}
