<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Review;
use App\Models\Booking;
use Illuminate\Support\Facades\Auth;

class ReviewController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'booking_id' => 'required|exists:bookings,id',
            'rating'     => 'required|integer|min:1|max:5',
            'comment'    => 'nullable|string',
        ]);

        $booking = Booking::findOrFail($request->booking_id);

        if ($booking->tenant_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'error'   => __('messages.not_allowed')
            ], 403);
        }

        if ($booking->apartment->owner_id == Auth::id()) {
            return response()->json([
                'success' => false,
                'error'   => __('messages.not_allowed')
            ], 403);
        }

        if ($booking->status !== 'approved' || $booking->end_date > now()) {
            return response()->json([
                'success' => false,
                'error'   => __('messages.not_allowed')
            ], 400);
        }

        if (Review::where('booking_id', $booking->id)->exists()) {
            return response()->json([
                'success' => false,
                'error'   => __('messages.already_done')
            ], 409);
        }

        $review = Review::create([
            'booking_id'   => $booking->id,
            'tenant_id'    => Auth::id(),
            'apartment_id' => $booking->apartment_id,
            'rating'       => $request->rating,
            'comment'      => $request->comment,
        ]);

        return response()->json([
            'success' => true,
            'message' => __('messages.review_added'),
            'review'  => $review
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $review = Review::findOrFail($id);

        if ($review->tenant_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'error'   => __('messages.not_allowed')
            ], 403);
        }

        $request->validate([
            'rating'  => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        $review->rating  = $request->rating;
        $review->comment = $request->comment;
        $review->save();

        return response()->json([
            'success' => true,
            'message' => __('messages.review_updated'),
            'review'  => $review
        ], 200);
    }

    public function destroy($id)
    {
        $review = Review::findOrFail($id);

        if ($review->tenant_id !== Auth::id()) {
            return response()->json([
                'success' => false,
                'error'   => __('messages.not_allowed')
            ], 403);
        }

        $review->delete();

        return response()->json([
            'success' => true,
            'message' => __('messages.review_deleted')
        ], 200);
    }

    public function getApartmentReviews($apartmentId)
    {
        $reviews = Review::where('apartment_id', $apartmentId)
            ->with('tenant:id,name')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'reviews' => $reviews
        ], 200);
    }
}
