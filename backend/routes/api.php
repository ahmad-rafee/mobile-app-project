<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\ApartmentController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\ConversationController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\FcmTokenController;
use App\Http\Controllers\MessageController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\ReviewController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::post('/update-profile', [AuthController::class, 'updateProfile']);

    Route::post('/bookings', [BookingController::class, 'store']);
    Route::put('/bookings/{id}', [BookingController::class, 'update']);
    Route::delete('/bookings/{id}', [BookingController::class, 'cancel']);
    Route::get('/my-bookings', [BookingController::class, 'myBookings']);

    Route::post('/bookings/{id}/approve', [BookingController::class, 'approve']);
    Route::post('/bookings/{id}/reject', [BookingController::class, 'reject']);

    Route::post('/reviews', [ReviewController::class, 'store']);
    Route::put('/reviews/{id}', [ReviewController::class, 'update']);
    Route::delete('/reviews/{id}', [ReviewController::class, 'destroy']);
    Route::get('/apartments/{id}/reviews', [ReviewController::class, 'getApartmentReviews']);


    Route::post('/favorites/{apartmentId}', [FavoriteController::class, 'store']);
    Route::delete('/favorites/{apartmentId}', [FavoriteController::class, 'destroy']);
    Route::get('/favorites', [FavoriteController::class, 'index']);
});

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/apartments', [ApartmentController::class, 'store']);
    Route::put('/apartments/{id}', [ApartmentController::class, 'update']);
    Route::delete('/apartments/{id}', [ApartmentController::class, 'destroy']);

    Route::get('/apartments/{id}', [ApartmentController::class, 'show']);

    Route::post('/conversations/start', [ConversationController::class, 'startConversation']);
    Route::delete('/conversations/{id}', [ConversationController::class, 'deleteConversation']);

    Route::get('/conversations', [MessageController::class, 'myConversations']);
    Route::post('/messages/send', [MessageController::class, 'send']);
    Route::get('/messages/{conversations_id}', [MessageController::class, 'getMessages']);
    Route::post('/message/read', [MessageController::class, 'markAsRead']);
    Route::delete('/messages/{id}', [MessageController::class, 'deleteMesaage']);
});
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/notification/send', [NotificationController::class, 'sendNotification']);
    Route::get('/notification', [NotificationController::class, 'getNotifications']);
    Route::post('/notification/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::delete('/notification/{id}', [NotificationController::class, 'deleteNotification']);
    Route::post('/fcm-token',[FcmTokenController::class,'store']);
});

Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::get('/admin/users/pending', [AdminController::class, 'pendingUsers']);
    Route::get('/admin/apartments/pending', [AdminController::class, 'pendingApartments']);

    Route::post('/admin/apartments/{id}/approve', [AdminController::class, 'approveApartment']);
    Route::post('/admin/apartments/{id}/reject', [AdminController::class, 'rejectApartment']);

    Route::post('/admin/users/{id}/approve', [AdminController::class, 'approveUser']);
    Route::delete('/admin/users/{id}', [AdminController::class, 'deleteUser']);

});
Route::get('/apartments', [ApartmentController::class, 'index']);

