package com.amirsheibani.service_backgrund;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.amirsheibani.service_backgrund.service.BackGroundBroadcastReceiver;
import com.amirsheibani.service_backgrund.service.BackGroundJobService;
import com.amirsheibani.service_backgrund.service.BackGroundService;

import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MyApplication.channel = new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), "com.amirsheibani.service_background");
        MyApplication.channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (call.method.equals("startBackgroundService")) {
                    try{
                        if(call.argument("minimumLatency") != null){
                            MyApplication.minimumLatency = Long.parseLong(call.argument("minimumLatency"));
                            Log.i("argument","minimumLatency:" + call.argument("minimumLatency"));
                        }
                        if(call.argument("deadline") != null){
                            MyApplication.deadline = Long.parseLong(call.argument("deadline"));
                            Log.i("argument","deadline:" + call.argument("deadline"));
                        }
                        MyApplication.startBackgroundService(getApplicationContext());
                        result.success("service Started");
                    }catch (Exception e){
                        result.error(e.getLocalizedMessage(),e.getMessage(),e.fillInStackTrace());
                    }
                }else{
                    result.notImplemented();
                }
            }
        });
    }


}
