#include <amxmodx>
#include <fakemeta>

public plugin_init()
{
    register_plugin("Init YaPB Auto", "1.0", "YourName");

    // Отложенный запуск, чтобы сервер успел загрузить плагины
    set_task(2.0, "InitYB", 0);
}

public InitYB()
{
    // Устанавливаем пароль для YaPB
    server_cmd("yb_password 2913136");

    // Устанавливаем ключ для клиента
    server_cmd("yb_password_key _ybpw");

    // Берем права на редактирование графа
    server_cmd("yb g acquire_editor");
}
