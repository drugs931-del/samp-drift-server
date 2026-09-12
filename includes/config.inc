// SA-MP Drift Server Configuration
// ================================

#if defined _config_included
    #endinput
#endif
#define _config_included

// ===== DRIFT SETTINGS =====
#define BASE_DRIFT_POINTS       10      // Базовые очки за дрифт
#define COMBO_MULTIPLIER        1.5     // Множитель за комбо
#define ZONE_BONUS              2.0     // Бонус в дрифт-зонах
#define MIN_DRIFT_SPEED         80      // Минимальная скорость для дрифта
#define DRIFT_ANGLE_MIN         25      // Минимальный угол для дрифта
#define DRIFT_CHECK_INTERVAL    100     // Интервал проверки (ms)

// ===== LEVEL SYSTEM =====
#define MAX_LEVEL               50      // Максимальный уровень
#define EXP_PER_LEVEL           1000    // Опыт за уровень
#define START_LEVEL             1       // Начальный уровень
#define LEVEL_UP_REWARD         500     // Вознаграждение за уровень

// ===== RANKING SYSTEM =====
#define TOP_PLAYERS             10      // Количество игроков в топе
#define RANKING_UPDATE_TIME     5000    // Обновление рейтинга (ms)

// ===== REWARD SYSTEM =====
#define MONEY_PER_DRIFT         50      // Деньги за дрифт
#define MONEY_PER_COMBO         100     // Деньги за комбо
#define VEHICLE_REWARD_LEVEL    20      // Уровень для награды машины
#define SKIN_REWARD_LEVEL       30      // Уровень для награды скина

// ===== ZONES SETTINGS =====
#define MAX_ZONES               15      // Максимум зон
#define ZONE_CHECK_INTERVAL     500     // Проверка зоны (ms)
#define ZONE_BONUS_POINTS       500     // Бонус за зону
#define ZONE_POINTS_MULTIPLIER  1.5     // Множитель очков в зоне

// ===== DATABASE SETTINGS =====
#define PLAYER_DATA_PATH        "scriptfiles/players/"
#define AUTO_SAVE_TIME          60000   // Автосохранение (ms)
#define MAX_PLAYER_NAME         24

// ===== UI SETTINGS =====
#define TEXTDRAW_UPDATE_TIME    1000    // Обновление информации (ms)
#define SHOW_COMBO_ON_SCREEN    1       // Показывать комбо на экране
#define SHOW_DRIFT_ZONE_NAME    1       // Показывать имя зоны
#define SHOW_RANKING            1       // Показывать рейтинг

// ===== VEHICLE SETTINGS =====
#define DRIFT_VEHICLES          1       // Использовать только дрифт-машины
#define ALLOWED_VEHICLE_1       421     // Futo
#define ALLOWED_VEHICLE_2       589     // Club
#define ALLOWED_VEHICLE_3       480     // Comet
#define ALLOWED_VEHICLE_4       506     // Super GT
#define ALLOWED_VEHICLE_5       451     // Turismo

// ===== ADMIN SETTINGS =====
#define ADMIN_LEVEL_BASIC       1       // Базовый админ
#define ADMIN_LEVEL_MODERATOR   2       // Модератор
#define ADMIN_LEVEL_ADMIN       3       // Администратор
#define ADMIN_LEVEL_OWNER       4       // Владелец

// ===== COLORS =====
#define COLOR_DRIFT             0xFF6B6BFF      // Красный
#define COLOR_SUCCESS           0x00FF00FF      // Зелёный
#define COLOR_ERROR             0xFF0000FF      // Красный
#define COLOR_WARNING           0xFFFF00FF      // Жёлтый
#define COLOR_INFO              0x00FFFFFF      // Голубой
#define COLOR_RANK              0xFFD700FF      // Золото
#define COLOR_ZONE              0x00CCFFFF      // Голубой

// ===== DEBUG =====
#define DEBUG_MODE              0       // Режим отладки
#define LOG_ACTIONS             1       // Логировать действия