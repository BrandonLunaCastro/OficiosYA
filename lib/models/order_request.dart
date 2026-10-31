class OrderRequest {
  final String service;
  final String providerInitials;
  final String providerName;
  final String date;
  final String time;
  final String phone;
  final String email;
  final String clientName;
  final String location;
  final String status;

  const OrderRequest({
    required this.service,
    required this.providerInitials,
    required this.providerName,
    required this.date,
    required this.time,
    required this.phone,
    required this.email,
    this.clientName = '',
    this.location = 'Mendoza',
    this.status = 'Pendiente',
  });
}