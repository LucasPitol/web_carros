import 'package:web_carros_app/models/aditional_specs.dart';
import 'package:web_carros_app/models/dtos/auto_specs_dto.dart';
import 'package:web_carros_app/models/transmission_specs.dart';
import 'package:web_carros_app/models/dtos/response_dto.dart';
import 'package:web_carros_app/models/dimensions_specs.dart';
import 'package:web_carros_app/models/performace_specs.dart';
import 'package:web_carros_app/models/dtos/filterDto.dart';
import 'package:web_carros_app/models/engine_specs.dart';
import 'package:web_carros_app/models/auto.dart';
import 'package:web_carros_app/db/auto_dao.dart';
import 'package:web_carros_app/utils/constants.dart';

import 'transmission_specs_service.dart';
import 'performance_specs_service.dart';
import 'dimension_specs_service.dart';
import 'aditional_specs_service.dart';
import 'engine_specs_service.dart';

class AutoService {
  AutoDao _dao;
  PerformanceSpecsService _performanceSpecsService;
  EngineSpecsService _engineSpecsService;
  TransmissionSpecsService _transmissionSpecsService;
  DimensionsSpecsService _dimensionsSpecsService;
  AditionalSpecsService _aditionalSpecsService;

  AutoService() {
    this._dao = AutoDao();
    this._performanceSpecsService = PerformanceSpecsService();
    this._engineSpecsService = EngineSpecsService();
    this._transmissionSpecsService = TransmissionSpecsService();
    this._dimensionsSpecsService = DimensionsSpecsService();
    this._aditionalSpecsService = AditionalSpecsService();
  }

  mockData() {
    this._dao.mockData();
  }

  Future<ResponseDto> getNews() async {
    ResponseDto res = ResponseDto();

    List<Auto> autos = await this._dao.getNews();

    autos.sort((a, b) => b.creationDate.compareTo(a.creationDate));

    res.success = true;
    res.data = autos;

    return res;
  }

  Future<ResponseDto> getByIds(List<String> autoIds) async {
    ResponseDto res = ResponseDto();

    List<Auto> autos = await this._dao.getByIds(autoIds);

    res.success = true;
    res.data = autos;

    return res;
  }

  Future<ResponseDto> getAutoSpecs(String autoId) async {
    ResponseDto res = ResponseDto();
    AutoSpecsDto autoSpecsDto = AutoSpecsDto();

    PerformanceSpecs performanceSpecs =
        await this._performanceSpecsService.getPerformanceSpecsByAutoId(autoId);

    autoSpecsDto.performanceSpecs = performanceSpecs;

    EngineSpecs engineSpecs =
        await this._engineSpecsService.getEngineSpecsByAutoId(autoId);

    autoSpecsDto.engineSpecs = engineSpecs;

    TransmissionSpecs transmissionSpecs = await this
        ._transmissionSpecsService
        .getTransmissionSpecsByAutoId(autoId);

    autoSpecsDto.transmissionSpecs = transmissionSpecs;

    DimensionsSpecs dimensionsSpecs =
        await this._dimensionsSpecsService.getDimensionsSpecsByAutoId(autoId);

    autoSpecsDto.dimensionsSpecs = dimensionsSpecs;

    AditionalSpecs aditionalSpecs =
        await this._aditionalSpecsService.getAditionalSpecsByAutoId(autoId);

    autoSpecsDto.aditionalSpecs = aditionalSpecs;

    res.success = true;
    res.data = autoSpecsDto;

    return res;
  }

  Future<ResponseDto> getFilteredAutos(FilterDto filter) async {
    ResponseDto res = ResponseDto();

    String brandName = (filter.brand != null && filter.brand.name.isNotEmpty)
        ? filter.brand.name
        : null;
    int bodywork = filter.bodywork;

    List<int> bodyworkList = [];

    List<Auto> autos = [];

    if (bodywork != null) {
      if (bodywork == 0) {
        Constants.bodyworkMap.keys.forEach((key) {
          if (key != 0) {
            bodyworkList.add(key);
          }
        });
      } else {
        bodyworkList.add(bodywork);
      }
    }

    if (brandName != null) {
      autos = await this._dao.getAutosByBrand(brandName, bodyworkList);
    } else {
      autos = await this._dao.getAutosByBodywork(bodyworkList);
    }

    autos.sort((a, b) => b.initYear.compareTo(a.initYear));

    res.success = true;
    res.data = autos;

    return res;
  }
}
