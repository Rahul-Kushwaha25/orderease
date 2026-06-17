import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../catalog/domain/usecases/get_items_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.getItemsUseCase,
  }) : super(const HomeInitial()) {
    on<LoadHomeItems>(_onLoadItems);
    on<ToggleViewMode>(_onToggleViewMode);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
  }

  final GetItemsUseCase getItemsUseCase;

  Future<void> _onLoadItems(
    LoadHomeItems event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      final items = await getItemsUseCase();
      emit(HomeLoaded(items: items, cart: const {}, isGrouped: false));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  void _onToggleViewMode(ToggleViewMode event, Emitter<HomeState> emit) {
    final curr = state;
    if (curr is HomeLoaded) {
      emit(HomeLoaded(
        items: curr.items,
        cart: curr.cart,
        isGrouped: !curr.isGrouped,
      ));
    }
  }

  void _onAddToCart(AddToCart event, Emitter<HomeState> emit) {
    final curr = state;
    if (curr is HomeLoaded) {
      final newCart = Map<int, int>.from(curr.cart);
      newCart[event.itemId] = (newCart[event.itemId] ?? 0) + 1;
      emit(HomeLoaded(items: curr.items, cart: newCart, isGrouped: curr.isGrouped));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<HomeState> emit) {
    final curr = state;
    if (curr is HomeLoaded) {
      final newCart = Map<int, int>.from(curr.cart);
      if (newCart.containsKey(event.itemId)) {
        final newQty = newCart[event.itemId]! - 1;
        if (newQty <= 0) {
          newCart.remove(event.itemId);
        } else {
          newCart[event.itemId] = newQty;
        }
      }
      emit(HomeLoaded(items: curr.items, cart: newCart, isGrouped: curr.isGrouped));
    }
  }
}
