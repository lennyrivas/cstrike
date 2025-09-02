/*
* ===== ИНФОРМАЦИЯ =====
*
* Название: END ROUND MUSIC MP3
* Версия: 1.4
* Автор: Sho0ter ( Специально для http://cs.4m.net.ua )
* Последнее обновление: 10.04.2010
*
* ========================
*
* ======= ОПИСАНИЕ =======
*
* Сравнительно простой, но в то же время функциональный плагин для проигрывания MP3 музыки в конце раунда
*
* ========================
*
* == ОСНОВНЫЕ ФУНКЦИИ ==
*
* 1. Отдельные плейлисты для Т и CT
* 2. Автовыставление mp3volume
* 3. Возможность включить/отключить плагин на стороне клиента
* 4. Ведение собственного лога
* 5. Переменные для управления плагином
*
* ========================
*
* ===== ПЕРЕМЕННЫЕ ======
* 	
* amx_erm_autovol <0...1> [По умолчанию: 0.5]
* 	- Уровень громкости, который выставляется на клиенте при подключении к серверу.
*
* amx_erm_radio <0/1> [По умолчанию: 1]
*	- Проигрывать ли звуки ctwin или twin
*	- 1 да
*	- 0 нет
*
* amx_erm_showinfo_delay <секунды> [По умолчанию: 20.0]
*	- Время после подключения к серверу, после которого показывается информация о чат-коммандах плагина
*
* amx_erm_log <0/1> [По умолчанияю: 1]
*	- Писать ли лог
*	- 1 да
*	- 0 нет
*
* ========================
*
* ===== ЧАТ-КОМАНДЫ =====
*
* say /ermoff - выключить музыку в конце раунда (только для себя)
* say /ermon - включить музыку в конце раунда (только для себя)
*
* =========================
*
* ========= CОВЕТЫ =========
* 1. Конвентируйте музызку: 
*	- Формат: MP3
*	- Битрейт: 32-320 Kbps
*	- Частота 22-44 KHz
*
* 2. Используйте конвентор http://formatoz.com/RU_download.html 
*	- Поскольку КС дружит далеко не со всеми конвенторами
*
* 3. Музыку кидайте в папку sound и прописывайте в плей-лист все что после cstrike/sound/
* =========================
*/

#include <amxmodx>
#include <amxmisc>

#define PLUGIN "End Round Music MP3"
#define VERSION "1.4"
#define AUTHOR "Sho0ter"

new g_SizeLineTFile, g_SizeLineCTFile, SayText
new g_configfileT[128], g_configfileCT[128]
new g_checkErminf[32][5]
new logdate[64], logfile[64]

public plugin_init() 
{ 
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_dictionary("endroundmusicmp3.txt")
	register_event("SendAudio", "t_win", "a", "2&%!MRAD_terwin")
	register_event("SendAudio", "ct_win", "a", "2&%!MRAD_ctwin")
	register_cvar("amx_erm_autovol", "0.5")
	register_cvar("amx_erm_radio", "1")
	register_cvar("amx_erm_showinfo_delay", "20.0")
	register_cvar("amx_erm_log", "1")
  	register_clcmd("say /ermon", "cmd_ermon", 0, " - turn on end round music")  
  	register_clcmd("say /ermoff", "cmd_ermoff", 0, " - turn off end round music")  
	SayText = get_user_msgid("SayText");
	return PLUGIN_CONTINUE
}

public plugin_precache() 
{
	new config[64]
	get_configsdir(config, 63)
	get_time("20%y.%m.%d", logdate, 63)
	formatex(logfile, 63, "endroundmusicmp3_%s.log", logdate)
	format(g_configfileT, 127, "%s/endroundmusicmp3_t.ini", config)
	format(g_configfileCT, 127, "%s/endroundmusicmp3_ct.ini", config)
	if(file_exists(g_configfileT)  &&  file_exists(g_configfileCT))
	{
		g_SizeLineTFile = file_size(g_configfileT, 1)
		g_SizeLineCTFile = file_size(g_configfileCT, 1)
	}
	else
	{
		server_print("[ERM MP3 ERROR] Could not find config file!")
		if(get_cvar_num("amx_erm_log") == 1)
		{
  			log_to_file(logfile, "[ERM MP3 ERROR] [Could not find config file!]")
  			log_to_file(logfile, "[ERM MP3 ERROR] [You should put endroundmusicmp3_t.ini in addons/amxmodx/configs/]")
  			log_to_file(logfile, "[ERM MP3 ERROR] [You should put endroundmusicmp3_ct.ini in addons/amxmodx/configs/]")
		}
		return PLUGIN_CONTINUE
	}	
	new BufferFileName[160], len, index	
	index=0
	while (read_file(g_configfileT, index, BufferFileName, sizeof(BufferFileName)-1, len) )
	{	
		index++	
		precache_sound(BufferFileName)
 	}
	index=0
	while (read_file(g_configfileCT, index, BufferFileName, sizeof(BufferFileName)-1, len) )
	{
		index++
		precache_sound(BufferFileName)
	}	
	return PLUGIN_CONTINUE
}

