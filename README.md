# Mindful Recipes 🌿✨

A modern, serene Flutter recipe and meal-planning application crafted with mindful aesthetics, soft lavender palettes, warm peach accents, dynamic servings scaling, and offline-first state architecture.

**Author**: Mehjabin ([@mehjabim](https://github.com/mehjabim))  
**Repository**: [https://github.com/mehjabim/recipe-app-flutter](https://github.com/mehjabim/recipe-app-flutter)

---

## 🎨 Visual Identity & Design System
- **Primary / Brand**: Soft Lavender / Periwinkle (`#8B7CE5`)
- **Accent / Badges**: Warm Apricot / Peach (`#FFA06B` / `#FF9671`)
- **Canvas / Background**: Soothing Lilac Tint (`#F5F3FF`)
- **Cards & Surfaces**: Clean rounded containers with 20–24px border radii and tinted elevation shadows.
- **Typography & Icons**: Midnight Slate (`#262444`) with [Iconsax](https://pub.dev/packages/iconsax) modern icon sets.

---

## 🚀 Key Features

### 1. Robust Authentication & Guest Mode
- **Zero-Friction Access**: Instant guest login allowing users to explore all features offline without account creation.
- **Persistent User Sessions**: `SharedPreferences` session cache keeps user state across restarts.
- **Firebase Auth Ready**: Built-in hooks for email/password and Google Sign-In.

### 2. Wholesome Recipe Catalog & Live Search
- **Unique Recipe Collection**: Curated recipes (Buddha bowls, matcha chia jars, turmeric dal, ricotta toasts, falafel, etc.) with verified high-resolution imagery and distinct metadata.
- **Dynamic Category Filtering**: Seamlessly filter across *Mindful Bowls*, *Energizing Breakfast*, *Fresh Greens*, *Warm Comfort*, *Sweet Treats*, and *Quick Snacks*.
- **Instant Search**: Real-time keyword filter across recipe titles and ingredients with single-tap query clearing.

### 3. Dynamic Servings Scaling
- **Interactive Multiplier**: Increase or decrease servings count directly on the recipe details screen.
- **Live Ingredient Calculation**: Automatically scales gram/milliliter amounts proportionally in real time.

### 4. 7-Day Meal Planner
- **Weekly Schedule**: Plan recipes for Monday through Sunday.
- **Instant Local Response (0ms)**: Zero-lag completion toggling and checklist tracking.
- **Safe Meal Removal**: Delete meals with confirmation dialogs and instant **UNDO** snackbar recovery.

### 5. Personal Bookmarks & Favorites
- Bookmark favorite recipes with the heart button.
- User data isolation ensures guest sessions and authenticated users maintain their own bookmarks.

### 6. Interactive Profile & Dietary Controls
- Customizable user display name.
- Dietary preferences selection (Vegetarian, Gluten-Free, High-Protein focus).
- Daily cooking reminders switch and dedicated Notifications Inbox.

---

## 📁 Project Architecture

```
lib/
├── constants/
├── Utils/
│   ├── constants.dart            # Brand palette and styling constants
│   └── theme.dart                # Material 3 ThemeData with custom components
├── models/
│   ├── category_model.dart       # Category schema & Firestore mapping
│   └── recipe_model.dart         # Recipe data class with nutrition & ingredients
├── Provider/
│   ├── auth_provider.dart        # Session state, guest auth & user profile
│   ├── favorite_provider.dart    # Isolated bookmarks with 0ms local response
│   ├── meal_plan_provider.dart   # 7-day schedule with undo & completion tracking
│   └── quantity.dart             # Dynamic servings scaling calculations
├── services/
│   └── mock_data_service.dart    # Curated offline catalog & Firestore sync
├── Views/
│   ├── app_main_screen.dart      # Navigation bar shell (Home, Plan, Favs, Profile)
│   ├── auth_gate.dart            # Reactive login stream router
│   ├── favorite_screen.dart      # 2-column bookmarks grid & empty state
│   ├── login_screen.dart         # Custom lavender/peach sign-in UI
│   ├── meal_plan_screen.dart     # Weekly meal planner with day filter tabs
│   ├── my_app_home_screen.dart   # Home feed, banner, search, & category chips
│   ├── notifications_screen.dart # Daily prep reminders & habit tips
│   ├── profile_screen.dart       # Settings, preferences, and account controls
│   ├── recipe_detail_screen.dart # Hero header, servings scaler, & ingredients
│   └── view_all_items.dart       # Comprehensive catalog grid with category filters
├── Widget/
│   ├── banner.dart               # Exploration gradient banner
│   ├── food_items_display.dart   # Rounded recipe display card with badge pills
│   ├── my_icon_button.dart       # Elevated circular action button
│   └── quantity_increment_decrement.dart # Servings counter pill
└── main.dart                     # App entry point, image cache tuning, multi-provider
```

---

## 🧪 Automated Testing

The project includes unit and widget test suites verifying state providers, UI rendering, servings scaling, and navigation:

```bash
flutter test
```

All 10 tests passing:
- `test/widget_test.dart` (AuthGate & LoginScreen smoke test)
- `test/models_and_providers_test.dart` (Quantity scaler & FavoriteProvider tests)
- `test/home_screen_test.dart` (Home feed, categories & banner test)
- `test/servings_widget_test.dart` (Recipe detail & dynamic ingredient scaling test)
- `test/meal_plan_and_favorites_test.dart` (Meal planner & Favorites screen tests)
- `test/profile_and_notifications_test.dart` (Profile settings & notifications test)

---

## 🛠️ Running the App

1. Ensure Flutter 3.11+ is installed:
   ```bash
   flutter doctor
   ```
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run on connected device or emulator:
   ```bash
   flutter run
   ```
