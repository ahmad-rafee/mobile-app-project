<?php

namespace App\Http\Controllers;

use App\Models\Apartment;
use App\Models\Booking;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class BookingController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'apartment_id' => 'required|exists:apartments,id',
            'start_date' => 'required|date|after_or_equal:today',
            'end_date' => 'required|date|after:start_date',
            'location' => 'required|string|max:255',
            'payment_method' => 'required|string',
        ]);

        $apartment = Apartment::find($request->apartment_id);

        if ($apartment->owner_id === Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 403);
        }

        $exists = Booking::where('apartment_id', $request->apartment_id)
            ->whereIn('status', ['pending', 'approved'])
            ->where(function ($query) use ($request) {
                $query->whereBetween('start_date', [$request->start_date, $request->end_date])
                    ->orWhereBetween('end_date', [$request->start_date, $request->end_date])
                    ->orWhere(function ($q) use ($request) {
                        $q->where('start_date', '<=', $request->start_date)
                            ->where('end_date', '>=', $request->end_date);
                    });
            })
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => __('messages.booking_conflict'),
            ], 400);
        }

        $booking = Booking::create([
            'tenant_id' => Auth::id(),
            'apartment_id' => $request->apartment_id,
            'start_date' => $request->start_date,
            'end_date' => $request->end_date,
            'location' => $request->location,
            'status' => 'pending',
            'modification_status' => 'none',
            'payment_method' => $request->payment_method,
            'payment_status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => __('messages.booking_created'),
            'booking' => $booking
        ], 201);
    }

    public function approve($id)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->apartment->owner_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 403);
        }

        if ($booking->modification_status === 'pending') {

            $exists = Booking::where('apartment_id', $booking->apartment_id)
                ->where('id', '!=', $booking->id)
                ->whereIn('status', ['pending', 'approved'])
                ->where(function ($query) use ($booking) {
                    $query->whereBetween('start_date', [$booking->start_date, $booking->end_date])
                        ->orWhereBetween('end_date', [$booking->start_date, $booking->end_date])
                        ->orWhere(function ($q) use ($booking) {
                            $q->where('start_date', '<=', $booking->start_date)
                                ->where('end_date', '>=', $booking->end_date);
                        });
                })
                ->exists();

            if ($exists) {
                return response()->json([
                    'success' => false,
                    'message' => __('messages.booking_conflict'),
                ], 400);
            }

            $booking->modification_status = 'approved';
            $booking->save();

            return response()->json([
                'success' => true,
                'message' => __('messages.success'),
                'booking' => $booking
            ], 200);
        }

        $booking->status = 'approved';
        $booking->save();

        return response()->json([
            'success' => true,
            'message' => __('messages.booking_approved'),
            'booking' => $booking
        ], 200);
    }

    public function reject($id)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->apartment->owner_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 403);
        }

        if ($booking->modification_status === 'pending') {
            $booking->modification_status = 'rejected';
            $booking->save();

            return response()->json([
                'success' => true,
                'message' => __('messages.success'),
                'booking' => $booking
            ], 200);
        }

        $booking->status = 'rejected';
        $booking->save();

        return response()->json([
            'success' => true,
            'message' => __('messages.booking_rejected'),
            'booking' => $booking
        ], 200);
    }

    public function cancel($id)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->tenant_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 403);
        }

        if ($booking->status === 'approved' && $booking->start_date <= now()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 400);
        }

        $booking->status = 'canceled';
        $booking->save();

        return response()->json([
            'success' => true,
            'message' => __('messages.booking_canceled'),
            'booking' => $booking
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $booking = Booking::findOrFail($id);

        if ($booking->tenant_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 403);
        }

        if ($booking->status === 'approved' && $booking->start_date <= now()) {
            return response()->json([
                'success' => false,
                'message' => __('messages.not_allowed'),
            ], 400);
        }

        $request->validate([
            'start_date' => 'required|date|after_or_equal:today',
            'end_date' => 'required|date|after:start_date',
        ]);

        $exists = Booking::where('apartment_id', $booking->apartment_id)
            ->where('id', '!=', $booking->id)
            ->whereIn('status', ['pending', 'approved'])
            ->where(function ($query) use ($request) {
                $query->whereBetween('start_date', [$request->start_date, $request->end_date])
                    ->orWhereBetween('end_date', [$request->start_date, $request->end_date])
                    ->orWhere(function ($q) use ($request) {
                        $q->where('start_date', '<=', $request->start_date)
                            ->where('end_date', '>=', $request->end_date);
                    });
            })
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => __('messages.booking_conflict'),
            ], 409);
        }

        $booking->update([
            'start_date' => $request->start_date,
            'end_date' => $request->end_date,
            'modification_status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => __('messages.booking_created'),
            'booking' => $booking
        ], 200);
    }

    public function myBookings()
    {
        $bookings = Booking::where('tenant_id', Auth::id())
            ->with('apartment')
            ->orderBy('start_date', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => __('messages.success'),
            'bookings' => $bookings
        ], 200);
    }

    public function ownerBookings()
    {
        // Get apartments owned by the user
        $apartmentIds = Apartment::where('owner_id', Auth::id())->pluck('id');

        // Get bookings for those apartments
        $bookings = Booking::whereIn('apartment_id', $apartmentIds)
            ->with(['apartment', 'tenant']) // Load tenant info too
            ->orderBy('start_date', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => __('messages.success'),
            'bookings' => $bookings
        ], 200);
    }
}
