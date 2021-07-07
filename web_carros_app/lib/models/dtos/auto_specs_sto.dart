import 'package:web_carros_app/models/transmission_specs.dart';

import '../dimensions_specs.dart';
import '../engine_specs.dart';
import '../performace_specs.dart';

class AutoSpecsDto {
  PerformanceSpecs performanceSpecs;
  EngineSpecs engineSpecs;
  TransmissionSpecs transmissionSpecs;
  DimensionsSpecs dimensionsSpecs;

  AutoSpecsDto() {
    this.performanceSpecs = PerformanceSpecs();
    this.engineSpecs = EngineSpecs();
    this.transmissionSpecs = TransmissionSpecs();
    this.dimensionsSpecs = DimensionsSpecs();
  }
}