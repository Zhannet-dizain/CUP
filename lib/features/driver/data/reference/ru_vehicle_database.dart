import '../../domain/models/vehicle.dart';

/// Справочник российской техники
class RuVehicleDatabase {
  /// Список популярных тягачей в РФ
  static final List<TractorModel> tractorList = [
    // Европейская «Большая семерка»
    TractorModel(
      id: 'daf-xf105',
      brand: 'DAF',
      model: 'XF 105',
      wheelFormula: '4x2',
      curbWeight: 8.1,
      frontAxleEmptyWeight: 5.2,
      rearAxleEmptyWeight: 2.9,
      maxFifthWheelLoad: 18.0,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'merc-actros-mp4',
      brand: 'Mercedes-Benz',
      model: 'Actros MP4',
      wheelFormula: '4x2',
      curbWeight: 8.3,
      frontAxleEmptyWeight: 5.4,
      rearAxleEmptyWeight: 2.9,
      maxFifthWheelLoad: 18.5,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'scania-r440',
      brand: 'Scania',
      model: 'R440',
      wheelFormula: '4x2',
      curbWeight: 7.9,
      frontAxleEmptyWeight: 5.1,
      rearAxleEmptyWeight: 2.8,
      maxFifthWheelLoad: 19.0,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'volvo-fh13',
      brand: 'Volvo',
      model: 'FH13',
      wheelFormula: '4x2',
      curbWeight: 8.0,
      frontAxleEmptyWeight: 5.2,
      rearAxleEmptyWeight: 2.8,
      maxFifthWheelLoad: 18.0,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'man-tgx',
      brand: 'MAN',
      model: 'TGX',
      wheelFormula: '4x2',
      curbWeight: 8.2,
      frontAxleEmptyWeight: 5.3,
      rearAxleEmptyWeight: 2.9,
      maxFifthWheelLoad: 18.0,
      suspension: SuspensionType.air,
    ),
    
    // Китайский автопром
    TractorModel(
      id: 'sitrak-c7h-4x2',
      brand: 'Sitrak',
      model: 'C7H MAX',
      wheelFormula: '4x2',
      curbWeight: 7.8,
      frontAxleEmptyWeight: 5.0,
      rearAxleEmptyWeight: 2.8,
      maxFifthWheelLoad: 17.5,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'shacman-x6000',
      brand: 'Shacman',
      model: 'X6000',
      wheelFormula: '4x2',
      curbWeight: 7.9,
      frontAxleEmptyWeight: 5.1,
      rearAxleEmptyWeight: 2.8,
      maxFifthWheelLoad: 18.0,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'faw-j7',
      brand: 'FAW',
      model: 'J7',
      wheelFormula: '4x2',
      curbWeight: 8.1,
      frontAxleEmptyWeight: 5.2,
      rearAxleEmptyWeight: 2.9,
      maxFifthWheelLoad: 18.0,
      suspension: SuspensionType.air,
    ),
    
    // Отечественные
    TractorModel(
      id: 'kamaz-54901',
      brand: 'КАМАЗ',
      model: '54901 (K5)',
      wheelFormula: '4x2',
      curbWeight: 8.2,
      frontAxleEmptyWeight: 5.3,
      rearAxleEmptyWeight: 2.9,
      maxFifthWheelLoad: 18.6,
      suspension: SuspensionType.mixed,
    ),
    TractorModel(
      id: 'maz-5440',
      brand: 'МАЗ',
      model: '5440',
      wheelFormula: '4x2',
      curbWeight: 7.9,
      frontAxleEmptyWeight: 5.1,
      rearAxleEmptyWeight: 2.8,
      maxFifthWheelLoad: 17.0,
      suspension: SuspensionType.air,
    ),
    
    // Тяжеловозы (6x4)
    TractorModel(
      id: 'scania-r500-6x4',
      brand: 'Scania',
      model: 'R500',
      wheelFormula: '6x4',
      curbWeight: 9.5,
      frontAxleEmptyWeight: 5.5,
      rearAxleEmptyWeight: 4.0,
      maxFifthWheelLoad: 21.0,
      suspension: SuspensionType.air,
    ),
    TractorModel(
      id: 'kamaz-65206',
      brand: 'КАМАЗ',
      model: '65206',
      wheelFormula: '6x4',
      curbWeight: 9.2,
      frontAxleEmptyWeight: 5.4,
      rearAxleEmptyWeight: 3.8,
      maxFifthWheelLoad: 20.0,
      suspension: SuspensionType.air,
    ),
  ];

  /// Список доступных полуприцепов
  static final List<TrailerModel> trailerList = [
    TrailerModel(
      id: 'schora-13-6',
      name: 'Стандартная штора 13.6м',
      type: TrailerType.curtainSide,
      axleCount: 3,
      unladenWeight: 6.8,
      axleDistances: [1.31, 1.31],
    ),
    TrailerModel(
      id: 'tonar-16-5-4',
      name: 'Тонар 16.5м (4 оси)',
      type: TrailerType.curtainSide,
      axleCount: 4,
      unladenWeight: 8.5,
      axleDistances: [2.51, 1.31, 1.31], // Первая ось вынесена
      isFirstAxleLifted: false,
    ),
    TrailerModel(
      id: 'tanker-nefaz',
      name: 'Полуприцеп-цистерна (Нефаз)',
      type: TrailerType.tanker,
      axleCount: 3,
      unladenWeight: 7.2,
      axleDistances: [1.31, 1.31],
    ),
    TrailerModel(
      id: 'reefer-standard',
      name: 'Полуприцеп рефрижератор',
      type: TrailerType.reefer,
      axleCount: 3,
      unladenWeight: 8.9,
      axleDistances: [1.31, 1.31],
    ),
  ];
}
