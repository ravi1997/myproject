import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:myproject/services/logs/log_manager.dart';
import 'package:enum_to_string/enum_to_string.dart';

class Config {
  final String baseUrl;
  final String appName;
  final String lang;
  
  final String organizationName = "Community Ophthalmology";
  final String contactInfo = "Help Line: 011-26593140";
  final String copyright = "© 2025 Community Ophthalmology";

  late Logger logger;



  Config._(this.baseUrl, this.appName,this.lang) {
    logger = LogManager().logger;
  }

  static Future<Config> load() async {
    await dotenv.load(fileName: "assets/files/.env");
    final baseUrl = dotenv.env['BASE_URL'] ?? '';
    final appName = dotenv.env['APP_NAME'] ?? '';
    final lang = dotenv.env['LANG'] ?? '';
    return Config._(baseUrl, appName,lang);
  }
}


late Config config;


enum SchoolType {all, govt, private, other }

extension SchoolTypeExtension on SchoolType {
  String get label => EnumToString.convertToString(this, camelCase: false);

  static SchoolType? fromString(String label) {
    return EnumToString.fromString(SchoolType.values, label, camelCase: false);
  }
  
  IconData get icon {
    switch (this) {
      case SchoolType.govt:
        return Icons.apartment;
      case SchoolType.private:
        return Icons.school;
      case SchoolType.other:
        return Icons.help_outline;
      case SchoolType.all:
        return Icons.list;
    }
  }

}


enum ExaminationStatus { all,examined, absent, refused, referred }

extension ExaminationStatusExtension on ExaminationStatus {
  String get label => EnumToString.convertToString(this, camelCase: false);

  static ExaminationStatus? fromString(String label) {
    return EnumToString.fromString(
      ExaminationStatus.values, label, camelCase: false);
  }


  IconData get icon {
    switch (this) {
      case ExaminationStatus.examined:
        return Icons.check_circle;
      case ExaminationStatus.absent:
        return Icons.cancel;
      case ExaminationStatus.refused:
        return Icons.block;
      
      case ExaminationStatus.referred:
        return Icons.list;
      case ExaminationStatus.all:
        return Icons.list;

    }
  }

}



enum Gender { all, male, female, other }

extension GenderExtension on Gender {
  String get label => EnumToString.convertToString(this, camelCase: false);

  static Gender? fromString(String label) {
    return EnumToString.fromString(
      Gender.values, label, camelCase: false);
  }


  IconData get icon {
    switch (this) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
      case Gender.other:
        return Icons.transgender;
      case Gender.all:
        return Icons.list;
    }
  }

}



enum ReferredReasonSchool { useGlasses, vision, notrefered, controlcase }

extension ReferredReasonSchoolExtension on ReferredReasonSchool {
  String get label {
    if(this==ReferredReasonSchool.useGlasses) {
      return 'Yes, as child uses glasses/ Contact Lens';
    }
    if (this == ReferredReasonSchool.vision) {
      return 'Yes Unaided Vision <6/9 in any eye';
    }
    if (this == ReferredReasonSchool.controlcase) {
      return 'Control Case';
    }

    return 'Not Referred';
  }

  static ReferredReasonSchool? fromString(String label) {
    if (label == 'Yes, as child uses glasses/ Contact Lens') {
      return ReferredReasonSchool.useGlasses;
    }
    if (label == 'Yes Unaided Vision <6/9 in any eye') {
      return ReferredReasonSchool.vision;
    }
    if (label == 'Control Case') {
      return ReferredReasonSchool.controlcase;
    }

    return ReferredReasonSchool.notrefered;  }

}
