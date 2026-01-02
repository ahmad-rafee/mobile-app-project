<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\FcmToken;
use App\Services\FcmService;

class FcmTokenController extends Controller
{
    protected $fcmService;


    public function __construct(FcmService $fcmService)
    {
        $this->fcmService = $fcmService;
    }

    public function store(Request $request)
    {
        $request->validate([
            'token' => 'required|string',
            'device_type' => 'nullable|string'
        ]);

        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        $fcmToken = FcmToken::updateOrCreate(
            ['user_id' => $user->id, 'device_type' => $request->device_type ?? 'unknown'],
            ['fcm_token' => $request->token]
        );


        $title = 'Welcome!';
        $body = 'Your FCM token has been saved successfully.';

        $success = $this->fcmService->sendNotification($fcmToken->fcm_token, $title, $body);


        if ($success) {
            return response()->json([
                'message' => 'FCM token saved and notification sent successfully'
            ], 200);
        }

        return response()->json([
            'message' => 'FCM token saved, but notification sending failed'
        ], 500);
    }
}
