import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:freemium_novels_app/models.dart';

class CryptoApiService {
  final String _baseUrl = "https://api.coingecko.com/api/v3";

  final Map<String, String> _coinIdMap = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'SOL': 'solana',
    'XRP': 'ripple',
    'DOGE': 'dogecoin',
  };

  Future<List<CryptoCurrency>> getLiveCryptoPrices() async {
    final ids = _coinIdMap.values.join(',');
    final url = Uri.parse(
        '$_baseUrl/simple/price?ids=$ids&vs_currencies=usd&include_24hr_change=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<CryptoCurrency> cryptoList = [];
        _coinIdMap.forEach((symbol, id) {
          if (data.containsKey(id)) {
            cryptoList.add(
              CryptoCurrency(
                id: id,
                symbol: symbol,
                name: id.substring(0, 1).toUpperCase() + id.substring(1),
                price: (data[id]['usd'] as num).toDouble(),
                change24h: (data[id]['usd_24h_change'] as num).toDouble(),
              ),
            );
          }
        });
        return cryptoList;
      } else {
        throw Exception('Failed to load crypto prices');
      }
    } catch (e) {
      throw Exception('Failed to connect to the network: $e');
    }
  }
}
