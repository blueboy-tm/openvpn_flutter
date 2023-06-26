import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:openvpn_flutter/openvpn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  bool _granted = false;
  @override
  void initState() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = data;
        });
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        setState(() {
          this.stage = stage;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    super.initState();
  }

  Future<void> initPlatformState() async {
    engine.connect(config, "USA",
        username: defaultVpnUsername,
        password: defaultVpnPassword,
        certIsRequired: true);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stage?.toString() ?? VPNStage.disconnected.toString()),
              Text(status?.toJson().toString() ?? ""),
              TextButton(
                child: const Text("Start"),
                onPressed: () {
                  initPlatformState();
                },
              ),
              TextButton(
                child: const Text("STOP"),
                onPressed: () {
                  engine.disconnect();
                },
              ),
              if (Platform.isAndroid)
                TextButton(
                  child: Text(_granted ? "Granted" : "Request Permission"),
                  onPressed: () {
                    engine.requestPermissionAndroid().then((value) {
                      setState(() {
                        _granted = value;
                      });
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

const String defaultVpnUsername = "ios";
const String defaultVpnPassword = "123";

String config = """client
dev tun
proto tcp-client
persist-key
persist-tun
tls-client
remote-cert-tls server
verb 4
auth-nocache
mute 10
remote at3.vpservise.com
port 2701
auth SHA1
cipher AES-256-CBC
redirect-gateway def1
auth-user-pass
<ca>
-----BEGIN CERTIFICATE-----
MIIFGjCCAwKgAwIBAgIIM/ib0GuoPMUwDQYJKoZIhvcNAQELBQAwGDEWMBQGA1UE
AwwNdnBzZXJ2aXNlLnh5ejAeFw0yMzAzMTgyMzUzMjhaFw0zMzAzMTUyMzUzMjha
MBgxFjAUBgNVBAMMDXZwc2VydmlzZS54eXowggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQCnumOCeOhXr8dN58i3dL6+NlLTBg5AH272D7TuZf2YQc90en49
34rsrS9o7h9mp74SFG/njRH50UuRIUOaerT22yzfAnPPp72M8M7+V/yPNLkVEtg1
Sf7EEGokEmbUgQ9gfrK0o45lDHyNUikmqeeTJBOkUupBtPne43egAVJ1ehPRdVD3
o76UNllQ5QxSZY84bA2Dtos4+sekB/rjzGia5M2L07d1/QAW5ehUhLUDSHDgkqgy
+qeEbcKF1wmghZGAa+xBJNVWY8ieOAUB0Z4H1At67p65UOiH7N0+sJ5kCFQnlGmO
AC93jtkS5iU+fEqBtvNOUq0fqnyP30NZUPpjJpMj59d6aa3qeD2OrWJxBXYU4xaD
D6t3Fhe+vj8CQci78aL1MpVKalxCW46vlk1gzjl8PTAqrtDKxTcXjJ28ye61phR9
II0/EAv/ahyTKOJfIr1eFixKy6Tf/P+MTZfpj2hKsebwsNXGZ9W5MJGW7OblhlRw
B3hfOJHGe8R30aS+JvFKz9sQV6yb6ZjJH5okashy82WKh51GkGe/HsbqcXsyOs0+
IeIAgg0Dr1wfS+A2vw7PjF90kzUM4zsyEjmfYq6vSZXaoKNk7gAmYz05qxxAJ+dk
i0OlqrMK/rC0AwS2SUloVImHZn6FGePUDDbHBoJMckApdkccmyE5MwLeiwIDAQAB
o2gwZjAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQU
YI8Lpr2EHA0MJ8SN1gH8p19cKxUwJAYJYIZIAYb4QgENBBcWFUdlbmVyYXRlZCBi
eSBSb3V0ZXJPUzANBgkqhkiG9w0BAQsFAAOCAgEAhqS7tMs3zSQ6Vvjc9D3UhSoZ
65rN4EltxyyCjl1Pb1LnTc8vhiIpzp5cqi944XffiqUR2mvExZDhrjf17HIegrZj
Kq923RsUaUBSClN5kYhJEKiL+RH50+gA6E/LO7BRLt/HKn5kgCp4wLOfRNs6vQXA
Sf2Xip3iw8rHAkm13/vg6K0qjpSUO42Tl2j/ZR90eRwZ1mAYIrrRvHItKVHAH0xA
MvpAWTuImDrFeNu+NVYoNjXwInyjdsyOtTJZyTY8PEIqyQ+UOBRieZIB4TRXsupF
UJJl0rHMuvjHHkHDgrNr7VwDtnwK5VZ1n/iZetP95MTkBAT78Fx7JP0RmWdNXzlm
FPRp0nM4s+uMJAVlGd9EnfuUGoNb5GOZsqWdttyvpPee92hNbw+FFaXSZkzsk4Ml
Ad5PXDOhXaMmAFPbigGfu/zw9HeclnuFcW25BRdC+KkkksFFySIQF5ooWNSBMb3q
Gmnil43NLAOR0dW9NNouqIoJhJmOzWrQbcjnxjXdP94lHqCx3CnPsVoG6ih+d9Ob
fBOXncID2PRfQoemPKUUVQFm7EJycfqAZYV0jWp6p/KYOt66Y5AiWkNj65RSBZHm
f1LVovlySzG6hi+9Ac6JhG95OOWuKl2F+GkQp+gNohLpFKK9HyRmDTjmxdU9ERQ2
Yk/XUF/7PDI869W2w+o=
-----END CERTIFICATE-----

</ca>
<cert>
-----BEGIN CERTIFICATE-----
MIIFNjCCAx6gAwIBAgIIQS0cEnNkjyMwDQYJKoZIhvcNAQELBQAwGDEWMBQGA1UE
AwwNdnBzZXJ2aXNlLnh5ejAeFw0yMzAzMTgyMzUzNDJaFw0zMzAzMTUyMzUzNDJa
MB8xHTAbBgNVBAMMFGNsaWVudC52cHNlcnZpc2UueHl6MIICIjANBgkqhkiG9w0B
AQEFAAOCAg8AMIICCgKCAgEA8HRYbtHJJzByTeBqFHCt/zCEFKugoKxTdXcMj5nr
NtBCl5Nz4p5Rg6X0nOEZXVoIZqVH7pyD4fh49HJZGpdy7qFY7fcyvF5d7Kz6MiSj
sTjuuABZCv8FzKYr+8ywgKm7lX+DZp4UKAfXlRXupD56cKL09UEq9uRFzNg3LO/K
0Uar3kMWfZAI63nXSdyYuY56d7392D2iIh+KVpIGjgplMUux9IQ5yDp4Vi96X1fN
JGsfsum3D6ktOP9zvGRmTejqDDBsQufZXkJlLUADFqYtVliaKnCZXfL00OubB66M
LD3sPWuBB2M6Qb4XtUp4UfQxhx0Sun9ennE8UKmpTUhMwlWgztw4hnthIkpFeV7w
mTCf4bv9JNYXfLRVZQqm5uqdJNd8HpXZljzAhbyLqjACFTE97cp1ZJhCIVe0nx5B
vkrAERIhSTH1MIcUEkXaros0isF3Jvr3xuclfWC+TMEyGo/5MZRDmlS23uUC4uI+
d+7b9IFPn6zcKWuiMmQptonfLazUe2UJfQk6mH3SR2SRs722U69qC717sLIjj+GG
XrR9C9WrsxV473ojW5H/CZrNTfI2uBLW47reFbVYIY+DyTVa5YGx6m0lu7a1G6r2
dl5vyjJl/DfWTgvmwyDdrTl5DtyGr8RFj0lh5POWoZU4v430muwqIAl3+P5UqvhO
+pcCAwEAAaN9MHswEwYDVR0lBAwwCgYIKwYBBQUHAwIwHQYDVR0OBBYEFPciN4JU
eFvFwtmA2//FFTaSq12qMB8GA1UdIwQYMBaAFGCPC6a9hBwNDCfEjdYB/KdfXCsV
MCQGCWCGSAGG+EIBDQQXFhVHZW5lcmF0ZWQgYnkgUm91dGVyT1MwDQYJKoZIhvcN
AQELBQADggIBAKCFBVVxoz4y0X7HesslQPOItq6rdHihtAm5iiIysfZ1RHb7iXm1
M6Cy8pGtoJwGoobdqpSyHCIt21880OestR4vYWn3pKEO0S3Dqfyz7E2VMvwiVjNO
eX/4kixSsSH2IESnubVfHEUmL++Om9YDag1mDRf2wI261xxGJvHzjXACwKMyI1vS
gVeOyIx0EiH11l86tdRl7uMwHSOUPHEDHhCAHD4VeIj60Mz50T6qVv7vUj+cqowW
I7IVnnax4sImGDgp6NK3ureJr9sHpvIZmbUitvYWhLSUuEQIv9vMAs5G6ZTnWyQf
V+pi4UdY9ZeWKgAoWGIr8oSXk7jJRLBVFac43fyDGabMQMdyI0Lw19eZaPK9HD/0
brAEKMtroMdvkphEi9iwfmNmURbNsi0k3BDDRUljZkUuQljlJyQej103XqiZ/LJ0
8gC/1v1Zyp4+HF4jj4n7L8DaiVm9JrdffZmsjMijQZoqBDQK6gSMrC+j4dFWWLaW
jMkMwwd+W/y4+o+C+5oX43DjSrnYgHUo10DpseakeewYsMY096CoXFwbz/awfPYz
2BRlFJArm2+8YDggSWsTX3OSDcwViFCHkzaULJzxWsYLoMq1qtoOzLFrLLBG+sdS
U5DKUCMuBbZIwPDOYbBBMwqpFr65Sl8pZtNar6W6Fk2tGg3ZliyDsSNV
-----END CERTIFICATE-----

</cert>
<key>
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----

</key>
""";
