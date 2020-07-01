package com.beuniquegroup.tienda;

import android.app.NativeActivity;
import android.content.Intent;
import android.os.Bundle;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import zendesk.answerbot.AnswerBot;
import zendesk.answerbot.AnswerBotEngine;
import zendesk.chat.Chat;
import zendesk.chat.ChatEngine;
import zendesk.core.AnonymousIdentity;
import zendesk.core.Zendesk;
import zendesk.messaging.Engine;
import zendesk.messaging.MessagingActivity;
import zendesk.support.Support;
import zendesk.support.SupportEngine;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "tienda.dev/zendesk";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getChat")) {
                                String response = getResponseFromZendesk();

                                result.success(response);
                            } else {
                                result.notImplemented();
                            }
                        }

                );
    }

    private String getResponseFromZendesk() {
      /*  Chat.INSTANCE.init(context, "https://tiendabeuniquegroup.zendesk.com",
                "ae6fb92f4cf70c5ffc348374b465b3adfad753c8d14a5cb4",
                "mobile_sdk_client_59f9a7d0f15202eb4dd6");*/

        Zendesk.INSTANCE.init(this, "https://tiendabeuniquegroup.zendesk.com", "82b091c3bfcf42fe91be469929c862edf6e41960aa28c25e", "mobile_sdk_client_ab97cd0b47875959102b");
        Support.INSTANCE.init(Zendesk.INSTANCE);
        AnswerBot.INSTANCE.init(Zendesk.INSTANCE, Support.INSTANCE);
        Chat.INSTANCE.init(this, "TkPrZmaVkTcwDxSmVJVLfAbao79XxaB4");
        Zendesk.INSTANCE.setIdentity(new AnonymousIdentity());

        Engine answerBotEngine = AnswerBotEngine.engine();
        Engine supportEngine = SupportEngine.engine();
        Engine chatEngine = ChatEngine.engine();

        MessagingActivity.builder()
                .withEngines(answerBotEngine, supportEngine, chatEngine)
                .show(this);

        return "success";
    }

    private String getResponseFromNative() {
        Intent intent = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.GINGERBREAD) {
            intent = new Intent(this, SampleActivity.class);
        }
        this.startActivity(intent);
        return "success";
    }


}
