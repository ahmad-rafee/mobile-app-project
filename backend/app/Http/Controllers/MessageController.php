<?php

namespace App\Http\Controllers;

use App\Models\Conversation;
use App\Models\Message;
use App\Models\Notification;
use Illuminate\Http\Request;

use function Symfony\Component\Clock\now;

class MessageController extends Controller
{
    public function send(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversation,id',
            'receiver_id' => 'required|exists:users,id',
            'message' => 'required|string'
        ]);

        $user = $request->user();
        $conversation = Conversation::find($request->conversation_id);

        if ($user->id == $conversation->user_id) {
            $receiver_id = $conversation->owner_id;
        } elseif ($user->id == $conversation->owner_id) {
            $receiver_id = $conversation->user_id;
        } else {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $message = Message::create([
            'conversation_id' => $conversation->id,
            'sender_id' => $user->id,
            'receiver_id' => $receiver_id,
            'message' => $request->message,
            'read_at' => null
        ]);

        Notification::create([
            'user_id' => $request->receiver_id,
            'title' => __('messages.message_sent'),
            'body' => __('messages.message_sent'),
            'is_read' => false
        ]);

        return response()->json([
            'message' => __('messages.message_sent'),
            'data' => $message
        ], 201);
    }

    public function getMessages(Request $request, $conversation_id)
    {
        $user = $request->user();
        $conversation = Conversation::find($conversation_id);

        if (!$conversation) {
            return response()->json([
                'message' => __('messages.not_found')
            ], 404);
        }

        if ($user->id != $conversation->user_id && $user->id != $conversation->owner_id) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $messages = $conversation->messages()->with('sender')->orderBy('created_at', 'asc')->get();
        return response()->json($messages, 200);
    }

    public function markAsRead(Request $request)
    {
        $request->validate([
            'conversation_id' => 'required|exists:conversation,id'
        ]);

        $user = $request->user();
        $conversation = Conversation::find($request->conversation_id);

        if (!$conversation) {
            return response()->json([
                'message' => __('messages.not_found')
            ], 404);
        }

        if ($user->id != $conversation->user_id && $user->id != $conversation->owner_id) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        Message::where('conversation_id', $conversation->id)
            ->where('receiver_id', $user->id)
            ->whereNull('read_at')->update(['read_at' => now()]);

        return response()->json([
            'message' => __('messages.notification_read')
        ], 200);
    }

    public function deleteMessage(Request $request, $id)
    {
        $user = $request->user();
        $message = Message::find($id);

        if (!$message) {
            return response()->json([
                'message' => __('messages.not_found')
            ], 404);
        }

        if ($message->sender_id != $user->id) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $message->delete();

        return response()->json([
            'message' => __('messages.message_deleted')
        ], 200);
    }
}
