<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
      use HasFactory, Notifiable,HasApiTokens;
    protected $fillable = [
        'first_name',
        'last_name',
        'phone',
        'password',
        'birth_date',
        'profile_image',
        'id_image',
        'role',
        'status',
        'is_approved'
    ];
    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'password' => 'hashed',
        ];
    }
    public function apartments()
    {
        return $this->hasMany(Apartment::class, 'owner_id');
    }

    public function bookings()
    {
        return $this->hasMany(Booking::class, 'tenant_id');
    }

    public function reviews()
    {
        return $this->hasMany(Review::class, 'tenant_id');
    }

    public function favorites()
    {
        return $this->hasMany(Favorite::class, 'tenant_id');
    }

    public function messagesSent()
     {
         return $this->hasMany(Message::class, 'sender_id');
     }

     public function messagesReceived()
     {
         return $this->hasMany(Message::class, 'receiver_id');
     }

    public function notifications()
     {
         return $this->hasMany(Notification::class, 'user_id');
     }





}
