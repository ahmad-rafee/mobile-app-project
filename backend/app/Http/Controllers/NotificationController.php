<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function sendNotification(Request $request)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'title'   => 'required|string',
            'body'    => 'nullable|string'
        ]);

        $notification = Notification::create([
            'user_id' => $request->user_id,
            'title'   => $request->title,
            'body'    => $request->body,
            'is_read' => false
        ]);

        return response()->json([
            'message' => __('messages.notification_sent'),
            'data'    => $notification
        ], 201);
    }

    public function getNotifications(Request $request)
    {
        $user = $request->user();

        $notifications = Notification::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($notifications, 200);
    }

    public function markAsRead($id)
    {
        $notification = Notification::find($id);

        if (!$notification) {
            return response()->json([
                'message' => __('messages.not_found')
            ], 404);
        }

        $notification->update(['is_read' => true]);

        return response()->json([
            'message' => __('messages.notification_read')
        ], 200);
    }

    public function deleteNotification($id)
    {
        $notification = Notification::find($id);

        if (!$notification) {
            return response()->json([
                'message' => __('messages.not_found')
            ], 404);
        }

        $notification->delete();

        return response()->json([
            'message' => __('messages.notification_deleted')
        ], 200);
    }
}
