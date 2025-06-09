part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoadSuccess extends BookingState {
  final List<Route> routes;

  const BookingLoadSuccess({required this.routes});

  @override
  List<Object> get props => [routes];
}

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

class BookingError extends BookingState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object> get props => [message];
}

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

class BookingSubmissionInProgress extends BookingState {}

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

class TicketDownloadInProgress extends BookingState {}

class TicketDownloadSuccess extends BookingState {}

class TicketDownloadFailure extends BookingState {
  final String error;

  const TicketDownloadFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// Add these states to booking_state.dart
class PopularRoutesLoaded extends BookingState {
  final List<Route> routes;

  const PopularRoutesLoaded({required this.routes});

  @override
  List<Object> get props => [routes];
}
class AllRoutesLoaded extends BookingState {
  final List<Route> routes;

  const AllRoutesLoaded({required this.routes});

  @override
  List<Object> get props => [routes];
}

// class InitialDataLoaded extends BookingState {
//   final List<Booking> bookings;
//   final List<Route> routes;
//
//   const InitialDataLoaded({required this.bookings, required this.routes});
//
//   @override
//   List<Object> get props => [bookings, routes];
// }


class InitialDataLoaded extends BookingState {
  final List<Booking> bookings;
  final List<Route> popularRoutes;
  final List<Route> allRoutes;

  const InitialDataLoaded({
    required this.bookings,
    required this.popularRoutes,
    required this.allRoutes,
  });

  @override
  List<Object> get props => [bookings, popularRoutes, allRoutes];
}

// Add these states
class HomeDataLoaded extends BookingState {
  final List<Route> popularRoutes;
  final List<Booking> recentBookings;

  const HomeDataLoaded({
    required this.popularRoutes,
    required this.recentBookings,
  });

  @override
  List<Object> get props => [popularRoutes, recentBookings];
}

class RestoreHomeData extends BookingEvent {
  final HomeDataLoaded homeData;
  const RestoreHomeData(this.homeData);
}

class SearchResultsLoaded extends BookingState {
  final List<Route> routes;
  final String from;
  final String to;
  final DateTime? date;

  const SearchResultsLoaded({
    required this.routes,
    required this.from,
    required this.to,
    this.date,
  });

  @override
  List<Object> get props => [routes, from, to, date ?? DateTime.now()];
}

class TicketsLoaded extends BookingState {
  final List<Booking> bookings;

  const TicketsLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}