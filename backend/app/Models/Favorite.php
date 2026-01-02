<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    protected $fillable = [
        'tenant_id',
        'apartment_id',
    ];

    protected $casts = [
        'tenant_id' => 'integer',
        'apartment_id' => 'integer',
    ];

    public function tenant()
    {
        return $this->belongsTo(User::class, 'tenant_id');
    }

    public function apartment()
    {
        return $this->belongsTo(Apartment::class);
    }
}