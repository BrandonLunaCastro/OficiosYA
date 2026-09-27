import 'package:oficios/models/order_request.dart';

const List<OrderRequest> mockOrders = [
  OrderRequest(
    service: 'Plomería',
    providerInitials: 'CR',
    providerName: 'Carlos Rodriguez',
    date: '24 sep',
    time: '10:30',
    phone: '+54 261 555-0129',
    email: 'carlos.p@reparaseguro.com',
  ),
  OrderRequest(
    service: 'Electricidad',
    providerInitials: 'JL',
    providerName: 'Jorge López',
    date: '22 sep',
    time: '18:15',
    phone: '+54 261 555-0187',
    email: 'jorge.lopez@electricistas.com',
  ),
  OrderRequest(
    service: 'Pintura interior',
    providerInitials: 'MG',
    providerName: 'Martín Gómez',
    date: '18 sep',
    time: '12:40',
    phone: '+54 261 555-0143',
    email: 'martin.gomez@pinturas.com',
  ),
];