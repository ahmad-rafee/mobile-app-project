<?php

namespace App\Http\Controllers;

use App\Models\Apartment;
use App\Models\ApartmentImage;
use App\Models\Notification;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ApartmentController extends Controller
{
    public function store(Request $request)
    {
        if ($request->user()->role !== 'owner') {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'governorate' => 'required|string',
            'city' => 'required|string',
            'price' => 'required|numeric|min:1',
            'rooms' => 'nullable|integer|min:1',
            'area' => 'nullable|numeric|min:0',
            'images' => 'required|array|min:1',
            'images.*' => 'image|mimes:jpg,jpeg,png,webp|max:4096',
        ]);

        $apartment = Apartment::create([
            'owner_id' => $request->user()->id,
            'title' => $request->title,
            'description' => $request->description,
            'governorate' => $request->governorate,
            'city' => $request->city,
            'price' => $request->price,
            'rooms' => $request->rooms,
            'area' => $request->area,
            'status' => 'pending'
        ]);

        $admins = User::where('role', 'admin')->get();
        foreach ($admins as $admin) {
            Notification::create([
                'user_id' => $admin->id,
                'title' => __('messages.apartment_added_pending'),
                'body' => __('messages.apartment_added_pending'),
                'is_read' => false
            ]);
        }

        foreach ($request->file('images') as $image) {
            $path = $image->store('apartments', 'public');
            ApartmentImage::create([
                'apartment_id' => $apartment->id,
                'path' => $path
            ]);
        }

        return response()->json([
            'message' => __('messages.apartment_added_pending'),
            'apartment' => $apartment
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $apartment = Apartment::findOrFail($id);

        if (
            $request->user()->id !== $apartment->owner_id &&
            $request->user()->role !== 'admin'
        ) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'governorate' => 'sometimes|string',
            'city' => 'sometimes|string',
            'price' => 'sometimes|numeric|min:1',
            'rooms' => 'sometimes|integer|min:1',
            'area' => 'sometimes|numeric|min:0',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpg,jpeg,png,webp|max:4096',
        ]);

        $apartment->update($request->only([
            'title',
            'description',
            'governorate',
            'city',
            'price',
            'rooms',
            'area'
        ]));

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('apartments', 'public');
                ApartmentImage::create([
                    'apartment_id' => $apartment->id,
                    'path' => $path
                ]);
            }
        }

        return response()->json([
            'message' => __('messages.apartment_updated'),
            'apartment' => $apartment->load('images')
        ], 200);
    }

    public function destroy(Request $request, $id)
    {
        $apartment = Apartment::findOrFail($id);

        if (
            $request->user()->id !== $apartment->owner_id &&
            $request->user()->role !== 'admin'
        ) {
            return response()->json([
                'message' => __('messages.not_allowed')
            ], 403);
        }

        foreach ($apartment->images as $image) {
            Storage::disk('public')->delete($image->path);
        }

        $apartment->delete();

        return response()->json([
            'message' => __('messages.apartment_deleted')
        ], 200);
    }

    public function index(Request $request)
    {
        $query = Apartment::where('status', 'approved')
            ->where('is_available', true);

        if ($request->filled('governorate')) {
            $query->where('governorate', $request->governorate);
        }

        if ($request->filled('city')) {
            $query->where('city', $request->city);
        }

        if ($request->filled('min_price')) {
            $query->where('price', '>=', $request->min_price);
        }

        if ($request->filled('max_price')) {
            $query->where('price', '<=', $request->max_price);
        }

        if ($request->filled('rooms')) {
            $query->where('rooms', $request->rooms);
        }

        if ($request->filled('area')) {
            $query->where('area', $request->area);
        }

        match ($request->sort_by) {
            'price_asc' => $query->orderBy('price', 'asc'),
            'price_desc' => $query->orderBy('price', 'desc'),
            default => $query->orderBy('created_at', 'desc'),
        };

        return response()->json(
            $query->with('images')->paginate(10)
        );
    }

    public function show($id)
    {
        $apartment = Apartment::with('images', 'owner')->find($id);

        if (!$apartment) {
            return response()->json([
                'message' => __('messages.apartment_not_found')
            ], 404);
        }

        if ($apartment->status !== 'approved') {
            return response()->json([
                'message' => __('messages.apartment_not_approved')
            ], 403);
        }

        return response()->json($apartment, 200);
    }
}
