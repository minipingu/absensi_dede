# Absensi Kopdes — Full Application Flow (Mermaid Diagram)

> **Cara Import ke FigJam / Eraser:**
> 1. **FigJam:** Tambahkan widget **Mermaid** dari tab Plugins/Widgets, lalu *paste* seluruh blok kode Mermaid di bawah ini.
> 2. **Eraser.io:** Buat diagram baru, pilih mode diagram syntax (Mermaid), lalu *paste* kodenya.
> 3. **Export ke PDF:** Anda bisa menggunakan viewer Markdown (seperti VS Code Markdown PDF, Notion, atau [Mermaid Live Editor](https://mermaid.live)) lalu klik *Download/Print to PDF*.

---

```mermaid
flowchart TD

%% ====================================================
%% SUBGRAPH 1: STARTUP, ROUTING & DEVICE SECURITY
%% ====================================================
subgraph S1 ["1. Startup, routing & device security"]
    A1["Launch application"] --> A2["Initialize Flutter bindings<br/><i>Alarm.init() + id_ID date formatting</i>"]
    A2 --> A3["Precheck root / jailbreak + dev mode<br/><i>Cache status; exception -> unsafe</i>"]
    A3 --> A4["runApp(ProviderScope)<br/><i>Theme, router, resume and alarm listeners</i>"]
    A4 --> D1{"Device safe?"}
    D1 -- "No" --> A5["/dev-mode-check<br/><i>Block navigation; back disabled</i>"]
    D1 -- "Yes / root" --> A6["Recheck on button / app resume<br/><i>Update cached security status</i>"]
end

%% ====================================================
%% SUBGRAPH 2: LOGIN & REGISTRATION
%% ====================================================
subgraph S2 ["2. Login & registration"]
    B1["/splash-screen — wait 3 seconds<br/><i>If unmounted: stop; if unsafe: block</i>"]
    B1 --> D2{"Saved isLogin?"}
    
    D2 -- "No" --> B2["/login-register<br/><i>Toggle login / register; validate form<br/>Email; strong password; name for signup</i>"]
    D2 -- "Yes" --> C1
    
    B2 -- "Valid signup" --> B3["RegisterUser<br/><i>POST /api/register<br/>Success -> login; preserve credentials</i>"]
    B2 -- "Valid login" --> B4["LoginUser<br/><i>POST /api/login</i>"]
    
    B3 -- "Success" --> B4
    B3 -- "Error" --> B6["Show API / validation error<br/><i>Keep form available for retry</i>"]
    
    B4 --> D3{"Response data exists?"}
    D3 -- "Yes" --> B5["Save login, token & user<br/><i>Invalidate user / profile / history</i>"]
    D3 -- "No / error" --> B6
    B6 -- "Retry" --> B2
end

%% ====================================================
%% SUBGRAPH 3: HOME, PERMISSIONS & ATTENDANCE SUBMISSION
%% ====================================================
subgraph S3 ["3. Home, permissions & attendance submission"]
    C1["/home<br/><i>Refresh username + GET attendance history</i>"]
    C2["Request runtime permissions<br/><i>Location, notification, exact alarm, battery<br/>Denied -> settings dialog; battery -> explain</i>"]
    C3["Bottom navigation / stateful shell<br/><i>Home - Maps - Alarm - Presensi - Profile</i>"]
    
    C1 --> C4["Find today's attendance<br/><i>Izin -> disable check-in and izin<br/>Checked in -> disable izin only</i>"]
    
    C4 --> C5["Press enabled Check in<br/><i>GPS + permission -> coordinates + address<br/>Location failure -> error toast, abort</i>"]
    C4 --> C6["Press enabled Izin<br/><i>Require nonempty reason; cancel -> return<br/>Location failure -> 0.0, 0.0 / Lokasi Izin</i>"]
    
    C5 --> C7["Require token; POST /api/absen/check-in<br/><i>Check-in: status masuk | Leave: status izin</i>"]
    C6 --> C7
    
    C7 --> C8["Data returned -> refresh history + toast<br/><i>Missing token/data or exception -> error toast</i>"]
end

%% ====================================================
%% SUBGRAPH 4: ATTENDANCE HISTORY & DETAIL
%% ====================================================
subgraph S4 ["4. Attendance history & detail"]
    E1["GET /api/absen/history<br/><i>Bearer token; loading -> spinner<br/>Error -> retry refresh; empty -> guidance</i>"]
    E1 -- "Records" --> E2["/attendance-list<br/><i>Home tile saves selected attendance ID<br/>Use selected record or first; date selector</i>"]
    
    E2 --> D4{"Checkout recorded?"}
    E2 -- "Yes: show location" --> E3["Display attendance detail<br/><i>Status, time, leave reason, addresses<br/>Parse coordinates -> maps / unavailable</i>"]
    
    D4 -- "No" --> E4["Press Check Out<br/><i>Require GPS, permission + token<br/>POST /api/absen/check-out</i>"]
    
    E3 --> E5["Delete button"] --> D5{"Confirm deletion?"}
    D5 -- "Cancel" --> E3
    D5 -- "Yes" --> E6["DELETE /api/absen/{id}<br/><i>Token + selected ID (fallback: saved user ID)<br/>Requires token and ID</i>"]
    
    E4 --> E7["Success -> invalidate history, maybePop(), success toast<br/><i>Checkout requires response data; delete accepts returned response<br/>Failure -> error toast; keep retry available</i>"]
    E6 --> E7
end

%% ====================================================
%% SUBGRAPH 5: MAPS, PROFILE & LOGOUT
%% ====================================================
subgraph S5 ["5. Maps, profile & logout"]
    F1["/maps<br/><i>Initial load / tab refresh / manual refresh<br/>Check GPS + request location permission</i>"]
    F1 --> F2["High-accuracy position + address<br/><i>Update marker / camera; external Maps link<br/>Failure -> location message; allow refresh</i>"]
    F2 --> F3["Profile avatar video<br/><i>Play only: foreground + profile + tab 4<br/>Otherwise pause; error -> fallback icon</i>"]
    
    F4["/profile -> GET /api/profile<br/><i>Sync user cache; missing token/API failure<br/>Use cached user or show error + retry</i>"]
    F4 --> F5["Edit name -> validate<br/><i>Required, >=3 characters, letters / spaces<br/>Valid + token -> PUT /api/profile</i>"]
    F5 --> F6["Data returned -> save cached user<br/><i>Invalidate username + profile; close dialog<br/>Failure -> toast; dialog stays open</i>"]
    
    F4 --> F7["Logout action"] --> F8["Logout<br/><i>Remove login/token/user preferences<br/>Invalidate account providers -> login form</i>"]
end

%% ====================================================
%% SUBGRAPH 6: CHECKOUT REMINDER & RINGING
%% ====================================================
subgraph S6 ["6. Checkout reminder & ringing"]
    G1["/alarm — load saved configuration<br/><i>Enabled but missing schedule -> restore<br/>Listen to scheduled stream; ID 1001</i>"]
    G1 --> G2["Select time + at least one day<br/><i>Presets: workdays / every day<br/>Request notifications, exact alarm, battery</i>"]
    
    G2 -- "Save / activate" --> G3["Find next future selected day<br/><i>Today if future; otherwise search 1-7 days<br/>Alarm.set() -> save config on success</i>"]
    G2 -- "Disable action" --> G4["Disable reminder<br/><i>Alarm.stop(1001); enabled = false</i>"]
    
    G3 -- "Due time" --> G5["Alarm ringing stream / startup value<br/><i>Nonempty -> post-frame /alarm-ringing<br/>Security router still blocks unsafe devices</i>"]
    
    G5 --> G6["Stop button / back attempt<br/><i>Guard duplicate stop; stop() + stopAll<br/>Error -> attempt stopAll again</i>"]
    G6 --> D6{"Enabled + valid time<br/>+ selected days?"}
    
    D6 -- "Yes" --> G7["Schedule next recurring alarm<br/><i>Otherwise clear enabled status</i>"]
    D6 -- "No" --> G7
    G7 --> G8["Toast -> allow pop -> root/local navigator pop<br/><i>If no stack: logged in -> home; else -> login-register<br/>Stopping the reminder does not perform checkout</i>"]
end

%% ====================================================
%% CROSS-SECTION CONNECTIONS
%% ====================================================
A1 -.-> B1
B5 --> C1
C3 -. "Maps tab" .-> F1
C3 -. "Profile tab" .-> F4
C3 -. "Alarm tab" .-> G1
C8 -.-> E1
F8 -.-> B2
```