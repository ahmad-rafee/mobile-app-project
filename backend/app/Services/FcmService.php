<?php

namespace App\Services;

use Kreait\Firebase\Factory;  
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FcmService
{
    protected $messaging;

    public function __construct()
    {
        
        $this->messaging = (new Factory)->createMessaging();
    }

    /**
     * إرسال إشعار إلى المستخدم عبر FCM Token.
     *
     * @param string $fcmToken   FCM Token الخاص بالمستخدم
     * @param string $title      عنوان الإشعار
     * @param string $body       محتوى الإشعار
     * @return bool              نتيجة الإرسال، سواء كان ناجحًا أو فشل
     */
    public function sendNotification($fcmToken, $title, $body)
    {
       
        $notification = Notification::create($title, $body);

        $message = CloudMessage::withTarget('token', $fcmToken)
            ->withNotification($notification);

        try {
            
            $this->messaging->send($message);
            return true; 
        } catch (\Exception $e) {
            
            return false;
        }
    }
}
