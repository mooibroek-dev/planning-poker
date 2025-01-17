// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentRoomIdHash() => r'53cc6b6a138fb4ca93683e768b6d6346e558eb83';

/// See also [currentRoomId].
@ProviderFor(currentRoomId)
final currentRoomIdProvider = AutoDisposeProvider<String>.internal(
  currentRoomId,
  name: r'currentRoomIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentRoomIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentRoomIdRef = AutoDisposeProviderRef<String>;
String _$roomHash() => r'df8fefcbf5e0f45e4e7c8efa467f2a1c7302bbf2';

/// See also [room].
@ProviderFor(room)
final roomProvider = AutoDisposeStreamProvider<Room>.internal(
  room,
  name: r'roomProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$roomHash,
  dependencies: <ProviderOrFamily>[currentRoomIdProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    currentRoomIdProvider,
    ...?currentRoomIdProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomRef = AutoDisposeStreamProviderRef<Room>;
String _$participantsHash() => r'b639fcad4d068bcecb3b32b6bf4d5b0ea66fd5f2';

/// See also [participants].
@ProviderFor(participants)
final participantsProvider =
    AutoDisposeProvider<List<RoomParticipant>>.internal(
  participants,
  name: r'participantsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$participantsHash,
  dependencies: <ProviderOrFamily>[roomProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    roomProvider,
    ...?roomProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ParticipantsRef = AutoDisposeProviderRef<List<RoomParticipant>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
