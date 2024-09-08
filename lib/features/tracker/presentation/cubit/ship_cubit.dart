import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/ship_entity.dart';
import '../../domain/usecases/create_report_use_case.dart';
import '../../domain/usecases/get_all_spreadsheet_files_use_case.dart';
import '../../domain/usecases/get_ships_use_case.dart';
import '../../domain/usecases/insert_ship_use_case.dart';

part 'ship_state.dart';

class ShipCubit extends Cubit<ShipState> {
  ShipCubit({
    required this.getShipsUseCase,
    required this.insertShipUseCase,
    required this.createReportUseCase,
    required this.getAllSpreadsheetFilesUseCase,
    required this.camera,
  }) : super(ShipInitial());

  final GetShipsUseCase getShipsUseCase;
  final InsertShipUseCase insertShipUseCase;
  final CreateReportUseCase createReportUseCase;
  final GetAllSpreadsheetFilesUseCase getAllSpreadsheetFilesUseCase;
  final CameraDescription camera;

  late List<String> shortFilename;
  late String picturePath;

  Future<void> getShips(int stageId) async {
    emit(ShipLoading());

    final result = await getShipsUseCase(stageId);

    result.fold(
      (l) => emit(ShipError(l.message)),
      (r) => r.isEmpty ? emit(ShipEmpty()) : emit(ShipLoaded(r)),
    );
  }

  Future<void> insertShip(
      String receiptNumber, String name, int stageId) async {
    emit(InsertShipLoading());

    final result = await insertShipUseCase(receiptNumber, name, stageId);

    result.fold(
      (l) => emit(InsertShipError(l.message)),
      (r) => emit(InsertShipFinished(r)),
    );
  }

  Future<void> createReport() async {
    emit(ReportLoading());

    final result = await createReportUseCase();

    result.fold(
      (l) => emit(ReportError(l.message)),
      (r) => emit(CreateReport(r)),
    );
  }

  Future<void> getAllSpreadsheetFiles() async {
    emit(ReportLoading());

    final result = await getAllSpreadsheetFilesUseCase();

    result.fold(
      (l) => emit(ReportError(l.message)),
      (r) {
        shortFilename =
            r.map((e) => e.split(RegExp(r'.*files/')).last).toList();
        emit(AllReport(r));
      },
    );
  }
}
