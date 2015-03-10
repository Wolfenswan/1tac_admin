class CfgPatches 
{
	class FA_ADMIN_CONSOLE
	{
		units[] = {};
		weapons[] = {};
		worlds[] = {};
		requiredAddons[] = {"a3_data_f","a3data"};
		requiredVersion = 0.2;
		author[] = {"Snippers","Wolfenswan"};
		authorUrl = "wwww.folkarps.com";
	};
};

#include "defines.hpp"
#include "dialogs.hpp"

class CfgFunctions
{	
	//TODO: Proper function tree
	class FA_ADMIN
	{
		class admin_menu {
			file = "FA_admin\functions";
			class init {postInit = 1};
			class teleport {postInit = 1};
			class zeus {postInit = 1};
			class endMission {postInit = 1};
		};
	};
};

class CfgDifficulties {
  default = "Veteran";
  defaultEasy = "Veteran";
  defaultNormal = "Veteran";
  defaultHard = "Veteran";
};