<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reviews', function (Blueprint $table) {

    $table->id();

    $table->foreignId('booking_id')->constrained('bookings')->onDelete('cascade');
    $table->foreignId('tenant_id')->constrained('users')->onDelete('cascade');
    $table->foreignId('apartment_id')->constrained('apartments')->onDelete('cascade');

    $table->tinyInteger('rating'); // 1 to 5
    $table->text('comment')->nullable();

    $table->unique(['booking_id', 'tenant_id']);

    $table->timestamps();
});

    }

    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};