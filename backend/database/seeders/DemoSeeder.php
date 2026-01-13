<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Apartment;
use App\Models\ApartmentImage;
use App\Models\Booking;
use App\Models\Review;
use App\Models\Favorite;
use App\Models\Conversation;
use App\Models\Message;
use App\Models\Notification;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class DemoSeeder extends Seeder
{
    public function run(): void
    {
        // =====================
        // DEMO USERS
        // =====================
        
        // Admin User
        $admin = User::create([
            'first_name' => 'Admin',
            'last_name' => 'User',
            'phone' => '0600000001',
            'password' => Hash::make('demo123'),
            'birth_date' => '1990-01-15',
            'profile_image' => 'demo/profiles/admin.jpg',
            'id_image' => 'demo/ids/admin_id.jpg',
            'role' => 'admin',
            'status' => 'approved',
            'is_approved' => true,
        ]);

        // Owner Users
        $owner1 = User::create([
            'first_name' => 'Mohammed',
            'last_name' => 'Alami',
            'phone' => '0600000002',
            'password' => Hash::make('demo123'),
            'birth_date' => '1985-05-20',
            'profile_image' => 'demo/profiles/owner1.jpg',
            'id_image' => 'demo/ids/owner1_id.jpg',
            'role' => 'owner',
            'status' => 'approved',
            'is_approved' => true,
        ]);

        $owner2 = User::create([
            'first_name' => 'Fatima',
            'last_name' => 'Bennani',
            'phone' => '0600000003',
            'password' => Hash::make('demo123'),
            'birth_date' => '1988-08-10',
            'profile_image' => 'demo/profiles/owner2.jpg',
            'id_image' => 'demo/ids/owner2_id.jpg',
            'role' => 'owner',
            'status' => 'approved',
            'is_approved' => true,
        ]);

        // Tenant Users
        $tenant1 = User::create([
            'first_name' => 'Ahmed',
            'last_name' => 'Tazi',
            'phone' => '0600000004',
            'password' => Hash::make('demo123'),
            'birth_date' => '1995-03-25',
            'profile_image' => 'demo/profiles/tenant1.jpg',
            'id_image' => 'demo/ids/tenant1_id.jpg',
            'role' => 'tenant',
            'status' => 'approved',
            'is_approved' => true,
        ]);

        $tenant2 = User::create([
            'first_name' => 'Sara',
            'last_name' => 'Idrissi',
            'phone' => '0600000005',
            'password' => Hash::make('demo123'),
            'birth_date' => '1992-11-30',
            'profile_image' => 'demo/profiles/tenant2.jpg',
            'id_image' => 'demo/ids/tenant2_id.jpg',
            'role' => 'tenant',
            'status' => 'approved',
            'is_approved' => true,
        ]);

        // Pending user for admin demo
        $pendingUser = User::create([
            'first_name' => 'Youssef',
            'last_name' => 'Mansouri',
            'phone' => '0600000006',
            'password' => Hash::make('demo123'),
            'birth_date' => '1998-07-12',
            'profile_image' => 'demo/profiles/pending1.jpg',
            'id_image' => 'demo/ids/pending1_id.jpg',
            'role' => 'tenant',
            'status' => 'pending',
            'is_approved' => false,
        ]);

        // =====================
        // DEMO APARTMENTS
        // =====================

        $apt1 = Apartment::create([
            'owner_id' => $owner1->id,
            'title' => 'Appartement Moderne Centre-Ville',
            'description' => 'Magnifique appartement de 3 chambres au cœur de Casablanca. Entièrement rénové avec des finitions haut de gamme. Proche de toutes commodités.',
            'governorate' => 'Casablanca-Settat',
            'city' => 'Casablanca',
            'price' => 8500.00,
            'rooms' => 3,
            'area' => 120.00,
            'is_available' => true,
            'status' => 'approved',
        ]);

        $apt2 = Apartment::create([
            'owner_id' => $owner1->id,
            'title' => 'Studio Meublé Maarif',
            'description' => 'Studio moderne entièrement meublé dans le quartier Maarif. Idéal pour étudiant ou jeune professionnel. Wifi inclus.',
            'governorate' => 'Casablanca-Settat',
            'city' => 'Casablanca',
            'price' => 4500.00,
            'rooms' => 1,
            'area' => 45.00,
            'is_available' => true,
            'status' => 'approved',
        ]);

        $apt3 = Apartment::create([
            'owner_id' => $owner2->id,
            'title' => 'Villa avec Jardin Rabat',
            'description' => 'Belle villa spacieuse avec jardin privé à Rabat. 4 chambres, 2 salles de bain, garage. Quartier calme et sécurisé.',
            'governorate' => 'Rabat-Salé-Kénitra',
            'city' => 'Rabat',
            'price' => 15000.00,
            'rooms' => 4,
            'area' => 200.00,
            'is_available' => true,
            'status' => 'approved',
        ]);

        $apt4 = Apartment::create([
            'owner_id' => $owner2->id,
            'title' => 'Appartement Vue Mer Tanger',
            'description' => 'Superbe appartement avec vue panoramique sur la mer. 2 chambres, balcon, parking. À 5 minutes de la plage.',
            'governorate' => 'Tanger-Tétouan-Al Hoceïma',
            'city' => 'Tanger',
            'price' => 7000.00,
            'rooms' => 2,
            'area' => 85.00,
            'is_available' => true,
            'status' => 'approved',
        ]);

        $apt5 = Apartment::create([
            'owner_id' => $owner1->id,
            'title' => 'Duplex Luxueux Marrakech',
            'description' => 'Duplex de luxe dans résidence sécurisée. Piscine commune, salle de sport. Proche de la Médina.',
            'governorate' => 'Marrakech-Safi',
            'city' => 'Marrakech',
            'price' => 12000.00,
            'rooms' => 3,
            'area' => 150.00,
            'is_available' => true,
            'status' => 'approved',
        ]);

        // Pending apartment for admin demo
        $aptPending = Apartment::create([
            'owner_id' => $owner2->id,
            'title' => 'Appartement Neuf Fès',
            'description' => 'Appartement neuf jamais habité. 2 chambres, cuisine équipée, parking souterrain.',
            'governorate' => 'Fès-Meknès',
            'city' => 'Fès',
            'price' => 5500.00,
            'rooms' => 2,
            'area' => 75.00,
            'is_available' => true,
            'status' => 'pending',
        ]);

        // =====================
        // APARTMENT IMAGES (placeholder paths)
        // =====================
        $apartments = [$apt1, $apt2, $apt3, $apt4, $apt5, $aptPending];
        foreach ($apartments as $index => $apt) {
            for ($i = 1; $i <= 3; $i++) {
                ApartmentImage::create([
                    'apartment_id' => $apt->id,
                    'path' => "demo/apartments/apt{$apt->id}_img{$i}.jpg",
                ]);
            }
        }

        // =====================
        // DEMO BOOKINGS
        // =====================

        // Approved booking (completed)
        $booking1 = Booking::create([
            'tenant_id' => $tenant1->id,
            'apartment_id' => $apt1->id,
            'start_date' => Carbon::now()->subMonths(2),
            'end_date' => Carbon::now()->subMonth(),
            'location' => 'Casablanca Centre',
            'status' => 'approved',
            'modification_status' => 'none',
            'payment_method' => 'cash',
            'payment_status' => 'paid',
        ]);

        // Current active booking
        $booking2 = Booking::create([
            'tenant_id' => $tenant2->id,
            'apartment_id' => $apt3->id,
            'start_date' => Carbon::now()->subWeeks(2),
            'end_date' => Carbon::now()->addWeeks(2),
            'location' => 'Rabat Agdal',
            'status' => 'approved',
            'modification_status' => 'none',
            'payment_method' => 'bank_transfer',
            'payment_status' => 'paid',
        ]);

        // Pending booking for owner demo
        $booking3 = Booking::create([
            'tenant_id' => $tenant1->id,
            'apartment_id' => $apt4->id,
            'start_date' => Carbon::now()->addWeek(),
            'end_date' => Carbon::now()->addWeeks(3),
            'location' => 'Tanger Malabata',
            'status' => 'pending',
            'modification_status' => 'none',
            'payment_method' => 'cash',
            'payment_status' => 'pending',
        ]);

        // Another pending booking
        $booking4 = Booking::create([
            'tenant_id' => $tenant2->id,
            'apartment_id' => $apt2->id,
            'start_date' => Carbon::now()->addDays(5),
            'end_date' => Carbon::now()->addMonths(6),
            'location' => 'Casablanca Maarif',
            'status' => 'pending',
            'modification_status' => 'none',
            'payment_method' => 'bank_transfer',
            'payment_status' => 'pending',
        ]);

        // =====================
        // DEMO REVIEWS
        // =====================

        Review::create([
            'booking_id' => $booking1->id,
            'tenant_id' => $tenant1->id,
            'apartment_id' => $apt1->id,
            'rating' => 5,
            'comment' => 'Excellent appartement! Très propre et bien situé. Le propriétaire est très réactif. Je recommande vivement.',
        ]);

        Review::create([
            'booking_id' => $booking2->id,
            'tenant_id' => $tenant2->id,
            'apartment_id' => $apt3->id,
            'rating' => 4,
            'comment' => 'Belle villa avec un grand jardin. Quelques petits travaux à prévoir mais dans l\'ensemble très satisfaite.',
        ]);

        // =====================
        // DEMO FAVORITES
        // =====================

        Favorite::create([
            'tenant_id' => $tenant1->id,
            'apartment_id' => $apt3->id,
        ]);

        Favorite::create([
            'tenant_id' => $tenant1->id,
            'apartment_id' => $apt5->id,
        ]);

        Favorite::create([
            'tenant_id' => $tenant2->id,
            'apartment_id' => $apt1->id,
        ]);

        Favorite::create([
            'tenant_id' => $tenant2->id,
            'apartment_id' => $apt4->id,
        ]);

        // =====================
        // DEMO CONVERSATIONS & MESSAGES
        // =====================

        // Conversation between tenant1 and owner1 about apt1
        $conv1 = Conversation::create([
            'user_id' => $tenant1->id,
            'owner_id' => $owner1->id,
            'apartment_id' => $apt1->id,
        ]);

        Message::create([
            'conversation_id' => $conv1->id,
            'sender_id' => $tenant1->id,
            'receiver_id' => $owner1->id,
            'message' => 'Bonjour, je suis intéressé par votre appartement. Est-il toujours disponible?',
            'read_at' => Carbon::now()->subDays(5),
        ]);

        Message::create([
            'conversation_id' => $conv1->id,
            'sender_id' => $owner1->id,
            'receiver_id' => $tenant1->id,
            'message' => 'Bonjour! Oui, l\'appartement est disponible. Souhaitez-vous organiser une visite?',
            'read_at' => Carbon::now()->subDays(5),
        ]);

        Message::create([
            'conversation_id' => $conv1->id,
            'sender_id' => $tenant1->id,
            'receiver_id' => $owner1->id,
            'message' => 'Oui, je suis disponible ce weekend. Samedi matin vous convient?',
            'read_at' => Carbon::now()->subDays(4),
        ]);

        Message::create([
            'conversation_id' => $conv1->id,
            'sender_id' => $owner1->id,
            'receiver_id' => $tenant1->id,
            'message' => 'Parfait! Samedi à 10h. Je vous envoie l\'adresse exacte.',
            'read_at' => null,
        ]);

        // Conversation between tenant2 and owner2 about apt3
        $conv2 = Conversation::create([
            'user_id' => $tenant2->id,
            'owner_id' => $owner2->id,
            'apartment_id' => $apt3->id,
        ]);

        Message::create([
            'conversation_id' => $conv2->id,
            'sender_id' => $tenant2->id,
            'receiver_id' => $owner2->id,
            'message' => 'Bonjour Madame, la villa accepte-t-elle les animaux de compagnie?',
            'read_at' => Carbon::now()->subDays(2),
        ]);

        Message::create([
            'conversation_id' => $conv2->id,
            'sender_id' => $owner2->id,
            'receiver_id' => $tenant2->id,
            'message' => 'Bonjour, oui les petits animaux sont acceptés. Vous avez quel type d\'animal?',
            'read_at' => null,
        ]);

        // =====================
        // DEMO NOTIFICATIONS
        // =====================

        Notification::create([
            'user_id' => $tenant1->id,
            'title' => 'Réservation confirmée',
            'body' => 'Votre réservation pour "Appartement Moderne Centre-Ville" a été approuvée.',
            'is_read' => true,
        ]);

        Notification::create([
            'user_id' => $tenant1->id,
            'title' => 'Nouveau message',
            'body' => 'Mohammed Alami vous a envoyé un message.',
            'is_read' => false,
        ]);

        Notification::create([
            'user_id' => $owner1->id,
            'title' => 'Nouvelle demande de réservation',
            'body' => 'Ahmed Tazi souhaite réserver votre appartement "Studio Meublé Maarif".',
            'is_read' => false,
        ]);

        Notification::create([
            'user_id' => $owner2->id,
            'title' => 'Nouvel avis',
            'body' => 'Sara Idrissi a laissé un avis 4 étoiles sur votre villa.',
            'is_read' => true,
        ]);

        Notification::create([
            'user_id' => $admin->id,
            'title' => 'Nouvel utilisateur en attente',
            'body' => 'Youssef Mansouri attend la validation de son compte.',
            'is_read' => false,
        ]);

        Notification::create([
            'user_id' => $admin->id,
            'title' => 'Nouvel appartement en attente',
            'body' => 'Un nouvel appartement "Appartement Neuf Fès" attend validation.',
            'is_read' => false,
        ]);

        $this->command->info('Demo data seeded successfully!');
        $this->command->info('');
        $this->command->info('=== DEMO CREDENTIALS ===');
        $this->command->info('Admin:  0600000001 / demo123');
        $this->command->info('Owner1: 0600000002 / demo123');
        $this->command->info('Owner2: 0600000003 / demo123');
        $this->command->info('Tenant1: 0600000004 / demo123');
        $this->command->info('Tenant2: 0600000005 / demo123');
        $this->command->info('========================');
    }
}
