part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingsLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

class BookingCreated extends BookingState {
  final Booking booking;

  const BookingCreated({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingCancelled extends BookingState {}

class BookingSeatsSelectedState extends BookingState {
  final List<String> selectedSeats;

  const BookingSeatsSelectedState({required this.selectedSeats});

  @override
  List<Object> get props => [selectedSeats];
}

class BookingStopsSelectedState extends BookingState {
  final String pickupStopId;
  final String dropoffStopId;

  const BookingStopsSelectedState({
    required this.pickupStopId,
    required this.dropoffStopId,
  });

  @override
  List<Object> get props => [pickupStopId, dropoffStopId];
}

class BookingError extends BookingState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object> get props => [message];
}

// Add these states to your existing state file
class BookingSubmissionSuccess extends BookingState {
  final Booking booking;

  const BookingSubmissionSuccess({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingSubmissionFailure extends BookingState {
  final String error;

  const BookingSubmissionFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class BookingSubmissionInProgress extends BookingState {}

class BookingLoadSuccess extends BookingState {
  final List<Route> routes;
  const BookingLoadSuccess({required this.routes});

  @override
  List<Object> get props => [routes];
}
