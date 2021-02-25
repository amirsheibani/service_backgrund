package com.amirsheibani.service_backgrund.service;

import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.amirsheibani.service_backgrund.MainActivity;
import com.amirsheibani.service_backgrund.MyApplication;
import com.amirsheibani.service_backgrund.R;

import java.util.List;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

public class BackGroundService extends Service{

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"backGroundService")
                    .setContentText("This is running in Background Service")
                    .setContentTitle("Flutter Background").setSmallIcon(R.drawable.ic_stat_onesignal_default);

            startForeground(5050,builder.build());
            MyApplication.channel.invokeMethod("runMe", null, new MethodChannel.Result() {
                @Override
                public void success(@Nullable Object result) {
//                    Log.d("Android", "result = " + result);
                }

                @Override
                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                    Log.d("BackGroundService", ""+errorCode+","+ errorMessage+","+ errorDetails);
                }

                @Override
                public void notImplemented() {
                    Log.d("BackGroundService", "notImplemented");
                }
            });
        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
