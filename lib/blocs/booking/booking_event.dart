part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class LoadBookings extends BookingEvent {}

class CreateBooking extends BookingEvent {
  final String routeId;
  final String transportId;
  final String pickupStopId;
  final String dropoffStopId;
  final List<Map<String, dynamic>> seats;
  final String? paymentMethod;
  final Map<String, dynamic>? paymentDetails;
  final String? notes;

  const CreateBooking({
    required this.routeId,
    required this.transportId,
    required this.pickupStopId,
    required this.dropoffStopId,
    required this.seats,
    this.paymentMethod,
    this.paymentDetails,
    this.notes,
  });

  @override
  List<Object> get props => [
    routeId,
    transportId,
    pickupStopId,
    dropoffStopId,
    seats,
    paymentMethod ?? '',
    paymentDetails ?? {},
    notes ?? '',
  ];
}

class CancelBooking extends BookingEvent {
  final String bookingId;

  const CancelBooking({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class BookingSeatsSelected extends BookingEvent {
  final List<String> selectedSeats;

  const BookingSeatsSelected({required this.selectedSeats});

  @override
  List<Object> get props => [selectedSeats];
}

class BookingStopsSelected extends BookingEvent {
  final String pickupStopId;
  final String dropoffStopId;

  const BookingStopsSelected({
    required this.pickupStopId,
    required this.dropoffStopId,
  });

  @override
  List<Object> get props => [pickupStopId, dropoffStopId];
}

class BookingSubmitted extends BookingEvent {
  final String routeId;
  final String transportId;
  final String pickupStopId;
  final String dropoffStopId;
  final List<Map<String, dynamic>> seats;
  final String? paymentMethod;
  final Map<String, dynamic>? paymentDetails;
  final String? notes;

  const BookingSubmitted({
    required this.routeId,
    required this.transportId,
    required this.pickupStopId,
    required this.dropoffStopId,
    required this.seats,
    this.paymentMethod,
    this.paymentDetails,
    this.notes,
  });

  @override
  List<Object> get props => [
    routeId,
    transportId,
    pickupStopId,
    dropoffStopId,
    seats,
    paymentMethod ?? '',
    paymentDetails ?? {},
    notes ?? '',
  ];
}

class BookingStarted extends BookingEvent {
  final String from;
  final String to;
  final DateTime? date;

  const BookingStarted({
    required this.from,
    required this.to,
    this.date,
  });

  @override
  List<Object> get props => [from, to, date ?? DateTime.fromMillisecondsSinceEpoch(0)];
}

class DownloadTicket extends BookingEvent {
  final String bookingId;

  const DownloadTicket({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}



// part of 'booking_bloc.dart';
//
// abstract class BookingEvent extends Equatable {
//   const BookingEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class LoadBookings extends BookingEvent {}
//
// class CreateBooking extends BookingEvent {
//   final String routeId;
//   final String transportId;
//   final String pickupStopId;
//   final String dropoffStopId;
//   final List<Map<String, dynamic>> seats;
//
//   const CreateBooking({
//     required this.routeId,
//     required this.transportId,
//     required this.pickupStopId,
//     required this.dropoffStopId,
//     required this.seats,
//   });
//
//   @override
//   List<Object> get props => [routeId, transportId, pickupStopId, dropoffStopId, seats];
// }
//
// class CancelBooking extends BookingEvent {
//   final String bookingId;
//
//   const CancelBooking({required this.bookingId});
//
//   @override
//   List<Object> get props => [bookingId];
// }
//
// class BookingSeatsSelected extends BookingEvent {
//   final List<String> selectedSeats;
//
//   const BookingSeatsSelected({required this.selectedSeats});
//
//   @override
//   List<Object> get props => [selectedSeats];
// }
//
// class BookingStopsSelected extends BookingEvent {
//   final String pickupStopId;
//   final String dropoffStopId;
//
//   const BookingStopsSelected({
//     required this.pickupStopId,
//     required this.dropoffStopId,
//   });
//
//   @override
//   List<Object> get props => [pickupStopId, dropoffStopId];
// }
// // class BookingSubmitted extends BookingEvent {
// //   final Booking booking;
// //   BookingSubmitted(this.booking);
// // }
// class BookingSubmitted extends BookingEvent {
//   final String routeId;
//   final String transportId;
//   final String pickupStopId;
//   final String dropoffStopId;
//   final List<Map<String, dynamic>> seats;
//
//   BookingSubmitted({
//     required this.routeId,
//     required this.transportId,
//     required this.pickupStopId,
//     required this.dropoffStopId,
//     required this.seats,
//   });
//
//   @override
//   List<Object> get props => [
//     routeId,
//     transportId,
//     pickupStopId,
//     dropoffStopId,
//     seats,
//   ];
// }
// class BookingStarted extends BookingEvent {
//   final String from;
//   final String to;
//   final DateTime? date;
//
//   BookingStarted({
//     required this.from,
//     required this.to,
//     this.date,
//   });
//
//   @override
//   List<Object> get props => [from, to, date??''/*DateTime.fromMillisecondsSinceEpoch(0)*/];
// }
//
// class DownloadTicket extends BookingEvent {
//   final String bookingId;
//
//   const DownloadTicket({required this.bookingId});
//
//   @override
//   List<Object> get props => [bookingId];
// }
