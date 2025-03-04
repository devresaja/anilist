import 'dart:convert';
import 'dart:developer';

void logJson(Map body) {
  log(const JsonEncoder.withIndent('  ').convert(body));
}
