// -------------------------- [      АВТОР  : OVERGAME     ] --------------------------
// -------------------------- [      ПЛАГИН : BHOP MENU    ] --------------------------
// -------------------------- [ VK.COM/PLUGINS_BY_OVERGAME ] --------------------------

#include < amxmodx >
#include < amxmisc >
#include < engine >
#include < dhudmessage >

#define PLUGIN "BunnyHop Menu"
#define VERSION "1.2"
#define AUTHOR "OverGame"

#pragma tabsize 0

#define    FL_WATERJUMP    (1<<11)    
#define    FL_ONGROUND    (1<<9)  

new gBhop[32], gBigBhop[32], gOpts

public plugin_init()
{
        register_plugin(PLUGIN, VERSION, AUTHOR)
		register_clcmd("say /bhop", "bhop_menu")
		register_clcmd("bhop", "bhop_menu")
		register_clcmd("bmenu", "bhop_menu")
		register_clcmd("bhopmenu", "bhop_menu")
		
		gOpts = register_cvar("setting_air", "1")
		
		if ( get_pcvar_num(gOpts) )
		{
		server_cmd("sv_airaccelerate 9999")
		server_cmd("sv_airmove 1 ")
		}
}

public client_putinserver(id)
{
		gBhop[id] = 0
		gBigBhop[id] = 0
		
}

public client_PreThink(id) 
{
		if(gBhop[id] == 0)
        return PLUGIN_HANDLED
		
		
    entity_set_float(id, EV_FL_fuser2, 0.0)        
 
    if (entity_get_int(id, EV_INT_button) & 2) {    
        new flags = entity_get_int(id, EV_INT_flags)
 
        if (flags & FL_WATERJUMP)
            return PLUGIN_CONTINUE
        if ( entity_get_int(id, EV_INT_waterlevel) >= 2 )
            return PLUGIN_CONTINUE
        if ( !(flags & FL_ONGROUND) )
            return PLUGIN_CONTINUE
			
		        new Float:velocity[3]
				
				entity_get_vector(id, EV_VEC_velocity, velocity);
				
				velocity[2] += 250.0
				
				if ( gBigBhop[id] == 1 )
				{
                velocity[0] *= 1.15;
                velocity[1] *= 1.15;
				}
				
                entity_set_vector(id, EV_VEC_velocity, velocity)
			
                entity_set_int(id, EV_INT_gaitsequence, 6)
    }
	
    return PLUGIN_HANDLED
}

public bhop_menu(id)
{
        static s_MenuItem[255]
        formatex(s_MenuItem, charsmax(s_MenuItem), "\rBhop меню^n\yАвтор : \r%s^n\yВерсия : \r%s", AUTHOR, VERSION)
        new menu = menu_create(s_MenuItem, "bhopm_hand" )
		
		if ( gBhop[id] == 1 )
		{
        menu_additem(menu, "\yBhop \d[Включен]", "1")
		} else {
		menu_additem(menu, "\yBhop \d[Выключен]", "1")
		}
		
		if ( gBigBhop[id] == 1 )
		{
		menu_additem(menu, "\yУскоритель \d[Включен]", "2")
		} else {
		menu_additem(menu, "\yУскоритель \d[Выключен]", "2")
		}
		
		menu_setprop(menu, MPROP_BACKNAME, "Назад")
		menu_setprop(menu, MPROP_NEXTNAME, "Далее")
        menu_setprop(menu, MPROP_EXITNAME, "Выход")
 
        menu_display(id,menu,0)
        return PLUGIN_HANDLED
}

public bhopm_hand(id, menu, item)
{
        if(item == MENU_EXIT)
        {
                menu_destroy(menu)
                return PLUGIN_HANDLED
        }
 
        new data[6], iName[64], access, callback
        menu_item_getinfo(menu, item, access, data, 5, iName, 63, callback)
		
		static gMsg[255]
 
        new key = str_to_num(data)
 
        switch(key)
        {
        case 1:{
                        if ( gBhop[id] == 1 )
						{
							gBhop[id] = 0
							formatex(gMsg, charsmax(gMsg), "Bhop выключен!")
						} else {
							gBhop[id] = 1
							formatex(gMsg, charsmax(gMsg), "Bhop включен!")
						}
                }
        case 2:{
                        if ( gBigBhop[id] == 1 )
						{
							gBigBhop[id] = 0
							formatex(gMsg, charsmax(gMsg), "Ускоритель выключен!")
						} else {
							gBigBhop[id] = 1
							formatex(gMsg, charsmax(gMsg), "Ускоритель ключен!")
						}
                }
        }
		
		set_dhudmessage(243, 180, 48, 0.06, 0.74, 0, 1.0, 1.0, 0.1, 2.0)
		
		show_dhudmessage(id, gMsg)
		
		bhop_menu(id)
		
        return PLUGIN_HANDLED
}