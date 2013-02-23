/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: /Users/anegin/Documents/android_cheb/Hackathon_CK1/BattleOS/Android2/src/com/bump/api/IBumpAPI.aidl
 */
package com.bump.api;
public interface IBumpAPI extends android.os.IInterface
{
/** Local-side IPC implementation stub class. */
public static abstract class Stub extends android.os.Binder implements com.bump.api.IBumpAPI
{
private static final java.lang.String DESCRIPTOR = "com.bump.api.IBumpAPI";
/** Construct the stub at attach it to the interface. */
public Stub()
{
this.attachInterface(this, DESCRIPTOR);
}
/**
 * Cast an IBinder object into an com.bump.api.IBumpAPI interface,
 * generating a proxy if needed.
 */
public static com.bump.api.IBumpAPI asInterface(android.os.IBinder obj)
{
if ((obj==null)) {
return null;
}
android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
if (((iin!=null)&&(iin instanceof com.bump.api.IBumpAPI))) {
return ((com.bump.api.IBumpAPI)iin);
}
return new com.bump.api.IBumpAPI.Stub.Proxy(obj);
}
@Override public android.os.IBinder asBinder()
{
return this;
}
@Override public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
{
switch (code)
{
case INTERFACE_TRANSACTION:
{
reply.writeString(DESCRIPTOR);
return true;
}
case TRANSACTION_configure:
{
data.enforceInterface(DESCRIPTOR);
java.lang.String _arg0;
_arg0 = data.readString();
java.lang.String _arg1;
_arg1 = data.readString();
this.configure(_arg0, _arg1);
reply.writeNoException();
return true;
}
case TRANSACTION_userIDForChannelID:
{
data.enforceInterface(DESCRIPTOR);
long _arg0;
_arg0 = data.readLong();
java.lang.String _result = this.userIDForChannelID(_arg0);
reply.writeNoException();
reply.writeString(_result);
return true;
}
case TRANSACTION_enableBumping:
{
data.enforceInterface(DESCRIPTOR);
this.enableBumping();
reply.writeNoException();
return true;
}
case TRANSACTION_disableBumping:
{
data.enforceInterface(DESCRIPTOR);
this.disableBumping();
reply.writeNoException();
return true;
}
case TRANSACTION_confirm:
{
data.enforceInterface(DESCRIPTOR);
long _arg0;
_arg0 = data.readLong();
boolean _arg1;
_arg1 = (0!=data.readInt());
this.confirm(_arg0, _arg1);
reply.writeNoException();
return true;
}
case TRANSACTION_send:
{
data.enforceInterface(DESCRIPTOR);
long _arg0;
_arg0 = data.readLong();
byte[] _arg1;
_arg1 = data.createByteArray();
this.send(_arg0, _arg1);
reply.writeNoException();
return true;
}
case TRANSACTION_simulateBump:
{
data.enforceInterface(DESCRIPTOR);
this.simulateBump();
reply.writeNoException();
return true;
}
}
return super.onTransact(code, data, reply, flags);
}
private static class Proxy implements com.bump.api.IBumpAPI
{
private android.os.IBinder mRemote;
Proxy(android.os.IBinder remote)
{
mRemote = remote;
}
@Override public android.os.IBinder asBinder()
{
return mRemote;
}
public java.lang.String getInterfaceDescriptor()
{
return DESCRIPTOR;
}
/* Call to initially configure the API. After this, the API
     * can begin trying to establish a connection to the bump
     * servers 

     * parameters
     *  apiKey: your Bump API key.  Get one at http://bu.mp/apiagree 
                ensure that this key is moved to Production mode before shipping:
                http://bu.mp/apideveloper
     *  userID: an ID that makes sense for this user in the context of your application. 
                simpler apps often use the device's name or user's name. 
    */
@Override public void configure(java.lang.String key, java.lang.String userID) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeString(key);
_data.writeString(userID);
mRemote.transact(Stub.TRANSACTION_configure, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
/* Returns the other user's ID on a given channel, if it exists. */
@Override public java.lang.String userIDForChannelID(long channelID) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
java.lang.String _result;
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeLong(channelID);
mRemote.transact(Stub.TRANSACTION_userIDForChannelID, _data, _reply, 0);
_reply.readException();
_result = _reply.readString();
}
finally {
_reply.recycle();
_data.recycle();
}
return _result;
}
/* This will enable bump detection, which means you will
     * start getting MATCHED and NOT_MATCHED intents
     * (when the user actualy bumps) */
@Override public void enableBumping() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_enableBumping, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
/* This will disable bump detection */
@Override public void disableBumping() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_disableBumping, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
/* Confirm a match with another user.
     * Should be sent in response to a MATCHED Intent */
@Override public void confirm(long channelID, boolean result) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeLong(channelID);
_data.writeInt(((result)?(1):(0)));
mRemote.transact(Stub.TRANSACTION_confirm, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
/* Send data during to a channel.
     * Should only be called after receiving a
     * CHANNEL_CONFIRMED Intent */
@Override public void send(long channelID, byte[] data) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeLong(channelID);
_data.writeByteArray(data);
mRemote.transact(Stub.TRANSACTION_send, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
/**** FOR DEBUG ONLY ****
     * Trigger bump (as if the phone had actually bumped) */
@Override public void simulateBump() throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
mRemote.transact(Stub.TRANSACTION_simulateBump, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
}
static final int TRANSACTION_configure = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
static final int TRANSACTION_userIDForChannelID = (android.os.IBinder.FIRST_CALL_TRANSACTION + 1);
static final int TRANSACTION_enableBumping = (android.os.IBinder.FIRST_CALL_TRANSACTION + 2);
static final int TRANSACTION_disableBumping = (android.os.IBinder.FIRST_CALL_TRANSACTION + 3);
static final int TRANSACTION_confirm = (android.os.IBinder.FIRST_CALL_TRANSACTION + 4);
static final int TRANSACTION_send = (android.os.IBinder.FIRST_CALL_TRANSACTION + 5);
static final int TRANSACTION_simulateBump = (android.os.IBinder.FIRST_CALL_TRANSACTION + 6);
}
/* Call to initially configure the API. After this, the API
     * can begin trying to establish a connection to the bump
     * servers 

     * parameters
     *  apiKey: your Bump API key.  Get one at http://bu.mp/apiagree 
                ensure that this key is moved to Production mode before shipping:
                http://bu.mp/apideveloper
     *  userID: an ID that makes sense for this user in the context of your application. 
                simpler apps often use the device's name or user's name. 
    */
public void configure(java.lang.String key, java.lang.String userID) throws android.os.RemoteException;
/* Returns the other user's ID on a given channel, if it exists. */
public java.lang.String userIDForChannelID(long channelID) throws android.os.RemoteException;
/* This will enable bump detection, which means you will
     * start getting MATCHED and NOT_MATCHED intents
     * (when the user actualy bumps) */
public void enableBumping() throws android.os.RemoteException;
/* This will disable bump detection */
public void disableBumping() throws android.os.RemoteException;
/* Confirm a match with another user.
     * Should be sent in response to a MATCHED Intent */
public void confirm(long channelID, boolean result) throws android.os.RemoteException;
/* Send data during to a channel.
     * Should only be called after receiving a
     * CHANNEL_CONFIRMED Intent */
public void send(long channelID, byte[] data) throws android.os.RemoteException;
/**** FOR DEBUG ONLY ****
     * Trigger bump (as if the phone had actually bumped) */
public void simulateBump() throws android.os.RemoteException;
}
