/* 
* Это пример плагина.
* Переключение языка командой /lang
*/
#include <amxmodx>
#include <colored_translit>

public plugin_init()
{
	register_plugin("CT Addon: Say Lang", "1.0", "Sho0ter")
	register_clcmd("say /lang", "cmd_lang")
	ct_register_clcmd("/lang")
	return PLUGIN_CONTINUE
}

public cmd_lang(id)
{
	(ct_get_lang(id) == CT_LANG_ENG) ? ct_cmd_lang(id, CT_LANG_RUS) : ct_cmd_lang(id, CT_LANG_ENG)
	return PLUGIN_CONTINUE
}