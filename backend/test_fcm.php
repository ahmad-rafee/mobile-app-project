<?php

require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FcmNotification;
use App\Models\FcmToken;
use App\Models\Notification;

$userId = $argv[1] ?? 2;
$title = $argv[2] ?? 'Test Notification';
$body = $argv[3] ?? 'This is a test notification';

try {
    // 1. Store notification in database
    $notification = Notification::create([
        'user_id' => $userId,
        'title' => $title,
        'body' => $body,
        'is_read' => false
    ]);
    echo "Notification stored in DB (ID: {$notification->id})\n";

    // 2. Send FCM push
    $credentialsPath = base_path('firebase-credentials.json');
    $messaging = (new Factory)
        ->withServiceAccount($credentialsPath)
        ->createMessaging();
    
    $tokens = FcmToken::where('user_id', $userId)->get();
    
    if ($tokens->isEmpty()) {
        echo "No FCM tokens found for user $userId - notification stored but push not sent\n";
        exit(0);
    }
    
    foreach ($tokens as $token) {
        echo "Sending to token: " . substr($token->fcm_token, 0, 30) . "...\n";
        
        $fcmNotification = FcmNotification::create($title, $body);
        $message = CloudMessage::withTarget('token', $token->fcm_token)
            ->withNotification($fcmNotification);
        
        $result = $messaging->send($message);
        echo "SUCCESS: Push sent!\n";
    }
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo "Class: " . get_class($e) . "\n";
}
