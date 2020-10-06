#include <ESP8266WiFi.h>
#include <Bridge.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <ESP8266HTTPClient.h>

#define powerLED D8         //Power LED                  -     Digital
#define wifiConnecting D7   //WIFI Connecting LED        -     Digital
#define pairLED D5          //Pair / Connecting LED      -     Digital
#define scanLED D6          //Scan LED                   -     Digital
#define utPin D4            //Trigger                    -     Digital
#define uePin D3            //Echo                       -     Digital     

const char *wifiSSID =  "Shaveen";
const char *wifiPASS =  "Shaveen123";
const byte maxGarbaseLimit = 10;  //Maximum Garbage Limit
String deviceName = "Zero Garbage";

LiquidCrystal_I2C lcd = LiquidCrystal_I2C(0x27, 16, 2);

String displayText;

bool checkWifiStatus = false;
bool pairedDevice = false;
bool existedData = false;

int binDistance;
long duration;

String macAddress = WiFi.macAddress();

const String apiBaseUrl = "http://zerogarbage.tk/api";

const String pairCheckUrl = apiBaseUrl + "/checkpair?mac=" + macAddress;

HTTPClient http;
WiFiClient client;

void setup() {
  Serial.begin(115200);

  displayText = "Scanning WIFI..";

  lcd.init();
  lcd.backlight();
  showMessageInDisplay();

  pinMode(powerLED, OUTPUT);
  pinMode(wifiConnecting, OUTPUT);
  pinMode(pairLED, OUTPUT);
  pinMode(scanLED, OUTPUT);
  pinMode(utPin, OUTPUT);
  pinMode(uePin, INPUT);

  powerLed(powerLED, true);

  WiFi.begin(wifiSSID, wifiPASS);
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    powerLed(wifiConnecting, true);
    if (checkWifiStatus == false) {
      displayText = "Connected";
      showMessageInDisplay();
      delay(500);
    }

    checkWifiStatus = true;

    if (pairedDevice == false) {
      displayText = "Not Paired";
      showMessageInDisplay();
      checkPairedOrNot();
      delay(500);
    }

    if (pairedDevice == true) {
      Serial.println("Connected");
      powerLed(pairLED, true);
      doSensorProcess();
    } else {
      blinkLedQuick(pairLED);
    }

  } else {
    displayText = "Scanning WIFI..";
    showMessageInDisplay();
    checkWifiConnectedOrNot();
  }
}

void doSensorProcess() {
  checkDistance();

  int availableDistance = 100 - binDistance;
  if (binDistance == 0) {
    powerLed(scanLED, false);
  } else {
        if (binDistance < maxGarbaseLimit && existedData == false) {
          existedData = true;
          displayText = "Bin Full";
          showMessageInDisplay();
          powerLed(scanLED, true);
          sendUpdatedStatus();
        } else if (binDistance > maxGarbaseLimit && existedData == true) {
          existedData = false;
          displayText = "Scanning";
          showMessageInDisplay();
          sendUpdatedStatus();
        }
    
        if (binDistance > maxGarbaseLimit) {
          blinkLedQuick(scanLED);
        }
  }
}

void showMessageInDisplay() {
  lcd.clear();
  delay(50);
  lcd.setCursor(0, 0);
  lcd.print(deviceName);
  lcd.setCursor(0, 1);
  lcd.print(displayText);
}

void checkDistance() {
  digitalWrite(utPin, LOW);
  delayMicroseconds(2);
  digitalWrite(utPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(utPin, LOW);

  // Clears the trigPin
  digitalWrite(utPin, LOW);
  delayMicroseconds(2);

  digitalWrite(utPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(utPin, LOW);

  duration = pulseIn(uePin, HIGH);

  binDistance = duration * 0.034 / 2;
  delay(500);
}

void checkWifiConnectedOrNot() {
  while (WiFi.status() != WL_CONNECTED)
  {
    pairedDevice = false;
    checkWifiStatus = false;
    blinkLed(wifiConnecting);
    powerLed(pairLED, false);
    powerLed(scanLED, false);
  }
}

void blinkLed(byte pinRef) {
  powerLed(pinRef, true);
  delay(400);
  powerLed(pinRef, false);
  delay(400);
}

void blinkLedQuick(byte pinRef) {
  powerLed(pinRef, true);
  delay(100);
  powerLed(pinRef, false);
  delay(100);
}

void powerLed(byte pinRef, bool flow) {
  digitalWrite(pinRef, (flow == true) ? HIGH : LOW);
}


String httpRequestSend(String urlTemp) {
  Serial.println(urlTemp);
  String result = "";
  http.begin(client, urlTemp);
  int httpCode = http.GET();
  result = http.getString();
  http.end();
  return result;
}

void checkPairedOrNot() {
  String returnedData = httpRequestSend(pairCheckUrl);
  if (returnedData != "") {
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, returnedData);
    JsonObject obj = doc.as<JsonObject>();
    String dataStatus = obj["hello"]["status"];
    existedData = (dataStatus == "1") ? true : false;
    pairedDevice = true;

    displayText = "Paired";
    showMessageInDisplay();
    delay(500);
  } else {
    pairedDevice = false;
  }
}


void sendUpdatedStatus() {
  httpRequestSend(apiBaseUrl + "/storedata?sv=" + ((existedData == true) ? "1" : "0") + "&mac=" + macAddress);
}
