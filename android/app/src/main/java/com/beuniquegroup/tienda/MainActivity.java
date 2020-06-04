package com.beuniquegroup.tienda;

import android.app.NativeActivity;
import android.content.Intent;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.beunique.native/payment";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("openPaymentView")) {
                                String  response = getResponseFromNative();

                                result.success(response);
                            } else {
                                result.notImplemented();
                            }
                        }

                );
    }

    private String  getResponseFromNative() {
        Intent intent = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.GINGERBREAD) {
            intent = new Intent(this, SampleActivity.class);
        }
        this.startActivity(intent);
        return "success";
    }

}
