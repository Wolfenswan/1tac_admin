[] spawn {
    fn_am_action_give_zeus = {
        disableSerialization;
        private ["_control","_value"];
        _control = ((findDisplay 1888) displayCtrl 1500);
        if ((lbCurSel _control) == -1) exitWith{ hint "No unit was selected";};

        _value = _control lbData (lbCurSel _control);
        closeDialog 1888;
        _target = objNull;

        {
            _group = _x;
            {
                if (isPlayer _x) then {
                    if (_value == ("" + (getPlayerUID _x))) then {
                        _target = _x;
                    };
                };
            } forEach (units _group);
       } forEach allGroups;


        if (_target == objNull) exitWith{ hint "Error: finding unit to give Zeus"; };

        //hint format["Giving zeus to %1",name _target];
        [[_target],'fn_ZEUS_server_make',false] call BIS_fnc_MP;
    };

    fn_ZEUS_setup_sync = {
        _curator = _this select 0;
      //  _curator addEventHandler ["CuratorGroupPlaced",{[_this,"fn_ZEUS_srv_group_placed",false] call BIS_fnc_MP}];
        _curator addEventHandler ["CuratorObjectPlaced",{[_this,"fn_ZEUS_srv_obj_placed",false] call BIS_fnc_MP}];
    };

    fn_ZEUS_srv_obj_placed = {
       // disableSerialization;
        private["_curator","_placed"];
        _curator = _this select 0;
        _placed = _this select 1;
        {
            if (_x getVariable ["FA_ADMIN",false]) then {
                _x addCuratorEditableObjects [[_placed],true];
            };
        } forEach (allCurators);
        nil
    };

    fn_ZEUS_make = {
        if !(isNull (getAssignedCuratorLogic player)) exitWith{};

        [[player],'fn_ZEUS_server_make',false] call BIS_fnc_MP;
    };

    fn_ZEUS_ALL = {
        [[player],'fn_ZEUS_server_all',false] call BIS_fnc_MP;
    };

    fn_ZEUS_server_all = {
        if !(isServer) exitWith {};

        private ["_curator"];
        _curator = getAssignedCuratorLogic (_this select 0);

        { if (side _x != sideLogic) then { _curator addCuratorEditableObjects [[_x],true]; }; } forEach allMissionObjects "";
    };

    fn_ZEUS_server_make = {
        if !(isServer) exitWith {};

        private ["_unit","_addons","_objects","_curator","_cfgPatches","_class","_i","_isValidCurator"];
        _unit = _this select 0;
        if (isNull _unit) exitWith {};

        //Prevent duplication.
        if (!isNull (getAssignedCuratorLogic _unit)) exitWith{}; //already is a curator.

        //Server for an empty curator space. (Assumes mission doesn't preallocate zeuses).
        _isValidCurator = false;
        {
            if (isNull (getAssignedCuratorUnit _x)) then {
                if (_x getVariable ["FA_ADMIN",false]) then {
                    _isValidCurator = true;
                };
            } else {
                if (_x getVariable ["FA_ADMIN",false]) then {
                    if (!isPlayer _x) then {
                        _isValidCurator = true;
                    };
                };
            };

            if (_isValidCurator) exitWith {
                _emptyExists = true;
                unassignCurator _x;
                _x assignCurator _unit;

                [[_x],'SNIP_ZEUS_setup_sync',_unit] spawn BIS_fnc_MP;
            };
        } forEach allCurators;

        if (!_isValidCurator) then {

            if (isNil "f_var_sideCenter") then {
                f_var_sideCenter = createCenter sideLogic;
            };

            _curator = (createGroup f_var_sideCenter) createUnit ["ModuleCurator_F",[0,0,0] , [], 0, ""];
            _curator setVariable ["Addons",3];
            //_curator setVariable ["owner",format["%1",_unit]];
            _curator setVariable ["FA_ADMIN",true];

            _addons = [];
            _cfgPatches = configfile >> "cfgpatches";
            for "_i" from 0 to (count _cfgPatches - 1) do {
                _class = _cfgPatches select _i;
                if (isClass _class) then {_addons pushBack (configName _class);};
            };
            _curator addCuratorAddons _addons;

            //Pre add only players to Zeus control.
            {
                if (isPlayer _x) then {
                    _curator addCuratorEditableObjects [[_x],true];
                };
            } forEach playableUnits;

            _curator setCuratorWaypointCost 0;
            {_curator setCuratorCoef [_x,0];} forEach ["place","edit","delete","destroy","group","synchronize"];

            if({!isNil _x} count ["f_param_AISkill_BLUFOR","f_param_AISkill_INDP","f_param_AISkill_OPFOR"] > 0) then {
                        _curator addEventHandler ['CuratorObjectPlaced',{{[_x] call f_fnc_setAISkill;} forEach crew(_this select 1)}];
            };

            // Do last, so that the 'sync' is minimal?
            _unit assignCurator _curator;

            [[_curator],'SNIP_ZEUS_setup_sync',_unit] spawn BIS_fnc_MP;
        };
    };

};