<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Apartment extends Model
{
   protected $fillable  = 
   [
    'owner_id',
    'title',
    'description',
    'governorate',
    'city',
    'price' ,
    'rooms',
    'area',
    'is_available',
    'status',
   ];
 
   public function owner()
   {

    return 
    $this->belongsTo(User::class,'owner_id');

   }
    public function images()
   {

    return 
    $this->hasMany(ApartmentImage::class,'apartment_id');

   }



}
