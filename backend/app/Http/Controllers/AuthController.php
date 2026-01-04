<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

use App\Models\Apartment;
use App\Models\Booking;
use App\Models\Message;

class AuthController extends Controller
{
    public function dashboardStats(Request $request)
    {
        $user = $request->user();
        if ($user->role !== 'owner') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $totalProperties = Apartment::where('owner_id', $user->id)->count();


        // Count bookings for any of the owner's apartments
        $totalBookings = Booking::whereHas('apartment', function ($query) use ($user) {
            $query->where('owner_id', $user->id);
        })->count();

        // Calculate total earnings (sum of price of approved bookings)
        $totalEarnings = Booking::whereHas('apartment', function ($query) use ($user) {
            $query->where('owner_id', $user->id);
        })->where('bookings.status', 'approved')  // Qualified column name to avoid ambiguity
            ->join('apartments', 'bookings.apartment_id', '=', 'apartments.id')
            ->sum('apartments.price');

        // Messages count placeholder
        $messagesCount = 0;

        // Recent Activity: 3 latest bookings
        $recentActivity = Booking::whereHas('apartment', function ($query) use ($user) {
            $query->where('owner_id', $user->id);
        })->with('apartment')
            ->orderBy('created_at', 'desc')
            ->take(3)
            ->get()
            ->map(function ($booking) {
                return [
                    'title' => $booking->apartment->title,
                    'subtitle' => 'Booking ' . $booking->status,
                    'date' => $booking->created_at->diffForHumans(),
                ];
            });


        return response()->json([
            'success' => true,
            'data' => [
                'total_properties' => $totalProperties,
                'total_bookings' => $totalBookings,
                'total_earnings' => $totalEarnings,
                'messages_count' => $messagesCount,
                'recent_activity' => $recentActivity
            ]
        ]);
    }
    public function register(Request $request)
    {
        $validated = $request->validate([
            'first_name' => 'required|string|max:100',
            'last_name' => 'required|string|max:100',
            'phone' => [
                'required',
                // 'regex:/^\+?[1-9]\d{9,14}$/',
                'unique:users,phone'
            ],
            'password' => 'required|string|min:6|confirmed',
            'birth_date' => 'required|date',
            'profile_image' => 'required|image|mimes:jpg,jpeg,webp,png|max:2048',
            'id_image' => 'required|image|mimes:jpg,jpeg,webp,png|max:4096',
            // 'role' => 'nullable|in:tenant,owner,admin',
        ]);

        $role = $validated['role'] ?? 'tenant';

        $profileImagePath = $request->file('profile_image')
            ->store('users/profile_images', 'public');
        $idImagePath = $request->file('id_image')
            ->store('users/id_images', 'public');

        $user = User::create([
            'first_name' => $validated['first_name'],
            'last_name' => $validated['last_name'],
            'phone' => $validated['phone'],
            'password' => $validated['password'],
            'birth_date' => $validated['birth_date'],
            'profile_image' => $profileImagePath,
            'id_image' => $idImagePath,
            'role' => $role,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => __('messages.account_pending'),
            'data' => $user
        ], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'phone' => 'required|string',
            'password' => 'required|string',
        ]);

        $user = User::where('phone', $request->phone)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => __('messages.invalid_credentials'),
            ], 401);
        }

        if ($user->status === 'pending') {
            return response()->json([
                'success' => false,
                'message' => __('messages.account_pending'),
            ], 403);
        }

        if ($user->status === 'rejected') {
            return response()->json([
                'success' => false,
                'message' => __('messages.account_rejected'),
            ], 403);
        }

        if ($user->status !== 'approved') {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 400);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => __('messages.login_success'),
            'user' => $user->only(['id', 'first_name', 'last_name', 'phone', 'role', 'status']),
            'token' => $token,
        ], 200);
    }

    public function logout(Request $request)
    {
        $token = $request->user()->currentAccessToken();

        if ($token) {
            $token->delete();
        }

        return response()->json([
            'success' => true,
            'message' => __('messages.logout_success')
        ], 200);
    }

    public function profile(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'phone' => $user->phone,
                'birth_date' => $user->birth_date,
                'profile_image' => $user->profile_image ? url('storage/' . $user->profile_image) : null,
                'id_image' => $user->id_image ? url('storage/' . $user->id_image) : null,
                'role' => $user->role,
                'status' => $user->status,
            ]
        ], 200);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'first_name' => 'sometimes|string|max:100',
            'last_name' => 'sometimes|string|max:100',
            'phone' => [
                'sometimes',
                'regex:/^\+?[1-9]\d{9,14}$/',
                Rule::unique('users', 'phone')->ignore($user->id),
            ],
            'birth_date' => 'sometimes|date',
            'password' => 'sometimes|string|min:6',
            'profile_image' => 'sometimes|image|mimes:jpg,jpeg,png|max:2048',
            'id_image' => 'sometimes|image|mimes:jpg,jpeg,png|max:4096',
        ]);

        $user->fill($validated);

        if ($request->filled('password')) {
            $user->password = $validated['password'];
        }

        if ($request->hasFile('profile_image')) {
            if ($user->profile_image) {
                Storage::disk('public')->delete($user->profile_image);
            }
            $user->profile_image = $request->file('profile_image')
                ->store('users/profile_images', 'public');
        }

        if ($request->hasFile('id_image')) {
            if ($user->id_image) {
                Storage::disk('public')->delete($user->id_image);
            }
            $user->id_image = $request->file('id_image')
                ->store('users/id_images', 'public');
        }

        $user->save();

        return response()->json([
            'success' => true,
            'message' => __('messages.success'),
            'user' => [
                'id' => $user->id,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'phone' => $user->phone,
                'birth_date' => $user->birth_date,
                'profile_image' => $user->profile_image ? url('storage/' . $user->profile_image) : null,
                'id_image' => $user->id_image ? url('storage/' . $user->id_image) : null,
                'role' => $user->role,
                'status' => $user->status,
            ]
        ], 200);
    }

}
