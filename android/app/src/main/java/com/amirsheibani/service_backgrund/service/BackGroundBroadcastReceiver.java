package com.amirsheibani.service_backgrund.service;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BackGroundBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.O) {
            Intent syncIntent = new Intent(context, BackGroundService.class);
            context.startService(syncIntent);
        }
    }
}
