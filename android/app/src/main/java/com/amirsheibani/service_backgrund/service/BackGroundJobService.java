package com.amirsheibani.service_backgrund.service;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.os.Build;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import com.amirsheibani.service_backgrund.MainActivity;
import com.amirsheibani.service_backgrund.MyApplication;
import com.amirsheibani.service_backgrund.R;

import io.flutter.Log;
import io.flutter.plugin.common.MethodChannel;

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class BackGroundJobService extends JobService {
    @Override
    public boolean onStartJob(JobParameters params) {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            MyApplication.scheduleJob(getApplicationContext());
            NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"backGroundService")
                    .setContentText("This is running in Background JobService")
                    .setContentTitle("Flutter Background").setSmallIcon(R.drawable.ic_stat_onesignal_default);

            startForeground(5050,builder.build());

            MyApplication.channel.invokeMethod("runMe", null, new MethodChannel.Result() {
                @Override
                public void success(@Nullable Object result) {
//                    Log.d("Android", "result = " + result);
                }

                @Override
                public void error(String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
                    Log.d("BackGroundJobService", ""+errorCode+","+ errorMessage+","+ errorDetails);
                }

                @Override
                public void notImplemented() {
                    Log.d("BackGroundJobService", "notImplemented");
                }
            });
        }
        return true;
    }

    @Override
    public boolean onStopJob(JobParameters params) {
        return true;
    }
}
