<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Favorite;
use App\Models\Apartment;
use Illuminate\Support\Facades\Auth;

class FavoriteController extends Controller
{
    public function store($apartmentId)
    {
        $apartment = Apartment::findOrFail($apartmentId);

        if ($apartment->owner_id == Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $exists = Favorite::where('tenant_id', Auth::id())
                          ->where('apartment_id', $apartmentId)
                          ->exists();

        if ($exists) {
            return response()->json([
                'success' => true,
                'message' => __('messages.already_done')
            ], 200);
        }

        $favorite = Favorite::create([
            'tenant_id'    => Auth::id(),
            'apartment_id' => $apartmentId,
        ]);

        return response()->json([
            'success'  => true,
            'message'  => __('messages.success'),
            'favorite' => $favorite
        ], 201);
    }

    public function destroy($apartmentId)
    {
        $favorite = Favorite::where('tenant_id', Auth::id())
                            ->where('apartment_id', $apartmentId)
                            ->firstOrFail();

        $favorite->delete();

        return response()->json([
            'success' => true,
            'message' => __('messages.apartment_deleted')
        ], 200);
    }

    public function index()
    {
        $favorites = Favorite::where('tenant_id', Auth::id())
            ->with('apartment')
            ->get();

        return response()->json([
            'success'   => true,
            'favorites' => $favorites
        ], 200);
    }
}
