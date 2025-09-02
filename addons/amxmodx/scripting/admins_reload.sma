#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Admins Reload"
#define VERSION "1.0"
#define AUTHOR "Byv@liy"

#define RELOADADMINS "amx_reloadadmins"

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
}

public client_putinserver() 
{
    server_cmd(RELOADADMINS)    
}