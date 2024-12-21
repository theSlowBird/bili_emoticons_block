; AutoHotKey-Potplayer 自用长按倍速播放/自定倍速切换
; 注意Potplayer默认的c是+0.1x，可以把下文中的每次c替换成5个起到相同作用

; 以下c表示+0.5x，x表示-0.5x，z表示在1倍速和当前速度之间切换

#HotIf WinActive("ahk_class PotPlayer64 ahk_exe PotPlayerMini64.exe")

; 初始化全局变量，记录当前倍速，默认为1倍速
global CurrentSpeed := 1.0

AdjustSpeed(TargetSpeed) {
    global CurrentSpeed
    SpeedDiff := TargetSpeed - CurrentSpeed ; 计算目标倍速与当前倍速的差值
    Steps := Round(SpeedDiff * 2) ; 每步代表0.5倍速，四舍五入得到按键次数

    if (Steps > 0) {
        Loop Steps {
            Send("c") ; 增加倍速
        }
    } else if (Steps < 0) {
        Loop Abs(Steps) {
            Send("x") ; 减少倍速
        }
    }
    CurrentSpeed := TargetSpeed ; 更新当前倍速
    ShowToolTip(">>> " . TargetSpeed . "x", 1000) ; 显示提示信息
}

Right:: ; 长按右键3倍速播放，松开恢复到之前倍速
{
    if !(KeyWait("Right", "T0.3")) { ; 按下按键持续0.3s
        OriginalSpeed := CurrentSpeed ; 记录当前倍速
        AdjustSpeed(2.0) ; 调整到2倍速
        KeyWait("Right") ; 松开按键
        AdjustSpeed(OriginalSpeed) ; 恢复到之前的倍速
    } else {
        Send("{Right}") ; 如果按键按下未持续0.3s，则触发Potplayer原始快捷键
    }
    return
}

v:: ; 1.5倍速
{
    AdjustSpeed(1.5)
    return
}

1:: ; 1倍速
{
    AdjustSpeed(1.0)
    return
}

2:: ; 2倍速
{
    AdjustSpeed(2.0)
    return
}

3:: ; 3倍速
{
    AdjustSpeed(3.0)
    return
}

4:: ; 4倍速
{
    AdjustSpeed(4.0)
    return
}

5:: ; 5倍速
{
    AdjustSpeed(5.0)
    return
}

6:: ; 6倍速
{
    AdjustSpeed(6.0)
    return
}

7:: ; 7倍速
{
    AdjustSpeed(7.0)
    return
}

8:: ; 8倍速
{
    AdjustSpeed(8.0)
    return
}

9:: ; 9倍速
{
    AdjustSpeed(9.0)
    return
}

0:: ; 10倍速
{
    AdjustSpeed(10.0)
    return
}

ShowToolTip(text, duration) {
    ToolTip(text)
    SetTimer(RemoveToolTip, -duration) ; 设置定时器在指定毫秒后触发
}

RemoveToolTip() {
    ToolTip() ; 关闭提示
}
