
missionSwitch = false          --任务开关
SmokeTimmerSwitch = false      --函数开关

_10sSmkTimmerSwitch = false     --10s计时器开关
_20sSmkCdTimmerSwitch = false       --20s计时器开关

Mira = nil      --Mira data

function MiraSmokeTimmer()

    SmokeTimmerSwitch = true

    --in map
    local Data_map = engine.World:new()
    if Data_map.MapId == 417 then

        if missionSwitch == false then
            Message("已检测到黑龙任务\n开启监控烟雾弹cd和烟雾弹生效时间计时功能")
            missionSwitch = true
        end

        --monster
        local monsterList = GetAllMonster()

        for monster, monsterData in pairs(monsterList) do
            local Data_Monster = engine.Monster:new(monster)
            Mira = Data_Monster
        end
        
        --in smoke to do
        if Mira.Action.lmtID == 16395 or Mira.Action.lmtID == 16396 or Mira.Action.lmtID == 16398 or Mira.Action.lmtID == 16397 then
            --10sTimmer start
            if (0 < Mira.Frame.frame and Mira.Frame.frame < 10) and _10sSmkTimmerSwitch == false then
                Message("开始10秒烟雾弹隐匿计时...")
                _10sSmkTimmerSwitch = true
                AddChronoscope(8, "MiraInSmokeTimmer")
            end

            _10sTimmerChecker()
        end

        _20sTimmerChecker()
    end
end


function _10sTimmerChecker()
    if CheckChronoscope("MiraInSmokeTimmer") then
        Message("黑龙即将脱离烟雾弹索敌阶段，请注意！")
        AddChronoscope(23, "MiraSmokeCDTimmer")
        Message("现在开始20秒烟雾弹CD计时\nTips:请按照提示为准不要自己倒计时！")
        _20sSmkCdTimmerSwitch = true
    elseif not CheckChronoscope("MiraInSmokeTimmer") and 
    (not Mira.Action.lmtID == 16395 and 
    not Mira.Action.lmtID == 16396 and 
    not Mira.Action.lmtID == 16398 and
    not Mira.Action.lmtID == 16397) then
        Message("黑龙已提前脱离烟雾索敌状态！\n将直接开始20秒CD计时!")
        AddChronoscope(23, "MiraSmokeCDTimmer")
        _20sSmkCdTimmerSwitch = true
    end
end


function _20sTimmerChecker()
    if CheckChronoscope("MiraSmokeCDTimmer") then
        Message("黑龙20秒烟雾抗性已结束")
        _10sSmkTimmerSwitch = false
        _20sSmkCdTimmerSwitch = false
    end
end




function on_imgui()
end

--游戏初始化执行的代码
function on_init()
end

--游戏每秒检测的代码
function on_time()
    if SmokeTimmerSwitch == false and _10sSmkTimmerSwitch == false and _20sSmkCdTimmerSwitch == false then
        MiraSmokeTimmer()
        SmokeTimmerSwitch = false
    elseif SmokeTimmerSwitch == false and _10sSmkTimmerSwitch == true and _20sSmkCdTimmerSwitch == false then
        _10sTimmerChecker()
    elseif SmokeTimmerSwitch == false and _10sSmkTimmerSwitch == true and _20sSmkCdTimmerSwitch == true then
        _20sTimmerChecker()
    end
end

--每次切换场景执行的代码
function on_switch_scenes()
    missionSwitch = false
end

--每次生成怪物时执行的代码
function on_monster_create()
    _10sSmkTimmerSwitch = false
    _20sSmkCdTimmerSwitch = false
end

--每次销毁怪物时执行的代码
function on_monster_destroy()
    _10sSmkTimmerSwitch = false
    _20sSmkCdTimmerSwitch = false
end