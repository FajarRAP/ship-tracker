import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/create_report_use_case.dart';

import '../../domain/entities/ship_entity.dart';
import '../../domain/usecases/get_ships_use_case.dart';
import '../../domain/usecases/insert_ship_use_case.dart';

part 'ship_state.dart';

class ShipCubit extends Cubit<ShipState> {
  ShipCubit({
    required this.getShipsUseCase,
    required this.insertShipUseCase,
    required this.createReportUseCase,
  }) : super(ShipInitial());

  final GetShipsUseCase getShipsUseCase;
  final InsertShipUseCase insertShipUseCase;
  final CreateReportUseCase createReportUseCase;

  Future<void> getShips(int stageId) async {
    emit(ShipLoading());

    final result = await getShipsUseCase(stageId);

    result.fold(
      (l) => emit(ShipError(l.message)),
      (r) => emit(ShipLoaded(r)),
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
    emit(CreateReportLoading());

    final result = await createReportUseCase();

    result.fold(
      (l) => emit(CreateReportError(l.message)),
      (r) => emit(CreateReportLoaded(r)),
    );
  }
}
