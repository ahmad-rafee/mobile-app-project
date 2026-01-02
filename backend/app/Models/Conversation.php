<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

use function PHPUnit\Framework\returnValue;

class Conversation extends Model
{
    use HasFactory;
    protected $fillable = [
            'user_id',
            'owner_id',
            'apartment_id'
    ];
    public function user()
    {
        return
        $this-> belongsTo(User::class, 'user_id');
    }
    public function owner()
    {
        return
        $this->belongsTo(User::class, 'owner_id');
    }
    public function apartment()
    {
        return
        $this->belongsTo(Apartment::class);
    }
    public function messages()
    {
        return
        $this->hasMany(Message::class);
    }
}
