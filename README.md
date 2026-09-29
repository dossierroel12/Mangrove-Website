#  Mangrove Monitoring System

## Prerequisites (Install these first)

### 1. **Node.js** (for frontend)
- Download from: https://nodejs.org/
- Install the LTS version (recommended)
- Verify installation: Open terminal and run `node --version`

### 2. **PHP** (for backend)
- Download from: https://www.php.net/downloads
- OR use XAMPP (includes PHP + MySQL): https://www.apachefriends.org/
- If using XAMPP, it will also install MySQL
- Verify installation: Open terminal and run `php --version`

### 3. **MySQL** (for database)
- If using XAMPP, it's included
- Otherwise download from: https://dev.mysql.com/downloads/mysql/
- Verify installation: Open terminal and run `mysql --version`

### 4. **Composer** (for PHP dependencies)
- Download from: https://getcomposer.org/
- Verify installation: Open terminal and run `composer --version`

---

## Step-by-Step Setup

### **Step 1: Transfer Files**
1. Copy the entire `LeoWorks` folder to your new PC/laptop
2. Place it in a location like `C:\xampp\htdocs\LeoWorks` (if using XAMPP) or any folder you prefer

### **Step 2: Install Node.js Dependencies**
1. Open terminal/command prompt
2. Navigate to the project folder:
   ```bash
   cd C:\xampp\htdocs\LeoWorks
   ```
3. Install all frontend dependencies:
   ```bash
   npm install
   ```
   (This will install all the libraries including React, Leaflet, leaflet.heat, etc.)

### **Step 3: Install PHP Dependencies**
1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install PHP dependencies:
   ```bash
   composer install
   ```

### **Step 4: Set Up Database**
1. Open MySQL (via phpMyAdmin if using XAMPP, or command line)
2. Create a new database:
   ```sql
   CREATE DATABASE leoworks;
   ```
3. Import the database schema:
   - Find the SQL file in `backend/database/schema.sql`
   - Import it using phpMyAdmin or command line:
     ```bash
     mysql -u root -p leoworks < backend/database/schema.sql
     ```

### **Step 5: Configure Database Connection**
1. Copy `backend/src/config.local.example.php` to `backend/src/config.local.php`
   (this file holds this machine's real credentials and is per-machine — never share it as-is)
2. Open `backend/src/config.local.php` and update the values:
   ```php
   return [
       'db_host' => '127.0.0.1',
       'db_port' => 3306,
       'db_name' => 'leoworks',
       'db_user' => 'root',
       'db_pass' => '', // Your MySQL password
       // Only needed if `mysql`/`mysqldump` aren't on PATH, e.g. 'C:\\xampp\\mysql\\bin'
       'mysql_bin_dir' => '',
   ];
   ```

### **Step 6: Run the Application**
1. Go back to the project root:
   ```bash
   cd C:\xampp\htdocs\LeoWorks
   ```
2. Run the development server:
   ```bash
   npm run dev
   ```
   This will start both:
   - PHP backend on http://127.0.0.1:8787
   - Vite frontend (will open automatically in browser)

---

## Alternative: Run Separately

If the combined command doesn't work, run them separately:

### Terminal 1 (Backend):
```bash
cd C:\xampp\htdocs\LeoWorks\backend
php -S 127.0.0.1:8787 -t public
```

### Terminal 2 (Frontend):
```bash
cd C:\xampp\htdocs\LeoWorks
npm run dev:vite
```

---

## Troubleshooting

**If npm install fails:**
- Clear npm cache: `npm cache clean --force`
- Delete `node_modules` folder and try again

**If PHP doesn't work:**
- Make sure PHP is in your system PATH
- Try using full path to PHP executable

**If database connection fails:**
- Check MySQL is running
- Verify credentials in `backend/src/config.local.php`
- Make sure the database exists

---

## Backup & Restore

LeoWorks includes two scripts that package the **entire live database and all uploaded
photos** into one `.zip` file, and can load that `.zip` back in — on the same machine or
a different one.

### Creating a backup

Double-click `backup.bat` (or run `php backend/bin/backup.php` from the project root).

This creates `backend/backups/leoworks-backup-<date>-<time>.zip`, containing:
- A full database dump (`mysqldump`) — every user account, role, monitoring/planting
  record, species profile, and the institution profile, not just the empty schema.
- The entire `backend/storage/` folder — every uploaded monitoring photo and the
  verification-codes file, at the same relative paths the app expects.
- A `manifest.json` summary (timestamp, row counts) and, if present, a snapshot of
  `backend/src/config.local.php` (kept for reference only — see Restoring below).

**Keep backups somewhere other than this computer** (USB drive, network share, cloud
folder) — a copy that only lives in `backend/backups/` won't survive a hard drive
failure. Run `backup.bat` regularly, or right before doing anything risky.

### Restoring a backup

Drag a backup `.zip` onto `restore.bat` (or run
`php backend/bin/restore.php path\to\backup.zip`, or double-click and type the path
when prompted).

The script shows what it's about to do and requires typing `YES` to continue, because
restoring **replaces** the current database contents and adds/overwrites files in
`backend/storage/`. It does **not** touch `backend/src/config.local.php` on this
machine — if the backup included a config snapshot from another computer, it's saved
to `backend/backups/restored-config.local.php.snapshot-<date>` for reference only, so a
restore never silently switches which database server or credentials this install
points at.

### Full System Transfer (moving to a new computer/server, with your existing data)

**Quick way — run `setup.bat`:** if the backup `.zip` is already sitting inside
`backend/backups/` (it is, if you got this folder as a transfer package), just
double-click `setup.bat` in the project root. It runs `npm install`,
`composer install`, creates `backend/src/config.local.php` from the example if it's
missing, finds the backup automatically, and asks `Y/N` before restoring it. Then run
`start-dev.bat` and you're done — skip the manual steps below.

**Manual way:**

1. **On the old machine:** run `backup.bat`. Note the `.zip` created in
   `backend/backups/`.
2. Copy the whole `LeoWorks` project folder **and** that backup `.zip` to the new
   machine (USB drive, network share, or cloud folder).
3. **On the new machine:** install the same prerequisites as above (Node.js,
   PHP/XAMPP, Composer) and start Apache + MySQL.
4. From the project root, install dependencies:
   ```bash
   npm install
   cd backend
   composer install
   cd ..
   ```
5. Set up `backend/src/config.local.php` for the *new* machine (copy from
   `config.local.example.php`, fill in DB credentials — see Step 5 above).
6. Run `restore.bat`, pointing it at the backup `.zip` you copied over; type `YES` to
   confirm.
7. Start the app as usual (`start-dev.bat`).

**Existing usernames and passwords work immediately — nobody needs to create a new
account.** All monitoring/planting records, species profiles, the institution profile,
and every uploaded photo carry over exactly as they were on the old machine.

---

## Features

- **Dashboard Overview**: Real-time monitoring statistics and notifications
- **Mapping Areas**: Interactive Leaflet map with heatmap visualization for mangrove health
- **Monitoring Records**: Track and manage planting site monitoring data
- **Analytics Dashboard**: Charts and analytics for survival rates and species distribution
- **User Management**: Admin and worker role-based access control

---

## Technologies Used

- **Frontend**: React, TypeScript, Vite, Tailwind CSS
- **Backend**: PHP, MySQL
- **Maps**: Leaflet, React Leaflet, Leaflet.heat (for heatmap visualization)
- **UI Components**: Radix UI, Lucide Icons
- **Charts**: Recharts 
