<?php

namespace App\Http\Controllers;

use App\Device;
use App\DeviceHasUser;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;

class DeviceController extends Controller
{
    public function check(Request $request)
    {
        if ($request->has('mac')) {
            $deviceData = Device::where('mac', $request->mac)->first();
            if ($deviceData != null) {
                return Response::json([
                    'data' => $deviceData
                ], 200);
            } else {
                return Response::json([
                    "code" => "0"
                ], 204);
            }
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

    public function store(Request $request)
    {
        if ($request->has('mac') && $request->has('sv')) {
            $deviceData = Device::where('mac', $request->mac)->first();
            if ($deviceData != null) {
                Device::where('mac', $request->mac)->update([
                    "status" => $request->sv
                ]);

                return Response::json([
                    "code" => "1"
                ], 200);
            } else {
                return Response::json([
                    "code" => "0"
                ], 204);
            }
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

    public function create(Request $request)
    {
        if ($request->has('mac') && $request->has('longitude') && $request->has('latitude')) {
            $savedData=Device::create([
                "mac"=>$request->mac,
                "longitude"=>$request->longitude,
                "latitude"=>$request->latitude
            ]);

            return Response::json($savedData, 200);
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

    public function getAll(Request $request)
    {
        if ($request->has('type')) {

            if($request->type=="0"){
                $result=Device::get();
            }else{
                $result=Device::where('type', $request->type)->get();
            }

            return Response::json([
                "code" => "1",
                "data"=>$result
            ], 200);
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

    public function deleteDevice(Request $request)
    {
        if ($request->has('id')) {
            $deviceData = Device::where('id', $request->id)->delete();
            return Response::json([
                    'data' => $deviceData
                ], 200);
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

     public function updateDeviceType(Request $request)
    {
        if ($request->has('id') && $request->has('type')) {
            $deviceData = Device::where('id', $request->id)->update(["type"=>$request->type]);
            return Response::json([
                    'data' => $deviceData
                ], 200);
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }


}
