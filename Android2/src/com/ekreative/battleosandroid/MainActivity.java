package com.ekreative.battleosandroid;

import java.util.HashMap;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.widget.Toast;

import com.bump.api.BumpAPIIntents;
import com.bump.api.IBumpAPI;


public class MainActivity extends Activity {
	private IBumpAPI api;	
	private final String tag ="!!!CHEB!!!";
	private final ServiceConnection connection = new ServiceConnection() {	    
		public void onServiceConnected(ComponentName className, IBinder binder) {
			Log.i(tag,"onServiceConnected");
	        api = IBumpAPI.Stub.asInterface(binder);	        
	        Log.i(tag,"after IBumpAPI.Stub.asInterface(binder)");
	        try {
	            new Thread(new Runnable() {					
					public void run() {
						try{
							Log.i(tag,"Inner Try! before api.configured");
							api.configure("de703e6680454adbbf3d1ac99727c9b0", "Cheb");//Max ID
							//api.configure("004d36464fba4d8a99db91ab389929c7", "Cheb");//New Cheb ID
							//api.configure("b00609a8b2f143edba70f8e0bee2754e", "Cheb");//Old ChebID
							Log.i(tag,"Inner Try! after api.configured");
						}catch (RemoteException e) {
							Log.i(tag,"RemoteException error: "+ e.toString());
						}
					}
				}).start();        	
	        } catch (Exception e) {
	        	Log.i(tag,"catch error: "+ e.toString());	
	        }	        	
	    }
		public void onServiceDisconnected(ComponentName name) {}
	};
	
	private final BroadcastReceiver receiver = new BroadcastReceiver() {
	    public void onReceive(Context context, Intent intent) {
	        final String action = intent.getAction();
	        try {
	        	Log.i(tag,"Recive something");
	        	if (action.equals(BumpAPIIntents.DATA_RECEIVED)) {
	            	Log.i("Bump Test", "Received data from: " + api.userIDForChannelID(intent.getLongExtra("channelID", 0)));
	                  Toast.makeText(getApplicationContext(), "Received data from: " + api.userIDForChannelID(intent.getLongExtra("channelID", 0)), Toast.LENGTH_LONG).show();
	                Log.i("Bump Test", "Data: " + new String(intent.getByteArrayExtra("data")));
	                Log.i("Result_data", "Data: " + new String(intent.getByteArrayExtra("data")));
	                Toast.makeText(getApplicationContext(), "Result_data: " + new String(intent.getByteArrayExtra("data")), Toast.LENGTH_LONG).show();
	                              	  
	            } else if (action.equals(BumpAPIIntents.MATCHED)) {
	                api.confirm(intent.getLongExtra("proposedChannelID", 0), true);
	                  Toast.makeText(getApplicationContext(), "MATCHED", Toast.LENGTH_LONG).show();
	            } else if (action.equals(BumpAPIIntents.CHANNEL_CONFIRMED)) {
	            	HashMap<String, String> hash = new HashMap<String, String>();
	            	hash.put("os", "Android");
	            	hash.put("attack", "0");
	            	api.send(intent.getLongExtra("channelID", 0), hash.toString().getBytes());	            	
	                Toast.makeText(getApplicationContext(), "CHANNEL_CONFIRMED", Toast.LENGTH_LONG).show();
	            } else if (action.equals(BumpAPIIntents.CONNECTED)) {
	                api.enableBumping();
	                Toast.makeText(getApplicationContext(), "CONNECTED", Toast.LENGTH_LONG).show();
	            } else{
	            	Log.i(tag,"Get this action: "+action.toString());
	            	Toast.makeText(getApplicationContext(), "Get this action: "+action.toString(), Toast.LENGTH_LONG).show();
	            }	            
	        } catch (RemoteException e) {}
	    }
	};

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout. activity_main);
        bindService(new Intent(IBumpAPI.class.getName()),
                connection, 
                Context.BIND_AUTO_CREATE);        
        Log.i(tag,"After BIND");
        IntentFilter filter = new IntentFilter();
        filter.addAction(BumpAPIIntents.CHANNEL_CONFIRMED);
        filter.addAction(BumpAPIIntents.DATA_RECEIVED);
        filter.addAction(BumpAPIIntents.NOT_MATCHED);
        filter.addAction(BumpAPIIntents.MATCHED);
        filter.addAction(BumpAPIIntents.CONNECTED);
        Log.i(tag,"After add all actions");
        registerReceiver(receiver, filter);
    }    
    
    public void onDestroy() {
        Log.i(tag, "onDestroy");
        unbindService(connection);
        unregisterReceiver(receiver);
        super.onDestroy();
     }
}