// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:pingware/dns_lookup/models/dns_lookup_response.dart';
import 'package:pingware/dns_lookup/repository/dns_lookup_repository.dart';

part 'dns_lookup_event.dart';
part 'dns_lookup_state.dart';

class DnsLookupBloc extends Bloc<DnsLookupEvent, DnsLookupState> {
  DnsLookupBloc(DnsLookupRepository dnsLookupRepository)
      : _dnsLookupRepository = dnsLookupRepository,
        super(DnsLookupInitial()) {
    on<DnsLookupRequested>(_onLookupRequested);
  }

  final DnsLookupRepository _dnsLookupRepository;

  Future<void> _onLookupRequested(
    DnsLookupRequested event,
    Emitter<DnsLookupState> emit,
  ) async {
    emit(DnsLookupLoadInProgress());

    try {
      final response =
          await _dnsLookupRepository.lookup(event.hostname, type: event.type);

      emit(DnsLookupLoadSuccess(response));
    } on Exception {
      emit(DnsLookupLoadFailure());
    }
  }
}
