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

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<CreateBooking>(_onCreateBooking);
    on<CancelBooking>(_onCancelBooking);
    on<BookingSeatsSelected>(_onSeatsSelected);
    on<BookingStopsSelected>(_onStopsSelected);
    on<BookingStarted>(_onBookingStarted);
    on<BookingSubmitted>(_onBookingSubmitted);
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
    emit(BookingLoading());
    try {
      final result = await bookingRepository.searchRoutes(
        from: event.from,
        to: event.to,
        date: event.date,
      );
print('RESULT: ${result }');
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
      );

      result.fold(
            (failure) => emit(BookingSubmissionFailure(error: failure.message)),
            (booking) => emit(BookingSubmissionSuccess(booking: booking)),
      );
    } catch (e) {
      emit(BookingSubmissionFailure(error: e.toString()));
    }
  }


}