import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../domain/usecases/add_item_usecase.dart';
import '../../domain/usecases/update_item_usecase.dart';
import '../../domain/usecases/delete_item_usecase.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({
    required this.getItemsUseCase,
    required this.addItemUseCase,
    required this.updateItemUseCase,
    required this.deleteItemUseCase,
  }) : super(const CatalogInitial()) {
    on<LoadCatalogItems>(_onLoadItems);
    on<AddCatalogItem>(_onAddItem);
    on<UpdateCatalogItem>(_onUpdateItem);
    on<DeleteCatalogItem>(_onDeleteItem);
  }

  final GetItemsUseCase getItemsUseCase;
  final AddItemUseCase addItemUseCase;
  final UpdateItemUseCase updateItemUseCase;
  final DeleteItemUseCase deleteItemUseCase;

  Future<void> _onLoadItems(
    LoadCatalogItems event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());
    try {
      final items = await getItemsUseCase();
      emit(CatalogLoaded(items: items));
    } catch (e) {
      emit(CatalogError(message: e.toString()));
    }
  }

  Future<void> _onAddItem(
    AddCatalogItem event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());
    try {
      await addItemUseCase(event.item);
      emit(const CatalogItemOperationSuccess());
      add(const LoadCatalogItems());
    } catch (e) {
      emit(CatalogError(message: e.toString()));
    }
  }

  Future<void> _onUpdateItem(
    UpdateCatalogItem event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());
    try {
      await updateItemUseCase(event.item);
      emit(const CatalogItemOperationSuccess());
      add(const LoadCatalogItems());
    } catch (e) {
      emit(CatalogError(message: e.toString()));
    }
  }

  Future<void> _onDeleteItem(
    DeleteCatalogItem event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoading());
    try {
      await deleteItemUseCase(event.itemId);
      emit(const CatalogItemOperationSuccess());
      add(const LoadCatalogItems());
    } catch (e) {
      emit(CatalogError(message: e.toString()));
    }
  }
}
