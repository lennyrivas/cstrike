/* 
* Это пример плагина.
* Отнятие оружия за маты
*/
#include <amxmodx>
#include <fun>
#include <colored_translit>

public plugin_init()
{
	register_plugin("CT Addon: Swear Strip", "1.0", "Sho0ter")
	return PLUGIN_CONTINUE
}

public ct_message_swear(id, message[])
{
	if(is_user_alive(id))
	{
		strip_user_weapons(id)
		ct_send_infomsg(id, "У вас отнято все оружие за нецензурные выражения")
	}
	return PLUGIN_CONTINUE
}