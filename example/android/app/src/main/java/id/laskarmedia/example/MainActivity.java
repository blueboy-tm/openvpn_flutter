package id.laskarmedia.example;

import io.flutter.embedding.android.FlutterActivity;
import id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin;
import android.content.Intent;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK);
        super.onActivityResult(requestCode, resultCode, data);
    }
}
