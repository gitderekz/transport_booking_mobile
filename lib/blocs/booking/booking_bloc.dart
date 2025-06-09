import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:transport_booking/models/booking.dart';
import 'package:transport_booking/models/route.dart';
import 'package:transport_booking/repositories/booking_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;
  BookingState? _previousState; // Add this line to track previous state
  InitialDataLoaded? _cachedInitialData;
  HomeDataLoaded? _cachedHomeData;
  TicketsLoaded? _cachedTicketsData;
  AllRoutesLoaded? _cachedRoutesData;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<CreateBooking>(_onCreateBooking);
    on<CancelBooking>(_onCancelBooking);
    on<BookingSeatsSelected>(_onSeatsSelected);
    on<BookingStopsSelected>(_onStopsSelected);
    // on<BookingStarted>(_onBookingStarted);
    on<BookingStarted>((event, emit) async {
      _previousState = state;
      emit(BookingLoading());
      try {
        final result = await bookingRepository.searchRoutes(
          from: event.from,
          to: event.to,
          date: event.date,
        );
        result.fold(
              (failure) => emit(BookingError(message: failure.message)),
              (routes) => emit(BookingLoadSuccess(routes: routes)),
        );
      } catch (e) {
        emit(BookingError(message: 'Failed to search routes: ${e.toString()}'));
      }
    });
    on<BookingSubmitted>(_onBookingSubmitted);
    on<DownloadTicket>(_onDownloadTicket);
    on<LoadPopularRoutes>(_onLoadPopularRoutes);
    on<LoadRoutesByTransportType>(_onLoadRoutesByTransportType);
    on<LoadAllRoutes>(_onLoadAllRoutes);
    on<LoadInitialData>(_onLoadInitialData);
    on<RestoreHomeData>(_onRestoreHomeData);
    on<CacheCurrentState>(_onCacheCurrentState);
    on<RestoreCachedState>(_onRestoreCachedState);
    on<RestorePreviousState>((event, emit) {
      if (_previousState != null) {
        emit(_previousState!);
      } else {
        add(LoadInitialData());
      }
    });
  }

  FutureOr<void> _onCacheCurrentState(
      CacheCurrentState event,
      Emitter<BookingState> emit,
      ) {
    final currentState = state;
    if (currentState is InitialDataLoaded) {
      _cachedInitialData = currentState;
    } else if (currentState is HomeDataLoaded) {
      _cachedHomeData = currentState;
    } else if (currentState is TicketsLoaded) {
      _cachedTicketsData = currentState;
    } else if (currentState is AllRoutesLoaded) {
      _cachedRoutesData = currentState;
    }
  }

  FutureOr<void> _onRestoreCachedState(
      RestoreCachedState event,
      Emitter<BookingState> emit,
      ) {
    if (_cachedInitialData != null) {
      emit(_cachedInitialData!);
    } else if (_cachedHomeData != null) {
      emit(_cachedHomeData!);
    } else if (_cachedTicketsData != null) {
      emit(_cachedTicketsData!);
    } else if (_cachedRoutesData != null) {
      emit(_cachedRoutesData!);
    } else {
      emit(BookingInitial());
      add(LoadInitialData());
    }
  }
  FutureOr<void> _onLoadBookings(
      LoadBookings event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.getUserBookings();
      // emit(BookingsLoaded(bookings: bookings));
      bookings.fold(
            (failure) => emit(BookingError(message: failure.message)),
            (bookings) => emit(BookingsLoaded(bookings: bookings)),
      );
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  FutureOr<void> _onCreateBooking(
      CreateBooking event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      final booking = await bookingRepository.createBooking(
        routeId: event.routeId,
        transportId: event.transportId,
        pickupStopId: event.pickupStopId,
        dropoffStopId: event.dropoffStopId,
        seats: event.seats,
        payment_method: event.paymentMethod,
        paymentDetails:event.paymentDetails,
        notes: event.notes,
      );
      // emit(BookingCreated(booking: booking));

      booking.fold(
            (failure) => emit(BookingError(message: failure.message)),
            (booking) => emit(BookingCreated(booking: booking)),
      );
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  FutureOr<void> _onCancelBooking(
      CancelBooking event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      await bookingRepository.cancelBooking(event.bookingId);
      emit(BookingCancelled());
      add(LoadBookings());
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  FutureOr<void> _onSeatsSelected(
      BookingSeatsSelected event,
      Emitter<BookingState> emit,
      ) {
    emit(BookingSeatsSelectedState(selectedSeats: event.selectedSeats));
  }

  FutureOr<void> _onStopsSelected(
      BookingStopsSelected event,
      Emitter<BookingState> emit,
      ) {
    emit(BookingStopsSelectedState(
      pickupStopId: event.pickupStopId,
      dropoffStopId: event.dropoffStopId,
    ));
  }

  Future<void> _onBookingStarted(
      BookingStarted event,
      Emitter<BookingState> emit,
      ) async {
    _previousState = state; // Store current state before searching
    emit(BookingLoading());
    try {
      final result = await bookingRepository.searchRoutes(
        from: event.from,
        to: event.to,
        date: event.date,
      );
      result.fold(
            (failure) => emit(BookingError(message: failure.message)),
            (routes) => emit(BookingLoadSuccess(routes: routes)),
      );
    } catch (e) {
      emit(BookingError(message: 'Failed to search routes: ${e.toString()}'));
    }
  }

  Future<void> _onBookingSubmitted(
      BookingSubmitted event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingSubmissionInProgress());
    try {
      final result = await bookingRepository.createBooking(
        routeId: event.routeId,
        transportId: event.transportId,
        pickupStopId: event.pickupStopId,
        dropoffStopId: event.dropoffStopId,
        seats: event.seats,
        payment_method: event.paymentMethod,
        paymentDetails:event.paymentDetails,
        notes: event.notes,
      );

      result.fold(
            (failure) => emit(BookingSubmissionFailure(error: failure.message)),
            (booking) => emit(BookingSubmissionSuccess(booking: booking)),
      );
    } catch (e) {
      emit(BookingSubmissionFailure(error: e.toString()));
    }
  }
  Future<void> _onDownloadTicket(
      DownloadTicket event,
      Emitter<BookingState> emit,
      ) async {
    try {
      // Optionally emit a loading state here
      // emit(DownloadingTicket());

      // Simulate or perform the download logic
      // For example, call a repository function or download a file
      print("Downloading ticket for booking ID: ${event.bookingId}");

      // Optionally emit a success state
      // emit(TicketDownloadedSuccessfully());

    } catch (e) {
      // Handle error, maybe emit a failure state
      // emit(DownloadTicketFailed(error: e.toString()));
    }
  }

// Update booking_bloc.dart
  FutureOr<void> _onLoadPopularRoutes(
      LoadPopularRoutes event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    print('Loading popular routes...'); // Debug print
    try {
      final result = await bookingRepository.getPopularRoutes();
      print('Popular routes result: $result'); // Debug print
      result.fold(
            (failure) {
          print('Popular routes load failed: ${failure.message}'); // Debug print
          emit(BookingError(message: failure.message));
        },
            (routes) {
          print('Popular routes loaded: ${routes.length} routes'); // Debug print
          emit(PopularRoutesLoaded(routes: routes));
        },
      );
    } catch (e) {
      print('Popular routes load error: $e'); // Debug print
      emit(BookingError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadRoutesByTransportType(
      LoadRoutesByTransportType event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      final result = await bookingRepository.getRoutesByTransportType(event.transportType);
      result.fold(
            (failure) => emit(BookingError(message: failure.message)),
            (routes) => emit(BookingLoadSuccess(routes: routes)),
      );
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadAllRoutes(
      LoadAllRoutes event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());
    try {
      final result = await bookingRepository.getAllRoutes();
      print('ALL-ROUTES ${result.toString()}');
      result.fold(
            (failure) => emit(BookingError(message: failure.message)),
            (routes) => emit(AllRoutesLoaded(routes: routes)),
      );
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  FutureOr<void> _onRestoreHomeData(
      RestoreHomeData event,
      Emitter<BookingState> emit,
      ) {
    emit(event.homeData);
  }

  // FutureOr<void> _onLoadInitialData(
  //     LoadInitialData event,
  //     Emitter<BookingState> emit,
  //     ) async {
  //   emit(BookingLoading());
  //
  //   // Load both in parallel
  //   final bookings = await bookingRepository.getUserBookings();
  //   final popularRoutes = await bookingRepository.getPopularRoutes();
  //   final allRoutes = await bookingRepository.getAllRoutes();
  //
  //   // Combine results
  //   bookings.fold(
  //         (failure) => emit(BookingError(message: failure.message)),
  //         (bookings) {
  //       popularRoutes.fold(
  //             (failure) => emit(BookingError(message: failure.message)),
  //             (routes) => emit(InitialDataLoaded(bookings: bookings, routes: routes)),
  //       );
  //     },
  //   );
  // }
  FutureOr<void> _onLoadInitialData(
      LoadInitialData event,
      Emitter<BookingState> emit,
      ) async {
    emit(BookingLoading());

    final bookingsResult = await bookingRepository.getUserBookings();
    final popularRoutesResult = await bookingRepository.getPopularRoutes();
    final allRoutesResult = await bookingRepository.getAllRoutes();

    // final bookings = await bookingRepository.getUserBookings();
    // context.read<BookingBloc>().add(LoadBookings());

    bookingsResult.fold(
          (failure) => emit(BookingError(message: failure.message)),
          (bookings) {
        popularRoutesResult.fold(
              (failure) => emit(BookingError(message: failure.message)),
              (popularRoutes) {
            allRoutesResult.fold(
                  (failure) => emit(BookingError(message: failure.message)),
                  (allRoutes) {
                emit(
                  InitialDataLoaded(
                    bookings: bookings.cast<Booking>(),
                    popularRoutes: popularRoutes.cast<Route>(),
                    allRoutes: allRoutes.cast<Route>(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


// Update your event handlers
  Stream<BookingState> mapEventToState(BookingEvent event) async* {
    if (event is RestoreHomeData) {
      yield event.homeData;
    }
    if (event is ResetToInitialState) {
      yield BookingInitial();
      // Reload home data
      add(LoadInitialData());
    } else if (event is LoadInitialData) {
      yield* _mapLoadInitialDataToState(event);
    }
    // ... other event handlers
  }

  Stream<BookingState> _mapLoadInitialDataToState(LoadInitialData event) async* {
    yield BookingLoading();
    try {
      final bookingsResult = await bookingRepository.getUserBookings();
      final popularRoutesResult = await bookingRepository.getPopularRoutes();

      yield bookingsResult.fold(
            (failure) => BookingError(message: failure.message),
            (bookings) {
          return popularRoutesResult.fold(
                (failure) => BookingError(message: failure.message),
                (popularRoutes) => HomeDataLoaded(
              popularRoutes: popularRoutes,
              recentBookings: bookings,
            ),
          );
        },
      );
    } catch (e) {
      yield BookingError(message: e.toString());
    }
  }


}