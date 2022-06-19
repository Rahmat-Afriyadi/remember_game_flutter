class ApiUrl {
  static const String baseUrl = 'https://flutterremembergame.devryank.tech/public/api';

  static const String registrasi = baseUrl + '/register';
  static const String login = baseUrl + '/login';
  static const String me = baseUrl + '/me';
  static const String histories = baseUrl + '/histories';
  static const String addHistories = baseUrl + '/histories/store';
  static const String rankPage = baseUrl + '/rank/page';
  static const String listProduk = baseUrl + '/produk';
  static const String createProduk = baseUrl + '/produk';

  static String updateProduk(int id) {
    return baseUrl + '/produk/' + id.toString() + '/update';
  }

  static String showProduk(int id) {
    return baseUrl + '/produk/' + id.toString();
  }

  static String deleteProduk(int id) {
    return baseUrl + '/produk/' + id.toString();
  }
}
