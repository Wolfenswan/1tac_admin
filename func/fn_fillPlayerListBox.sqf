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
                _control lbSetPictureColor [_i, [1,1,1,0.7]];
				_control lbSetPictureColorSelected [_i,[1,1,1,1]];
            };

            _i = _i + 1;
        };
    } forEach (units _group);
    if (_addGroup) then {
        _groupNum = _groupNum + 1;
    };
} forEach allGroups; 