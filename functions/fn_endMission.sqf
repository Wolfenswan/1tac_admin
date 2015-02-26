[] spawn {
    fn_admin_missionEnding_Smooth = {
        disableSerialization;
        _control = ((findDisplay 1895) displayCtrl 1550);

        sleep 0.1;
        [_control lbData( lbCurSel _control),"BIS_fnc_endMission",true] call BIS_fnc_MP;
        closeDialog 1889;

    };

    fn_admin_missionEnding_Instant = {
        disableSerialization;
        _control = ((findDisplay 1895) displayCtrl 1550);

        [_control lbData( lbCurSel _control),"endMission",true] call BIS_fnc_MP;
        closeDialog 1889;
    };
};