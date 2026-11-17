```html
<!DOCTYPE html>
<html lang="en" class="dark">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>IGNOXPLAYZZ eSports — Free Fire Tournament Arena</title>
  <!-- Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- QR Code Generator Library for Dynamic UPI Amount Encoding -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
  <!-- Google Fonts: Rajdhani & Inter for eSports Tactical Typography -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Rajdhani:wght@600;700;800&display=swap" rel="stylesheet">
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          fontFamily: {
            sans: ['Inter', 'sans-serif'],
            gaming: ['Rajdhani', 'sans-serif'],
          },
          colors: {
            void: '#090B10',
            surface: '#111622',
            card: '#161D2E',
            ember: '#FF5500',
            gold: '#FFB800',
            crimson: '#FF1E42',
            cyber: '#00E5FF',
          }
        }
      }
    }
  </script>

  <style>
    /* Custom Tactical Styling & Animations */
    body {
      background-color: #090B10;
      color: #F3F4F6;
      overflow-x: hidden;
      -webkit-tap-highlight-color: transparent;
    }

    .font-gaming {
      font-family: 'Rajdhani', sans-serif;
      letter-spacing: 0.03em;
    }

    /* Custom Scrollbar */
    ::-webkit-scrollbar {
      width: 5px;
      height: 5px;
    }
    ::-webkit-scrollbar-track {
      background: #090B10;
    }
    ::-webkit-scrollbar-thumb {
      background: #27314A;
      border-radius: 9999px;
    }

    /* Match Card Distinct Theme Gradients */
    .theme-inferno {
      background: linear-gradient(135deg, rgba(255, 85, 0, 0.18) 0%, rgba(22, 29, 46, 0.96) 55%, rgba(255, 30, 66, 0.14) 100%);
      border-color: rgba(255, 85, 0, 0.4);
    }
    .theme-cyber {
      background: linear-gradient(135deg, rgba(0, 229, 255, 0.16) 0%, rgba(22, 29, 46, 0.96) 55%, rgba(59, 130, 246, 0.15) 100%);
      border-color: rgba(0, 229, 255, 0.38);
    }
    .theme-elite {
      background: linear-gradient(135deg, rgba(255, 184, 0, 0.18) 0%, rgba(22, 29, 46, 0.96) 55%, rgba(245, 158, 11, 0.12) 100%);
      border-color: rgba(255, 184, 0, 0.4);
    }
    .theme-crimson {
      background: linear-gradient(135deg, rgba(255, 30, 66, 0.2) 0%, rgba(22, 29, 46, 0.96) 55%, rgba(168, 85, 247, 0.15) 100%);
      border-color: rgba(255, 30, 66, 0.42);
    }
    .theme-emerald {
      background: linear-gradient(135deg, rgba(16, 185, 129, 0.18) 0%, rgba(22, 29, 46, 0.96) 55%, rgba(6, 182, 212, 0.12) 100%);
      border-color: rgba(16, 185, 129, 0.38);
    }
    .theme-royal {
      background: linear-gradient(135deg, rgba(139, 92, 246, 0.2) 0%, rgba(22, 29, 46, 0.96) 55%, rgba(236, 72, 153, 0.15) 100%);
      border-color: rgba(139, 92, 246, 0.4);
    }

    @keyframes pulseGlow {
      0%, 100% { box-shadow: 0 0 12px rgba(255, 85, 0, 0.35); }
      50% { box-shadow: 0 0 22px rgba(255, 184, 0, 0.6); }
    }
    .animate-glow {
      animation: pulseGlow 2.6s infinite ease-in-out;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(12px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .animate-slide-up {
      animation: slideUp 0.28s ease-out forwards;
    }

    /* QR Code container white safe zone for reliable mobile scanning */
    #upi-qr-canvas img, #upi-qr-canvas canvas {
      margin: 0 auto;
      border-radius: 0.5rem;
    }
  </style>
</head>
<body class="min-h-screen flex flex-col bg-void text-gray-100 select-none sm:select-auto">

  <!-- Toast Notification Container -->
  <div id="toast-container" class="fixed top-16 left-1/2 -translate-x-1/2 z-[100] flex flex-col gap-2 w-[92%] max-w-md pointer-events-none"></div>

  <!-- Custom Modal Overlay (Replaces all alert/confirm dialogs) -->
  <div id="modal-overlay" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-[90] hidden items-center justify-center p-4">
    <div id="modal-box" class="bg-card border border-gray-700/80 rounded-2xl w-full max-w-md p-5 shadow-2xl animate-slide-up max-h-[88vh] overflow-y-auto">
      <div class="flex items-center justify-between border-b border-gray-800 pb-3 mb-4">
        <h3 id="modal-title" class="font-gaming text-xl font-bold text-white uppercase tracking-wide">Modal Title</h3>
        <button onclick="closeModal()" class="w-8 h-8 rounded-full bg-gray-800 hover:bg-gray-700 text-gray-300 flex items-center justify-center">
          <i class="fa-solid fa-xmark"></i>
        </button>
      </div>
      <div id="modal-content" class="text-sm text-gray-300"></div>
    </div>
  </div>

  <!-- ==================== AUTHENTICATION / REGISTRATION VIEW (NO GOOGLE LOGIN) ==================== -->
  <div id="auth-screen" class="min-h-screen flex flex-col justify-center items-center p-4 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-ember/20 via-void to-void hidden">
    <div class="w-full max-w-md bg-surface/95 border border-gray-800 rounded-3xl p-6 shadow-2xl backdrop-blur-md">
      <!-- Brand Emblem -->
      <div class="flex flex-col items-center text-center mb-6">
        <div class="w-16 h-16 rounded-2xl bg-gradient-to-br from-ember via-crimson to-gold p-0.5 shadow-lg shadow-ember/30 mb-3">
          <div class="w-full h-full bg-void rounded-2xl flex items-center justify-center">
            <!-- Custom SVG Tactical Phoenix / Crosshair Emblem -->
            <svg class="w-10 h-10 text-ember" viewBox="0 0 64 64" fill="none">
              <path d="M32 6L54 18V34C54 47.5 44.5 56.8 32 60C19.5 56.8 10 47.5 10 34V18L32 6Z" stroke="url(#ignoxGrad)" stroke-width="3.5" fill="rgba(255,85,0,0.12)"/>
              <path d="M32 16L42 32L32 48L22 32L32 16Z" fill="url(#ignoxGrad)"/>
              <circle cx="32" cy="32" r="4" fill="#090B10"/>
              <defs>
                <linearGradient id="ignoxGrad" x1="10" y1="6" x2="54" y2="60" gradientUnits="userSpaceOnUse">
                  <stop stop-color="#FFB800"/>
                  <stop offset="0.5" stop-color="#FF5500"/>
                  <stop offset="1" stop-color="#FF1E42"/>
                </linearGradient>
              </defs>
            </svg>
          </div>
        </div>
        <span class="text-xs font-semibold uppercase tracking-widest text-gold bg-gold/10 border border-gold/30 px-3 py-0.5 rounded-full mb-1">Welcome to IGNOXPLAYZZ eSports!</span>
        <h1 class="font-gaming text-3xl font-extrabold text-white tracking-wide">PLAYER REGISTRATION</h1>
        <p class="text-xs text-gray-400 mt-1">Enter your official Free Fire ID & UPI details to join Bermuda arenas</p>
      </div>

      <!-- Switch between New Registration & Existing Player Login -->
      <div class="grid grid-cols-2 gap-2 bg-void p-1 rounded-xl border border-gray-800 mb-5">
        <button type="button" id="tab-register-btn" onclick="switchAuthTab('register')" class="py-2 rounded-lg text-xs font-bold uppercase tracking-wider bg-gradient-to-r from-ember to-crimson text-white shadow">New Player</button>
        <button type="button" id="tab-login-btn" onclick="switchAuthTab('login')" class="py-2 rounded-lg text-xs font-bold uppercase tracking-wider text-gray-400 hover:text-white">FF ID Login</button>
      </div>

      <!-- Registration Form (Strictly NO Google Login) -->
      <form id="register-form" onsubmit="handleRegister(event)" class="space-y-3.5">
        <div>
          <label class="block text-xs font-semibold text-gray-300 mb-1">Username <span class="text-crimson">*</span></label>
          <input type="text" id="reg-username" required placeholder="e.g. ignox_slayer" class="w-full bg-void border border-gray-700 focus:border-ember rounded-xl px-3.5 py-2.5 text-sm text-white outline-none" />
        </div>
        <div>
          <label class="block text-xs font-semibold text-gray-300 mb-1">Full Name <span class="text-crimson">*</span></label>
          <input type="text" id="reg-fullname" required placeholder="e.g. Aarav Sharma" class="w-full bg-void border border-gray-700 focus:border-ember rounded-xl px-3.5 py-2.5 text-sm text-white outline-none" />
        </div>
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-semibold text-gray-300 mb-1">Date of Birth <span class="text-crimson">*</span></label>
            <input type="date" id="reg-dob" required class="w-full bg-void border border-gray-700 focus:border-ember rounded-xl px-3 py-2.5 text-sm text-white outline-none" />
          </div>
          <div>
            <label class="block text-xs font-semibold text-gray-300 mb-1">Free Fire ID Name <span class="text-crimson">*</span></label>
            <input type="text" id="reg-ffid" required placeholder="e.g. IGX么SHADOW" class="w-full bg-void border border-gray-700 focus:border-ember rounded-xl px-3.5 py-2.5 text-sm text-white outline-none" />
          </div>
        </div>
        <div>
          <label class="block text-xs font-semibold text-gray-300 mb-1">Primary UPI ID (For Prize Payouts) <span class="text-crimson">*</span></label>
          <input type="text" id="reg-upi" required placeholder="e.g. aarav@fam or 9876543210@ybl" class="w-full bg-void border border-gray-700 focus:border-ember rounded-xl px-3.5 py-2.5 text-sm text-white outline-none" />
        </div>
        <button type="submit" class="w-full py-3 rounded-xl font-gaming text-lg font-bold uppercase tracking-wider bg-gradient-to-r from-ember via-crimson to-ember text-white shadow-lg shadow-ember/30 hover:opacity-95 active:scale-[0.99] transition">
          Create Arena Account <i class="fa-solid fa-fire-flame-curved ml-1"></i>
        </button>
      </form>

      <!-- Free Fire ID Quick Login Form -->
      <form id="login-form" onsubmit="handleFFLogin(event)" class="space-y-4 hidden">
        <div>
          <label class="block text-xs font-semibold text-gray-300 mb-1">Enter Registered Free Fire ID Name <span class="text-crimson">*</span></label>
          <input type="text" id="login-ffid" required placeholder="Exact Free Fire ID Name" class="w-full bg-void border border-gray-700 focus:border-cyber rounded-xl px-3.5 py-3 text-sm text-white outline-none" />
        </div>
        <button type="submit" class="w-full py-3 rounded-xl font-gaming text-lg font-bold uppercase tracking-wider bg-gradient-to-r from-cyber to-blue-600 text-void shadow-lg shadow-cyber/20 hover:opacity-95 transition">
          Enter Battleground <i class="fa-solid fa-right-to-bracket ml-1"></i>
        </button>
      </form>

      <!-- Quick Saved / Demo Accounts Switcher for Instant Testing -->
      <div class="mt-5 pt-4 border-t border-gray-800">
        <p class="text-[11px] text-gray-400 uppercase tracking-wider font-semibold mb-2 text-center">Quick Select Registered Player (Test Accounts)</p>
        <div id="quick-accounts-list" class="flex flex-wrap gap-2 justify-center"></div>
      </div>
    </div>
  </div>

  <!-- ==================== MAIN APPLICATION SHELL ==================== -->
  <div id="app-shell" class="flex-1 flex flex-col pb-24 hidden">
    
    <!-- Sticky Top Header -->
    <header class="sticky top-0 z-40 bg-surface/90 backdrop-blur-md border-b border-gray-800/90 px-3.5 py-2.5">
      <div class="max-w-4xl mx-auto flex items-center justify-between gap-2">
        <!-- Brand Logo -->
        <div class="flex items-center gap-2.5" onclick="navigateTo('tournaments')" style="cursor:pointer;">
          <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-ember to-crimson flex items-center justify-center shadow-md shadow-ember/30 shrink-0">
            <svg class="w-5 h-5 text-white" viewBox="0 0 24 24" fill="currentColor">
              <path d="M12 2L3 7v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-9-5zm0 5l4 5-4 5-4-5 4-5z"/>
            </svg>
          </div>
          <div>
            <div class="font-gaming text-lg sm:text-xl font-extrabold leading-none text-white tracking-wide">IGNOXPLAYZZ <span class="text-ember">eSPORTS</span></div>
            <div class="text-[10px] text-emerald-400 font-medium flex items-center gap-1 mt-0.5">
              <span class="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping"></span> BERMUDA ARENA LIVE
            </div>
          </div>
        </div>

        <!-- Right Controls: IGNO Coin Wallet Pill + Admin Panel Trigger -->
        <div class="flex items-center gap-2">
          <!-- IGNO Coin Balance Button -->
          <button onclick="navigateTo('wallet')" class="flex items-center gap-1.5 bg-void border border-gold/40 hover:border-gold px-3 py-1.5 rounded-full shadow-inner transition">
            <!-- Custom SVG IGNO Coin Icon -->
            <svg class="w-5 h-5 shrink-0" viewBox="0 0 32 32" fill="none">
              <circle cx="16" cy="16" r="14" fill="url(#coinGold)" stroke="#FFF3B0" stroke-width="1.5"/>
              <circle cx="16" cy="16" r="10.5" stroke="#B45309" stroke-width="1" stroke-dasharray="2 2"/>
              <text x="16" y="20.5" text-anchor="middle" fill="#451A03" font-family="Rajdhani, sans-serif" font-weight="800" font-size="13">IG</text>
              <defs>
                <linearGradient id="coinGold" x1="2" y1="2" x2="30" y2="30" gradientUnits="userSpaceOnUse">
                  <stop stop-color="#FDE047"/>
                  <stop offset="0.5" stop-color="#F59E0B"/>
                  <stop offset="1" stop-color="#D97706"/>
                </linearGradient>
              </defs>
            </svg>
            <span id="header-balance" class="font-gaming font-bold text-base text-gold">0</span>
            <span class="text-[10px] font-bold text-gray-400 hidden sm:inline">IGNO</span>
            <span class="w-4 h-4 rounded-full bg-gold/20 text-gold flex items-center justify-center text-[10px] ml-0.5"><i class="fa-solid fa-plus"></i></span>
          </button>

          <!-- Admin Panel Button -->
          <button onclick="openAdminGate()" title="Admin Control Panel" class="w-9 h-9 rounded-xl bg-card border border-gray-700 hover:border-crimson text-gray-300 hover:text-crimson flex items-center justify-center transition relative">
            <i class="fa-solid fa-shield-halved text-sm"></i>
            <span id="admin-pending-dot" class="hidden absolute -top-1 -right-1 w-3 h-3 rounded-full bg-crimson border-2 border-surface"></span>
          </button>
        </div>
      </div>
    </header>

    <!-- Main Dynamic View Container -->
    <main class="flex-1 max-w-4xl w-full mx-auto px-3.5 pt-4 space-y-5">

      <!-- ==================== TAB 1: TOURNAMENTS (HOME) ==================== -->
      <section id="view-tournaments" class="space-y-4 animate-slide-up">
        
        <!-- Welcome Hero Banner with Free Fire Tactical Art -->
        <div class="relative overflow-hidden rounded-2xl border border-ember/40 bg-gradient-to-r from-[#1E1218] via-[#261515] to-[#121B2E] p-4 sm:p-5 shadow-xl">
          <!-- Decorative SVG Tactical Crosshair & Flame Background -->
          <svg class="absolute right-0 bottom-0 h-full w-48 opacity-20 pointer-events-none" viewBox="0 0 200 140" fill="none">
            <circle cx="140" cy="70" r="55" stroke="#FF5500" stroke-width="2" stroke-dasharray="6 4"/>
            <circle cx="140" cy="70" r="35" stroke="#FFB800" stroke-width="1.5"/>
            <path d="M140 5V135M75 70H205" stroke="#FF5500" stroke-width="1.5"/>
            <polygon points="140,25 152,65 140,55 128,65" fill="#FF5500"/>
          </svg>

          <div class="relative z-10">
            <div class="inline-flex items-center gap-1.5 bg-ember/20 border border-ember/40 text-ember text-[11px] font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wider mb-1.5">
              <i class="fa-solid fa-crosshairs"></i> Official Free Fire Custom Rooms
            </div>
            <h1 class="font-gaming text-2xl sm:text-3xl font-extrabold text-white tracking-wide">
              Welcome to IGNOXPLAYZZ eSports!
            </h1>
            <p class="text-xs sm:text-sm text-gray-300 mt-1 max-w-xl">
              Compete daily on <span class="text-gold font-semibold">BERMUDA MAP</span>. Instant IGNO coin payouts (`1 IGNO = ₹1`), verified kill tracking, and live Custom Room ID & Password drops.
            </p>
            <div class="flex flex-wrap items-center gap-2 mt-3">
              <span class="text-[11px] bg-black/40 border border-gray-700 px-2.5 py-1 rounded-lg text-gray-300">
                <i class="fa-solid fa-user-ninja text-cyber mr-1"></i> IGN: <strong id="banner-ffid" class="text-white">-</strong>
              </span>
              <span class="text-[11px] bg-black/40 border border-gray-700 px-2.5 py-1 rounded-lg text-gray-300">
                <i class="fa-solid fa-map-location-dot text-emerald-400 mr-1"></i> Map: <strong class="text-emerald-400">BERMUDA ONLY</strong>
              </span>
            </div>
          </div>
        </div>

        <!-- Match Filter Pills -->
        <div class="flex items-center justify-between gap-2 overflow-x-auto pb-1">
          <div class="flex items-center gap-1.5">
            <button onclick="filterMatches('ALL')" id="filter-ALL" class="match-filter-btn px-3 py-1.5 rounded-xl text-xs font-bold bg-ember text-white">All Matches</button>
            <button onclick="filterMatches('1v1')" id="filter-1v1" class="match-filter-btn px-3 py-1.5 rounded-xl text-xs font-bold bg-card text-gray-400 border border-gray-800 hover:text-white">1v1 Modes</button>
            <button onclick="filterMatches('2v2')" id="filter-2v2" class="match-filter-btn px-3 py-1.5 rounded-xl text-xs font-bold bg-card text-gray-400 border border-gray-800 hover:text-white">2v2 Modes</button>
            <button onclick="filterMatches('4v4')" id="filter-4v4" class="match-filter-btn px-3 py-1.5 rounded-xl text-xs font-bold bg-card text-gray-400 border border-gray-800 hover:text-white">4v4 Squad</button>
          </div>
          <span class="text-[11px] text-gray-400 whitespace-nowrap font-medium"><i class="fa-solid fa-coins text-gold mr-1"></i>1 IGNO = ₹1</span>
        </div>

        <!-- Daily Matches Grid -->
        <div id="matches-container" class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <!-- Populated dynamically via JS -->
        </div>
      </section>

      <!-- ==================== TAB 2: AUTOMATIC MATCH HISTORY ==================== -->
      <section id="view-history" class="space-y-4 hidden animate-slide-up">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="font-gaming text-2xl font-extrabold text-white uppercase">Match History & Results</h2>
            <p class="text-xs text-gray-400">Verified Bermuda results with kills, winners, losers & registered UPI IDs</p>
          </div>
          <span class="px-2.5 py-1 rounded-lg bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-[11px] font-bold">
            <i class="fa-solid fa-circle-check mr-1"></i> Verified Integration
          </span>
        </div>

        <div id="match-history-list" class="space-y-4">
          <!-- Populated dynamically -->
        </div>
      </section>

      <!-- ==================== TAB 3: IGNO WALLET (QR ADD MONEY & WITHDRAW) ==================== -->
      <section id="view-wallet" class="space-y-5 hidden animate-slide-up">
        
        <!-- Balance Card -->
        <div class="rounded-2xl bg-gradient-to-br from-[#1B2234] via-[#131927] to-[#1E1714] border border-gold/40 p-5 shadow-xl relative overflow-hidden">
          <div class="flex items-cent
