import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/save_order_usecase.dart';
import '../../domain/usecases/get_recent_orders_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required this.saveOrderUseCase,
    required this.getRecentOrdersUseCase,
  }) : super(const OrderInitial()) {
    on<SaveOrderEvent>(_onSaveOrder);
    on<LoadRecentOrdersEvent>(_onLoadRecentOrders);
  }

  final SaveOrderUseCase saveOrderUseCase;
  final GetRecentOrdersUseCase getRecentOrdersUseCase;

  Future<void> _onSaveOrder(
    SaveOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      await saveOrderUseCase(event.order);
      emit(const OrderSavedState());
      add(const LoadRecentOrdersEvent());
    } catch (e) {
      emit(OrderErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadRecentOrders(
    LoadRecentOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      final orders = await getRecentOrdersUseCase();
      emit(RecentOrdersLoadedState(orders: orders));
    } catch (e) {
      emit(OrderErrorState(message: e.toString()));
    }
  }
}
