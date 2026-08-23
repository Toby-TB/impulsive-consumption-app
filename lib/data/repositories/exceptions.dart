class InsufficientBalanceException implements Exception {
  final int missingCents;

  const InsufficientBalanceException(this.missingCents);

  @override
  String toString() =>
      'InsufficientBalanceException(missingCents: $missingCents)';
}

class CouponNotApplicableException implements Exception {
  final String reason;

  const CouponNotApplicableException(this.reason);

  @override
  String toString() => 'CouponNotApplicableException($reason)';
}
