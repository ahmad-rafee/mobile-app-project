<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bookings', function (Blueprint $table) {
            $table->id();

            $table->foreignId('tenant_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('apartment_id')->constrained('apartments')->onDelete('cascade');

            $table->date('start_date');
            $table->date('end_date');
            $table->string('location')->nullable();

            $table->enum('status', ['pending', 'approved', 'rejected', 'canceled'])
                ->default('pending');

            $table->enum('modification_status', ['none', 'pending', 'approved', 'rejected'])
                ->default('none');

            $table->string('payment_method')->nullable();
            $table->string('payment_status')->default('pending');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bookings');
    }
};
