<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('user/register', 'UserController@register');                        //need name,email,password,retype password - ( external - type )
Route::post('user/login', 'UserController@login');                              //need email,password
Route::get('checkpair', 'DeviceController@check');                              //need mac address
Route::get('storedata', 'DeviceController@store');                              //need sv with macaddress
Route::get('create', 'DeviceController@create');                                //need mac,longitude,latitude
Route::get('getPairedDevices', 'DeviceController@getAll');                      //need user_id
Route::get('deleteDevice', 'DeviceController@deleteDevice');                    //need id
Route::get('deleteUser', 'UserController@deleteUser');                          //need id
Route::get('updateDeviceType', 'DeviceController@updateDeviceType');            //need id,type
Route::get('updateUserType', 'UserController@updateUserType');                  //need id,type
Route::get('user/getUsers', 'UserController@getUsers');                         //need user_id
Route::post('feedback/create', 'FeedbackController@create');                    //need feedback and device id | ( external - image )
Route::get('feedback/drop', 'FeedbackController@drop');                         //need feedback id
Route::get('feedback/get', 'FeedbackController@get');                           //need feedback id

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
