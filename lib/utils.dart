import 'dart:convert';
import 'dart:io';

extension StringX on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : this;
}

String? readLine([String? message]) {
  if (message != null) stdout.write(message);
  return stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);
}

typedef WhenCheck<I> = bool Function(I);

abstract class When {
  static R when<I, R>(
    I data,
    Map<WhenCheck<I>, R> exprs, {
    required R standart,
  }) {
    for (final func in exprs.keys) {
      if (func(data)) return exprs[func]!;
    }
    return standart;
  }

  static WhenCheck<I> eq<I>(I cmp) => (I data) => data == cmp;

  static WhenCheck<num> range(num start, num end) =>
      (num data) => data >= start && data <= end;
}
