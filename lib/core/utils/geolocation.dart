/// Platform-agnostic geolocation facade.
///
/// Resolves to the real web implementation (`web_geolocation.dart`) on web
/// builds, and to a no-op stub (`web_geolocation_stub.dart`) elsewhere.
/// This lets non-web builds compile without pulling in `dart:js_interop`.
library;

export 'web_geolocation_stub.dart'
    if (dart.library.js_interop) 'web_geolocation.dart';
