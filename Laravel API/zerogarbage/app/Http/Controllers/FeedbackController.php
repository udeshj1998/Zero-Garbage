<?php

namespace App\Http\Controllers;

use App\Feedbacks;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Validator;

class FeedbackController extends Controller
{

    //Success
    public $successStatus = 200;
    //Bad Request
    public $paramsEmptyStatus = 400;
    //Auth Error
    public $authErrorStatus = 401;

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'feedback' => 'required|String',
            'device_id' => 'required|Integer',
        ]);

        //Request Error
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], $this->paramsEmptyStatus);
        }

        $filename="";
        $filepath="";

        if ($request->has('image')) {

            $image = $request->image;  // your base64 encoded
            $filename = time().'.'.'jpg';
            $filepath="uploads/".$filename;

            $path = public_path('uploads').'/'.$filename;

            $image_base64 = base64_decode($image);

            file_put_contents($path, $image_base64);
        }

        $feedbackData=Feedbacks::create([
            "feedback"=>$request->feedback,
            "path"=>$filepath,
            "device_id"=>$request->device_id,
        ]);

        return response()->json([
            "token" =>  $path
        ], $this->successStatus);
    }

    public function drop(Request $request)
    {
        if ($request->has('id')) {
            $deviceData = Feedbacks::where('id', $request->id)->delete();
            return Response::json([
                    'data' => $deviceData
                ], $this->successStatus);
        } else {
            return Response::json([
                "code" => "0"
            ], $this->paramsEmptyStatus);
        }
    }

    public function get(Request $request)
    {
        if ($request->has('id')) {
            $deviceData = Feedbacks::where('device_id', $request->id)->get();

            $deviceDataNew=[];

            foreach($deviceData as $data){
                $data->date=date_format($data->created_at,"Y/m/d");
                $deviceDataNew[]=$data;
            }

            return Response::json([
                    'data' => $deviceDataNew
                ], $this->successStatus);
        } else {
            return Response::json([
                "code" => "0"
            ], $this->paramsEmptyStatus);
        }
    }
}