public client_disconnect(id) 
{
	remove_task(id)
	return PLUGIN_CONTINUE
}

public client_putinserver(id) 
{
	set_task(get_cvar_float("amx_erm_showinfo_delay"), "showerminfo", id)
	return PLUGIN_HANDLED
}

public t_win()
{
	new players[32], inum, id
	new buffer[160],len
	new random_line = random(g_SizeLineTFile)
	read_file(g_configfileT, random_line, buffer, sizeof(buffer)-1, len) 
	get_players(players, inum, "c")
	for(new a=0;a<inum;++a)
	{
		id=players[a]
		if (equali(g_checkErminf[id],"ON"))
		{
 			client_cmd(id,"stopsound")
			client_cmd(id,"mp3 play sound/%s", buffer)
			if(get_cvar_num("amx_erm_radio") == 1)
			{
				client_cmd(id, "spk radio/terwin")
			}
		}
	}
	if(get_cvar_num("amx_erm_log") == 1)
	{
		new map[32]
		get_mapname(map, 31)
		get_time("20%y.%m.%d", logdate, 63)
		formatex(logfile, 63, "endroundmusicmp3_%s.log", logdate)
  		log_to_file(logfile, "[T PLAY] [%s] [%s] [%d] [%s]", buffer, g_configfileT, g_SizeLineTFile, map)
	}
	return PLUGIN_HANDLED
}

public ct_win()
{
	new players[32], inum, id
	new buffer[160],len
	new random_line = random(g_SizeLineCTFile)
	read_file(g_configfileCT, random_line, buffer, sizeof(buffer)-1, len) 
	get_players(players, inum, "c")
	for(new a=0;a<inum;++a)
	{
		id=players[a]
		if (equali(g_checkErminf[id],"ON"))
		{
 			client_cmd(id,"stopsound")
			client_cmd(id, "mp3 play sound/%s",buffer)
			if(get_cvar_num("amx_erm_radio") == 1)
			{
				client_cmd(id, "spk radio/ctrwin")
			}
		}
	}
	if(get_cvar_num("amx_erm_log") == 1)
	{
		new map[32]
		get_mapname(map, 31)
		get_time("20%y.%m.%d", logdate, 63)
		formatex(logfile, 63, "endroundmusicmp3_%s.log", logdate)
  		log_to_file(logfile, "[CT PLAY] [%s] [%s] [%d] [%s]", buffer, g_configfileT, g_SizeLineCTFile, map)
	}
	return PLUGIN_HANDLED
}

public cmd_ermon(id)
{
	client_cmd(id, "setinfo erm ON")
	g_checkErminf[id]= "ON"	
	client_cmd(id, "mp3volume %f", get_cvar_float("amx_erm_autovol"))
	client_cmd(id, "spk vox/activated")
	green_print(id, "ERMMP3ON_MSG1")
	green_print(id, "ERMMP3ON_MSG2")
	if(get_cvar_num("amx_erm_log") == 1)
	{
		new map[32]
		get_mapname(map, 31)
		new name[32]
		get_user_name(id, name, 31)
		get_time("20%y.%m.%d", logdate, 63)
		formatex(logfile, 63, "endroundmusicmp3_%s.log", logdate)
  		log_to_file(logfile, "[ERM MP3 ON] [%s] [%s]", name, map)
	}
	return PLUGIN_CONTINUE
}


public cmd_ermoff(id)
{
	client_cmd(id, "setinfo erm OFF")
	g_checkErminf[id]= "OFF"
	client_cmd(id, "mp3 stop")
	client_cmd(id, "spk vox/deactivated")
	green_print(id, "ERMMP3OFF_MSG1")
	green_print(id, "ERMMP3OFF_MSG2")
	if(get_cvar_num("amx_erm_log") == 1)
	{
		new map[32]
		get_mapname(map, 31)
		new name[32]
		get_user_name(id, name, 31)
		get_time("20%y.%m.%d", logdate, 63)
		formatex(logfile, 63, "endroundmusicmp3_%s.log", logdate)
  		log_to_file(logfile, "[ERM MP3 OFF] [%s] [%s]", name, map)
	}
	return PLUGIN_CONTINUE
}

public showerminfo(id)
{
	client_cmd(id, "setinfo erm ON")
	g_checkErminf[id]= "ON"	
	client_cmd(id, "mp3volume %f", get_cvar_float("amx_erm_autovol"))
	green_print(id, "ERMMP3INFO_MSG1")
	green_print(id, "ERMMP3INFO_MSG2")
}

stock green_print(index, const message[])
{
	new finalmsg[192];
	formatex(finalmsg, 191, "^x04[ERM MP3] ^x01%L", LANG_PLAYER, message);
	message_begin(MSG_ONE, SayText, _, index);
	write_byte(index);
	write_string(finalmsg);
	message_end();
}