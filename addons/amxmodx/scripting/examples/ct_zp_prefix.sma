/* 
* Это пример плагина.
* Префикс для зомби мода
*/
#include <amxmodx>
#include <colored_translit>
#include <zombieplague>

new ZP[4][] =
{
	"Zombie",
	"Nemesis",
	"Survivor",
	"Human"
}

public plugin_init()
{
	register_plugin("CT Addon: ZP Prefix", "1.0", "Sho0ter")
	return PLUGIN_CONTINUE
}

public ct_start_format(id)
{
	new class
	if(zp_get_user_nemesis(id))
	{
		class = 0
	}
	else if(zp_get_user_nemesis(id))
	{
		class = 1
	}
	else if(zp_get_user_survivor(id))
	{
		class = 2
	}
	else
	{
		class = 3
	}
	ct_add_to_msg(CT_MSGPOS_PRENAME, "[^x04%s^x01]", ZP[class])
	return PLUGIN_CONTINUE
}