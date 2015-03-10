[] spawn {

    fn_fillListBox = {
         // Fill list with the players
        disableSerialization;
        _control = ((findDisplay 1888) displayCtrl 1500);
        _i = 0;
        _groupNum = 1;
        {
            _group = _x;
            _addGroup = false;
            {
                if (isPlayer _x) then {
                    if (!_addGroup) then {
                        _control lbAdd (format["Grp%1 - %2",_groupNum,name _x]);
                        _addGroup = true;
                    } else {
                        _control lbAdd (format["        %1",name _x]);
                    };
                    _control lbSetData[_i,""+getPlayerUID _x];

                    _factionImg = getText (configfile >> "CfgFactionClasses" >> (faction _x) >> "icon");
                    if (_factionImg != "") then {
                        _control lbSetPicture[_i,_factionImg];
                    };

                    _i = _i + 1;
                };
            } forEach (units _group);
            if (_addGroup) then {
                _groupNum = _groupNum + 1;
            };
       } forEach allGroups;


    };

    fn_fillMissionListBox = {
        disableSerialization;
         _control = ((findDisplay 1895) displayCtrl 1550);
         _i = 0;
        _config = missionconfigfile >> "CfgDebriefing";

        while {_i < count _config} do {
            _title = getText (_config select _i >> "title");
            _description = getText (_config select _i >> "description");
            _control lbAdd (format ["%1 - %2",_title,_description]);
            _control lbSetData[_i,configName (_config select _i)];
            _i = _i + 1;
        };

        _control lbAdd "*** Arma 3 Vanilla Mission Success ***";
        _control lbSetData[_i,"asdasdasdga"];
    };

    adminMenu_keyPressed =
    {
        private ["_key","_shift","_ctrl","_alt"];

        //if (dialog) exitWith {false};

        _key = _this select 1;
        _shift = _this select 2;
        _ctrl = _this select 3;
        _alt = _this select 4;

        if (not (_key == 59 && _shift && !_ctrl && !_alt)) exitWith {false};

        // If player is dead and F3 spectator present, exit it
        if (!alive player && !(isNil "f_fnc_forceExit")) then {
         [] call f_fnc_forceExit;
        };

        closeDialog 0;

        if (isServer or ((getPlayerUID player) in [
            "76561197970308881", // Bodge
            "76561198012648163", // Wolfenswan
            "76561197975964276", // Fer
            "76561198012169975", // Audiox
            "76561197978479707", // Pickers
            "76561198028156171", // Aquarius
            "76561197967080299", // Ferrard
            "76561197967886612", // Netkev
            "76561197991278130", // SuperÜ
            "76561197991685206"  // blip2
        ]) or (serverCommandAvailable "#kick")) then //(serverCommandAvailable "#kick")
        {
            createDialog 'adminMenuDialog';
        } else {
            hintsilent "You need to be logged in as admin.";
        };
        true
    };

    [] spawn
    {
        waitUntil {sleep 0.5; !isNull (findDisplay 46)};
        (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call adminMenu_keyPressed"];
    };

};