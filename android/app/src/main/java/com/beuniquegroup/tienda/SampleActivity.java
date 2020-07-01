package com.beuniquegroup.tienda;

import android.os.Bundle;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import android.view.View;
import android.widget.Button;

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

public class SampleActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {


        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sample);

        Button mChatButton;
        mChatButton = (Button) findViewById(R.id.chat_button);
        mChatButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v){

            }
        });
    }

}
