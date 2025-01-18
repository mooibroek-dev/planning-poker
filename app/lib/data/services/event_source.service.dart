import 'dart:async';
import 'dart:convert';

import 'package:app/core/logger.dart';
import 'package:app/env.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:universal_html/html.dart';

typedef ListenerKey = (String collection, String id);

abstract class IEventSourceService {
  void subscribe(String collection, String? expand, ValueSetter<RecordSubscriptionEvent> callback);
}

class EventSourceService implements IEventSourceService {
  Env get env => inject();

  String? _clientId;
  StreamSubscription<SSEEvent>? listener;

  late final eventListener = HttpEventListener(env.pocketBaseUrl);

  @override
  void subscribe(String collection, String? expand, ValueSetter<RecordSubscriptionEvent> callback) {
    listener = eventListener.fetchServerSentEvents().listen((event) {
      if (event.event == 'PB_CONNECT') {
        _clientId = event.data['clientId'] as String;
        Log.v('Received client ID: $_clientId');
        final subscription = _buildSubscription(collection, expand: expand);
        eventListener.sendSubscriptionUpdate(_clientId!, [subscription]);
      } else {
        final record = RecordModel.fromJson(event.data['record'] as Map<String, dynamic>);
        callback(RecordSubscriptionEvent(record: record, action: event.data['action'] as String));
      }
    });
  }

  String _buildSubscription(String collection, {String? expand}) {
    var key = collection;
    final options = <String, dynamic>{};
    if (expand != null) {
      options['query'] = {
        'expand': expand,
      };
    }

    if (options.isNotEmpty) {
      final encoded = 'options=${Uri.encodeQueryComponent(jsonEncode(options))}';
      key += (key.contains('?') ? '&' : '?') + encoded;
    }

    return key;
  }
}

class HttpEventListener {
  HttpEventListener(this.baseUrl);

  final String baseUrl;

  final RegExp regExp = RegExp(
    r'id:(.*)\nevent:(.*)\ndata:(.*)',
    multiLine: true,
  );

  void sendSubscriptionUpdate(String clientId, List<String> collections) {
    final req = HttpRequest();
    req.open('POST', '$baseUrl/api/realtime', async: true);
    req.setRequestHeader('Content-Type', 'application/json');
    req.send(jsonEncode({'subscriptions': collections, 'clientId': clientId}));
  }

  Stream<SSEEvent> fetchServerSentEvents() async* {
    final controller = StreamController<SSEEvent>();
    final req = HttpRequest();

    req.open('GET', '$baseUrl/api/realtime', async: true);
    req.setRequestHeader('Accept', 'text/event-stream');
    req.setRequestHeader('Cache-Control', 'no-cache');

    var seenChars = 0;
    req.onProgress.listen((_) {
      final body = req.responseText?.substring(seenChars) ?? '';
      final matches = regExp.allMatches(body);

      for (var match in matches) {
        final id = match.group(1)?.trim();
        final event = match.group(2)?.trim();
        final data = match.group(3)?.trim();

        if (id != null && event != null && data != null) {
          try {
            final jsonData = jsonDecode(data) as Map<String, dynamic>;
            controller.add(SSEEvent(id: id, event: event, data: jsonData));
          } catch (e, stacktrace) {
            debugPrint('${e.toString()}\n$stacktrace\n\n Unexpected Error when converting stream data to json');
          }
        }
      }

      seenChars = req.responseText?.length ?? 0;
    });

    req.onError.listen((error) {
      controller.addError(error);
    });

    req.onReadyStateChange.listen((event) {
      if (req.readyState == HttpRequest.DONE) {
        controller.close();
      }
    });

    req.send();

    await for (var value in controller.stream) {
      yield value;
    }
  }
}

class SSEEvent {
  SSEEvent({
    required this.id,
    required this.event,
    required this.data,
  });

  final String id;
  final String event;
  final Map<String, dynamic> data;
}
