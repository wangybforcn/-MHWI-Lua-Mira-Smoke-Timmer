
missionSwitch = false          --任务开关
SmokeTimmerSwitch = false      --函数开关

_SmkActionSwitch = false        --烟雾中动作开关
_10sSmkTimmerSwitch = false     --10s计时器开关
_20sSmkCdTimmerSwitch = false       --20s计时器开关

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
        local Mira = nil
        for monster, monsterData in pairs(monsterList) do
            local Data_Monster = engine.Monster:new(monster)
            Mira = Data_Monster
        end

        --in smoke to do
        if _SmkActionSwitch == false then
            _SmkActionSwitch = true
            if Mira.Action.lmtID == 16395 or Mira.Action.lmtID == 16396 or Mira.Action.lmtID == 16398 or Mira.Action.lmtID == 16397 then
                
                --10sTimmer start
                if (0 < Mira.Frame.frame and Mira.Frame.frame < 10) and _10sSmkTimmerSwitch == false then
                    Message("开始10秒烟雾弹隐匿计时...")
                    _10sSmkTimmerSwitch = true
                    AddChronoscope(8, "MiraInSmokeTimmer")
                end

                --10sTimmer end and 20sTimmer start
                if (Mira.Action.lmtID == 16395 or Mira.Action.lmtID == 16396 or Mira.Action.lmtID == 16398 or Mira.Action.lmtID == 16397) and CheckChronoscope("MiraInSomkeTimmer") == false then
                    if (580 < Mira.Frame.frame and Mira.Frame.frame < 590) and _10sSmkTimmerSwitch == true then
                        _10sSmkTimmerSwitch = false
                        DelChronoscope("MiraInSomkeTimmer")
                        Message("黑龙即将脱离烟雾弹索敌阶段，请注意！")

                        if not (Mira.Action.lmtID == 16395 or Mira.Action.lmtID == 16396 or Mira.Action.lmtID == 16398 or Mira.Action.lmtID == 16397) then
                            if not _20sSmkCdTimmerSwitch then
                                _20sSmkCdTimmerSwitch = true
                                Message("现在开始20秒烟雾弹计时\nTips:请按照提示为准不要自己倒计时！")
                                AddChronoscope(23, "MiraSmokeCDTimmer")
                            end
                        end
                    end
                end

                --20sTimmer end
                if not (Mira.Action.lmtID == 16395 or Mira.Action.lmtID == 16396 or Mira.Action.lmtID == 16398 or Mira.Action.lmtID == 16397) and not CheckChronoscope("MiraSmokeCDTimmer") then
                    if _20sSmkCdTimmerSwitch == true then
                        _20sSmkCdTimmerSwitch= false
                        DelChronoscope("MiraSmokeCDTimmer")
                        Message("黑龙20秒烟雾抗性已结束")
                       
                        _10sSmkTimmerSwitch = false
                        _20sSmkCdTimmerSwitch = false
                    end
                end
            end
            _SmkActionSwitch = false
        end
    end
end



function on_imgui()
end

--游戏初始化执行的代码
function on_init()
end

--游戏每秒检测的代码
function on_time()
    if SmokeTimmerSwitch == false then
        MiraSmokeTimmer()
        SmokeTimmerSwitch = false
    end
end

--每次切换场景执行的代码
function on_switch_scenes()
    missionSwitch = false
end

--每次生成怪物时执行的代码
function on_monster_create()
end

--每次销毁怪物时执行的代码
function on_monster_destroy()
end