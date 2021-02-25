package com.amirsheibani.service_backgrund;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.job.JobInfo;
import android.app.job.JobScheduler;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.PersistableBundle;

import com.amirsheibani.service_backgrund.service.BackGroundBroadcastReceiver;
import com.amirsheibani.service_backgrund.service.BackGroundJobService;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.MethodChannel;

public class MyApplication extends FlutterApplication {

    public static MethodChannel channel;
    public static Long minimumLatency = 6000L;
    public static Long deadline = 6000L;
    @Override
    public void onCreate() {
        super.onCreate();
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel("backGroundService","BackGroundService", NotificationManager.IMPORTANCE_LOW);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    public static void scheduleJob(Context context){
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            PersistableBundle bundle = new PersistableBundle();
            ComponentName backGroundComponent = new ComponentName(context, BackGroundJobService.class);
            JobInfo.Builder builder = new JobInfo.Builder(1001, backGroundComponent);
            builder.setExtras(bundle);
            builder.setMinimumLatency(minimumLatency);
            builder.setOverrideDeadline(deadline);
            JobScheduler jobScheduler = context.getSystemService(JobScheduler.class);
            jobScheduler.schedule(builder.build());
        }
    }

    public static void startBackgroundService(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            scheduleJob(context);
        } else {
            AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            Intent intent = new Intent(context, BackGroundBroadcastReceiver.class);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0);
            if(alarmManager != null){
                alarmManager.cancel(pendingIntent);
                alarmManager.setRepeating(AlarmManager.RTC_WAKEUP, System.currentTimeMillis(), minimumLatency, pendingIntent);
            }
        }
    }
}
