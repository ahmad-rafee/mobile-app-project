<?php

namespace App\Http\Controllers;

use App\Models\Apartment;
use App\Models\Conversation;
use Illuminate\Http\Request;

class ConversationController extends Controller
{
    public function startConversation(Request $request)
    {
        $request->validate([
            'apartment_id' => 'required|exists:apartments,id'
        ]);

        $user = $request->user();
        $apartment = Apartment::find($request->apartment_id);
        $owner_id = $apartment->owner_id;

        if ($user->id === $owner_id) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $conversation = Conversation::where('user_id', $user->id)
            ->where('owner_id', $owner_id)
            ->where('apartment_id', $apartment->id)
            ->first();

        if ($conversation) {
            return response()->json([
                'message' => __('messages.conversation_exists'),
                'conversation' => $conversation
            ], 200);
        }

        $conversation = Conversation::create([
            'user_id'      => $user->id,
            'owner_id'     => $owner_id,
            'apartment_id' => $apartment->id
        ]);

        return response()->json([
            'message' => __('messages.conversation_created'),
            'conversation' => $conversation
        ], 201);
    }

    public function myConversations(Request $request)
    {
        $user = $request->user();

        $conversations = Conversation::where('user_id', $user->id)
            ->orWhere('owner_id', $user->id)
            ->with(['user', 'owner', 'apartment'])
            ->with(['messages' => function ($query) {
                $query->latest()->limit(1);
            }])
            ->orderBy('updated_at', 'desc')
            ->get();

        return response()->json($conversations, 200);
    }

    public function deleteConversation(Request $request, $id)
    {
        $user = $request->user();

        $conversation = Conversation::find($id);

        if (!$conversation) {
            return response()->json([
                'message' => __('messages.not_found')
            ], 404);
        }

        if ($user->id !== $conversation->user_id && $user->id !== $conversation->owner_id) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $conversation->messages()->delete();
        $conversation->delete();

        return response()->json([
            'message' => __('messages.conversation_deleted')
        ], 200);
    }
}
