<?php

namespace App\Http\Controllers;

use App\Models\Apartment;
use App\Models\Notification;
use App\Models\User;
use App\Providers\AppServiceProvider;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function pendingUsers()
{
    $users = User::where('status', 'pending')->get();

    return response()->json([
        'status' => true,
        'message' => 'Pending users retrieved successfully',
        'data' => $users
    ]);
}

public function pendingApartments()
{
    $apartments = Apartment::where('status', 'pending')->get();

    return response()->json([
        'status' => true,
        'message' => 'Pending apartments retrieved successfully',
        'data' => $apartments
    ]);
}

    public function approveApartment(Request $request, $id)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $apartment = Apartment::find($id);
        if (!$apartment) {
            return response()->json([
                'message' => __('messages.apartment_not_found')
            ], 404);
        }

        if ($apartment->status === 'approved') {
            return response()->json([
                'message' => __('messages.apartment_already_approved')
            ], 400);
        }

        $apartment->update([
            'status' => 'approved'
        ]);

        Notification::create([
            'user_id' => $apartment->owner_id,
            'title'   => __('messages.apartment_approved'),
            'body'    => __('messages.apartment_approved'),
            'is_read' => false
        ]);

        return response()->json([
            'message' => __('messages.apartment_approved')
        ], 200);
    }

    public function rejectApartment(Request $request, $id)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $apartment = Apartment::find($id);
        if (!$apartment) {
            return response()->json([
                'message' => __('messages.apartment_not_found')
            ], 404);
        }

        if ($apartment->status === 'rejected') {
            return response()->json([
                'message' => __('messages.apartment_already_rejected')
            ], 400);
        }

        $apartment->update([
            'status' => 'rejected'
        ]);

        Notification::create([
            'user_id' => $apartment->owner_id,
            'title'   => __('messages.apartment_rejected'),
            'body'    => __('messages.apartment_rejected'),
            'is_read' => false
        ]);

        return response()->json([
            'message' => __('messages.apartment_rejected')
        ], 200);
    }

  public function approveUser(Request $request, $id)
{
    if ($request->user()->role !== 'admin') {
        return response()->json([
            'message' => __('messages.not_allowed')
        ], 403);
    }

    $user = User::find($id);
    if (!$user) {
        return response()->json([
            'message' => __('messages.user_not_found')
        ], 404);
    }

    if ($user->is_approved === 1 || $user->status === 'approved') {
        return response()->json([
            'message' => __('messages.user_already_approved')
        ], 400);
    }

    $user->update([
        'is_approved' => 1,
        'status'      => 'approved'
    ]);

    Notification::create([
        'user_id' => $user->id,
        'title'   => __('messages.user_approved'),
        'body'    => __('messages.user_approved'),
        'is_read' => false
    ]);

    return response()->json([
        'message' => __('messages.user_approved')
    ], 200);
}


    public function deleteUser(Request $request, $id)
    {
        if ($request->user()->role !== 'admin') {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $user = User::find($id);
        if (!$user) {
            return response()->json([
                'message' => __('messages.user_not_found')
            ], 404);
        }

        Notification::create([
            'user_id' => $user->id,
            'title'   => __('messages.user_deleted'),
            'body'    => __('messages.user_deleted'),
            'is_read' => false
        ]);

        $user->delete();

        return response()->json([
            'message' => __('messages.user_deleted')
        ], 200);
    }
}
