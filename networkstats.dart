import 'package:connectivity/connectivity.dart';


 network_stats() async {

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("mobike");
    return true;
    // I am connected to a mobile network.
  } else if (connectivityResult == ConnectivityResult.wifi) {
   print("wif");
    return true;
  }
  else 
  {
    print("no net");
    return false;
  }

}
