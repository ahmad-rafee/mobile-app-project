# Demo Version Setup

## Quick Start

Run the following commands from the `backend` directory:

```bash
# Fresh migration with demo data
php artisan migrate:fresh --seed

# Or just seed demo data (if migrations already exist)
php artisan db:seed --class=DemoSeeder
```

## Demo Credentials

All demo accounts use the password: **`demo123`**

| Role | Phone | Name |
|------|-------|------|
| **Admin** | `0600000001` | Admin User |
| **Owner 1** | `0600000002` | Mohammed Alami |
| **Owner 2** | `0600000003` | Fatima Bennani |
| **Tenant 1** | `0600000004` | Ahmed Tazi |
| **Tenant 2** | `0600000005` | Sara Idrissi |
| **Pending User** | `0600000006` | Youssef Mansouri |

## Demo Data Overview

### Users (6 total)
- 1 Admin (approved)
- 2 Owners (approved)
- 2 Tenants (approved)
- 1 Pending user (for admin approval demo)

### Apartments (6 total)
- 5 Approved apartments in different cities (Casablanca, Rabat, Tanger, Marrakech)
- 1 Pending apartment (for admin approval demo)

### Bookings (4 total)
- 1 Completed booking (past dates, paid)
- 1 Active booking (current dates, paid)
- 2 Pending bookings (for owner approval demo)

### Reviews (2 total)
- Reviews linked to completed bookings

### Favorites (4 total)
- Sample favorites for tenant accounts

### Conversations & Messages
- 2 conversations with message history
- Mix of read and unread messages

### Notifications (6 total)
- Sample notifications for all user types

## Demo Images

The seeder uses placeholder image paths in `demo/` folder. For a complete demo, add sample images to:

```
storage/app/public/
├── demo/
│   ├── profiles/
│   │   ├── admin.jpg
│   │   ├── owner1.jpg
│   │   ├── owner2.jpg
│   │   ├── tenant1.jpg
│   │   ├── tenant2.jpg
│   │   └── pending1.jpg
│   ├── ids/
│   │   └── [user]_id.jpg files
│   └── apartments/
│       └── apt[id]_img[1-3].jpg files
```

Or use placeholder images from services like:
- https://picsum.photos/
- https://placehold.co/

## Testing Different Flows

### Admin Flow
1. Login with `0600000001` / `demo123`
2. View dashboard stats
3. Approve/reject pending user (Youssef Mansouri)
4. Approve/reject pending apartment (Appartement Neuf Fès)

### Owner Flow
1. Login with `0600000002` / `demo123`
2. View owned apartments
3. Approve/reject pending bookings
4. View messages from tenants
5. Check dashboard stats

### Tenant Flow
1. Login with `0600000004` / `demo123`
2. Browse apartments
3. View favorites
4. Check booking history
5. Send messages to owners
6. View notifications

## Reset Demo Data

To reset all data and start fresh:

```bash
php artisan migrate:fresh --seed
```
