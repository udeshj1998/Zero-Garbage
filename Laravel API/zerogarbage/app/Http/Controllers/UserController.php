<?php

namespace App\Http\Controllers;

use App\User;
use DateTime;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Response;

class UserController extends Controller
{
    //Success
    public $successStatus = 200;
    //Bad Request
    public $paramsEmptyStatus = 400;
    //Auth Error
    public $authErrorStatus = 401;

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|max:25',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:6',
            'repassword' => 'required|min:6|same:password',
        ]);

        //Request Error
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], $this->paramsEmptyStatus);
        }

        $currentDateTime = new DateTime();

        //Register Process
        $user = User::create([
            "name" => $request->name,
            "email" => $request->email,
            "password" => bcrypt($request->password),
            "email_verified_at" => $currentDateTime->format('Y-m-d H:i:s'),
            "type" => ($request->has('type')) ? $request->type : 1,
        ]);

        //Token Creation Process
        return response()->json([
            "token" => $user
        ], $this->successStatus);
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        //Request Error
        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], $this->paramsEmptyStatus);
        }

        if (Auth::attempt(array('email' => $request->email, 'password' => $request->password))) {
            $user = Auth::user();

            return response()->json([
                "user" => $user
            ], $this->successStatus);
        } else {
            return response()->json([], $this->authErrorStatus);
        }
    }

        public function deleteUser(Request $request)
    {
        if ($request->has('id')) {
            $deviceData = User::where('id', $request->id)->delete();
            return Response::json([
                    'data' => $deviceData
                ], 200);
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

            public function updateUserType(Request $request)
    {
        if ($request->has('id') && $request->has('type')) {
            $deviceData = User::where('id', $request->id)->update([
                "type"=>$request->type
            ]);
            return Response::json([
                    'data' => $deviceData
                ], 200);
        } else {
            return Response::json([
                "code" => "0"
            ], 400);
        }
    }

                public function getUsers(Request $request)
    {
        $userData = User::get();
            return Response::json([
                    'data' => $userData
                ], 200);
    }
}
