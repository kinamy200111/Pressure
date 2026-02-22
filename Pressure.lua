Print ("ChangelogsVer3.4")
Print ("Small changes for watermark")
Print ("Small changes for UI")
Print ("Fix error with no worked paper password")

do

local Mouse = game.Players.LocalPlayer:GetMouse()

Settings={
    notificationsEnabled={Angler=false,Froger=false,Pinkie=false,Blitz=false,
        Pandemonium=false,Chainsmoker=false,["A60"]=false,Harbinger=false,Painter=false},
    keycardESPEnabled=false,doorESPEnabled=false,
    itemsESPEnabled=false,currencyESPEnabled=false,
    autoRescanEnabled=false,espMaxDistance=150
}

NotificationSystem = {
    activeNotifications = {},
    nextYPosition = 0,
    notificationHeight = 60,
    spacing = 10,
    maxNotifications = 5
}

TrackedMobs = {"Angler", "Blitz", "Pinkie", "Pandemonium", "Froger", "Chainsmoker",
    "RidgeAngler","RidgeBlitz","RidgePinkie","RidgePandemonium","RidgeFroger","RidgeChainsmoker","A60","Harbinger"}

detectedMobs = {}

function NotificationSystem:CreateNotification(mobName,duration)
    if #self.activeNotifications>=self.maxNotifications then
        local oldest=table.remove(self.activeNotifications,1)
        if oldest then pcall(function()
            oldest.bg1:Remove() oldest.bg2:Remove() oldest.bg3:Remove()
            oldest.logo:Remove() oldest.ttl:Remove()
            oldest.c1:Remove() oldest.c2:Remove() oldest.c3:Remove()
            oldest.div:Remove() oldest.etxt:Remove() oldest.tbar:Remove()
        end) self.nextYPosition=self.nextYPosition-110 end
    end
    local cam=workspace.CurrentCamera
    local vp=(cam and cam.ViewportSize) or Vector2.new(1920,1080)
    local bp=Vector2.new(vp.X-360,vp.Y-130-self.nextYPosition)
    local bg2=Drawing.new("Square") bg2.Visible=true bg2.Transparency=1 bg2.ZIndex=10
    bg2.Color=Color3.fromHex("#20133f") bg2.Position=bp+Vector2.new(-3.5,0) bg2.Size=Vector2.new(348,100) bg2.Filled=true
    local bg1=Drawing.new("Square") bg1.Visible=true bg1.Transparency=1 bg1.ZIndex=20
    bg1.Color=Color3.fromHex("#0e0f2f") bg1.Position=bp bg1.Size=Vector2.new(341,98) bg1.Filled=true
    local bg3=Drawing.new("Square") bg3.Visible=true bg3.Transparency=1 bg3.ZIndex=30
    bg3.Color=Color3.fromHex("#0a0b1e") bg3.Position=bp bg3.Size=Vector2.new(341,30) bg3.Filled=true
    local logo=Drawing.new("Text") logo.Visible=true logo.Transparency=1 logo.ZIndex=40
    logo.Color=Color3.fromHex("#4948b9") logo.Position=bp+Vector2.new(13,7)
    logo.Text=">" logo.Size=16 logo.Center=false logo.Outline=false logo.Font=Drawing.Fonts.Monospace
    local ttl=Drawing.new("Text") ttl.Visible=true ttl.Transparency=1 ttl.ZIndex=50
    ttl.Color=Color3.fromHex("#6366f1") ttl.Position=bp+Vector2.new(29,11)
    ttl.Text="NOTIFICATION" ttl.Size=10 ttl.Center=false ttl.Outline=false ttl.Font=Drawing.Fonts.SystemBold
    local c1=Drawing.new("Circle") c1.Visible=true c1.Transparency=1 c1.ZIndex=60
    c1.Color=Color3.fromHex("#7c3aec") c1.Position=bp+Vector2.new(300,17) c1.Radius=3 c1.NumSides=32 c1.Thickness=1 c1.Filled=true
    local c2=Drawing.new("Circle") c2.Visible=true c2.Transparency=1 c2.ZIndex=70
    c2.Color=Color3.fromHex("#4b1c94") c2.Position=bp+Vector2.new(309,17) c2.Radius=3 c2.NumSides=32 c2.Thickness=1 c2.Filled=true
    local c3=Drawing.new("Circle") c3.Visible=true c3.Transparency=1 c3.ZIndex=80
    c3.Color=Color3.fromHex("#1f3b8a") c3.Position=bp+Vector2.new(318,17) c3.Radius=3 c3.NumSides=32 c3.Thickness=1 c3.Filled=true
    local div=Drawing.new("Square") div.Visible=true div.Transparency=1 div.ZIndex=100
    div.Color=Color3.fromHex("#1f3b8a") div.Position=bp+Vector2.new(0,30) div.Size=Vector2.new(340,1) div.Filled=true
    local etxt=Drawing.new("Text") etxt.Visible=true etxt.Transparency=1 etxt.ZIndex=110
    etxt.Color=Color3.fromHex("#e4e6eb") etxt.Position=bp+Vector2.new(23,50)
    etxt.Text=mobName.." is here!" etxt.Size=14 etxt.Center=false etxt.Outline=true etxt.Font=Drawing.Fonts.System
    local tbar=Drawing.new("Square") tbar.Visible=true tbar.Transparency=1 tbar.ZIndex=110
    tbar.Color=Color3.fromHex("#7c3aed") tbar.Position=bp+Vector2.new(-1,0) tbar.Size=Vector2.new(341,1) tbar.Filled=true
    local notif={bg1=bg1,bg2=bg2,bg3=bg3,logo=logo,ttl=ttl,c1=c1,c2=c2,c3=c3,div=div,etxt=etxt,tbar=tbar,startTime=os.clock(),duration=duration or 5,fullWidth=341}
    table.insert(self.activeNotifications,notif)
    self.nextYPosition=self.nextYPosition+110
end
function NotificationSystem:Update()
    local now=os.clock() local toRemove={}
    for i,n in ipairs(self.activeNotifications) do
        local el=now-n.startTime
        n.tbar.Size=Vector2.new(n.fullWidth*(1-math.min(el/n.duration,1)),1)
        if el>=n.duration then
            local fp=math.min((el-n.duration)/0.3,1)
            local a=1-math.pow(fp,2)
            n.bg1.Transparency=a n.bg2.Transparency=a n.bg3.Transparency=a
            n.logo.Transparency=a n.ttl.Transparency=a n.c1.Transparency=a
            n.c2.Transparency=a n.c3.Transparency=a n.div.Transparency=a
            n.etxt.Transparency=a n.tbar.Transparency=a
            if fp>=1 then table.insert(toRemove,i) end
        end
    end
    for i=#toRemove,1,-1 do
        local n=table.remove(self.activeNotifications,toRemove[i])
        if n then pcall(function()
            n.bg1:Remove() n.bg2:Remove() n.bg3:Remove() n.logo:Remove() n.ttl:Remove()
            n.c1:Remove() n.c2:Remove() n.c3:Remove() n.div:Remove() n.etxt:Remove() n.tbar:Remove()
        end) end
    end
    if #toRemove>0 then
        self.nextYPosition=0
        for _,n in ipairs(self.activeNotifications) do
            local cam=workspace.CurrentCamera
            local vp=(cam and cam.ViewportSize) or Vector2.new(1920,1080)
            local ty=vp.Y-130-self.nextYPosition
            local np=Vector2.new(vp.X-360,n.bg1.Position.Y+(ty-n.bg1.Position.Y)*0.15)
            n.bg1.Position=np n.bg2.Position=np+Vector2.new(-3.5,0) n.bg3.Position=np
            n.logo.Position=np+Vector2.new(13,7) n.ttl.Position=np+Vector2.new(29,11)
            n.c1.Position=np+Vector2.new(300,17) n.c2.Position=np+Vector2.new(309,17)
            n.c3.Position=np+Vector2.new(318,17) n.div.Position=np+Vector2.new(0,30)
            n.etxt.Position=np+Vector2.new(23,50) n.tbar.Position=np+Vector2.new(-1,0)
            self.nextYPosition=self.nextYPosition+110
        end
    end
end
function NotificationSystem:CheckForMobs()
    local currentFrameMobs = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        local mobName = obj.Name
        for _, targetMob in ipairs(TrackedMobs) do
            if mobName == targetMob then
                currentFrameMobs[mobName] = true
                if not detectedMobs[mobName] then
                    detectedMobs[mobName] = true
                    local simpleName = mobName:gsub("Ridge", "")
                    if Settings.notificationsEnabled[simpleName] then
                        self:CreateNotification(mobName, 5)
                    end
                    if WatermarkSystem then
                        WatermarkSystem.currentEntity = mobName
                    end
                end
                break
            end
        end
    end
        local painterKey="__Painter__"
    local gf=workspace:FindFirstChild("GameplayFolder")
    if gf then local rooms=gf:FindFirstChild("Rooms") if rooms then
        for _,room in ipairs(rooms:GetChildren()) do
            if room:FindFirstChild("Painter") then
                currentFrameMobs[painterKey]=true
                if not detectedMobs[painterKey] then detectedMobs[painterKey]=true
                    if Settings.notificationsEnabled.Painter then self:CreateNotification("Painter",5) end
                    if WatermarkSystem then WatermarkSystem.currentEntity="Painter" end
                end break end
        end end end
    for mobName, _ in pairs(detectedMobs) do
        if not currentFrameMobs[mobName] then
            detectedMobs[mobName] = nil
        end
    end
end

WatermarkSystem={enabled=false,currentEntity="None",elements={}}
local _wm=Vector2.new(90,28)
local _WM1=Drawing.new("Square") _WM1.Visible=false _WM1.Transparency=1 _WM1.ZIndex=10 _WM1.Color=Color3.fromHex("#0c0d1e") _WM1.Position=_wm _WM1.Size=Vector2.new(582,55) _WM1.Filled=true _WM1.Corner=12
local _WM1B=Drawing.new("Square") _WM1B.Visible=false _WM1B.Transparency=1 _WM1B.ZIndex=11 _WM1B.Color=Color3.fromHex("#18193c") _WM1B.Filled=false _WM1B.Thickness=1 _WM1B.Position=_wm _WM1B.Size=Vector2.new(582,55) _WM1B.Corner=12
local _W1=Drawing.new("Circle") _W1.Visible=false _W1.Transparency=1 _W1.ZIndex=20 _W1.Color=Color3.fromHex("#5c61e3") _W1.Position=_wm+Vector2.new(39,29) _W1.Radius=3 _W1.NumSides=32 _W1.Thickness=1 _W1.Filled=true
local _W2=Drawing.new("Circle") _W2.Visible=false _W2.Transparency=1 _W2.ZIndex=30 _W2.Color=Color3.fromHex("#8b5df6") _W2.Position=_wm+Vector2.new(48,29) _W2.Radius=3 _W2.NumSides=32 _W2.Thickness=1 _W2.Filled=true
local _W3=Drawing.new("Circle") _W3.Visible=false _W3.Transparency=1 _W3.ZIndex=40 _W3.Color=Color3.fromHex("#a68afa") _W3.Position=_wm+Vector2.new(59,29) _W3.Radius=3 _W3.NumSides=32 _W3.Thickness=1 _W3.Filled=true
local _WRT=Drawing.new("Text") _WRT.Visible=false _WRT.Transparency=1 _WRT.ZIndex=70 _WRT.Color=Color3.fromHex("#435bee") _WRT.Position=_wm+Vector2.new(69,20) _WRT.Text="RatHub" _WRT.Size=14 _WRT.Center=false _WRT.Outline=false _WRT.Font=Drawing.Fonts.SystemBold
local _W4=Drawing.new("Circle") _W4.Visible=false _W4.Transparency=1 _W4.ZIndex=50 _W4.Color=Color3.fromHex("#5c61e3") _W4.Position=_wm+Vector2.new(123,29) _W4.Radius=3 _W4.NumSides=32 _W4.Thickness=1 _W4.Filled=true
local _W5=Drawing.new("Circle") _W5.Visible=false _W5.Transparency=1 _W5.ZIndex=60 _W5.Color=Color3.fromHex("#8b5df6") _W5.Position=_wm+Vector2.new(133,29) _W5.Radius=3 _W5.NumSides=32 _W5.Thickness=1 _W5.Filled=true
local _W6=Drawing.new("Circle") _W6.Visible=false _W6.Transparency=1 _W6.ZIndex=80 _W6.Color=Color3.fromHex("#a68afa") _W6.Position=_wm+Vector2.new(144,29) _W6.Radius=3 _W6.NumSides=32 _W6.Thickness=1 _W6.Filled=true
local _DL1=Drawing.new("Square") _DL1.Visible=false _DL1.Transparency=1 _DL1.ZIndex=90 _DL1.Color=Color3.fromHex("#20204a") _DL1.Position=_wm+Vector2.new(154,19) _DL1.Size=Vector2.new(0.5,15) _DL1.Filled=true
local _NNP=Drawing.new("Text") _NNP.Visible=false _NNP.Transparency=1 _NNP.ZIndex=110 _NNP.Color=Color3.fromHex("#FFFFFF") _NNP.Position=_wm+Vector2.new(161,22) _NNP.Text="..." _NNP.Size=10 _NNP.Center=false _NNP.Outline=true _NNP.Font=Drawing.Fonts.SystemBold
local _MSE=Drawing.new("Square") _MSE.Visible=false _MSE.Transparency=1 _MSE.ZIndex=120 _MSE.Color=Color3.fromHex("#20204a") _MSE.Position=_wm+Vector2.new(246,9.5) _MSE.Size=Vector2.new(168,36) _MSE.Filled=true _MSE.Corner=12
local _MSEB=Drawing.new("Square") _MSEB.Visible=false _MSEB.Transparency=1 _MSEB.ZIndex=121 _MSEB.Color=Color3.fromHex("#242452") _MSEB.Filled=false _MSEB.Thickness=1 _MSEB.Position=_MSE.Position _MSEB.Size=_MSE.Size _MSEB.Corner=12
local _CET=Drawing.new("Text") _CET.Visible=false _CET.Transparency=1 _CET.ZIndex=130 _CET.Color=Color3.fromHex("#7f839a") _CET.Position=_wm+Vector2.new(254,23) _CET.Text="Current Entinty:" _CET.Size=10 _CET.Center=false _CET.Outline=true _CET.Font=Drawing.Fonts.SystemBold
local _SE=Drawing.new("Text") _SE.Visible=false _SE.Transparency=1 _SE.ZIndex=140 _SE.Color=Color3.fromHex("#e1e2cc") _SE.Position=_wm+Vector2.new(329,24) _SE.Text="None" _SE.Size=10 _SE.Center=false _SE.Outline=true _SE.Font=Drawing.Fonts.SystemBold
local _CDR=Drawing.new("Text") _CDR.Visible=false _CDR.Transparency=1 _CDR.ZIndex=150 _CDR.Color=Color3.fromHex("#e1d7c6") _CDR.Position=_wm+Vector2.new(423,24) _CDR.Text="Count Doors Reach: ???" _CDR.Size=10 _CDR.Center=false _CDR.Outline=true _CDR.Font=Drawing.Fonts.SystemBold
local _DL2=Drawing.new("Square") _DL2.Visible=false _DL2.Transparency=1 _DL2.ZIndex=90 _DL2.Color=Color3.fromHex("#20204a") _DL2.Position=_wm+Vector2.new(534,19) _DL2.Size=Vector2.new(0.5,15) _DL2.Filled=true
local _W8=Drawing.new("Circle") _W8.Visible=false _W8.Transparency=1 _W8.ZIndex=50 _W8.Color=Color3.fromHex("#5c61e3") _W8.Position=_wm+Vector2.new(543,29) _W8.Radius=3 _W8.NumSides=32 _W8.Thickness=1 _W8.Filled=true
local _W7=Drawing.new("Circle") _W7.Visible=false _W7.Transparency=1 _W7.ZIndex=60 _W7.Color=Color3.fromHex("#8b5df6") _W7.Position=_wm+Vector2.new(552,29) _W7.Radius=3 _W7.NumSides=32 _W7.Thickness=1 _W7.Filled=true
local _W9=Drawing.new("Circle") _W9.Visible=false _W9.Transparency=1 _W9.ZIndex=80 _W9.Color=Color3.fromHex("#a68afa") _W9.Position=_wm+Vector2.new(562,29) _W9.Radius=3 _W9.NumSides=32 _W9.Thickness=1 _W9.Filled=true

-- Watermark Glow Layers
_W1_glow1=Drawing.new("Circle") _W1_glow1.Visible=false _W1_glow1.Transparency=0.25 _W1_glow1.ZIndex=15 _W1_glow1.Color=Color3.fromHex("#5c61e3") _W1_glow1.Position=_wm+Vector2.new(39,29) _W1_glow1.Radius=5 _W1_glow1.NumSides=32 _W1_glow1.Thickness=2 _W1_glow1.Filled=false
_W1_glow2=Drawing.new("Circle") _W1_glow2.Visible=false _W1_glow2.Transparency=0.12 _W1_glow2.ZIndex=14 _W1_glow2.Color=Color3.fromHex("#5c61e3") _W1_glow2.Position=_wm+Vector2.new(39,29) _W1_glow2.Radius=8 _W1_glow2.NumSides=32 _W1_glow2.Thickness=1 _W1_glow2.Filled=false
_W1_glow3=Drawing.new("Circle") _W1_glow3.Visible=false _W1_glow3.Transparency=0.05 _W1_glow3.ZIndex=13 _W1_glow3.Color=Color3.fromHex("#5c61e3") _W1_glow3.Position=_wm+Vector2.new(39,29) _W1_glow3.Radius=11 _W1_glow3.NumSides=32 _W1_glow3.Thickness=1 _W1_glow3.Filled=false
_W2_glow1=Drawing.new("Circle") _W2_glow1.Visible=false _W2_glow1.Transparency=0.25 _W2_glow1.ZIndex=15 _W2_glow1.Color=Color3.fromHex("#8b5df6") _W2_glow1.Position=_wm+Vector2.new(48,29) _W2_glow1.Radius=5 _W2_glow1.NumSides=32 _W2_glow1.Thickness=2 _W2_glow1.Filled=false
_W2_glow2=Drawing.new("Circle") _W2_glow2.Visible=false _W2_glow2.Transparency=0.12 _W2_glow2.ZIndex=14 _W2_glow2.Color=Color3.fromHex("#8b5df6") _W2_glow2.Position=_wm+Vector2.new(48,29) _W2_glow2.Radius=8 _W2_glow2.NumSides=32 _W2_glow2.Thickness=1 _W2_glow2.Filled=false
_W2_glow3=Drawing.new("Circle") _W2_glow3.Visible=false _W2_glow3.Transparency=0.05 _W2_glow3.ZIndex=13 _W2_glow3.Color=Color3.fromHex("#8b5df6") _W2_glow3.Position=_wm+Vector2.new(48,29) _W2_glow3.Radius=11 _W2_glow3.NumSides=32 _W2_glow3.Thickness=1 _W2_glow3.Filled=false
_W3_glow1=Drawing.new("Circle") _W3_glow1.Visible=false _W3_glow1.Transparency=0.25 _W3_glow1.ZIndex=15 _W3_glow1.Color=Color3.fromHex("#a68afa") _W3_glow1.Position=_wm+Vector2.new(59,29) _W3_glow1.Radius=5 _W3_glow1.NumSides=32 _W3_glow1.Thickness=2 _W3_glow1.Filled=false
_W3_glow2=Drawing.new("Circle") _W3_glow2.Visible=false _W3_glow2.Transparency=0.12 _W3_glow2.ZIndex=14 _W3_glow2.Color=Color3.fromHex("#a68afa") _W3_glow2.Position=_wm+Vector2.new(59,29) _W3_glow2.Radius=8 _W3_glow2.NumSides=32 _W3_glow2.Thickness=1 _W3_glow2.Filled=false
_W3_glow3=Drawing.new("Circle") _W3_glow3.Visible=false _W3_glow3.Transparency=0.05 _W3_glow3.ZIndex=13 _W3_glow3.Color=Color3.fromHex("#a68afa") _W3_glow3.Position=_wm+Vector2.new(59,29) _W3_glow3.Radius=11 _W3_glow3.NumSides=32 _W3_glow3.Thickness=1 _W3_glow3.Filled=false
_W4_glow1=Drawing.new("Circle") _W4_glow1.Visible=false _W4_glow1.Transparency=0.25 _W4_glow1.ZIndex=15 _W4_glow1.Color=Color3.fromHex("#5c61e3") _W4_glow1.Position=_wm+Vector2.new(123,29) _W4_glow1.Radius=5 _W4_glow1.NumSides=32 _W4_glow1.Thickness=2 _W4_glow1.Filled=false
_W4_glow2=Drawing.new("Circle") _W4_glow2.Visible=false _W4_glow2.Transparency=0.12 _W4_glow2.ZIndex=14 _W4_glow2.Color=Color3.fromHex("#5c61e3") _W4_glow2.Position=_wm+Vector2.new(123,29) _W4_glow2.Radius=8 _W4_glow2.NumSides=32 _W4_glow2.Thickness=1 _W4_glow2.Filled=false
_W4_glow3=Drawing.new("Circle") _W4_glow3.Visible=false _W4_glow3.Transparency=0.05 _W4_glow3.ZIndex=13 _W4_glow3.Color=Color3.fromHex("#5c61e3") _W4_glow3.Position=_wm+Vector2.new(123,29) _W4_glow3.Radius=11 _W4_glow3.NumSides=32 _W4_glow3.Thickness=1 _W4_glow3.Filled=false
_W5_glow1=Drawing.new("Circle") _W5_glow1.Visible=false _W5_glow1.Transparency=0.25 _W5_glow1.ZIndex=15 _W5_glow1.Color=Color3.fromHex("#8b5df6") _W5_glow1.Position=_wm+Vector2.new(133,29) _W5_glow1.Radius=5 _W5_glow1.NumSides=32 _W5_glow1.Thickness=2 _W5_glow1.Filled=false
_W5_glow2=Drawing.new("Circle") _W5_glow2.Visible=false _W5_glow2.Transparency=0.12 _W5_glow2.ZIndex=14 _W5_glow2.Color=Color3.fromHex("#8b5df6") _W5_glow2.Position=_wm+Vector2.new(133,29) _W5_glow2.Radius=8 _W5_glow2.NumSides=32 _W5_glow2.Thickness=1 _W5_glow2.Filled=false
_W5_glow3=Drawing.new("Circle") _W5_glow3.Visible=false _W5_glow3.Transparency=0.05 _W5_glow3.ZIndex=13 _W5_glow3.Color=Color3.fromHex("#8b5df6") _W5_glow3.Position=_wm+Vector2.new(133,29) _W5_glow3.Radius=11 _W5_glow3.NumSides=32 _W5_glow3.Thickness=1 _W5_glow3.Filled=false
_W6_glow1=Drawing.new("Circle") _W6_glow1.Visible=false _W6_glow1.Transparency=0.25 _W6_glow1.ZIndex=15 _W6_glow1.Color=Color3.fromHex("#a68afa") _W6_glow1.Position=_wm+Vector2.new(144,29) _W6_glow1.Radius=5 _W6_glow1.NumSides=32 _W6_glow1.Thickness=2 _W6_glow1.Filled=false
_W6_glow2=Drawing.new("Circle") _W6_glow2.Visible=false _W6_glow2.Transparency=0.12 _W6_glow2.ZIndex=14 _W6_glow2.Color=Color3.fromHex("#a68afa") _W6_glow2.Position=_wm+Vector2.new(144,29) _W6_glow2.Radius=8 _W6_glow2.NumSides=32 _W6_glow2.Thickness=1 _W6_glow2.Filled=false
_W6_glow3=Drawing.new("Circle") _W6_glow3.Visible=false _W6_glow3.Transparency=0.05 _W6_glow3.ZIndex=13 _W6_glow3.Color=Color3.fromHex("#a68afa") _W6_glow3.Position=_wm+Vector2.new(144,29) _W6_glow3.Radius=11 _W6_glow3.NumSides=32 _W6_glow3.Thickness=1 _W6_glow3.Filled=false
_W8_glow1=Drawing.new("Circle") _W8_glow1.Visible=false _W8_glow1.Transparency=0.25 _W8_glow1.ZIndex=15 _W8_glow1.Color=Color3.fromHex("#5c61e3") _W8_glow1.Position=_wm+Vector2.new(543,29) _W8_glow1.Radius=5 _W8_glow1.NumSides=32 _W8_glow1.Thickness=2 _W8_glow1.Filled=false
_W8_glow2=Drawing.new("Circle") _W8_glow2.Visible=false _W8_glow2.Transparency=0.12 _W8_glow2.ZIndex=14 _W8_glow2.Color=Color3.fromHex("#5c61e3") _W8_glow2.Position=_wm+Vector2.new(543,29) _W8_glow2.Radius=8 _W8_glow2.NumSides=32 _W8_glow2.Thickness=1 _W8_glow2.Filled=false
_W8_glow3=Drawing.new("Circle") _W8_glow3.Visible=false _W8_glow3.Transparency=0.05 _W8_glow3.ZIndex=13 _W8_glow3.Color=Color3.fromHex("#5c61e3") _W8_glow3.Position=_wm+Vector2.new(543,29) _W8_glow3.Radius=11 _W8_glow3.NumSides=32 _W8_glow3.Thickness=1 _W8_glow3.Filled=false
_W7_glow1=Drawing.new("Circle") _W7_glow1.Visible=false _W7_glow1.Transparency=0.25 _W7_glow1.ZIndex=15 _W7_glow1.Color=Color3.fromHex("#8b5df6") _W7_glow1.Position=_wm+Vector2.new(552,29) _W7_glow1.Radius=5 _W7_glow1.NumSides=32 _W7_glow1.Thickness=2 _W7_glow1.Filled=false
_W7_glow2=Drawing.new("Circle") _W7_glow2.Visible=false _W7_glow2.Transparency=0.12 _W7_glow2.ZIndex=14 _W7_glow2.Color=Color3.fromHex("#8b5df6") _W7_glow2.Position=_wm+Vector2.new(552,29) _W7_glow2.Radius=8 _W7_glow2.NumSides=32 _W7_glow2.Thickness=1 _W7_glow2.Filled=false
_W7_glow3=Drawing.new("Circle") _W7_glow3.Visible=false _W7_glow3.Transparency=0.05 _W7_glow3.ZIndex=13 _W7_glow3.Color=Color3.fromHex("#8b5df6") _W7_glow3.Position=_wm+Vector2.new(552,29) _W7_glow3.Radius=11 _W7_glow3.NumSides=32 _W7_glow3.Thickness=1 _W7_glow3.Filled=false
_W9_glow1=Drawing.new("Circle") _W9_glow1.Visible=false _W9_glow1.Transparency=0.25 _W9_glow1.ZIndex=15 _W9_glow1.Color=Color3.fromHex("#a68afa") _W9_glow1.Position=_wm+Vector2.new(562,29) _W9_glow1.Radius=5 _W9_glow1.NumSides=32 _W9_glow1.Thickness=2 _W9_glow1.Filled=false
_W9_glow2=Drawing.new("Circle") _W9_glow2.Visible=false _W9_glow2.Transparency=0.12 _W9_glow2.ZIndex=14 _W9_glow2.Color=Color3.fromHex("#a68afa") _W9_glow2.Position=_wm+Vector2.new(562,29) _W9_glow2.Radius=8 _W9_glow2.NumSides=32 _W9_glow2.Thickness=1 _W9_glow2.Filled=false
_W9_glow3=Drawing.new("Circle") _W9_glow3.Visible=false _W9_glow3.Transparency=0.05 _W9_glow3.ZIndex=13 _W9_glow3.Color=Color3.fromHex("#a68afa") _W9_glow3.Position=_wm+Vector2.new(562,29) _W9_glow3.Radius=11 _W9_glow3.NumSides=32 _W9_glow3.Thickness=1 _W9_glow3.Filled=false
_NNP.Text=game.Players.LocalPlayer.Name
WatermarkSystem.elements={_WM1,_WM1B,_W1,_W2,_W3,_W4,_W5,_W6,_W7,_W8,_W9,_WRT,_DL1,_NNP,_MSE,_MSEB,_CET,_SE,_CDR,_DL2,_W1_glow1,_W1_glow2,_W1_glow3,_W2_glow1,_W2_glow2,_W2_glow3,_W3_glow1,_W3_glow2,_W3_glow3,_W4_glow1,_W4_glow2,_W4_glow3,_W5_glow1,_W5_glow2,_W5_glow3,_W6_glow1,_W6_glow2,_W6_glow3,_W8_glow1,_W8_glow2,_W8_glow3,_W7_glow1,_W7_glow2,_W7_glow3,_W9_glow1,_W9_glow2,_W9_glow3}
spawn(function()
    local bd={
        {core=_W1,g1=_W1_glow1,g2=_W1_glow2,g3=_W1_glow3,phase=0.0},
        {core=_W2,g1=_W2_glow1,g2=_W2_glow2,g3=_W2_glow3,phase=0.6981},
        {core=_W3,g1=_W3_glow1,g2=_W3_glow2,g3=_W3_glow3,phase=1.3963},
        {core=_W4,g1=_W4_glow1,g2=_W4_glow2,g3=_W4_glow3,phase=2.0944},
        {core=_W5,g1=_W5_glow1,g2=_W5_glow2,g3=_W5_glow3,phase=2.7925},
        {core=_W6,g1=_W6_glow1,g2=_W6_glow2,g3=_W6_glow3,phase=3.4907},
        {core=_W8,g1=_W8_glow1,g2=_W8_glow2,g3=_W8_glow3,phase=4.1888},
        {core=_W7,g1=_W7_glow1,g2=_W7_glow2,g3=_W7_glow3,phase=4.8869},
        {core=_W9,g1=_W9_glow1,g2=_W9_glow2,g3=_W9_glow3,phase=5.5851},
    }
    while true do
        if WatermarkSystem.enabled then
            local t=os.clock()
            for _,d in ipairs(bd) do
                local s01=(math.sin(t*1.8+d.phase)+1)/2
                d.core.Radius = 3   + s01*0.25
                d.g1.Radius   = 5   + s01*0.8
                d.g2.Radius   = 8   + s01*1.0
                d.g3.Radius   = 11  + s01*1.2
                d.g1.Transparency = 0.10 + (1-s01)*0.50
                d.g2.Transparency = 0.05 + (1-s01)*0.50
                d.g3.Transparency = 0.02 + (1-s01)*0.48
                d.g1.Position=d.core.Position
                d.g2.Position=d.core.Position
                d.g3.Position=d.core.Position
            end
        end
        wait(0.016)
    end
end)

function WatermarkSystem:SetVisible(v) for _,el in pairs(self.elements) do if el then el.Visible=v and self.enabled end end end
function WatermarkSystem:CheckForMobs()
    for _,obj in ipairs(workspace:GetChildren()) do for _,m in ipairs(TrackedMobs) do if obj.Name==m then return m end end end return nil
end
function WatermarkSystem:UpdateEntity()
    if not self.enabled then return end
    local mob=self:CheckForMobs()
    if mob then self.currentEntity=mob _SE.Text=mob _SE.Color=MobColors[mob] or Color3.fromHex("#ff0000")
    else self.currentEntity="None" _SE.Text="None" _SE.Color=Color3.fromHex("#e1e2cc") end
end
spawn(function()
    local wmM=game.Players.LocalPlayer:GetMouse()
    local wmDrag=false local wmDS=nil local wmSP=nil local lwm=false
    while true do
        wait(0.01)
        if isrbxactive() and WatermarkSystem.enabled then
            local m1=ismouse1pressed() local mp=Vector2.new(wmM.X,wmM.Y)
            if m1 and not lwm then
                if _WM1.Visible and mp.X>=_WM1.Position.X and mp.X<=_WM1.Position.X+_WM1.Size.X and
                   mp.Y>=_WM1.Position.Y and mp.Y<=_WM1.Position.Y+_WM1.Size.Y then
                    wmDrag=true wmDS=mp wmSP=_WM1.Position end
            end
            if not m1 then wmDrag=false end
            if wmDrag and m1 then
                local np=wmSP+(mp-wmDS)
                _WM1.Position=np _WM1B.Position=np
                _W1.Position=np+Vector2.new(39,29) _W2.Position=np+Vector2.new(48,29)
                _W3.Position=np+Vector2.new(59,29) _WRT.Position=np+Vector2.new(69,20)
                _W4.Position=np+Vector2.new(123,29) _W5.Position=np+Vector2.new(133,29)
                _W6.Position=np+Vector2.new(144,29) _DL1.Position=np+Vector2.new(154,19)
                _NNP.Position=np+Vector2.new(161,22) _MSE.Position=np+Vector2.new(246,9.5)
                _MSEB.Position=_MSE.Position _CET.Position=np+Vector2.new(254,23)
                _SE.Position=np+Vector2.new(329,24) _CDR.Position=np+Vector2.new(423,24)
                _DL2.Position=np+Vector2.new(534,19) _W8.Position=np+Vector2.new(543,29)
                _W7.Position=np+Vector2.new(552,29) _W9.Position=np+Vector2.new(562,29)
                _W1_glow1.Position=np+Vector2.new(39,29) _W1_glow2.Position=np+Vector2.new(39,29) _W1_glow3.Position=np+Vector2.new(39,29)
                _W2_glow1.Position=np+Vector2.new(48,29) _W2_glow2.Position=np+Vector2.new(48,29) _W2_glow3.Position=np+Vector2.new(48,29)
                _W3_glow1.Position=np+Vector2.new(59,29) _W3_glow2.Position=np+Vector2.new(59,29) _W3_glow3.Position=np+Vector2.new(59,29)
                _W4_glow1.Position=np+Vector2.new(123,29) _W4_glow2.Position=np+Vector2.new(123,29) _W4_glow3.Position=np+Vector2.new(123,29)
                _W5_glow1.Position=np+Vector2.new(133,29) _W5_glow2.Position=np+Vector2.new(133,29) _W5_glow3.Position=np+Vector2.new(133,29)
                _W6_glow1.Position=np+Vector2.new(144,29) _W6_glow2.Position=np+Vector2.new(144,29) _W6_glow3.Position=np+Vector2.new(144,29)
                _W8_glow1.Position=np+Vector2.new(543,29) _W8_glow2.Position=np+Vector2.new(543,29) _W8_glow3.Position=np+Vector2.new(543,29)
                _W7_glow1.Position=np+Vector2.new(552,29) _W7_glow2.Position=np+Vector2.new(552,29) _W7_glow3.Position=np+Vector2.new(552,29)
                _W9_glow1.Position=np+Vector2.new(562,29) _W9_glow2.Position=np+Vector2.new(562,29) _W9_glow3.Position=np+Vector2.new(562,29)
            end
            lwm=m1
        end
    end
end)

loadstring(game:HttpGet("https://www.arcanecheats.xyz/api/matcha/esplib"))()

activeChunkedESPs = { KeyCard={}, InnerKeyCard={}, PasswordPaper={}, ItemBase={}, CurrencyBase={} }
activeDoorESPs = {}

local ChunkedColors = {
    KeyCard      = Color3.fromRGB(0, 255, 100),
    InnerKeyCard = Color3.fromRGB(102, 0, 255),
    PasswordPaper= Color3.fromRGB(229, 228, 226),
    ItemBase     = Color3.fromRGB(0, 200, 255),
    CurrencyBase = Color3.fromRGB(255, 215, 0),
}

local GetPlayerPos
GetPlayerPos = function()
    local p=game.Players.LocalPlayer
    if not p or not p.Character then return nil end
    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
    return hrp and hrp.Position or nil
end

local GetObjPos
GetObjPos = function(obj)
    if obj:IsA("BasePart") then return obj.Position end
    local bp=obj:FindFirstChildWhichIsA("BasePart",true)
    return bp and bp.Position or nil
end

local CreateChunkedESP
CreateChunkedESP = function(obj,iType)
    local tbl=activeChunkedESPs[iType] if not tbl then return end
    local key=obj:GetFullName() if tbl[key] then return end
    local pPos=GetPlayerPos()
    if pPos then
        local oPos=GetObjPos(obj)
        if oPos and (oPos-pPos).Magnitude>Settings.espMaxDistance then return end
    end
    local ok,esp=pcall(function()
        return ArcaneEsp.new(obj):AddTitle(ChunkedColors[iType],obj.Name):AddDistance(ChunkedColors[iType]):SetFont(0)
    end)
    if ok and esp then tbl[key]={esp=esp,obj=obj} end
end

local CleanupChunkedESP
CleanupChunkedESP = function(iType)
    local tbl=activeChunkedESPs[iType] if not tbl then return end
    for _,data in pairs(tbl) do pcall(function() data.esp:Destroy() end) end
    activeChunkedESPs[iType]={}
end

local CleanupDeadChunked
CleanupDeadChunked = function()
    for _,tbl in pairs(activeChunkedESPs) do
        for key,data in pairs(tbl) do
            if not data.obj or not data.obj.Parent then
                pcall(function() data.esp:Destroy() end)
                tbl[key]=nil
            end
        end
    end
end

local FindDoors
FindDoors = function()
    local found={}
    local gf=workspace:FindFirstChild("GameplayFolder")
    if not gf then return found end
    local rooms=gf:FindFirstChild("Rooms")
    if not rooms then return found end
    for _,room in ipairs(rooms:GetChildren()) do
        local exits=room:FindFirstChild("Exits")
        if exits then for _,e in ipairs(exits:GetChildren()) do
            local part=e:IsA("BasePart") and e or e:FindFirstChildWhichIsA("BasePart",true)
            if part then table.insert(found,{part=part,key=e:GetFullName()}) end
        end end
    end
    return found
end

local chunkedScanning=false
local ChunkedScan
ChunkedScan = function()
    if chunkedScanning then return end chunkedScanning=true
    local gf=workspace:FindFirstChild("GameplayFolder")
    local root=(gf and gf:FindFirstChild("Rooms")) or gf or workspace
    local desc=root:GetDescendants() local count=0
    for _,obj in ipairs(desc) do
        local iType=obj:GetAttribute("InteractionType")
        if iType then
            if (iType=="KeyCard" or iType=="InnerKeyCard") and Settings.keycardESPEnabled then
                CreateChunkedESP(obj,iType)
            elseif iType=="PasswordPaper" and Settings.keycardESPEnabled then
                CreateChunkedESP(obj,"PasswordPaper")
            elseif iType=="ItemBase" and Settings.itemsESPEnabled then
                CreateChunkedESP(obj,"ItemBase")
            elseif iType=="CurrencyBase" and Settings.currencyESPEnabled then
                CreateChunkedESP(obj,"CurrencyBase")
            end
        end
        count=count+1 if count%30==0 then wait() end
    end
    CleanupDeadChunked() chunkedScanning=false
end

StartKeycardESP   = function() if Settings.keycardESPEnabled then return end Settings.keycardESPEnabled=true end
CleanupKeycardESP = function()
    Settings.keycardESPEnabled=false
    CleanupChunkedESP("KeyCard")
    CleanupChunkedESP("InnerKeyCard")
    CleanupChunkedESP("PasswordPaper")
end
StartItemsESP      = function() if Settings.itemsESPEnabled    then return end Settings.itemsESPEnabled=true    end
CleanupItemsESP    = function() Settings.itemsESPEnabled=false    CleanupChunkedESP("ItemBase")    end
StartCurrencyESP   = function() if Settings.currencyESPEnabled then return end Settings.currencyESPEnabled=true end
CleanupCurrencyESP = function() Settings.currencyESPEnabled=false CleanupChunkedESP("CurrencyBase") end

StartDoorESP = function()
    if Settings.doorESPEnabled then return end Settings.doorESPEnabled=true
    for _,door in ipairs(FindDoors()) do
        if not activeDoorESPs[door.key] then
            local ok,esp=pcall(function()
                return ArcaneEsp.new(door.part):AddEsp(Color3.fromRGB(255,165,0)):AddTitle(Color3.new(1,1,1),"Door"):AddDistance(Color3.new(1,1,1)):SetFont(0)
            end)
            if ok and esp then activeDoorESPs[door.key]=esp end
        end
    end
end
CleanupDoorESP = function()
    Settings.doorESPEnabled=false
    for key,esp in pairs(activeDoorESPs) do pcall(function() esp:Destroy() end) activeDoorESPs[key]=nil end
end

ForceRescanESP = function() ChunkedScan() end

spawn(function()
    while true do
        wait(1)
        if Settings.keycardESPEnabled or Settings.itemsESPEnabled or Settings.currencyESPEnabled then
            if Settings.autoRescanEnabled then ChunkedScan() else CleanupDeadChunked() end
        end
        if Settings.doorESPEnabled then
            local doors=FindDoors() local newKeys={}
            for _,d in ipairs(doors) do newKeys[d.key]=d end
            for key,esp in pairs(activeDoorESPs) do
                if not newKeys[key] then pcall(function() esp:Destroy() end) activeDoorESPs[key]=nil end
            end
            for key,d in pairs(newKeys) do
                if not activeDoorESPs[key] then
                    local ok,esp=pcall(function()
                        return ArcaneEsp.new(d.part):AddEsp(Color3.fromRGB(255,165,0)):AddTitle(Color3.new(1,1,1),"Door"):AddDistance(Color3.new(1,1,1)):SetFont(0)
                    end)
                    if ok and esp then activeDoorESPs[key]=esp end
                end
            end
        end
    end
end)

AutoHideSystem={enabled=false,isHiding=false,originalPosition=nil,checkInterval=0.05,lastCheckTime=0,holdLoop=false}
local _AHP=game.Players
local TrackedMobsSet={}
for _,name in ipairs(TrackedMobs) do TrackedMobsSet[name]=true end
local getHRP; getHRP=function()
    local p=_AHP.LocalPlayer if not p or not p.Character then return nil end
    return p.Character:FindFirstChild("HumanoidRootPart")
end
local forceTeleport; forceTeleport=function(pos)
    for i=1,5 do local h=getHRP() if h then h.AssemblyLinearVelocity=Vector3.new(0,0,0) h.Position=pos end wait() end
end
function AutoHideSystem:CheckForMobs()
    for _,obj in ipairs(workspace:GetChildren()) do if TrackedMobsSet[obj.Name] then return true end end return false
end
function AutoHideSystem:Hide()
    if self.isHiding then return end local hrp=getHRP() if not hrp then return end
    self.originalPosition=hrp.Position self.isHiding=true self.holdLoop=true
    spawn(function() forceTeleport(self.originalPosition+Vector3.new(0,1000,0)) end)
    spawn(function() while self.holdLoop do local h=getHRP() if h then h.AssemblyLinearVelocity=Vector3.new(0,0,0) end wait() end end)
end
function AutoHideSystem:Unhide()
    if not self.isHiding then return end self.holdLoop=false self.isHiding=false
    local sp=self.originalPosition self.originalPosition=nil
    spawn(function() if sp then forceTeleport(sp) end end)
end
function AutoHideSystem:Update()
    if not self.enabled then if self.isHiding then self:Unhide() end return end
    if self.isHiding and not self.originalPosition then self.isHiding=false self.holdLoop=false end
    local ct=os.clock() if ct-self.lastCheckTime<self.checkInterval then return end
    self.lastCheckTime=ct
    if self:CheckForMobs() then if not self.isHiding then self:Hide() end
    else if self.isHiding then self:Unhide() end end
end
spawn(function() while true do AutoHideSystem:Update() wait() end end)

spawn(function()
    while true do
        pcall(function() NotificationSystem:Update() end)
        wait(0.016)
    end
end)

spawn(function()
    while true do
        pcall(function() NotificationSystem:CheckForMobs() end)
        wait(0.1)
    end
end)

spawn(function()
    while true do
        if WatermarkSystem.enabled then
            pcall(function() WatermarkSystem:UpdateEntity() end)
        end
        wait(0.1)
    end
end)

spawn(function()
    local lF5=false while true do wait(0.01) if isrbxactive() then
        local f5=iskeypressed(0x74) if f5 and not lF5 then ForceRescanESP() end lF5=f5 end end
end)
end

local Mouse = game.Players.LocalPlayer:GetMouse()

local Main1 = Drawing.new("Square")
Main1.Visible = true
Main1.Transparency = 1
Main1.ZIndex = 10
Main1.Color = Color3.fromHex("#0b0f1a")
Main1.Position = Vector2.new(98, 20)
Main1.Size = Vector2.new(604, 560)
Main1.Filled = true
Main1.Corner = 0

VeryTopPlace_Parts = {}
do
    local gSteps=50 local gW=604 local gH=46
    local r1,g1,b1=0x1a/255,0x15/255,0x30/255
    local r2,g2,b2=0x0f/255,0x14/255,0x28/255
    for i=0,gSteps-1 do
        local t=i/(gSteps-1)
        local sq=Drawing.new("Square")
        sq.Visible=true sq.Transparency=1 sq.ZIndex=20
        sq.Color=Color3.new(r1+(r2-r1)*t,g1+(g2-g1)*t,b1+(b2-b1)*t)
        sq.Position=Vector2.new(Main1.Position.X+i*math.floor(gW/gSteps),Main1.Position.Y)
        sq.Size=Vector2.new(math.floor(gW/gSteps)+1,gH)
        sq.Filled=true sq.Corner=0
        VeryTopPlace_Parts[i+1]=sq
    end
end
local VeryTopPlace=VeryTopPlace_Parts[1]

local Circle5 = Drawing.new("Circle")
Circle5.Visible = true
Circle5.Transparency = 1
Circle5.ZIndex = 30
Circle5.Color = Color3.fromHex("#ad47fe")
Circle5.Position = Main1.Position + Vector2.new(25, 23)
Circle5.Radius = 5
Circle5.NumSides = 32
Circle5.Thickness = 1
Circle5.Filled = true

local TextRATHUB = Drawing.new("Text")
TextRATHUB.Visible = true
TextRATHUB.Transparency = 1
TextRATHUB.ZIndex = 40
TextRATHUB.Color = Color3.fromHex("#FFFFFF")
TextRATHUB.Position = Main1.Position + Vector2.new(54, 17)
TextRATHUB.Text = "RATHUB"
TextRATHUB.Size = 14
TextRATHUB.Center = false
TextRATHUB.Outline = true
TextRATHUB.Font = Drawing.Fonts.System

local PlaceTabs = Drawing.new("Square")
PlaceTabs.Visible = true
PlaceTabs.Transparency = 1
PlaceTabs.ZIndex = 50
PlaceTabs.Color = Color3.fromHex("#0c1020")
PlaceTabs.Position = Main1.Position + Vector2.new(2, 46)
PlaceTabs.Size = Vector2.new(600, 43)
PlaceTabs.Filled = true

local VisualsTab = Drawing.new("Square")
VisualsTab.Visible = true
VisualsTab.Transparency = 1
VisualsTab.ZIndex = 60
VisualsTab.Color = Color3.fromHex("#0c1020")
VisualsTab.Position = Main1.Position + Vector2.new(8, 50)
VisualsTab.Size = Vector2.new(77, 36)
VisualsTab.Filled = true
VisualsTab.Corner = 8

local VisualsTab_Text = Drawing.new("Text")
VisualsTab_Text.Text = "Visuals"
VisualsTab_Text.Size = 14
VisualsTab_Text.Center = true
VisualsTab_Text.Outline = true
VisualsTab_Text.Font = 2
VisualsTab_Text.Color = Color3.fromHex("#d5c0e4")
VisualsTab_Text.Position = VisualsTab.Position + Vector2.new(77/2, 36/2)
VisualsTab_Text.Visible = true
VisualsTab_Text.ZIndex = 62

local ExploitsTab = Drawing.new("Square")
ExploitsTab.Visible = true
ExploitsTab.Transparency = 1
ExploitsTab.ZIndex = 70
ExploitsTab.Color = Color3.fromHex("#0c1020")
ExploitsTab.Position = Main1.Position + Vector2.new(100, 50)
ExploitsTab.Size = Vector2.new(71, 35)
ExploitsTab.Filled = true
ExploitsTab.Corner = 8

local ExploitsTab_Text = Drawing.new("Text")
ExploitsTab_Text.Text = "Exploits"
ExploitsTab_Text.Size = 14
ExploitsTab_Text.Center = true
ExploitsTab_Text.Outline = true
ExploitsTab_Text.Font = 2
ExploitsTab_Text.Color = Color3.fromHex("#d5c0e4")
ExploitsTab_Text.Position = ExploitsTab.Position + Vector2.new(71/2, 35/2)
ExploitsTab_Text.Visible = true
ExploitsTab_Text.ZIndex = 72

local MiscTab = Drawing.new("Square")
MiscTab.Visible = true
MiscTab.Transparency = 1
MiscTab.ZIndex = 80
MiscTab.Color = Color3.fromHex("#0c1020")
MiscTab.Position = Main1.Position + Vector2.new(186, 50)
MiscTab.Size = Vector2.new(73, 35)
MiscTab.Filled = true
MiscTab.Corner = 8

local MiscTab_Text = Drawing.new("Text")
MiscTab_Text.Text = "Misc"
MiscTab_Text.Size = 14
MiscTab_Text.Center = true
MiscTab_Text.Outline = true
MiscTab_Text.Font = 2
MiscTab_Text.Color = Color3.fromHex("#d5c0e4")
MiscTab_Text.Position = MiscTab.Position + Vector2.new(73/2, 35/2)
MiscTab_Text.Visible = true
MiscTab_Text.ZIndex = 82

local SettingsTab = Drawing.new("Square")
SettingsTab.Visible = true
SettingsTab.Transparency = 1
SettingsTab.ZIndex = 90
SettingsTab.Color = Color3.fromHex("#0c1020")
SettingsTab.Position = Main1.Position + Vector2.new(273, 50)
SettingsTab.Size = Vector2.new(73, 35)
SettingsTab.Filled = true
SettingsTab.Corner = 8

local SettingsTab_Text = Drawing.new("Text")
SettingsTab_Text.Text = "Settings"
SettingsTab_Text.Size = 14
SettingsTab_Text.Center = true
SettingsTab_Text.Outline = true
SettingsTab_Text.Font = 2
SettingsTab_Text.Color = Color3.fromHex("#d5c0e4")
SettingsTab_Text.Position = SettingsTab.Position + Vector2.new(73/2, 35/2)
SettingsTab_Text.Visible = true
SettingsTab_Text.ZIndex = 92

local function setActiveTab(activeBg,activeText)
    local tabs={{bg=VisualsTab,text=VisualsTab_Text},{bg=ExploitsTab,text=ExploitsTab_Text},{bg=MiscTab,text=MiscTab_Text},{bg=SettingsTab,text=SettingsTab_Text}}
    for _,t in ipairs(tabs) do t.bg.Color=Color3.fromHex("#0c1020") t.text.Color=Color3.fromHex("#d5c0e4") end
    activeBg.Color=Color3.fromHex("#6b12a9") activeText.Color=Color3.fromHex("#e7feff")
end
local Line1 = Drawing.new("Square")
Line1.Visible = true
Line1.Transparency = 1
Line1.ZIndex = 100
Line1.Color = Color3.fromHex("#171b2e")
Line1.Position = Main1.Position + Vector2.new(0, 45)
Line1.Size = Vector2.new(602, 2)
Line1.Filled = true
Line1.Corner = 1

local Line2 = Drawing.new("Square")
Line2.Visible = true
Line2.Transparency = 1
Line2.ZIndex = 110
Line2.Color = Color3.fromHex("#171b2e")
Line2.Position = Main1.Position + Vector2.new(0, 89)
Line2.Size = Vector2.new(602, 2)
Line2.Filled = true
Line2.Corner = 1

local ContentPageVisuals = Drawing.new("Square")
ContentPageVisuals.Visible = false
ContentPageVisuals.Transparency = 1
ContentPageVisuals.ZIndex = 120
ContentPageVisuals.Color = Color3.fromHex("#0c1020")
ContentPageVisuals.Position = Main1.Position + Vector2.new(25, 114)
ContentPageVisuals.Size = Vector2.new(534, 132)
ContentPageVisuals.Filled = true
ContentPageVisuals.Corner = 5

local ContentPageVisuals_Border = Drawing.new("Square")
ContentPageVisuals_Border.Visible = false
ContentPageVisuals_Border.Transparency = 1
ContentPageVisuals_Border.ZIndex = 121
ContentPageVisuals_Border.Color = Color3.fromHex("#13172a")
ContentPageVisuals_Border.Filled = false
ContentPageVisuals_Border.Thickness = 3
ContentPageVisuals_Border.Position = ContentPageVisuals.Position
ContentPageVisuals_Border.Size = ContentPageVisuals.Size
ContentPageVisuals_Border.Corner = 5

local ESPkeycardSwitch = Drawing.new("Switch")
ESPkeycardSwitch.Visible = false
ESPkeycardSwitch.Transparency = 1
ESPkeycardSwitch.ZIndex = 150
ESPkeycardSwitch.Color = Color3.fromHex("#212121")
ESPkeycardSwitch.Position = ContentPageVisuals.Position + Vector2.new(481, 9)

local ESPkeycardSwitch_IsChecked = false
local ESPkeycardSwitch = Drawing.new("Square")
ESPkeycardSwitch.Visible = false
ESPkeycardSwitch.Transparency = 1
ESPkeycardSwitch.Color = Color3.fromHex("#000000")
ESPkeycardSwitch.Thickness = 1
ESPkeycardSwitch.Filled = false
ESPkeycardSwitch.Size = Vector2.new(40, 20)
ESPkeycardSwitch.Position = Vector2.new(604, 143)
ESPkeycardSwitch.ZIndex = 150
ESPkeycardSwitch.Corner = 15
local ESPkeycardSwitch_Bg = Drawing.new("Square")
ESPkeycardSwitch_Bg.Visible = false
ESPkeycardSwitch_Bg.Transparency = 1
ESPkeycardSwitch_Bg.Color = Color3.fromHex("#212121")
ESPkeycardSwitch_Bg.Filled = true
ESPkeycardSwitch_Bg.Size = ESPkeycardSwitch.Size
ESPkeycardSwitch_Bg.Position = ESPkeycardSwitch.Position
ESPkeycardSwitch_Bg.ZIndex = 150
ESPkeycardSwitch_Bg.Corner = 15
local ESPkeycardSwitch_IndBorder = Drawing.new("Square")
ESPkeycardSwitch_IndBorder.Visible = false
ESPkeycardSwitch_IndBorder.Transparency = 1
ESPkeycardSwitch_IndBorder.Color = Color3.fromHex("#000000")
ESPkeycardSwitch_IndBorder.Thickness = 1
ESPkeycardSwitch_IndBorder.Filled = false
ESPkeycardSwitch_IndBorder.Size = Vector2.new(18, 18)
ESPkeycardSwitch_IndBorder.ZIndex = 152
ESPkeycardSwitch_IndBorder.Corner = 15
local ESPkeycardSwitch_Ind = Drawing.new("Square")
ESPkeycardSwitch_Ind.Visible = false
ESPkeycardSwitch_Ind.Transparency = 1
ESPkeycardSwitch_Ind.Color = Color3.fromHex("#ffffff")
ESPkeycardSwitch_Ind.Filled = true
ESPkeycardSwitch_Ind.Size = Vector2.new(18, 18)
ESPkeycardSwitch_Ind.ZIndex = 152
ESPkeycardSwitch_Ind.Corner = 15
if ESPkeycardSwitch_IsChecked then
    ESPkeycardSwitch_IndBorder.Position = ESPkeycardSwitch.Position + Vector2.new(21, 1)
    ESPkeycardSwitch_Ind.Position = ESPkeycardSwitch.Position + Vector2.new(21, 1)
else
    ESPkeycardSwitch_IndBorder.Position = ESPkeycardSwitch.Position + Vector2.new(1, 1)
    ESPkeycardSwitch_Ind.Position = ESPkeycardSwitch.Position + Vector2.new(1, 1)
end
local ESPkeycardSwitch_Label = Drawing.new("Text")
ESPkeycardSwitch_Label.Visible = false
ESPkeycardSwitch_Label.Text = ""
ESPkeycardSwitch_Label.Size = 12
ESPkeycardSwitch_Label.Color = Color3.fromHex("#FFFFFF")
ESPkeycardSwitch_Label.Outline = true
ESPkeycardSwitch_Label.Font = Drawing.Fonts.UI
ESPkeycardSwitch_Label.Position = ESPkeycardSwitch.Position + Vector2.new(50, 4)
ESPkeycardSwitch_Label.ZIndex = 151

local EspKeycardtext = Drawing.new("Text")
EspKeycardtext.Visible = false
EspKeycardtext.Transparency = 1
EspKeycardtext.ZIndex = 290
EspKeycardtext.Color = Color3.fromHex("#e5e4d3")
EspKeycardtext.Position = ContentPageVisuals.Position + Vector2.new(9, 9)
EspKeycardtext.Text = "ESP Keycard"
EspKeycardtext.Size = 14
EspKeycardtext.Center = false
EspKeycardtext.Outline = true
EspKeycardtext.Font = Drawing.Fonts.Monospace

local EspDoorText = Drawing.new("Text")
EspDoorText.Visible = false
EspDoorText.Transparency = 1
EspDoorText.ZIndex = 300
EspDoorText.Color = Color3.fromHex("#e5e4d3")
EspDoorText.Position = ContentPageVisuals.Position + Vector2.new(9, 35)
EspDoorText.Text = "ESP Doors"
EspDoorText.Size = 14
EspDoorText.Center = false
EspDoorText.Outline = true
EspDoorText.Font = Drawing.Fonts.Monospace

local ESPDoorsSwitch = Drawing.new("Switch")
ESPDoorsSwitch.Visible = false
ESPDoorsSwitch.Transparency = 1
ESPDoorsSwitch.ZIndex = 160
ESPDoorsSwitch.Color = Color3.fromHex("#212121")
ESPDoorsSwitch.Position = ContentPageVisuals.Position + Vector2.new(481, 35)

local ESPDoorsSwitch_IsChecked = false
local ESPDoorsSwitch = Drawing.new("Square")
ESPDoorsSwitch.Visible = false
ESPDoorsSwitch.Transparency = 1
ESPDoorsSwitch.Color = Color3.fromHex("#000000")
ESPDoorsSwitch.Thickness = 1
ESPDoorsSwitch.Filled = false
ESPDoorsSwitch.Size = Vector2.new(40, 20)
ESPDoorsSwitch.Position = Vector2.new(604, 169)
ESPDoorsSwitch.ZIndex = 160
ESPDoorsSwitch.Corner = 15
local ESPDoorsSwitch_Bg = Drawing.new("Square")
ESPDoorsSwitch_Bg.Visible = false
ESPDoorsSwitch_Bg.Transparency = 1
ESPDoorsSwitch_Bg.Color = Color3.fromHex("#212121")
ESPDoorsSwitch_Bg.Filled = true
ESPDoorsSwitch_Bg.Size = ESPDoorsSwitch.Size
ESPDoorsSwitch_Bg.Position = ESPDoorsSwitch.Position
ESPDoorsSwitch_Bg.ZIndex = 160
ESPDoorsSwitch_Bg.Corner = 15
local ESPDoorsSwitch_IndBorder = Drawing.new("Square")
ESPDoorsSwitch_IndBorder.Visible = false
ESPDoorsSwitch_IndBorder.Transparency = 1
ESPDoorsSwitch_IndBorder.Color = Color3.fromHex("#000000")
ESPDoorsSwitch_IndBorder.Thickness = 1
ESPDoorsSwitch_IndBorder.Filled = false
ESPDoorsSwitch_IndBorder.Size = Vector2.new(18, 18)
ESPDoorsSwitch_IndBorder.ZIndex = 162
ESPDoorsSwitch_IndBorder.Corner = 15
local ESPDoorsSwitch_Ind = Drawing.new("Square")
ESPDoorsSwitch_Ind.Visible = false
ESPDoorsSwitch_Ind.Transparency = 1
ESPDoorsSwitch_Ind.Color = Color3.fromHex("#ffffff")
ESPDoorsSwitch_Ind.Filled = true
ESPDoorsSwitch_Ind.Size = Vector2.new(18, 18)
ESPDoorsSwitch_Ind.ZIndex = 162
ESPDoorsSwitch_Ind.Corner = 15
if ESPDoorsSwitch_IsChecked then
    ESPDoorsSwitch_IndBorder.Position = ESPDoorsSwitch.Position + Vector2.new(21, 1)
    ESPDoorsSwitch_Ind.Position = ESPDoorsSwitch.Position + Vector2.new(21, 1)
else
    ESPDoorsSwitch_IndBorder.Position = ESPDoorsSwitch.Position + Vector2.new(1, 1)
    ESPDoorsSwitch_Ind.Position = ESPDoorsSwitch.Position + Vector2.new(1, 1)
end
local ESPDoorsSwitch_Label = Drawing.new("Text")
ESPDoorsSwitch_Label.Visible = false
ESPDoorsSwitch_Label.Text = ""
ESPDoorsSwitch_Label.Size = 12
ESPDoorsSwitch_Label.Color = Color3.fromHex("#FFFFFF")
ESPDoorsSwitch_Label.Outline = true
ESPDoorsSwitch_Label.Font = Drawing.Fonts.UI
ESPDoorsSwitch_Label.Position = ESPDoorsSwitch.Position + Vector2.new(50, 4)
ESPDoorsSwitch_Label.ZIndex = 161

local ContentPageVisuals2 = Drawing.new("Square")
ContentPageVisuals2.Visible = false
ContentPageVisuals2.Transparency = 1
ContentPageVisuals2.ZIndex = 130
ContentPageVisuals2.Color = Color3.fromHex("#0c1020")
ContentPageVisuals2.Position = ContentPageVisuals.Position + Vector2.new(0, 146)
ContentPageVisuals2.Size = Vector2.new(534, 210)
ContentPageVisuals2.Filled = true
ContentPageVisuals2.Corner = 5

local ContentPageVisuals2_Border = Drawing.new("Square")
ContentPageVisuals2_Border.Visible = false
ContentPageVisuals2_Border.Transparency = 1
ContentPageVisuals2_Border.ZIndex = 131
ContentPageVisuals2_Border.Color = Color3.fromHex("#13172a")
ContentPageVisuals2_Border.Filled = false
ContentPageVisuals2_Border.Thickness = 3
ContentPageVisuals2_Border.Position = ContentPageVisuals2.Position
ContentPageVisuals2_Border.Size = ContentPageVisuals2.Size
ContentPageVisuals2_Border.Corner = 5

local TextNofiticationAngler = Drawing.new("Text")
TextNofiticationAngler.Visible = false
TextNofiticationAngler.Transparency = 1
TextNofiticationAngler.ZIndex = 330
TextNofiticationAngler.Color = Color3.fromHex("#e5e4d3")
TextNofiticationAngler.Position = ContentPageVisuals.Position + Vector2.new(9, 161)
TextNofiticationAngler.Text = "Nof Angler"
TextNofiticationAngler.Size = 14
TextNofiticationAngler.Center = false
TextNofiticationAngler.Outline = true
TextNofiticationAngler.Font = Drawing.Fonts.Monospace

local NoffiticationAnglerSwitch = Drawing.new("Switch")
NoffiticationAnglerSwitch.Visible = false
NoffiticationAnglerSwitch.Transparency = 1
NoffiticationAnglerSwitch.ZIndex = 190
NoffiticationAnglerSwitch.Color = Color3.fromHex("#212121")
NoffiticationAnglerSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 161)

local NoffiticationAnglerSwitch_IsChecked = false
local NoffiticationAnglerSwitch = Drawing.new("Square")
NoffiticationAnglerSwitch.Visible = false
NoffiticationAnglerSwitch.Transparency = 1
NoffiticationAnglerSwitch.Color = Color3.fromHex("#000000")
NoffiticationAnglerSwitch.Thickness = 1
NoffiticationAnglerSwitch.Filled = false
NoffiticationAnglerSwitch.Size = Vector2.new(30, 13)
NoffiticationAnglerSwitch.Position = Vector2.new(614, 295)
NoffiticationAnglerSwitch.ZIndex = 190
NoffiticationAnglerSwitch.Corner = 15
local NoffiticationAnglerSwitch_Bg = Drawing.new("Square")
NoffiticationAnglerSwitch_Bg.Visible = false
NoffiticationAnglerSwitch_Bg.Transparency = 1
NoffiticationAnglerSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationAnglerSwitch_Bg.Filled = true
NoffiticationAnglerSwitch_Bg.Size = NoffiticationAnglerSwitch.Size
NoffiticationAnglerSwitch_Bg.Position = NoffiticationAnglerSwitch.Position
NoffiticationAnglerSwitch_Bg.ZIndex = 190
NoffiticationAnglerSwitch_Bg.Corner = 15
local NoffiticationAnglerSwitch_IndBorder = Drawing.new("Square")
NoffiticationAnglerSwitch_IndBorder.Visible = false
NoffiticationAnglerSwitch_IndBorder.Transparency = 1
NoffiticationAnglerSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationAnglerSwitch_IndBorder.Thickness = 1
NoffiticationAnglerSwitch_IndBorder.Filled = false
NoffiticationAnglerSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationAnglerSwitch_IndBorder.ZIndex = 192
NoffiticationAnglerSwitch_IndBorder.Corner = 15
local NoffiticationAnglerSwitch_Ind = Drawing.new("Square")
NoffiticationAnglerSwitch_Ind.Visible = false
NoffiticationAnglerSwitch_Ind.Transparency = 1
NoffiticationAnglerSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationAnglerSwitch_Ind.Filled = true
NoffiticationAnglerSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationAnglerSwitch_Ind.ZIndex = 192
NoffiticationAnglerSwitch_Ind.Corner = 15
if NoffiticationAnglerSwitch_IsChecked then
    NoffiticationAnglerSwitch_IndBorder.Position = NoffiticationAnglerSwitch.Position + Vector2.new(18, 1)
    NoffiticationAnglerSwitch_Ind.Position = NoffiticationAnglerSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationAnglerSwitch_IndBorder.Position = NoffiticationAnglerSwitch.Position + Vector2.new(1, 1)
    NoffiticationAnglerSwitch_Ind.Position = NoffiticationAnglerSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationAnglerSwitch_Label = Drawing.new("Text")
NoffiticationAnglerSwitch_Label.Visible = false
NoffiticationAnglerSwitch_Label.Text = ""
NoffiticationAnglerSwitch_Label.Size = 12
NoffiticationAnglerSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationAnglerSwitch_Label.Outline = true
NoffiticationAnglerSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationAnglerSwitch_Label.Position = NoffiticationAnglerSwitch.Position + Vector2.new(40, 0.5)
NoffiticationAnglerSwitch_Label.ZIndex = 191

local NofFrogerText = Drawing.new("Text")
NofFrogerText.Visible = false
NofFrogerText.Transparency = 1
NofFrogerText.ZIndex = 340
NofFrogerText.Color = Color3.fromHex("#e5e4d3")
NofFrogerText.Position = ContentPageVisuals.Position + Vector2.new(9, 181)
NofFrogerText.Text = "Nof Froger"
NofFrogerText.Size = 14
NofFrogerText.Center = false
NofFrogerText.Outline = true
NofFrogerText.Font = Drawing.Fonts.Monospace

local NofPinkieText = Drawing.new("Text")
NofPinkieText.Visible = false
NofPinkieText.Transparency = 1
NofPinkieText.ZIndex = 350
NofPinkieText.Color = Color3.fromHex("#e5e4d3")
NofPinkieText.Position = ContentPageVisuals.Position + Vector2.new(9, 201)
NofPinkieText.Text = "Nof Pinkie"
NofPinkieText.Size = 14
NofPinkieText.Center = false
NofPinkieText.Outline = true
NofPinkieText.Font = Drawing.Fonts.Monospace

local NofBlitzText = Drawing.new("Text")
NofBlitzText.Visible = false
NofBlitzText.Transparency = 1
NofBlitzText.ZIndex = 360
NofBlitzText.Color = Color3.fromHex("#e5e4d3")
NofBlitzText.Position = ContentPageVisuals.Position + Vector2.new(9, 221)
NofBlitzText.Text = "Nof Blitz"
NofBlitzText.Size = 14
NofBlitzText.Center = false
NofBlitzText.Outline = true
NofBlitzText.Font = Drawing.Fonts.Monospace

local NofChainsmokerText = Drawing.new("Text")
NofChainsmokerText.Visible = false
NofChainsmokerText.Transparency = 1
NofChainsmokerText.ZIndex = 370
NofChainsmokerText.Color = Color3.fromHex("#e5e4d3")
NofChainsmokerText.Position = ContentPageVisuals.Position + Vector2.new(9, 241)
NofChainsmokerText.Text = "Nof Chainsmoker"
NofChainsmokerText.Size = 14
NofChainsmokerText.Center = false
NofChainsmokerText.Outline = true
NofChainsmokerText.Font = Drawing.Fonts.Monospace

local NofPandemoniumText = Drawing.new("Text")
NofPandemoniumText.Visible = false
NofPandemoniumText.Transparency = 1
NofPandemoniumText.ZIndex = 380
NofPandemoniumText.Color = Color3.fromHex("#e5e4d3")
NofPandemoniumText.Position = ContentPageVisuals.Position + Vector2.new(9, 261)
NofPandemoniumText.Text = "Nof Pandemonium"
NofPandemoniumText.Size = 14
NofPandemoniumText.Center = false
NofPandemoniumText.Outline = true
NofPandemoniumText.Font = Drawing.Fonts.Monospace

local NofA60text = Drawing.new("Text")
NofA60text.Visible = false
NofA60text.Transparency = 1
NofA60text.ZIndex = 390
NofA60text.Color = Color3.fromHex("#e5e4d3")
NofA60text.Position = ContentPageVisuals.Position + Vector2.new(9, 281)
NofA60text.Text = "Nof A60"
NofA60text.Size = 14
NofA60text.Center = false
NofA60text.Outline = true
NofA60text.Font = Drawing.Fonts.Monospace

local NofHarbingerText = Drawing.new("Text")
NofHarbingerText.Visible = false
NofHarbingerText.Transparency = 1
NofHarbingerText.ZIndex = 400
NofHarbingerText.Color = Color3.fromHex("#e5e4d3")
NofHarbingerText.Position = ContentPageVisuals.Position + Vector2.new(9, 301)
NofHarbingerText.Text = "Nof Harbinger"
NofHarbingerText.Size = 14
NofHarbingerText.Center = false
NofHarbingerText.Outline = true
NofHarbingerText.Font = Drawing.Fonts.Monospace

local NofPainterRoomText = Drawing.new("Text")
NofPainterRoomText.Visible = false
NofPainterRoomText.Transparency = 1
NofPainterRoomText.ZIndex = 420
NofPainterRoomText.Color = Color3.fromHex("#e5e4d3")
NofPainterRoomText.Position = ContentPageVisuals.Position + Vector2.new(9, 321)
NofPainterRoomText.Text = "Nof Painter Room"
NofPainterRoomText.Size = 14
NofPainterRoomText.Center = false
NofPainterRoomText.Outline = true
NofPainterRoomText.Font = Drawing.Fonts.Monospace

local NoffiticationFrogerSwitch = Drawing.new("Switch")
NoffiticationFrogerSwitch.Visible = false
NoffiticationFrogerSwitch.Transparency = 1
NoffiticationFrogerSwitch.ZIndex = 200
NoffiticationFrogerSwitch.Color = Color3.fromHex("#212121")
NoffiticationFrogerSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 181)

local NoffiticationFrogerSwitch_IsChecked = false
local NoffiticationFrogerSwitch = Drawing.new("Square")
NoffiticationFrogerSwitch.Visible = false
NoffiticationFrogerSwitch.Transparency = 1
NoffiticationFrogerSwitch.Color = Color3.fromHex("#000000")
NoffiticationFrogerSwitch.Thickness = 1
NoffiticationFrogerSwitch.Filled = false
NoffiticationFrogerSwitch.Size = Vector2.new(30, 13)
NoffiticationFrogerSwitch.Position = Vector2.new(614, 315)
NoffiticationFrogerSwitch.ZIndex = 200
NoffiticationFrogerSwitch.Corner = 15
local NoffiticationFrogerSwitch_Bg = Drawing.new("Square")
NoffiticationFrogerSwitch_Bg.Visible = false
NoffiticationFrogerSwitch_Bg.Transparency = 1
NoffiticationFrogerSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationFrogerSwitch_Bg.Filled = true
NoffiticationFrogerSwitch_Bg.Size = NoffiticationFrogerSwitch.Size
NoffiticationFrogerSwitch_Bg.Position = NoffiticationFrogerSwitch.Position
NoffiticationFrogerSwitch_Bg.ZIndex = 200
NoffiticationFrogerSwitch_Bg.Corner = 15
local NoffiticationFrogerSwitch_IndBorder = Drawing.new("Square")
NoffiticationFrogerSwitch_IndBorder.Visible = false
NoffiticationFrogerSwitch_IndBorder.Transparency = 1
NoffiticationFrogerSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationFrogerSwitch_IndBorder.Thickness = 1
NoffiticationFrogerSwitch_IndBorder.Filled = false
NoffiticationFrogerSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationFrogerSwitch_IndBorder.ZIndex = 202
NoffiticationFrogerSwitch_IndBorder.Corner = 15
local NoffiticationFrogerSwitch_Ind = Drawing.new("Square")
NoffiticationFrogerSwitch_Ind.Visible = false
NoffiticationFrogerSwitch_Ind.Transparency = 1
NoffiticationFrogerSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationFrogerSwitch_Ind.Filled = true
NoffiticationFrogerSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationFrogerSwitch_Ind.ZIndex = 202
NoffiticationFrogerSwitch_Ind.Corner = 15
if NoffiticationFrogerSwitch_IsChecked then
    NoffiticationFrogerSwitch_IndBorder.Position = NoffiticationFrogerSwitch.Position + Vector2.new(18, 1)
    NoffiticationFrogerSwitch_Ind.Position = NoffiticationFrogerSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationFrogerSwitch_IndBorder.Position = NoffiticationFrogerSwitch.Position + Vector2.new(1, 1)
    NoffiticationFrogerSwitch_Ind.Position = NoffiticationFrogerSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationFrogerSwitch_Label = Drawing.new("Text")
NoffiticationFrogerSwitch_Label.Visible = false
NoffiticationFrogerSwitch_Label.Text = ""
NoffiticationFrogerSwitch_Label.Size = 12
NoffiticationFrogerSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationFrogerSwitch_Label.Outline = true
NoffiticationFrogerSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationFrogerSwitch_Label.Position = NoffiticationFrogerSwitch.Position + Vector2.new(40, 0.5)
NoffiticationFrogerSwitch_Label.ZIndex = 201

local NoffiticationPinkieSwitch = Drawing.new("Switch")
NoffiticationPinkieSwitch.Visible = false
NoffiticationPinkieSwitch.Transparency = 1
NoffiticationPinkieSwitch.ZIndex = 210
NoffiticationPinkieSwitch.Color = Color3.fromHex("#212121")
NoffiticationPinkieSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 201)

local NoffiticationPinkieSwitch_IsChecked = false
local NoffiticationPinkieSwitch = Drawing.new("Square")
NoffiticationPinkieSwitch.Visible = false
NoffiticationPinkieSwitch.Transparency = 1
NoffiticationPinkieSwitch.Color = Color3.fromHex("#000000")
NoffiticationPinkieSwitch.Thickness = 1
NoffiticationPinkieSwitch.Filled = false
NoffiticationPinkieSwitch.Size = Vector2.new(30, 13)
NoffiticationPinkieSwitch.Position = Vector2.new(614, 335)
NoffiticationPinkieSwitch.ZIndex = 210
NoffiticationPinkieSwitch.Corner = 15
local NoffiticationPinkieSwitch_Bg = Drawing.new("Square")
NoffiticationPinkieSwitch_Bg.Visible = false
NoffiticationPinkieSwitch_Bg.Transparency = 1
NoffiticationPinkieSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationPinkieSwitch_Bg.Filled = true
NoffiticationPinkieSwitch_Bg.Size = NoffiticationPinkieSwitch.Size
NoffiticationPinkieSwitch_Bg.Position = NoffiticationPinkieSwitch.Position
NoffiticationPinkieSwitch_Bg.ZIndex = 210
NoffiticationPinkieSwitch_Bg.Corner = 15
local NoffiticationPinkieSwitch_IndBorder = Drawing.new("Square")
NoffiticationPinkieSwitch_IndBorder.Visible = false
NoffiticationPinkieSwitch_IndBorder.Transparency = 1
NoffiticationPinkieSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationPinkieSwitch_IndBorder.Thickness = 1
NoffiticationPinkieSwitch_IndBorder.Filled = false
NoffiticationPinkieSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationPinkieSwitch_IndBorder.ZIndex = 212
NoffiticationPinkieSwitch_IndBorder.Corner = 15
local NoffiticationPinkieSwitch_Ind = Drawing.new("Square")
NoffiticationPinkieSwitch_Ind.Visible = false
NoffiticationPinkieSwitch_Ind.Transparency = 1
NoffiticationPinkieSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationPinkieSwitch_Ind.Filled = true
NoffiticationPinkieSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationPinkieSwitch_Ind.ZIndex = 212
NoffiticationPinkieSwitch_Ind.Corner = 15
if NoffiticationPinkieSwitch_IsChecked then
    NoffiticationPinkieSwitch_IndBorder.Position = NoffiticationPinkieSwitch.Position + Vector2.new(18, 1)
    NoffiticationPinkieSwitch_Ind.Position = NoffiticationPinkieSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationPinkieSwitch_IndBorder.Position = NoffiticationPinkieSwitch.Position + Vector2.new(1, 1)
    NoffiticationPinkieSwitch_Ind.Position = NoffiticationPinkieSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationPinkieSwitch_Label = Drawing.new("Text")
NoffiticationPinkieSwitch_Label.Visible = false
NoffiticationPinkieSwitch_Label.Text = ""
NoffiticationPinkieSwitch_Label.Size = 12
NoffiticationPinkieSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationPinkieSwitch_Label.Outline = true
NoffiticationPinkieSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationPinkieSwitch_Label.Position = NoffiticationPinkieSwitch.Position + Vector2.new(40, 0.5)
NoffiticationPinkieSwitch_Label.ZIndex = 211

local NoffiticationBlitzSwitch = Drawing.new("Switch")
NoffiticationBlitzSwitch.Visible = false
NoffiticationBlitzSwitch.Transparency = 1
NoffiticationBlitzSwitch.ZIndex = 220
NoffiticationBlitzSwitch.Color = Color3.fromHex("#212121")
NoffiticationBlitzSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 221)

local NoffiticationBlitzSwitch_IsChecked = false
local NoffiticationBlitzSwitch = Drawing.new("Square")
NoffiticationBlitzSwitch.Visible = false
NoffiticationBlitzSwitch.Transparency = 1
NoffiticationBlitzSwitch.Color = Color3.fromHex("#000000")
NoffiticationBlitzSwitch.Thickness = 1
NoffiticationBlitzSwitch.Filled = false
NoffiticationBlitzSwitch.Size = Vector2.new(30, 13)
NoffiticationBlitzSwitch.Position = Vector2.new(614, 355)
NoffiticationBlitzSwitch.ZIndex = 220
NoffiticationBlitzSwitch.Corner = 15
local NoffiticationBlitzSwitch_Bg = Drawing.new("Square")
NoffiticationBlitzSwitch_Bg.Visible = false
NoffiticationBlitzSwitch_Bg.Transparency = 1
NoffiticationBlitzSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationBlitzSwitch_Bg.Filled = true
NoffiticationBlitzSwitch_Bg.Size = NoffiticationBlitzSwitch.Size
NoffiticationBlitzSwitch_Bg.Position = NoffiticationBlitzSwitch.Position
NoffiticationBlitzSwitch_Bg.ZIndex = 220
NoffiticationBlitzSwitch_Bg.Corner = 15
local NoffiticationBlitzSwitch_IndBorder = Drawing.new("Square")
NoffiticationBlitzSwitch_IndBorder.Visible = false
NoffiticationBlitzSwitch_IndBorder.Transparency = 1
NoffiticationBlitzSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationBlitzSwitch_IndBorder.Thickness = 1
NoffiticationBlitzSwitch_IndBorder.Filled = false
NoffiticationBlitzSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationBlitzSwitch_IndBorder.ZIndex = 222
NoffiticationBlitzSwitch_IndBorder.Corner = 15
local NoffiticationBlitzSwitch_Ind = Drawing.new("Square")
NoffiticationBlitzSwitch_Ind.Visible = false
NoffiticationBlitzSwitch_Ind.Transparency = 1
NoffiticationBlitzSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationBlitzSwitch_Ind.Filled = true
NoffiticationBlitzSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationBlitzSwitch_Ind.ZIndex = 222
NoffiticationBlitzSwitch_Ind.Corner = 15
if NoffiticationBlitzSwitch_IsChecked then
    NoffiticationBlitzSwitch_IndBorder.Position = NoffiticationBlitzSwitch.Position + Vector2.new(18, 1)
    NoffiticationBlitzSwitch_Ind.Position = NoffiticationBlitzSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationBlitzSwitch_IndBorder.Position = NoffiticationBlitzSwitch.Position + Vector2.new(1, 1)
    NoffiticationBlitzSwitch_Ind.Position = NoffiticationBlitzSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationBlitzSwitch_Label = Drawing.new("Text")
NoffiticationBlitzSwitch_Label.Visible = false
NoffiticationBlitzSwitch_Label.Text = ""
NoffiticationBlitzSwitch_Label.Size = 12
NoffiticationBlitzSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationBlitzSwitch_Label.Outline = true
NoffiticationBlitzSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationBlitzSwitch_Label.Position = NoffiticationBlitzSwitch.Position + Vector2.new(40, 0.5)
NoffiticationBlitzSwitch_Label.ZIndex = 221

local NoffiticationChainsmokerSwitch = Drawing.new("Switch")
NoffiticationChainsmokerSwitch.Visible = false
NoffiticationChainsmokerSwitch.Transparency = 1
NoffiticationChainsmokerSwitch.ZIndex = 230
NoffiticationChainsmokerSwitch.Color = Color3.fromHex("#212121")
NoffiticationChainsmokerSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 241)

local NoffiticationChainsmokerSwitch_IsChecked = false
local NoffiticationChainsmokerSwitch = Drawing.new("Square")
NoffiticationChainsmokerSwitch.Visible = false
NoffiticationChainsmokerSwitch.Transparency = 1
NoffiticationChainsmokerSwitch.Color = Color3.fromHex("#000000")
NoffiticationChainsmokerSwitch.Thickness = 1
NoffiticationChainsmokerSwitch.Filled = false
NoffiticationChainsmokerSwitch.Size = Vector2.new(30, 13)
NoffiticationChainsmokerSwitch.Position = Vector2.new(614, 375)
NoffiticationChainsmokerSwitch.ZIndex = 230
NoffiticationChainsmokerSwitch.Corner = 15
local NoffiticationChainsmokerSwitch_Bg = Drawing.new("Square")
NoffiticationChainsmokerSwitch_Bg.Visible = false
NoffiticationChainsmokerSwitch_Bg.Transparency = 1
NoffiticationChainsmokerSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationChainsmokerSwitch_Bg.Filled = true
NoffiticationChainsmokerSwitch_Bg.Size = NoffiticationChainsmokerSwitch.Size
NoffiticationChainsmokerSwitch_Bg.Position = NoffiticationChainsmokerSwitch.Position
NoffiticationChainsmokerSwitch_Bg.ZIndex = 230
NoffiticationChainsmokerSwitch_Bg.Corner = 15
local NoffiticationChainsmokerSwitch_IndBorder = Drawing.new("Square")
NoffiticationChainsmokerSwitch_IndBorder.Visible = false
NoffiticationChainsmokerSwitch_IndBorder.Transparency = 1
NoffiticationChainsmokerSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationChainsmokerSwitch_IndBorder.Thickness = 1
NoffiticationChainsmokerSwitch_IndBorder.Filled = false
NoffiticationChainsmokerSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationChainsmokerSwitch_IndBorder.ZIndex = 232
NoffiticationChainsmokerSwitch_IndBorder.Corner = 15
local NoffiticationChainsmokerSwitch_Ind = Drawing.new("Square")
NoffiticationChainsmokerSwitch_Ind.Visible = false
NoffiticationChainsmokerSwitch_Ind.Transparency = 1
NoffiticationChainsmokerSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationChainsmokerSwitch_Ind.Filled = true
NoffiticationChainsmokerSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationChainsmokerSwitch_Ind.ZIndex = 232
NoffiticationChainsmokerSwitch_Ind.Corner = 15
if NoffiticationChainsmokerSwitch_IsChecked then
    NoffiticationChainsmokerSwitch_IndBorder.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(18, 1)
    NoffiticationChainsmokerSwitch_Ind.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationChainsmokerSwitch_IndBorder.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(1, 1)
    NoffiticationChainsmokerSwitch_Ind.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationChainsmokerSwitch_Label = Drawing.new("Text")
NoffiticationChainsmokerSwitch_Label.Visible = false
NoffiticationChainsmokerSwitch_Label.Text = ""
NoffiticationChainsmokerSwitch_Label.Size = 12
NoffiticationChainsmokerSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationChainsmokerSwitch_Label.Outline = true
NoffiticationChainsmokerSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationChainsmokerSwitch_Label.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(40, 0.5)
NoffiticationChainsmokerSwitch_Label.ZIndex = 231

local NoffiticationPandemoniumSwitch = Drawing.new("Switch")
NoffiticationPandemoniumSwitch.Visible = false
NoffiticationPandemoniumSwitch.Transparency = 1
NoffiticationPandemoniumSwitch.ZIndex = 240
NoffiticationPandemoniumSwitch.Color = Color3.fromHex("#212121")
NoffiticationPandemoniumSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 261)

local NoffiticationPandemoniumSwitch_IsChecked = false
local NoffiticationPandemoniumSwitch = Drawing.new("Square")
NoffiticationPandemoniumSwitch.Visible = false
NoffiticationPandemoniumSwitch.Transparency = 1
NoffiticationPandemoniumSwitch.Color = Color3.fromHex("#000000")
NoffiticationPandemoniumSwitch.Thickness = 1
NoffiticationPandemoniumSwitch.Filled = false
NoffiticationPandemoniumSwitch.Size = Vector2.new(30, 13)
NoffiticationPandemoniumSwitch.Position = Vector2.new(614, 395)
NoffiticationPandemoniumSwitch.ZIndex = 240
NoffiticationPandemoniumSwitch.Corner = 15
local NoffiticationPandemoniumSwitch_Bg = Drawing.new("Square")
NoffiticationPandemoniumSwitch_Bg.Visible = false
NoffiticationPandemoniumSwitch_Bg.Transparency = 1
NoffiticationPandemoniumSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationPandemoniumSwitch_Bg.Filled = true
NoffiticationPandemoniumSwitch_Bg.Size = NoffiticationPandemoniumSwitch.Size
NoffiticationPandemoniumSwitch_Bg.Position = NoffiticationPandemoniumSwitch.Position
NoffiticationPandemoniumSwitch_Bg.ZIndex = 240
NoffiticationPandemoniumSwitch_Bg.Corner = 15
local NoffiticationPandemoniumSwitch_IndBorder = Drawing.new("Square")
NoffiticationPandemoniumSwitch_IndBorder.Visible = false
NoffiticationPandemoniumSwitch_IndBorder.Transparency = 1
NoffiticationPandemoniumSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationPandemoniumSwitch_IndBorder.Thickness = 1
NoffiticationPandemoniumSwitch_IndBorder.Filled = false
NoffiticationPandemoniumSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationPandemoniumSwitch_IndBorder.ZIndex = 242
NoffiticationPandemoniumSwitch_IndBorder.Corner = 15
local NoffiticationPandemoniumSwitch_Ind = Drawing.new("Square")
NoffiticationPandemoniumSwitch_Ind.Visible = false
NoffiticationPandemoniumSwitch_Ind.Transparency = 1
NoffiticationPandemoniumSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationPandemoniumSwitch_Ind.Filled = true
NoffiticationPandemoniumSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationPandemoniumSwitch_Ind.ZIndex = 242
NoffiticationPandemoniumSwitch_Ind.Corner = 15
if NoffiticationPandemoniumSwitch_IsChecked then
    NoffiticationPandemoniumSwitch_IndBorder.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(18, 1)
    NoffiticationPandemoniumSwitch_Ind.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationPandemoniumSwitch_IndBorder.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(1, 1)
    NoffiticationPandemoniumSwitch_Ind.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationPandemoniumSwitch_Label = Drawing.new("Text")
NoffiticationPandemoniumSwitch_Label.Visible = false
NoffiticationPandemoniumSwitch_Label.Text = ""
NoffiticationPandemoniumSwitch_Label.Size = 12
NoffiticationPandemoniumSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationPandemoniumSwitch_Label.Outline = true
NoffiticationPandemoniumSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationPandemoniumSwitch_Label.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(40, 0.5)
NoffiticationPandemoniumSwitch_Label.ZIndex = 241

local NoffiticationA60Switch = Drawing.new("Switch")
NoffiticationA60Switch.Visible = false
NoffiticationA60Switch.Transparency = 1
NoffiticationA60Switch.ZIndex = 250
NoffiticationA60Switch.Color = Color3.fromHex("#212121")
NoffiticationA60Switch.Position = ContentPageVisuals.Position + Vector2.new(491, 281)

local NoffiticationA60Switch_IsChecked = false
local NoffiticationA60Switch = Drawing.new("Square")
NoffiticationA60Switch.Visible = false
NoffiticationA60Switch.Transparency = 1
NoffiticationA60Switch.Color = Color3.fromHex("#000000")
NoffiticationA60Switch.Thickness = 1
NoffiticationA60Switch.Filled = false
NoffiticationA60Switch.Size = Vector2.new(30, 13)
NoffiticationA60Switch.Position = Vector2.new(614, 415)
NoffiticationA60Switch.ZIndex = 250
NoffiticationA60Switch.Corner = 15
local NoffiticationA60Switch_Bg = Drawing.new("Square")
NoffiticationA60Switch_Bg.Visible = false
NoffiticationA60Switch_Bg.Transparency = 1
NoffiticationA60Switch_Bg.Color = Color3.fromHex("#212121")
NoffiticationA60Switch_Bg.Filled = true
NoffiticationA60Switch_Bg.Size = NoffiticationA60Switch.Size
NoffiticationA60Switch_Bg.Position = NoffiticationA60Switch.Position
NoffiticationA60Switch_Bg.ZIndex = 250
NoffiticationA60Switch_Bg.Corner = 15
local NoffiticationA60Switch_IndBorder = Drawing.new("Square")
NoffiticationA60Switch_IndBorder.Visible = false
NoffiticationA60Switch_IndBorder.Transparency = 1
NoffiticationA60Switch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationA60Switch_IndBorder.Thickness = 1
NoffiticationA60Switch_IndBorder.Filled = false
NoffiticationA60Switch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationA60Switch_IndBorder.ZIndex = 252
NoffiticationA60Switch_IndBorder.Corner = 15
local NoffiticationA60Switch_Ind = Drawing.new("Square")
NoffiticationA60Switch_Ind.Visible = false
NoffiticationA60Switch_Ind.Transparency = 1
NoffiticationA60Switch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationA60Switch_Ind.Filled = true
NoffiticationA60Switch_Ind.Size = Vector2.new(11, 11)
NoffiticationA60Switch_Ind.ZIndex = 252
NoffiticationA60Switch_Ind.Corner = 15
if NoffiticationA60Switch_IsChecked then
    NoffiticationA60Switch_IndBorder.Position = NoffiticationA60Switch.Position + Vector2.new(18, 1)
    NoffiticationA60Switch_Ind.Position = NoffiticationA60Switch.Position + Vector2.new(18, 1)
else
    NoffiticationA60Switch_IndBorder.Position = NoffiticationA60Switch.Position + Vector2.new(1, 1)
    NoffiticationA60Switch_Ind.Position = NoffiticationA60Switch.Position + Vector2.new(1, 1)
end
local NoffiticationA60Switch_Label = Drawing.new("Text")
NoffiticationA60Switch_Label.Visible = false
NoffiticationA60Switch_Label.Text = ""
NoffiticationA60Switch_Label.Size = 12
NoffiticationA60Switch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationA60Switch_Label.Outline = true
NoffiticationA60Switch_Label.Font = Drawing.Fonts.UI
NoffiticationA60Switch_Label.Position = NoffiticationA60Switch.Position + Vector2.new(40, 0.5)
NoffiticationA60Switch_Label.ZIndex = 251

local NoffiticationHarbingerSwitch = Drawing.new("Switch")
NoffiticationHarbingerSwitch.Visible = false
NoffiticationHarbingerSwitch.Transparency = 1
NoffiticationHarbingerSwitch.ZIndex = 260
NoffiticationHarbingerSwitch.Color = Color3.fromHex("#212121")
NoffiticationHarbingerSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 301)

local NoffiticationHarbingerSwitch_IsChecked = false
local NoffiticationHarbingerSwitch = Drawing.new("Square")
NoffiticationHarbingerSwitch.Visible = false
NoffiticationHarbingerSwitch.Transparency = 1
NoffiticationHarbingerSwitch.Color = Color3.fromHex("#000000")
NoffiticationHarbingerSwitch.Thickness = 1
NoffiticationHarbingerSwitch.Filled = false
NoffiticationHarbingerSwitch.Size = Vector2.new(30, 13)
NoffiticationHarbingerSwitch.Position = Vector2.new(614, 435)
NoffiticationHarbingerSwitch.ZIndex = 260
NoffiticationHarbingerSwitch.Corner = 15
local NoffiticationHarbingerSwitch_Bg = Drawing.new("Square")
NoffiticationHarbingerSwitch_Bg.Visible = false
NoffiticationHarbingerSwitch_Bg.Transparency = 1
NoffiticationHarbingerSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationHarbingerSwitch_Bg.Filled = true
NoffiticationHarbingerSwitch_Bg.Size = NoffiticationHarbingerSwitch.Size
NoffiticationHarbingerSwitch_Bg.Position = NoffiticationHarbingerSwitch.Position
NoffiticationHarbingerSwitch_Bg.ZIndex = 260
NoffiticationHarbingerSwitch_Bg.Corner = 15
local NoffiticationHarbingerSwitch_IndBorder = Drawing.new("Square")
NoffiticationHarbingerSwitch_IndBorder.Visible = false
NoffiticationHarbingerSwitch_IndBorder.Transparency = 1
NoffiticationHarbingerSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationHarbingerSwitch_IndBorder.Thickness = 1
NoffiticationHarbingerSwitch_IndBorder.Filled = false
NoffiticationHarbingerSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationHarbingerSwitch_IndBorder.ZIndex = 262
NoffiticationHarbingerSwitch_IndBorder.Corner = 15
local NoffiticationHarbingerSwitch_Ind = Drawing.new("Square")
NoffiticationHarbingerSwitch_Ind.Visible = false
NoffiticationHarbingerSwitch_Ind.Transparency = 1
NoffiticationHarbingerSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationHarbingerSwitch_Ind.Filled = true
NoffiticationHarbingerSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationHarbingerSwitch_Ind.ZIndex = 262
NoffiticationHarbingerSwitch_Ind.Corner = 15
if NoffiticationHarbingerSwitch_IsChecked then
    NoffiticationHarbingerSwitch_IndBorder.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(18, 1)
    NoffiticationHarbingerSwitch_Ind.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationHarbingerSwitch_IndBorder.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(1, 1)
    NoffiticationHarbingerSwitch_Ind.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationHarbingerSwitch_Label = Drawing.new("Text")
NoffiticationHarbingerSwitch_Label.Visible = false
NoffiticationHarbingerSwitch_Label.Text = ""
NoffiticationHarbingerSwitch_Label.Size = 12
NoffiticationHarbingerSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationHarbingerSwitch_Label.Outline = true
NoffiticationHarbingerSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationHarbingerSwitch_Label.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(40, 0.5)
NoffiticationHarbingerSwitch_Label.ZIndex = 261

local NoffiticationPainterRoomSwitch = Drawing.new("Switch")
NoffiticationPainterRoomSwitch.Visible = false
NoffiticationPainterRoomSwitch.Transparency = 1
NoffiticationPainterRoomSwitch.ZIndex = 270
NoffiticationPainterRoomSwitch.Color = Color3.fromHex("#212121")
NoffiticationPainterRoomSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 321)

local NoffiticationPainterRoomSwitch_IsChecked = false
local NoffiticationPainterRoomSwitch = Drawing.new("Square")
NoffiticationPainterRoomSwitch.Visible = false
NoffiticationPainterRoomSwitch.Transparency = 1
NoffiticationPainterRoomSwitch.Color = Color3.fromHex("#000000")
NoffiticationPainterRoomSwitch.Thickness = 1
NoffiticationPainterRoomSwitch.Filled = false
NoffiticationPainterRoomSwitch.Size = Vector2.new(30, 13)
NoffiticationPainterRoomSwitch.Position = Vector2.new(614, 455)
NoffiticationPainterRoomSwitch.ZIndex = 270
NoffiticationPainterRoomSwitch.Corner = 15
local NoffiticationPainterRoomSwitch_Bg = Drawing.new("Square")
NoffiticationPainterRoomSwitch_Bg.Visible = false
NoffiticationPainterRoomSwitch_Bg.Transparency = 1
NoffiticationPainterRoomSwitch_Bg.Color = Color3.fromHex("#212121")
NoffiticationPainterRoomSwitch_Bg.Filled = true
NoffiticationPainterRoomSwitch_Bg.Size = NoffiticationPainterRoomSwitch.Size
NoffiticationPainterRoomSwitch_Bg.Position = NoffiticationPainterRoomSwitch.Position
NoffiticationPainterRoomSwitch_Bg.ZIndex = 270
NoffiticationPainterRoomSwitch_Bg.Corner = 15
local NoffiticationPainterRoomSwitch_IndBorder = Drawing.new("Square")
NoffiticationPainterRoomSwitch_IndBorder.Visible = false
NoffiticationPainterRoomSwitch_IndBorder.Transparency = 1
NoffiticationPainterRoomSwitch_IndBorder.Color = Color3.fromHex("#000000")
NoffiticationPainterRoomSwitch_IndBorder.Thickness = 1
NoffiticationPainterRoomSwitch_IndBorder.Filled = false
NoffiticationPainterRoomSwitch_IndBorder.Size = Vector2.new(11, 11)
NoffiticationPainterRoomSwitch_IndBorder.ZIndex = 272
NoffiticationPainterRoomSwitch_IndBorder.Corner = 15
local NoffiticationPainterRoomSwitch_Ind = Drawing.new("Square")
NoffiticationPainterRoomSwitch_Ind.Visible = false
NoffiticationPainterRoomSwitch_Ind.Transparency = 1
NoffiticationPainterRoomSwitch_Ind.Color = Color3.fromHex("#ffffff")
NoffiticationPainterRoomSwitch_Ind.Filled = true
NoffiticationPainterRoomSwitch_Ind.Size = Vector2.new(11, 11)
NoffiticationPainterRoomSwitch_Ind.ZIndex = 272
NoffiticationPainterRoomSwitch_Ind.Corner = 15
if NoffiticationPainterRoomSwitch_IsChecked then
    NoffiticationPainterRoomSwitch_IndBorder.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(18, 1)
    NoffiticationPainterRoomSwitch_Ind.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(18, 1)
else
    NoffiticationPainterRoomSwitch_IndBorder.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(1, 1)
    NoffiticationPainterRoomSwitch_Ind.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(1, 1)
end
local NoffiticationPainterRoomSwitch_Label = Drawing.new("Text")
NoffiticationPainterRoomSwitch_Label.Visible = false
NoffiticationPainterRoomSwitch_Label.Text = ""
NoffiticationPainterRoomSwitch_Label.Size = 12
NoffiticationPainterRoomSwitch_Label.Color = Color3.fromHex("#FFFFFF")
NoffiticationPainterRoomSwitch_Label.Outline = true
NoffiticationPainterRoomSwitch_Label.Font = Drawing.Fonts.UI
NoffiticationPainterRoomSwitch_Label.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(40, 0.5)
NoffiticationPainterRoomSwitch_Label.ZIndex = 271

local ContentPageVisuals3 = Drawing.new("Square")
ContentPageVisuals3.Visible = false
ContentPageVisuals3.Transparency = 1
ContentPageVisuals3.ZIndex = 140
ContentPageVisuals3.Color = Color3.fromHex("#0c1020")
ContentPageVisuals3.Position = ContentPageVisuals.Position + Vector2.new(0, 363)
ContentPageVisuals3.Size = Vector2.new(534, 52)
ContentPageVisuals3.Filled = true
ContentPageVisuals3.Corner = 5

local ContentPageVisuals3_Border = Drawing.new("Square")
ContentPageVisuals3_Border.Visible = false
ContentPageVisuals3_Border.Transparency = 1
ContentPageVisuals3_Border.ZIndex = 141
ContentPageVisuals3_Border.Color = Color3.fromHex("#13172a")
ContentPageVisuals3_Border.Filled = false
ContentPageVisuals3_Border.Thickness = 3
ContentPageVisuals3_Border.Position = ContentPageVisuals3.Position
ContentPageVisuals3_Border.Size = ContentPageVisuals3.Size
ContentPageVisuals3_Border.Corner = 5

local EnableWatermarkText = Drawing.new("Text")
EnableWatermarkText.Visible = false
EnableWatermarkText.Transparency = 1
EnableWatermarkText.ZIndex = 430
EnableWatermarkText.Color = Color3.fromHex("#e5e4d3")
EnableWatermarkText.Position = ContentPageVisuals.Position + Vector2.new(9, 371)
EnableWatermarkText.Text = "Watermark"
EnableWatermarkText.Size = 14
EnableWatermarkText.Center = false
EnableWatermarkText.Outline = true
EnableWatermarkText.Font = Drawing.Fonts.Monospace

local EnableWatermarkSwitch = Drawing.new("Switch")
EnableWatermarkSwitch.Visible = false
EnableWatermarkSwitch.Transparency = 1
EnableWatermarkSwitch.ZIndex = 280
EnableWatermarkSwitch.Color = Color3.fromHex("#212121")
EnableWatermarkSwitch.Position = ContentPageVisuals.Position + Vector2.new(491, 371)

local EnableWatermarkSwitch_IsChecked = false
local EnableWatermarkSwitch = Drawing.new("Square")
EnableWatermarkSwitch.Visible = false
EnableWatermarkSwitch.Transparency = 1
EnableWatermarkSwitch.Color = Color3.fromHex("#000000")
EnableWatermarkSwitch.Thickness = 1
EnableWatermarkSwitch.Filled = false
EnableWatermarkSwitch.Size = Vector2.new(30, 13)
EnableWatermarkSwitch.Position = Vector2.new(614, 505)
EnableWatermarkSwitch.ZIndex = 280
EnableWatermarkSwitch.Corner = 15
local EnableWatermarkSwitch_Bg = Drawing.new("Square")
EnableWatermarkSwitch_Bg.Visible = false
EnableWatermarkSwitch_Bg.Transparency = 1
EnableWatermarkSwitch_Bg.Color = Color3.fromHex("#212121")
EnableWatermarkSwitch_Bg.Filled = true
EnableWatermarkSwitch_Bg.Size = EnableWatermarkSwitch.Size
EnableWatermarkSwitch_Bg.Position = EnableWatermarkSwitch.Position
EnableWatermarkSwitch_Bg.ZIndex = 280
EnableWatermarkSwitch_Bg.Corner = 15
local EnableWatermarkSwitch_IndBorder = Drawing.new("Square")
EnableWatermarkSwitch_IndBorder.Visible = false
EnableWatermarkSwitch_IndBorder.Transparency = 1
EnableWatermarkSwitch_IndBorder.Color = Color3.fromHex("#000000")
EnableWatermarkSwitch_IndBorder.Thickness = 1
EnableWatermarkSwitch_IndBorder.Filled = false
EnableWatermarkSwitch_IndBorder.Size = Vector2.new(11, 11)
EnableWatermarkSwitch_IndBorder.ZIndex = 282
EnableWatermarkSwitch_IndBorder.Corner = 15
local EnableWatermarkSwitch_Ind = Drawing.new("Square")
EnableWatermarkSwitch_Ind.Visible = false
EnableWatermarkSwitch_Ind.Transparency = 1
EnableWatermarkSwitch_Ind.Color = Color3.fromHex("#ffffff")
EnableWatermarkSwitch_Ind.Filled = true
EnableWatermarkSwitch_Ind.Size = Vector2.new(11, 11)
EnableWatermarkSwitch_Ind.ZIndex = 282
EnableWatermarkSwitch_Ind.Corner = 15
if EnableWatermarkSwitch_IsChecked then
    EnableWatermarkSwitch_IndBorder.Position = EnableWatermarkSwitch.Position + Vector2.new(18, 1)
    EnableWatermarkSwitch_Ind.Position = EnableWatermarkSwitch.Position + Vector2.new(18, 1)
else
    EnableWatermarkSwitch_IndBorder.Position = EnableWatermarkSwitch.Position + Vector2.new(1, 1)
    EnableWatermarkSwitch_Ind.Position = EnableWatermarkSwitch.Position + Vector2.new(1, 1)
end
local EnableWatermarkSwitch_Label = Drawing.new("Text")
EnableWatermarkSwitch_Label.Visible = false
EnableWatermarkSwitch_Label.Text = ""
EnableWatermarkSwitch_Label.Size = 12
EnableWatermarkSwitch_Label.Color = Color3.fromHex("#FFFFFF")
EnableWatermarkSwitch_Label.Outline = true
EnableWatermarkSwitch_Label.Font = Drawing.Fonts.UI
EnableWatermarkSwitch_Label.Position = EnableWatermarkSwitch.Position + Vector2.new(40, 0.5)
EnableWatermarkSwitch_Label.ZIndex = 281

local ContentPageExploits = Drawing.new("Square")
ContentPageExploits.Visible = false
ContentPageExploits.Transparency = 1
ContentPageExploits.ZIndex = 440
ContentPageExploits.Color = Color3.fromHex("#0c1020")
ContentPageExploits.Position = Main1.Position + Vector2.new(19, 107)
ContentPageExploits.Size = Vector2.new(532, 300)
ContentPageExploits.Filled = true
ContentPageExploits.Corner = 5

local ContentPageExploits_Border = Drawing.new("Square")
ContentPageExploits_Border.Visible = false
ContentPageExploits_Border.Transparency = 1
ContentPageExploits_Border.ZIndex = 441
ContentPageExploits_Border.Color = Color3.fromHex("#13172a")
ContentPageExploits_Border.Filled = false
ContentPageExploits_Border.Thickness = 3
ContentPageExploits_Border.Position = ContentPageExploits.Position
ContentPageExploits_Border.Size = ContentPageExploits.Size
ContentPageExploits_Border.Corner = 5

local AutoHideSwitch = Drawing.new("Switch")
AutoHideSwitch.Visible = false
AutoHideSwitch.Transparency = 1
AutoHideSwitch.ZIndex = 450
AutoHideSwitch.Color = Color3.fromHex("#212121")
AutoHideSwitch.Position = ContentPageExploits.Position + Vector2.new(474, 18)

local AutoHideSwitch_IsChecked = false
local AutoHideSwitch = Drawing.new("Square")
AutoHideSwitch.Visible = false
AutoHideSwitch.Transparency = 1
AutoHideSwitch.Color = Color3.fromHex("#000000")
AutoHideSwitch.Thickness = 1
AutoHideSwitch.Filled = false
AutoHideSwitch.Size = Vector2.new(40, 15)
AutoHideSwitch.Position = Vector2.new(591, 145)
AutoHideSwitch.ZIndex = 450
AutoHideSwitch.Corner = 15
local AutoHideSwitch_Bg = Drawing.new("Square")
AutoHideSwitch_Bg.Visible = false
AutoHideSwitch_Bg.Transparency = 1
AutoHideSwitch_Bg.Color = Color3.fromHex("#212121")
AutoHideSwitch_Bg.Filled = true
AutoHideSwitch_Bg.Size = AutoHideSwitch.Size
AutoHideSwitch_Bg.Position = AutoHideSwitch.Position
AutoHideSwitch_Bg.ZIndex = 450
AutoHideSwitch_Bg.Corner = 15
local AutoHideSwitch_IndBorder = Drawing.new("Square")
AutoHideSwitch_IndBorder.Visible = false
AutoHideSwitch_IndBorder.Transparency = 1
AutoHideSwitch_IndBorder.Color = Color3.fromHex("#000000")
AutoHideSwitch_IndBorder.Thickness = 1
AutoHideSwitch_IndBorder.Filled = false
AutoHideSwitch_IndBorder.Size = Vector2.new(13, 13)
AutoHideSwitch_IndBorder.ZIndex = 452
AutoHideSwitch_IndBorder.Corner = 15
local AutoHideSwitch_Ind = Drawing.new("Square")
AutoHideSwitch_Ind.Visible = false
AutoHideSwitch_Ind.Transparency = 1
AutoHideSwitch_Ind.Color = Color3.fromHex("#ffffff")
AutoHideSwitch_Ind.Filled = true
AutoHideSwitch_Ind.Size = Vector2.new(13, 13)
AutoHideSwitch_Ind.ZIndex = 452
AutoHideSwitch_Ind.Corner = 15
if AutoHideSwitch_IsChecked then
    AutoHideSwitch_IndBorder.Position = AutoHideSwitch.Position + Vector2.new(26, 1)
    AutoHideSwitch_Ind.Position = AutoHideSwitch.Position + Vector2.new(26, 1)
else
    AutoHideSwitch_IndBorder.Position = AutoHideSwitch.Position + Vector2.new(1, 1)
    AutoHideSwitch_Ind.Position = AutoHideSwitch.Position + Vector2.new(1, 1)
end
local AutoHideSwitch_Label = Drawing.new("Text")
AutoHideSwitch_Label.Visible = false
AutoHideSwitch_Label.Text = ""
AutoHideSwitch_Label.Size = 12
AutoHideSwitch_Label.Color = Color3.fromHex("#FFFFFF")
AutoHideSwitch_Label.Outline = true
AutoHideSwitch_Label.Font = Drawing.Fonts.UI
AutoHideSwitch_Label.Position = AutoHideSwitch.Position + Vector2.new(50, 1.5)
AutoHideSwitch_Label.ZIndex = 451

local AutoHideText = Drawing.new("Text")
AutoHideText.Visible = false
AutoHideText.Transparency = 1
AutoHideText.ZIndex = 460
AutoHideText.Color = Color3.fromHex("#e5e4d3")
AutoHideText.Position = ContentPageExploits.Position + Vector2.new(14, 18)
AutoHideText.Text = "AutoHide(Beta)"
AutoHideText.Size = 14
AutoHideText.Center = false
AutoHideText.Outline = true
AutoHideText.Font = Drawing.Fonts.Monospace

local ContentPageMisc = Drawing.new("Square")
ContentPageMisc.Visible = false
ContentPageMisc.Transparency = 1
ContentPageMisc.ZIndex = 470
ContentPageMisc.Color = Color3.fromHex("#0c1020")
ContentPageMisc.Position = Main1.Position + Vector2.new(14, 106)
ContentPageMisc.Size = Vector2.new(332, 150)
ContentPageMisc.Filled = true
ContentPageMisc.Corner = 5

local ContentPageMisc_Border = Drawing.new("Square")
ContentPageMisc_Border.Visible = false
ContentPageMisc_Border.Transparency = 1
ContentPageMisc_Border.ZIndex = 471
ContentPageMisc_Border.Color = Color3.fromHex("#13172a")
ContentPageMisc_Border.Filled = false
ContentPageMisc_Border.Thickness = 3
ContentPageMisc_Border.Position = ContentPageMisc.Position
ContentPageMisc_Border.Size = ContentPageMisc.Size
ContentPageMisc_Border.Corner = 5

local AutoRescanSwitch = Drawing.new("Switch")
AutoRescanSwitch.Visible = false
AutoRescanSwitch.Transparency = 1
AutoRescanSwitch.ZIndex = 500
AutoRescanSwitch.Color = Color3.fromHex("#212121")
AutoRescanSwitch.Position = ContentPageMisc.Position + Vector2.new(280, 18)

local AutoRescanSwitch_IsChecked = false
local AutoRescanSwitch = Drawing.new("Square")
AutoRescanSwitch.Visible = false
AutoRescanSwitch.Transparency = 1
AutoRescanSwitch.Color = Color3.fromHex("#000000")
AutoRescanSwitch.Thickness = 1
AutoRescanSwitch.Filled = false
AutoRescanSwitch.Size = Vector2.new(40, 15)
AutoRescanSwitch.Position = Vector2.new(392, 144)
AutoRescanSwitch.ZIndex = 500
AutoRescanSwitch.Corner = 15
local AutoRescanSwitch_Bg = Drawing.new("Square")
AutoRescanSwitch_Bg.Visible = false
AutoRescanSwitch_Bg.Transparency = 1
AutoRescanSwitch_Bg.Color = Color3.fromHex("#212121")
AutoRescanSwitch_Bg.Filled = true
AutoRescanSwitch_Bg.Size = AutoRescanSwitch.Size
AutoRescanSwitch_Bg.Position = AutoRescanSwitch.Position
AutoRescanSwitch_Bg.ZIndex = 500
AutoRescanSwitch_Bg.Corner = 15
local AutoRescanSwitch_IndBorder = Drawing.new("Square")
AutoRescanSwitch_IndBorder.Visible = false
AutoRescanSwitch_IndBorder.Transparency = 1
AutoRescanSwitch_IndBorder.Color = Color3.fromHex("#000000")
AutoRescanSwitch_IndBorder.Thickness = 1
AutoRescanSwitch_IndBorder.Filled = false
AutoRescanSwitch_IndBorder.Size = Vector2.new(13, 13)
AutoRescanSwitch_IndBorder.ZIndex = 502
AutoRescanSwitch_IndBorder.Corner = 15
local AutoRescanSwitch_Ind = Drawing.new("Square")
AutoRescanSwitch_Ind.Visible = false
AutoRescanSwitch_Ind.Transparency = 1
AutoRescanSwitch_Ind.Color = Color3.fromHex("#ffffff")
AutoRescanSwitch_Ind.Filled = true
AutoRescanSwitch_Ind.Size = Vector2.new(13, 13)
AutoRescanSwitch_Ind.ZIndex = 502
AutoRescanSwitch_Ind.Corner = 15
if AutoRescanSwitch_IsChecked then
    AutoRescanSwitch_IndBorder.Position = AutoRescanSwitch.Position + Vector2.new(26, 1)
    AutoRescanSwitch_Ind.Position = AutoRescanSwitch.Position + Vector2.new(26, 1)
else
    AutoRescanSwitch_IndBorder.Position = AutoRescanSwitch.Position + Vector2.new(1, 1)
    AutoRescanSwitch_Ind.Position = AutoRescanSwitch.Position + Vector2.new(1, 1)
end
local AutoRescanSwitch_Label = Drawing.new("Text")
AutoRescanSwitch_Label.Visible = false
AutoRescanSwitch_Label.Text = ""
AutoRescanSwitch_Label.Size = 12
AutoRescanSwitch_Label.Color = Color3.fromHex("#FFFFFF")
AutoRescanSwitch_Label.Outline = true
AutoRescanSwitch_Label.Font = Drawing.Fonts.UI
AutoRescanSwitch_Label.Position = AutoRescanSwitch.Position + Vector2.new(50, 1.5)
AutoRescanSwitch_Label.ZIndex = 501

local AutoRescanText = Drawing.new("Text")
AutoRescanText.Visible = false
AutoRescanText.Transparency = 1
AutoRescanText.ZIndex = 510
AutoRescanText.Color = Color3.fromHex("#eae0e2")
AutoRescanText.Position = ContentPageMisc.Position + Vector2.new(6, 18)
AutoRescanText.Text = "AutoRescan"
AutoRescanText.Size = 14
AutoRescanText.Center = false
AutoRescanText.Outline = true
AutoRescanText.Font = Drawing.Fonts.Monospace

local ContentPageSettings = Drawing.new("Square")
ContentPageSettings.Visible = false
ContentPageSettings.Transparency = 1
ContentPageSettings.ZIndex = 520
ContentPageSettings.Color = Color3.fromHex("#0c1020")
ContentPageSettings.Position = Main1.Position + Vector2.new(25, 111)
ContentPageSettings.Size = Vector2.new(332, 300)
ContentPageSettings.Filled = true
ContentPageSettings.Corner = 5

local ContentPageSettings_Border = Drawing.new("Square")
ContentPageSettings_Border.Visible = false
ContentPageSettings_Border.Transparency = 1
ContentPageSettings_Border.ZIndex = 521
ContentPageSettings_Border.Color = Color3.fromHex("#13172a")
ContentPageSettings_Border.Filled = false
ContentPageSettings_Border.Thickness = 3
ContentPageSettings_Border.Position = ContentPageSettings.Position
ContentPageSettings_Border.Size = ContentPageSettings.Size
ContentPageSettings_Border.Corner = 5

local ToggleUIvisiblity = Drawing.new("Square")
ToggleUIvisiblity.Visible = false
ToggleUIvisiblity.Transparency = 1
ToggleUIvisiblity.Color = Color3.fromHex("#6c11ae")
ToggleUIvisiblity.Filled = true
ToggleUIvisiblity.Size = Vector2.new(74, 16)
ToggleUIvisiblity.Position = Vector2.new(135, 145)
ToggleUIvisiblity.ZIndex = 530
ToggleUIvisiblity.Corner = 10
local ToggleUIvisiblity_Text = Drawing.new("Text")
ToggleUIvisiblity_Text.Text = "[ F1 ]"
ToggleUIvisiblity_Text.Size = 12
ToggleUIvisiblity_Text.Center = true
ToggleUIvisiblity_Text.Outline = true
ToggleUIvisiblity_Text.Font = 0
ToggleUIvisiblity_Text.Color = Color3.fromHex("#eae0e2")
ToggleUIvisiblity_Text.Position = ToggleUIvisiblity.Position + Vector2.new(74/2, 16/2)
ToggleUIvisiblity_Text.Visible = false
ToggleUIvisiblity_Text.ZIndex = 532
local ToggleUIvisiblity_Key = 0x70
local ToggleUIvisiblity_IsListening = false

local TextToRescanForce = Drawing.new("Text")
TextToRescanForce.Visible = false
TextToRescanForce.Transparency = 1
TextToRescanForce.ZIndex = 410
TextToRescanForce.Color = Color3.fromHex("#eedc17")
TextToRescanForce.Position = ContentPageVisuals.Position + Vector2.new(93, 9)
TextToRescanForce.Text = "To force-rescan tap F5"
TextToRescanForce.Size = 10
TextToRescanForce.Center = false
TextToRescanForce.Outline = false
TextToRescanForce.Font = Drawing.Fonts.SystemBold

local EspItemsText = Drawing.new("Text")
EspItemsText.Visible = false
EspItemsText.Transparency = 1
EspItemsText.ZIndex = 310
EspItemsText.Color = Color3.fromHex("#e5e4d3")
EspItemsText.Position = ContentPageVisuals.Position + Vector2.new(9, 58)
EspItemsText.Text = "ESP Items ALL"
EspItemsText.Size = 14
EspItemsText.Center = false
EspItemsText.Outline = true
EspItemsText.Font = Drawing.Fonts.Monospace

local SwitchForESPitems = Drawing.new("Switch")
SwitchForESPitems.Visible = false
SwitchForESPitems.Transparency = 1
SwitchForESPitems.ZIndex = 170
SwitchForESPitems.Color = Color3.fromHex("#212121")
SwitchForESPitems.Position = ContentPageVisuals.Position + Vector2.new(481, 58)

local SwitchForESPitems_IsChecked = false
local SwitchForESPitems = Drawing.new("Square")
SwitchForESPitems.Visible = false
SwitchForESPitems.Transparency = 1
SwitchForESPitems.Color = Color3.fromHex("#000000")
SwitchForESPitems.Thickness = 1
SwitchForESPitems.Filled = false
SwitchForESPitems.Size = Vector2.new(40, 20)
SwitchForESPitems.Position = Vector2.new(604, 192)
SwitchForESPitems.ZIndex = 170
SwitchForESPitems.Corner = 15
local SwitchForESPitems_Bg = Drawing.new("Square")
SwitchForESPitems_Bg.Visible = false
SwitchForESPitems_Bg.Transparency = 1
SwitchForESPitems_Bg.Color = Color3.fromHex("#212121")
SwitchForESPitems_Bg.Filled = true
SwitchForESPitems_Bg.Size = SwitchForESPitems.Size
SwitchForESPitems_Bg.Position = SwitchForESPitems.Position
SwitchForESPitems_Bg.ZIndex = 170
SwitchForESPitems_Bg.Corner = 15
local SwitchForESPitems_IndBorder = Drawing.new("Square")
SwitchForESPitems_IndBorder.Visible = false
SwitchForESPitems_IndBorder.Transparency = 1
SwitchForESPitems_IndBorder.Color = Color3.fromHex("#000000")
SwitchForESPitems_IndBorder.Thickness = 1
SwitchForESPitems_IndBorder.Filled = false
SwitchForESPitems_IndBorder.Size = Vector2.new(18, 18)
SwitchForESPitems_IndBorder.ZIndex = 172
SwitchForESPitems_IndBorder.Corner = 15
local SwitchForESPitems_Ind = Drawing.new("Square")
SwitchForESPitems_Ind.Visible = false
SwitchForESPitems_Ind.Transparency = 1
SwitchForESPitems_Ind.Color = Color3.fromHex("#ffffff")
SwitchForESPitems_Ind.Filled = true
SwitchForESPitems_Ind.Size = Vector2.new(18, 18)
SwitchForESPitems_Ind.ZIndex = 172
SwitchForESPitems_Ind.Corner = 15
if SwitchForESPitems_IsChecked then
    SwitchForESPitems_IndBorder.Position = SwitchForESPitems.Position + Vector2.new(21, 1)
    SwitchForESPitems_Ind.Position = SwitchForESPitems.Position + Vector2.new(21, 1)
else
    SwitchForESPitems_IndBorder.Position = SwitchForESPitems.Position + Vector2.new(1, 1)
    SwitchForESPitems_Ind.Position = SwitchForESPitems.Position + Vector2.new(1, 1)
end
local SwitchForESPitems_Label = Drawing.new("Text")
SwitchForESPitems_Label.Visible = false
SwitchForESPitems_Label.Text = ""
SwitchForESPitems_Label.Size = 12
SwitchForESPitems_Label.Color = Color3.fromHex("#FFFFFF")
SwitchForESPitems_Label.Outline = true
SwitchForESPitems_Label.Font = Drawing.Fonts.UI
SwitchForESPitems_Label.Position = SwitchForESPitems.Position + Vector2.new(50, 4)
SwitchForESPitems_Label.ZIndex = 171

local TextESPCurrency = Drawing.new("Text")
TextESPCurrency.Visible = false
TextESPCurrency.Transparency = 1
TextESPCurrency.ZIndex = 320
TextESPCurrency.Color = Color3.fromHex("#e5e4d3")
TextESPCurrency.Position = ContentPageVisuals.Position + Vector2.new(9, 84)
TextESPCurrency.Text = "ESP Currency ALL"
TextESPCurrency.Size = 14
TextESPCurrency.Center = false
TextESPCurrency.Outline = true
TextESPCurrency.Font = Drawing.Fonts.Monospace

local ESPswitchToCurrency = Drawing.new("Switch")
ESPswitchToCurrency.Visible = false
ESPswitchToCurrency.Transparency = 1
ESPswitchToCurrency.ZIndex = 180
ESPswitchToCurrency.Color = Color3.fromHex("#212121")
ESPswitchToCurrency.Position = ContentPageVisuals.Position + Vector2.new(481, 84)

local ESPswitchToCurrency_IsChecked = false
local ESPswitchToCurrency = Drawing.new("Square")
ESPswitchToCurrency.Visible = false
ESPswitchToCurrency.Transparency = 1
ESPswitchToCurrency.Color = Color3.fromHex("#000000")
ESPswitchToCurrency.Thickness = 1
ESPswitchToCurrency.Filled = false
ESPswitchToCurrency.Size = Vector2.new(40, 20)
ESPswitchToCurrency.Position = Vector2.new(604, 218)
ESPswitchToCurrency.ZIndex = 180
ESPswitchToCurrency.Corner = 15
local ESPswitchToCurrency_Bg = Drawing.new("Square")
ESPswitchToCurrency_Bg.Visible = false
ESPswitchToCurrency_Bg.Transparency = 1
ESPswitchToCurrency_Bg.Color = Color3.fromHex("#212121")
ESPswitchToCurrency_Bg.Filled = true
ESPswitchToCurrency_Bg.Size = ESPswitchToCurrency.Size
ESPswitchToCurrency_Bg.Position = ESPswitchToCurrency.Position
ESPswitchToCurrency_Bg.ZIndex = 180
ESPswitchToCurrency_Bg.Corner = 15
local ESPswitchToCurrency_IndBorder = Drawing.new("Square")
ESPswitchToCurrency_IndBorder.Visible = false
ESPswitchToCurrency_IndBorder.Transparency = 1
ESPswitchToCurrency_IndBorder.Color = Color3.fromHex("#000000")
ESPswitchToCurrency_IndBorder.Thickness = 1
ESPswitchToCurrency_IndBorder.Filled = false
ESPswitchToCurrency_IndBorder.Size = Vector2.new(18, 18)
ESPswitchToCurrency_IndBorder.ZIndex = 182
ESPswitchToCurrency_IndBorder.Corner = 15
local ESPswitchToCurrency_Ind = Drawing.new("Square")
ESPswitchToCurrency_Ind.Visible = false
ESPswitchToCurrency_Ind.Transparency = 1
ESPswitchToCurrency_Ind.Color = Color3.fromHex("#ffffff")
ESPswitchToCurrency_Ind.Filled = true
ESPswitchToCurrency_Ind.Size = Vector2.new(18, 18)
ESPswitchToCurrency_Ind.ZIndex = 182
ESPswitchToCurrency_Ind.Corner = 15
if ESPswitchToCurrency_IsChecked then
    ESPswitchToCurrency_IndBorder.Position = ESPswitchToCurrency.Position + Vector2.new(21, 1)
    ESPswitchToCurrency_Ind.Position = ESPswitchToCurrency.Position + Vector2.new(21, 1)
else
    ESPswitchToCurrency_IndBorder.Position = ESPswitchToCurrency.Position + Vector2.new(1, 1)
    ESPswitchToCurrency_Ind.Position = ESPswitchToCurrency.Position + Vector2.new(1, 1)
end
local ESPswitchToCurrency_Label = Drawing.new("Text")
ESPswitchToCurrency_Label.Visible = false
ESPswitchToCurrency_Label.Text = ""
ESPswitchToCurrency_Label.Size = 12
ESPswitchToCurrency_Label.Color = Color3.fromHex("#FFFFFF")
ESPswitchToCurrency_Label.Outline = true
ESPswitchToCurrency_Label.Font = Drawing.Fonts.UI
ESPswitchToCurrency_Label.Position = ESPswitchToCurrency.Position + Vector2.new(50, 4)
ESPswitchToCurrency_Label.ZIndex = 181

local ContentPageMisc2 = Drawing.new("Square")
ContentPageMisc2.Visible = false
ContentPageMisc2.Transparency = 1
ContentPageMisc2.ZIndex = 480
ContentPageMisc2.Color = Color3.fromHex("#0c1020")
ContentPageMisc2.Position = ContentPageMisc.Position + Vector2.new(0, 165)
ContentPageMisc2.Size = Vector2.new(325, 116)
ContentPageMisc2.Filled = true
ContentPageMisc2.Corner = 5

local ContentPageMisc2_Border = Drawing.new("Square")
ContentPageMisc2_Border.Visible = false
ContentPageMisc2_Border.Transparency = 1
ContentPageMisc2_Border.ZIndex = 481
ContentPageMisc2_Border.Color = Color3.fromHex("#13172a")
ContentPageMisc2_Border.Filled = false
ContentPageMisc2_Border.Thickness = 1
ContentPageMisc2_Border.Position = ContentPageMisc2.Position
ContentPageMisc2_Border.Size = ContentPageMisc2.Size
ContentPageMisc2_Border.Corner = 5

local SliderForESPdistance = Drawing.new("Square")
SliderForESPdistance.Visible = false
SliderForESPdistance.Transparency = 1
SliderForESPdistance.Color = Color3.fromHex("#444444")
SliderForESPdistance.Filled = true
SliderForESPdistance.Size = Vector2.new(200, 10)
SliderForESPdistance.Position = Vector2.new(118, 313)
SliderForESPdistance.ZIndex = 490
SliderForESPdistance.Corner = 15
local SliderForESPdistance_Value = 150
local SliderForESPdistance_Knob = Drawing.new("Square")
SliderForESPdistance_Knob.Visible = false
SliderForESPdistance_Knob.Transparency = 1
SliderForESPdistance_Knob.Color = Color3.fromHex("#3300ff")
SliderForESPdistance_Knob.Filled = true
SliderForESPdistance_Knob.Size = Vector2.new(20, 20)
SliderForESPdistance_Knob.Position = SliderForESPdistance.Position + Vector2.new(200 * 0.08544087491455912 - 10, 5 - 10)
SliderForESPdistance_Knob.ZIndex = 491
SliderForESPdistance_Knob.Corner = 100
local SliderForESPdistance_ValueText = Drawing.new("Text")
SliderForESPdistance_ValueText.Visible = false
SliderForESPdistance_ValueText.Text = tostring(math.floor(SliderForESPdistance_Value)) .. ""
SliderForESPdistance_ValueText.Size = 16
SliderForESPdistance_ValueText.Center = true
SliderForESPdistance_ValueText.Outline = true
SliderForESPdistance_ValueText.Color = Color3.new(1, 1, 1)
SliderForESPdistance_ValueText.Position = SliderForESPdistance.Position + Vector2.new(200/2, -10)
SliderForESPdistance_ValueText.ZIndex = 492

local TextUnderSliderEspDis = Drawing.new("Text")
TextUnderSliderEspDis.Visible = false
TextUnderSliderEspDis.Transparency = 1
TextUnderSliderEspDis.ZIndex = 510
TextUnderSliderEspDis.Color = Color3.fromHex("#eae0e2")
TextUnderSliderEspDis.Position = ContentPageMisc2.Position + Vector2.new(6, 46)
TextUnderSliderEspDis.Text = "ESP distance"
TextUnderSliderEspDis.Size = 14
TextUnderSliderEspDis.Center = false
TextUnderSliderEspDis.Outline = true
TextUnderSliderEspDis.Font = Drawing.Fonts.Monospace

local KeyNames = {
    [48] = "0",
    [49] = "1",
    [50] = "2",
    [51] = "3",
    [52] = "4",
    [53] = "5",
    [54] = "6",
    [55] = "7",
    [56] = "8",
    [57] = "9",
    [1] = "LeftMouse",
    [2] = "RightMouse",
    [4] = "MiddleMouse",
    [8] = "Backspace",
    [9] = "Tab",
    [13] = "Enter",
    [16] = "Shift",
    [17] = "Ctrl",
    [18] = "Alt",
    [19] = "Pause",
    [20] = "CapsLock",
    [27] = "Esc",
    [32] = "Space",
    [33] = "PageUp",
    [34] = "PageDown",
    [35] = "End",
    [36] = "Home",
    [37] = "Left",
    [38] = "Up",
    [39] = "Right",
    [40] = "Down",
    [45] = "Insert",
    [46] = "Delete",
    [65] = "A",
    [66] = "B",
    [67] = "C",
    [68] = "D",
    [69] = "E",
    [70] = "F",
    [71] = "G",
    [72] = "H",
    [73] = "I",
    [74] = "J",
    [75] = "K",
    [76] = "L",
    [77] = "M",
    [78] = "N",
    [79] = "O",
    [80] = "P",
    [81] = "Q",
    [82] = "R",
    [83] = "S",
    [84] = "T",
    [85] = "U",
    [86] = "V",
    [87] = "W",
    [88] = "X",
    [89] = "Y",
    [90] = "Z",
    [112] = "F1",
    [113] = "F2",
    [114] = "F3",
    [115] = "F4",
    [116] = "F5",
    [117] = "F6",
    [118] = "F7",
    [119] = "F8",
    [120] = "F9",
    [121] = "F10",
    [122] = "F11",
    [123] = "F12",
}

local Tab_ContentPageVisuals_SetVisible
Tab_ContentPageVisuals_SetVisible = function(visible)
    if ContentPageVisuals then ContentPageVisuals.Visible = visible end
    if ContentPageVisuals_Border then ContentPageVisuals_Border.Visible = visible end
    if ESPkeycardSwitch then
        ESPkeycardSwitch.Visible = visible
        ESPkeycardSwitch.Visible = visible
        if ESPkeycardSwitch_Bg then ESPkeycardSwitch_Bg.Visible = visible end
        if ESPkeycardSwitch_IndBorder then ESPkeycardSwitch_IndBorder.Visible = visible end
        if ESPkeycardSwitch_Ind then ESPkeycardSwitch_Ind.Visible = visible end
        if ESPkeycardSwitch_Label then ESPkeycardSwitch_Label.Visible = visible end
    end
    if EspKeycardtext then
        EspKeycardtext.Visible = visible
    end
    if EspDoorText then
        EspDoorText.Visible = visible
    end
    if ESPDoorsSwitch then
        ESPDoorsSwitch.Visible = visible
        ESPDoorsSwitch.Visible = visible
        if ESPDoorsSwitch_Bg then ESPDoorsSwitch_Bg.Visible = visible end
        if ESPDoorsSwitch_IndBorder then ESPDoorsSwitch_IndBorder.Visible = visible end
        if ESPDoorsSwitch_Ind then ESPDoorsSwitch_Ind.Visible = visible end
        if ESPDoorsSwitch_Label then ESPDoorsSwitch_Label.Visible = visible end
    end
    if ContentPageVisuals2 then
        ContentPageVisuals2.Visible = visible
        if ContentPageVisuals2_Border then ContentPageVisuals2_Border.Visible = visible end
    end
    if TextNofiticationAngler then
        TextNofiticationAngler.Visible = visible
    end
    if NoffiticationAnglerSwitch then
        NoffiticationAnglerSwitch.Visible = visible
        NoffiticationAnglerSwitch.Visible = visible
        if NoffiticationAnglerSwitch_Bg then NoffiticationAnglerSwitch_Bg.Visible = visible end
        if NoffiticationAnglerSwitch_IndBorder then NoffiticationAnglerSwitch_IndBorder.Visible = visible end
        if NoffiticationAnglerSwitch_Ind then NoffiticationAnglerSwitch_Ind.Visible = visible end
        if NoffiticationAnglerSwitch_Label then NoffiticationAnglerSwitch_Label.Visible = visible end
    end
    if NofFrogerText then
        NofFrogerText.Visible = visible
    end
    if NofPinkieText then
        NofPinkieText.Visible = visible
    end
    if NofBlitzText then
        NofBlitzText.Visible = visible
    end
    if NofChainsmokerText then
        NofChainsmokerText.Visible = visible
    end
    if NofPandemoniumText then
        NofPandemoniumText.Visible = visible
    end
    if NofA60text then
        NofA60text.Visible = visible
    end
    if NofHarbingerText then
        NofHarbingerText.Visible = visible
    end
    if NofPainterRoomText then
        NofPainterRoomText.Visible = visible
    end
    if NoffiticationFrogerSwitch then
        NoffiticationFrogerSwitch.Visible = visible
        NoffiticationFrogerSwitch.Visible = visible
        if NoffiticationFrogerSwitch_Bg then NoffiticationFrogerSwitch_Bg.Visible = visible end
        if NoffiticationFrogerSwitch_IndBorder then NoffiticationFrogerSwitch_IndBorder.Visible = visible end
        if NoffiticationFrogerSwitch_Ind then NoffiticationFrogerSwitch_Ind.Visible = visible end
        if NoffiticationFrogerSwitch_Label then NoffiticationFrogerSwitch_Label.Visible = visible end
    end
    if NoffiticationPinkieSwitch then
        NoffiticationPinkieSwitch.Visible = visible
        NoffiticationPinkieSwitch.Visible = visible
        if NoffiticationPinkieSwitch_Bg then NoffiticationPinkieSwitch_Bg.Visible = visible end
        if NoffiticationPinkieSwitch_IndBorder then NoffiticationPinkieSwitch_IndBorder.Visible = visible end
        if NoffiticationPinkieSwitch_Ind then NoffiticationPinkieSwitch_Ind.Visible = visible end
        if NoffiticationPinkieSwitch_Label then NoffiticationPinkieSwitch_Label.Visible = visible end
    end
    if NoffiticationBlitzSwitch then
        NoffiticationBlitzSwitch.Visible = visible
        NoffiticationBlitzSwitch.Visible = visible
        if NoffiticationBlitzSwitch_Bg then NoffiticationBlitzSwitch_Bg.Visible = visible end
        if NoffiticationBlitzSwitch_IndBorder then NoffiticationBlitzSwitch_IndBorder.Visible = visible end
        if NoffiticationBlitzSwitch_Ind then NoffiticationBlitzSwitch_Ind.Visible = visible end
        if NoffiticationBlitzSwitch_Label then NoffiticationBlitzSwitch_Label.Visible = visible end
    end
    if NoffiticationChainsmokerSwitch then
        NoffiticationChainsmokerSwitch.Visible = visible
        NoffiticationChainsmokerSwitch.Visible = visible
        if NoffiticationChainsmokerSwitch_Bg then NoffiticationChainsmokerSwitch_Bg.Visible = visible end
        if NoffiticationChainsmokerSwitch_IndBorder then NoffiticationChainsmokerSwitch_IndBorder.Visible = visible end
        if NoffiticationChainsmokerSwitch_Ind then NoffiticationChainsmokerSwitch_Ind.Visible = visible end
        if NoffiticationChainsmokerSwitch_Label then NoffiticationChainsmokerSwitch_Label.Visible = visible end
    end
    if NoffiticationPandemoniumSwitch then
        NoffiticationPandemoniumSwitch.Visible = visible
        NoffiticationPandemoniumSwitch.Visible = visible
        if NoffiticationPandemoniumSwitch_Bg then NoffiticationPandemoniumSwitch_Bg.Visible = visible end
        if NoffiticationPandemoniumSwitch_IndBorder then NoffiticationPandemoniumSwitch_IndBorder.Visible = visible end
        if NoffiticationPandemoniumSwitch_Ind then NoffiticationPandemoniumSwitch_Ind.Visible = visible end
        if NoffiticationPandemoniumSwitch_Label then NoffiticationPandemoniumSwitch_Label.Visible = visible end
    end
    if NoffiticationA60Switch then
        NoffiticationA60Switch.Visible = visible
        NoffiticationA60Switch.Visible = visible
        if NoffiticationA60Switch_Bg then NoffiticationA60Switch_Bg.Visible = visible end
        if NoffiticationA60Switch_IndBorder then NoffiticationA60Switch_IndBorder.Visible = visible end
        if NoffiticationA60Switch_Ind then NoffiticationA60Switch_Ind.Visible = visible end
        if NoffiticationA60Switch_Label then NoffiticationA60Switch_Label.Visible = visible end
    end
    if NoffiticationHarbingerSwitch then
        NoffiticationHarbingerSwitch.Visible = visible
        NoffiticationHarbingerSwitch.Visible = visible
        if NoffiticationHarbingerSwitch_Bg then NoffiticationHarbingerSwitch_Bg.Visible = visible end
        if NoffiticationHarbingerSwitch_IndBorder then NoffiticationHarbingerSwitch_IndBorder.Visible = visible end
        if NoffiticationHarbingerSwitch_Ind then NoffiticationHarbingerSwitch_Ind.Visible = visible end
        if NoffiticationHarbingerSwitch_Label then NoffiticationHarbingerSwitch_Label.Visible = visible end
    end
    if NoffiticationPainterRoomSwitch then
        NoffiticationPainterRoomSwitch.Visible = visible
        NoffiticationPainterRoomSwitch.Visible = visible
        if NoffiticationPainterRoomSwitch_Bg then NoffiticationPainterRoomSwitch_Bg.Visible = visible end
        if NoffiticationPainterRoomSwitch_IndBorder then NoffiticationPainterRoomSwitch_IndBorder.Visible = visible end
        if NoffiticationPainterRoomSwitch_Ind then NoffiticationPainterRoomSwitch_Ind.Visible = visible end
        if NoffiticationPainterRoomSwitch_Label then NoffiticationPainterRoomSwitch_Label.Visible = visible end
    end
    if ContentPageVisuals3 then
        ContentPageVisuals3.Visible = visible
        if ContentPageVisuals3_Border then ContentPageVisuals3_Border.Visible = visible end
    end
    if EnableWatermarkText then
        EnableWatermarkText.Visible = visible
    end
    if EnableWatermarkSwitch then
        EnableWatermarkSwitch.Visible = visible
        EnableWatermarkSwitch.Visible = visible
        if EnableWatermarkSwitch_Bg then EnableWatermarkSwitch_Bg.Visible = visible end
        if EnableWatermarkSwitch_IndBorder then EnableWatermarkSwitch_IndBorder.Visible = visible end
        if EnableWatermarkSwitch_Ind then EnableWatermarkSwitch_Ind.Visible = visible end
        if EnableWatermarkSwitch_Label then EnableWatermarkSwitch_Label.Visible = visible end
    end
    if TextToRescanForce then
        TextToRescanForce.Visible = visible
    end
    if EspItemsText then
        EspItemsText.Visible = visible
    end
    if SwitchForESPitems then
        SwitchForESPitems.Visible = visible
        SwitchForESPitems.Visible = visible
        if SwitchForESPitems_Bg then SwitchForESPitems_Bg.Visible = visible end
        if SwitchForESPitems_IndBorder then SwitchForESPitems_IndBorder.Visible = visible end
        if SwitchForESPitems_Ind then SwitchForESPitems_Ind.Visible = visible end
        if SwitchForESPitems_Label then SwitchForESPitems_Label.Visible = visible end
    end
    if TextESPCurrency then
        TextESPCurrency.Visible = visible
    end
    if ESPswitchToCurrency then
        ESPswitchToCurrency.Visible = visible
        ESPswitchToCurrency.Visible = visible
        if ESPswitchToCurrency_Bg then ESPswitchToCurrency_Bg.Visible = visible end
        if ESPswitchToCurrency_IndBorder then ESPswitchToCurrency_IndBorder.Visible = visible end
        if ESPswitchToCurrency_Ind then ESPswitchToCurrency_Ind.Visible = visible end
        if ESPswitchToCurrency_Label then ESPswitchToCurrency_Label.Visible = visible end
    end
end

local Tab_ContentPageVisuals2_SetVisible
Tab_ContentPageVisuals2_SetVisible = function(visible)
    if ContentPageVisuals2 then ContentPageVisuals2.Visible = visible end
    if ContentPageVisuals2_Border then ContentPageVisuals2_Border.Visible = visible end
end

local Tab_ContentPageVisuals3_SetVisible
Tab_ContentPageVisuals3_SetVisible = function(visible)
    if ContentPageVisuals3 then ContentPageVisuals3.Visible = visible end
    if ContentPageVisuals3_Border then ContentPageVisuals3_Border.Visible = visible end
end

local Tab_ContentPageExploits_SetVisible
Tab_ContentPageExploits_SetVisible = function(visible)
    if ContentPageExploits then ContentPageExploits.Visible = visible end
    if ContentPageExploits_Border then ContentPageExploits_Border.Visible = visible end
    if AutoHideSwitch then
        AutoHideSwitch.Visible = visible
        AutoHideSwitch.Visible = visible
        if AutoHideSwitch_Bg then AutoHideSwitch_Bg.Visible = visible end
        if AutoHideSwitch_IndBorder then AutoHideSwitch_IndBorder.Visible = visible end
        if AutoHideSwitch_Ind then AutoHideSwitch_Ind.Visible = visible end
        if AutoHideSwitch_Label then AutoHideSwitch_Label.Visible = visible end
    end
    if AutoHideText then
        AutoHideText.Visible = visible
    end
end

local Tab_ContentPageMisc_SetVisible
Tab_ContentPageMisc_SetVisible = function(visible)
    if ContentPageMisc then ContentPageMisc.Visible = visible end
    if ContentPageMisc_Border then ContentPageMisc_Border.Visible = visible end
    if AutoRescanSwitch then
        AutoRescanSwitch.Visible = visible
        AutoRescanSwitch.Visible = visible
        if AutoRescanSwitch_Bg then AutoRescanSwitch_Bg.Visible = visible end
        if AutoRescanSwitch_IndBorder then AutoRescanSwitch_IndBorder.Visible = visible end
        if AutoRescanSwitch_Ind then AutoRescanSwitch_Ind.Visible = visible end
        if AutoRescanSwitch_Label then AutoRescanSwitch_Label.Visible = visible end
    end
    if AutoRescanText then
        AutoRescanText.Visible = visible
    end
    if ContentPageMisc2 then
        ContentPageMisc2.Visible = visible
        if ContentPageMisc2_Border then ContentPageMisc2_Border.Visible = visible end
    end
    if SliderForESPdistance then
        SliderForESPdistance.Visible = visible
        if SliderForESPdistance_Knob then SliderForESPdistance_Knob.Visible = visible end
        if SliderForESPdistance_ValueText then SliderForESPdistance_ValueText.Visible = visible end
    end
    if TextUnderSliderEspDis then
        TextUnderSliderEspDis.Visible = visible
    end
end

local Tab_ContentPageSettings_SetVisible
Tab_ContentPageSettings_SetVisible = function(visible)
    if ContentPageSettings then ContentPageSettings.Visible = visible end
    if ContentPageSettings_Border then ContentPageSettings_Border.Visible = visible end
    if ToggleUIvisiblity then
        ToggleUIvisiblity.Visible = visible
        if ToggleUIvisiblity_Text then ToggleUIvisiblity_Text.Visible = visible end
    end
end

local Tab_ContentPageMisc2_SetVisible
Tab_ContentPageMisc2_SetVisible = function(visible)
    if ContentPageMisc2 then ContentPageMisc2.Visible = visible end
    if ContentPageMisc2_Border then ContentPageMisc2_Border.Visible = visible end
    if SliderForESPdistance then
        SliderForESPdistance.Visible = visible
        if SliderForESPdistance_Knob then SliderForESPdistance_Knob.Visible = visible end
        if SliderForESPdistance_ValueText then SliderForESPdistance_ValueText.Visible = visible end
    end
    if TextUnderSliderEspDis then
        TextUnderSliderEspDis.Visible = visible
    end
end

spawn(function()
    local lastVis=false
    while true do
        wait(0.05)
        local v=Main1.Visible
        if v~=lastVis then lastVis=v setrobloxinput(not v) end
    end
end)

local onSwitch=function(val)
    Settings.notificationsEnabled.Angler      = NoffiticationAnglerSwitch_IsChecked
    Settings.notificationsEnabled.Froger      = NoffiticationFrogerSwitch_IsChecked
    Settings.notificationsEnabled.Pinkie      = NoffiticationPinkieSwitch_IsChecked
    Settings.notificationsEnabled.Blitz       = NoffiticationBlitzSwitch_IsChecked
    Settings.notificationsEnabled.Chainsmoker = NoffiticationChainsmokerSwitch_IsChecked
    Settings.notificationsEnabled.Pandemonium = NoffiticationPandemoniumSwitch_IsChecked
    Settings.notificationsEnabled["A60"]     = NoffiticationA60Switch_IsChecked
    Settings.notificationsEnabled.Harbinger   = NoffiticationHarbingerSwitch_IsChecked
    Settings.notificationsEnabled.Painter     = NoffiticationPainterRoomSwitch_IsChecked
    AutoHideSystem.enabled = AutoHideSwitch_IsChecked
    Settings.autoRescanEnabled = AutoRescanSwitch_IsChecked
    if EnableWatermarkSwitch_IsChecked ~= WatermarkSystem.enabled then
        WatermarkSystem.enabled=EnableWatermarkSwitch_IsChecked
        WatermarkSystem:SetVisible(EnableWatermarkSwitch_IsChecked)
    end
    if ESPkeycardSwitch_IsChecked and not Settings.keycardESPEnabled then StartKeycardESP()
    elseif not ESPkeycardSwitch_IsChecked and Settings.keycardESPEnabled then CleanupKeycardESP() end
    if ESPDoorsSwitch_IsChecked and not Settings.doorESPEnabled then StartDoorESP()
    elseif not ESPDoorsSwitch_IsChecked and Settings.doorESPEnabled then CleanupDoorESP() end
    if SwitchForESPitems_IsChecked and not Settings.itemsESPEnabled then StartItemsESP()
    elseif not SwitchForESPitems_IsChecked and Settings.itemsESPEnabled then CleanupItemsESP() end
    if ESPswitchToCurrency_IsChecked and not Settings.currencyESPEnabled then StartCurrencyESP()
    elseif not ESPswitchToCurrency_IsChecked and Settings.currencyESPEnabled then CleanupCurrencyESP() end
end

local onChanged=function(val) Settings.espMaxDistance=math.max(25,math.floor(val)) end
local onClick=function() end
local onKeyChanged=function(i) end

local dragging = nil
local dragStart = nil
local startPos = nil
local knobStartPos = nil
local lastMouse1 = false

while true do
    wait(0.01)
    if isrbxactive() then
        local mouse1 = ismouse1pressed()
        local mPos = Vector2.new(Mouse.X, Mouse.Y)

        if ToggleUIvisiblity_IsListening then
             for i = 1, 255 do
                 if iskeypressed(i) and not ismouse1pressed() then
                     ToggleUIvisiblity_Key = i
                     ToggleUIvisiblity_IsListening = false
                     local keyName = KeyNames[i] or "Unknown"
                     ToggleUIvisiblity_Text.Text = "[ " .. keyName .. " ]"
                     ToggleUIvisiblity_Text.Color = Color3.fromHex("#eae0e2")
                     pcall(function() onKeyChanged(i) end)
                     wait(0.2)
                     break
                 end
             end
        else
             if iskeypressed(ToggleUIvisiblity_Key) then

                 local newState = not Main1.Visible
                 Main1.Visible = newState
                 for _,sq in ipairs(VeryTopPlace_Parts) do sq.Visible=newState end
                 Circle5.Visible = newState
                 TextRATHUB.Visible = newState
                 PlaceTabs.Visible = newState
                 VisualsTab.Visible = newState
                 VisualsTab_Text.Visible = newState
                 ExploitsTab.Visible = newState
                 ExploitsTab_Text.Visible = newState
                 MiscTab.Visible = newState
                 MiscTab_Text.Visible = newState
                 SettingsTab.Visible = newState
                 SettingsTab_Text.Visible = newState
                 Line1.Visible = newState
                 Line2.Visible = newState
                 ContentPageVisuals.Visible = newState
                 ContentPageVisuals_Border.Visible = newState
                 ESPkeycardSwitch.Visible = newState
                 ESPkeycardSwitch.Visible = newState
                 ESPkeycardSwitch_Bg.Visible = newState
                 ESPkeycardSwitch_IndBorder.Visible = newState
                 ESPkeycardSwitch_Ind.Visible = newState
                 ESPkeycardSwitch_Label.Visible = newState
                 EspKeycardtext.Visible = newState
                 EspDoorText.Visible = newState
                 ESPDoorsSwitch.Visible = newState
                 ESPDoorsSwitch.Visible = newState
                 ESPDoorsSwitch_Bg.Visible = newState
                 ESPDoorsSwitch_IndBorder.Visible = newState
                 ESPDoorsSwitch_Ind.Visible = newState
                 ESPDoorsSwitch_Label.Visible = newState
                 ContentPageVisuals2.Visible = newState
                 ContentPageVisuals2_Border.Visible = newState
                 TextNofiticationAngler.Visible = newState
                 NoffiticationAnglerSwitch.Visible = newState
                 NoffiticationAnglerSwitch.Visible = newState
                 NoffiticationAnglerSwitch_Bg.Visible = newState
                 NoffiticationAnglerSwitch_IndBorder.Visible = newState
                 NoffiticationAnglerSwitch_Ind.Visible = newState
                 NoffiticationAnglerSwitch_Label.Visible = newState
                 NofFrogerText.Visible = newState
                 NofPinkieText.Visible = newState
                 NofBlitzText.Visible = newState
                 NofChainsmokerText.Visible = newState
                 NofPandemoniumText.Visible = newState
                 NofA60text.Visible = newState
                 NofHarbingerText.Visible = newState
                 NofPainterRoomText.Visible = newState
                 NoffiticationFrogerSwitch.Visible = newState
                 NoffiticationFrogerSwitch.Visible = newState
                 NoffiticationFrogerSwitch_Bg.Visible = newState
                 NoffiticationFrogerSwitch_IndBorder.Visible = newState
                 NoffiticationFrogerSwitch_Ind.Visible = newState
                 NoffiticationFrogerSwitch_Label.Visible = newState
                 NoffiticationPinkieSwitch.Visible = newState
                 NoffiticationPinkieSwitch.Visible = newState
                 NoffiticationPinkieSwitch_Bg.Visible = newState
                 NoffiticationPinkieSwitch_IndBorder.Visible = newState
                 NoffiticationPinkieSwitch_Ind.Visible = newState
                 NoffiticationPinkieSwitch_Label.Visible = newState
                 NoffiticationBlitzSwitch.Visible = newState
                 NoffiticationBlitzSwitch.Visible = newState
                 NoffiticationBlitzSwitch_Bg.Visible = newState
                 NoffiticationBlitzSwitch_IndBorder.Visible = newState
                 NoffiticationBlitzSwitch_Ind.Visible = newState
                 NoffiticationBlitzSwitch_Label.Visible = newState
                 NoffiticationChainsmokerSwitch.Visible = newState
                 NoffiticationChainsmokerSwitch.Visible = newState
                 NoffiticationChainsmokerSwitch_Bg.Visible = newState
                 NoffiticationChainsmokerSwitch_IndBorder.Visible = newState
                 NoffiticationChainsmokerSwitch_Ind.Visible = newState
                 NoffiticationChainsmokerSwitch_Label.Visible = newState
                 NoffiticationPandemoniumSwitch.Visible = newState
                 NoffiticationPandemoniumSwitch.Visible = newState
                 NoffiticationPandemoniumSwitch_Bg.Visible = newState
                 NoffiticationPandemoniumSwitch_IndBorder.Visible = newState
                 NoffiticationPandemoniumSwitch_Ind.Visible = newState
                 NoffiticationPandemoniumSwitch_Label.Visible = newState
                 NoffiticationA60Switch.Visible = newState
                 NoffiticationA60Switch.Visible = newState
                 NoffiticationA60Switch_Bg.Visible = newState
                 NoffiticationA60Switch_IndBorder.Visible = newState
                 NoffiticationA60Switch_Ind.Visible = newState
                 NoffiticationA60Switch_Label.Visible = newState
                 NoffiticationHarbingerSwitch.Visible = newState
                 NoffiticationHarbingerSwitch.Visible = newState
                 NoffiticationHarbingerSwitch_Bg.Visible = newState
                 NoffiticationHarbingerSwitch_IndBorder.Visible = newState
                 NoffiticationHarbingerSwitch_Ind.Visible = newState
                 NoffiticationHarbingerSwitch_Label.Visible = newState
                 NoffiticationPainterRoomSwitch.Visible = newState
                 NoffiticationPainterRoomSwitch.Visible = newState
                 NoffiticationPainterRoomSwitch_Bg.Visible = newState
                 NoffiticationPainterRoomSwitch_IndBorder.Visible = newState
                 NoffiticationPainterRoomSwitch_Ind.Visible = newState
                 NoffiticationPainterRoomSwitch_Label.Visible = newState
                 ContentPageVisuals3.Visible = newState
                 ContentPageVisuals3_Border.Visible = newState
                 EnableWatermarkText.Visible = newState
                 EnableWatermarkSwitch.Visible = newState
                 EnableWatermarkSwitch.Visible = newState
                 EnableWatermarkSwitch_Bg.Visible = newState
                 EnableWatermarkSwitch_IndBorder.Visible = newState
                 EnableWatermarkSwitch_Ind.Visible = newState
                 EnableWatermarkSwitch_Label.Visible = newState
                 ContentPageExploits.Visible = newState
                 ContentPageExploits_Border.Visible = newState
                 AutoHideSwitch.Visible = newState
                 AutoHideSwitch.Visible = newState
                 AutoHideSwitch_Bg.Visible = newState
                 AutoHideSwitch_IndBorder.Visible = newState
                 AutoHideSwitch_Ind.Visible = newState
                 AutoHideSwitch_Label.Visible = newState
                 AutoHideText.Visible = newState
                 ContentPageMisc.Visible = newState
                 ContentPageMisc_Border.Visible = newState
                 AutoRescanSwitch.Visible = newState
                 AutoRescanSwitch.Visible = newState
                 AutoRescanSwitch_Bg.Visible = newState
                 AutoRescanSwitch_IndBorder.Visible = newState
                 AutoRescanSwitch_Ind.Visible = newState
                 AutoRescanSwitch_Label.Visible = newState
                 AutoRescanText.Visible = newState
                 ContentPageSettings.Visible = newState
                 ContentPageSettings_Border.Visible = newState
                 ToggleUIvisiblity.Visible = newState
                 ToggleUIvisiblity_Text.Visible = newState
                 TextToRescanForce.Visible = newState
                 EspItemsText.Visible = newState
                 SwitchForESPitems.Visible = newState
                 SwitchForESPitems.Visible = newState
                 SwitchForESPitems_Bg.Visible = newState
                 SwitchForESPitems_IndBorder.Visible = newState
                 SwitchForESPitems_Ind.Visible = newState
                 SwitchForESPitems_Label.Visible = newState
                 TextESPCurrency.Visible = newState
                 ESPswitchToCurrency.Visible = newState
                 ESPswitchToCurrency.Visible = newState
                 ESPswitchToCurrency_Bg.Visible = newState
                 ESPswitchToCurrency_IndBorder.Visible = newState
                 ESPswitchToCurrency_Ind.Visible = newState
                 ESPswitchToCurrency_Label.Visible = newState
                 ContentPageMisc2.Visible = newState
                 ContentPageMisc2_Border.Visible = newState
                 SliderForESPdistance.Visible = newState
                 SliderForESPdistance_Knob.Visible = newState
                 SliderForESPdistance_ValueText.Visible = newState
                 TextUnderSliderEspDis.Visible = newState
                 wait(0.2)
             end
        end

        if mouse1 and not lastMouse1 then

            if VisualsTab.Visible and mPos.X >= VisualsTab.Position.X and mPos.X <= VisualsTab.Position.X + VisualsTab.Size.X and
               mPos.Y >= VisualsTab.Position.Y and mPos.Y <= VisualsTab.Position.Y + VisualsTab.Size.Y then
                pcall(function() onClick() end)
                setActiveTab(VisualsTab,VisualsTab_Text)

                pcall(function() Tab_ContentPageVisuals2_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals3_SetVisible(false) end)
                pcall(function() Tab_ContentPageExploits_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc_SetVisible(false) end)
                pcall(function() Tab_ContentPageSettings_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc2_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals_SetVisible(not ContentPageVisuals.Visible) end)
            end

            if ExploitsTab.Visible and mPos.X >= ExploitsTab.Position.X and mPos.X <= ExploitsTab.Position.X + ExploitsTab.Size.X and
               mPos.Y >= ExploitsTab.Position.Y and mPos.Y <= ExploitsTab.Position.Y + ExploitsTab.Size.Y then
                pcall(function() onClick() end)
                setActiveTab(ExploitsTab,ExploitsTab_Text)

                pcall(function() Tab_ContentPageVisuals_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals2_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals3_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc_SetVisible(false) end)
                pcall(function() Tab_ContentPageSettings_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc2_SetVisible(false) end)
                pcall(function() Tab_ContentPageExploits_SetVisible(not ContentPageExploits.Visible) end)
            end

            if MiscTab.Visible and mPos.X >= MiscTab.Position.X and mPos.X <= MiscTab.Position.X + MiscTab.Size.X and
               mPos.Y >= MiscTab.Position.Y and mPos.Y <= MiscTab.Position.Y + MiscTab.Size.Y then
                pcall(function() onClick() end)
                setActiveTab(MiscTab,MiscTab_Text)

                pcall(function() Tab_ContentPageVisuals_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals2_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals3_SetVisible(false) end)
                pcall(function() Tab_ContentPageExploits_SetVisible(false) end)
                pcall(function() Tab_ContentPageSettings_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc2_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc_SetVisible(not ContentPageMisc.Visible) end)
            end

            if SettingsTab.Visible and mPos.X >= SettingsTab.Position.X and mPos.X <= SettingsTab.Position.X + SettingsTab.Size.X and
               mPos.Y >= SettingsTab.Position.Y and mPos.Y <= SettingsTab.Position.Y + SettingsTab.Size.Y then
                pcall(function() onClick() end)
                setActiveTab(SettingsTab,SettingsTab_Text)

                pcall(function() Tab_ContentPageVisuals_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals2_SetVisible(false) end)
                pcall(function() Tab_ContentPageVisuals3_SetVisible(false) end)
                pcall(function() Tab_ContentPageExploits_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc_SetVisible(false) end)
                pcall(function() Tab_ContentPageMisc2_SetVisible(false) end)
                pcall(function() Tab_ContentPageSettings_SetVisible(not ContentPageSettings.Visible) end)
            end

            if ESPkeycardSwitch_Label.Visible and mPos.X >= ESPkeycardSwitch.Position.X and mPos.X <= ESPkeycardSwitch.Position.X + ESPkeycardSwitch.Size.X and
               mPos.Y >= ESPkeycardSwitch.Position.Y and mPos.Y <= ESPkeycardSwitch.Position.Y + ESPkeycardSwitch.Size.Y then

                ESPkeycardSwitch_IsChecked = not ESPkeycardSwitch_IsChecked
                if ESPkeycardSwitch_IsChecked then
                    ESPkeycardSwitch_IndBorder.Position = ESPkeycardSwitch.Position + Vector2.new(21, 1)
                    ESPkeycardSwitch_Ind.Position = ESPkeycardSwitch.Position + Vector2.new(21, 1)
                else
                    ESPkeycardSwitch_IndBorder.Position = ESPkeycardSwitch.Position + Vector2.new(1, 1)
                    ESPkeycardSwitch_Ind.Position = ESPkeycardSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(ESPkeycardSwitch_IsChecked) end) end
            end

            if ESPDoorsSwitch_Label.Visible and mPos.X >= ESPDoorsSwitch.Position.X and mPos.X <= ESPDoorsSwitch.Position.X + ESPDoorsSwitch.Size.X and
               mPos.Y >= ESPDoorsSwitch.Position.Y and mPos.Y <= ESPDoorsSwitch.Position.Y + ESPDoorsSwitch.Size.Y then

                ESPDoorsSwitch_IsChecked = not ESPDoorsSwitch_IsChecked
                if ESPDoorsSwitch_IsChecked then
                    ESPDoorsSwitch_IndBorder.Position = ESPDoorsSwitch.Position + Vector2.new(21, 1)
                    ESPDoorsSwitch_Ind.Position = ESPDoorsSwitch.Position + Vector2.new(21, 1)
                else
                    ESPDoorsSwitch_IndBorder.Position = ESPDoorsSwitch.Position + Vector2.new(1, 1)
                    ESPDoorsSwitch_Ind.Position = ESPDoorsSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(ESPDoorsSwitch_IsChecked) end) end
            end

            if NoffiticationAnglerSwitch_Label.Visible and mPos.X >= NoffiticationAnglerSwitch.Position.X and mPos.X <= NoffiticationAnglerSwitch.Position.X + NoffiticationAnglerSwitch.Size.X and
               mPos.Y >= NoffiticationAnglerSwitch.Position.Y and mPos.Y <= NoffiticationAnglerSwitch.Position.Y + NoffiticationAnglerSwitch.Size.Y then

                NoffiticationAnglerSwitch_IsChecked = not NoffiticationAnglerSwitch_IsChecked
                if NoffiticationAnglerSwitch_IsChecked then
                    NoffiticationAnglerSwitch_IndBorder.Position = NoffiticationAnglerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationAnglerSwitch_Ind.Position = NoffiticationAnglerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationAnglerSwitch_IndBorder.Position = NoffiticationAnglerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationAnglerSwitch_Ind.Position = NoffiticationAnglerSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationAnglerSwitch_IsChecked) end) end
            end

            if NoffiticationFrogerSwitch_Label.Visible and mPos.X >= NoffiticationFrogerSwitch.Position.X and mPos.X <= NoffiticationFrogerSwitch.Position.X + NoffiticationFrogerSwitch.Size.X and
               mPos.Y >= NoffiticationFrogerSwitch.Position.Y and mPos.Y <= NoffiticationFrogerSwitch.Position.Y + NoffiticationFrogerSwitch.Size.Y then

                NoffiticationFrogerSwitch_IsChecked = not NoffiticationFrogerSwitch_IsChecked
                if NoffiticationFrogerSwitch_IsChecked then
                    NoffiticationFrogerSwitch_IndBorder.Position = NoffiticationFrogerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationFrogerSwitch_Ind.Position = NoffiticationFrogerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationFrogerSwitch_IndBorder.Position = NoffiticationFrogerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationFrogerSwitch_Ind.Position = NoffiticationFrogerSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationFrogerSwitch_IsChecked) end) end
            end

            if NoffiticationPinkieSwitch_Label.Visible and mPos.X >= NoffiticationPinkieSwitch.Position.X and mPos.X <= NoffiticationPinkieSwitch.Position.X + NoffiticationPinkieSwitch.Size.X and
               mPos.Y >= NoffiticationPinkieSwitch.Position.Y and mPos.Y <= NoffiticationPinkieSwitch.Position.Y + NoffiticationPinkieSwitch.Size.Y then

                NoffiticationPinkieSwitch_IsChecked = not NoffiticationPinkieSwitch_IsChecked
                if NoffiticationPinkieSwitch_IsChecked then
                    NoffiticationPinkieSwitch_IndBorder.Position = NoffiticationPinkieSwitch.Position + Vector2.new(18, 1)
                    NoffiticationPinkieSwitch_Ind.Position = NoffiticationPinkieSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationPinkieSwitch_IndBorder.Position = NoffiticationPinkieSwitch.Position + Vector2.new(1, 1)
                    NoffiticationPinkieSwitch_Ind.Position = NoffiticationPinkieSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationPinkieSwitch_IsChecked) end) end
            end

            if NoffiticationBlitzSwitch_Label.Visible and mPos.X >= NoffiticationBlitzSwitch.Position.X and mPos.X <= NoffiticationBlitzSwitch.Position.X + NoffiticationBlitzSwitch.Size.X and
               mPos.Y >= NoffiticationBlitzSwitch.Position.Y and mPos.Y <= NoffiticationBlitzSwitch.Position.Y + NoffiticationBlitzSwitch.Size.Y then

                NoffiticationBlitzSwitch_IsChecked = not NoffiticationBlitzSwitch_IsChecked
                if NoffiticationBlitzSwitch_IsChecked then
                    NoffiticationBlitzSwitch_IndBorder.Position = NoffiticationBlitzSwitch.Position + Vector2.new(18, 1)
                    NoffiticationBlitzSwitch_Ind.Position = NoffiticationBlitzSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationBlitzSwitch_IndBorder.Position = NoffiticationBlitzSwitch.Position + Vector2.new(1, 1)
                    NoffiticationBlitzSwitch_Ind.Position = NoffiticationBlitzSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationBlitzSwitch_IsChecked) end) end
            end

            if NoffiticationChainsmokerSwitch_Label.Visible and mPos.X >= NoffiticationChainsmokerSwitch.Position.X and mPos.X <= NoffiticationChainsmokerSwitch.Position.X + NoffiticationChainsmokerSwitch.Size.X and
               mPos.Y >= NoffiticationChainsmokerSwitch.Position.Y and mPos.Y <= NoffiticationChainsmokerSwitch.Position.Y + NoffiticationChainsmokerSwitch.Size.Y then

                NoffiticationChainsmokerSwitch_IsChecked = not NoffiticationChainsmokerSwitch_IsChecked
                if NoffiticationChainsmokerSwitch_IsChecked then
                    NoffiticationChainsmokerSwitch_IndBorder.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationChainsmokerSwitch_Ind.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationChainsmokerSwitch_IndBorder.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationChainsmokerSwitch_Ind.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationChainsmokerSwitch_IsChecked) end) end
            end

            if NoffiticationPandemoniumSwitch_Label.Visible and mPos.X >= NoffiticationPandemoniumSwitch.Position.X and mPos.X <= NoffiticationPandemoniumSwitch.Position.X + NoffiticationPandemoniumSwitch.Size.X and
               mPos.Y >= NoffiticationPandemoniumSwitch.Position.Y and mPos.Y <= NoffiticationPandemoniumSwitch.Position.Y + NoffiticationPandemoniumSwitch.Size.Y then

                NoffiticationPandemoniumSwitch_IsChecked = not NoffiticationPandemoniumSwitch_IsChecked
                if NoffiticationPandemoniumSwitch_IsChecked then
                    NoffiticationPandemoniumSwitch_IndBorder.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(18, 1)
                    NoffiticationPandemoniumSwitch_Ind.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationPandemoniumSwitch_IndBorder.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(1, 1)
                    NoffiticationPandemoniumSwitch_Ind.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationPandemoniumSwitch_IsChecked) end) end
            end

            if NoffiticationA60Switch_Label.Visible and mPos.X >= NoffiticationA60Switch.Position.X and mPos.X <= NoffiticationA60Switch.Position.X + NoffiticationA60Switch.Size.X and
               mPos.Y >= NoffiticationA60Switch.Position.Y and mPos.Y <= NoffiticationA60Switch.Position.Y + NoffiticationA60Switch.Size.Y then

                NoffiticationA60Switch_IsChecked = not NoffiticationA60Switch_IsChecked
                if NoffiticationA60Switch_IsChecked then
                    NoffiticationA60Switch_IndBorder.Position = NoffiticationA60Switch.Position + Vector2.new(18, 1)
                    NoffiticationA60Switch_Ind.Position = NoffiticationA60Switch.Position + Vector2.new(18, 1)
                else
                    NoffiticationA60Switch_IndBorder.Position = NoffiticationA60Switch.Position + Vector2.new(1, 1)
                    NoffiticationA60Switch_Ind.Position = NoffiticationA60Switch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationA60Switch_IsChecked) end) end
            end

            if NoffiticationHarbingerSwitch_Label.Visible and mPos.X >= NoffiticationHarbingerSwitch.Position.X and mPos.X <= NoffiticationHarbingerSwitch.Position.X + NoffiticationHarbingerSwitch.Size.X and
               mPos.Y >= NoffiticationHarbingerSwitch.Position.Y and mPos.Y <= NoffiticationHarbingerSwitch.Position.Y + NoffiticationHarbingerSwitch.Size.Y then

                NoffiticationHarbingerSwitch_IsChecked = not NoffiticationHarbingerSwitch_IsChecked
                if NoffiticationHarbingerSwitch_IsChecked then
                    NoffiticationHarbingerSwitch_IndBorder.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationHarbingerSwitch_Ind.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationHarbingerSwitch_IndBorder.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationHarbingerSwitch_Ind.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationHarbingerSwitch_IsChecked) end) end
            end

            if NoffiticationPainterRoomSwitch_Label.Visible and mPos.X >= NoffiticationPainterRoomSwitch.Position.X and mPos.X <= NoffiticationPainterRoomSwitch.Position.X + NoffiticationPainterRoomSwitch.Size.X and
               mPos.Y >= NoffiticationPainterRoomSwitch.Position.Y and mPos.Y <= NoffiticationPainterRoomSwitch.Position.Y + NoffiticationPainterRoomSwitch.Size.Y then

                NoffiticationPainterRoomSwitch_IsChecked = not NoffiticationPainterRoomSwitch_IsChecked
                if NoffiticationPainterRoomSwitch_IsChecked then
                    NoffiticationPainterRoomSwitch_IndBorder.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(18, 1)
                    NoffiticationPainterRoomSwitch_Ind.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationPainterRoomSwitch_IndBorder.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(1, 1)
                    NoffiticationPainterRoomSwitch_Ind.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(NoffiticationPainterRoomSwitch_IsChecked) end) end
            end

            if EnableWatermarkSwitch_Label.Visible and mPos.X >= EnableWatermarkSwitch.Position.X and mPos.X <= EnableWatermarkSwitch.Position.X + EnableWatermarkSwitch.Size.X and
               mPos.Y >= EnableWatermarkSwitch.Position.Y and mPos.Y <= EnableWatermarkSwitch.Position.Y + EnableWatermarkSwitch.Size.Y then

                EnableWatermarkSwitch_IsChecked = not EnableWatermarkSwitch_IsChecked
                if EnableWatermarkSwitch_IsChecked then
                    EnableWatermarkSwitch_IndBorder.Position = EnableWatermarkSwitch.Position + Vector2.new(18, 1)
                    EnableWatermarkSwitch_Ind.Position = EnableWatermarkSwitch.Position + Vector2.new(18, 1)
                else
                    EnableWatermarkSwitch_IndBorder.Position = EnableWatermarkSwitch.Position + Vector2.new(1, 1)
                    EnableWatermarkSwitch_Ind.Position = EnableWatermarkSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(EnableWatermarkSwitch_IsChecked) end) end
            end

            if AutoHideSwitch_Label.Visible and mPos.X >= AutoHideSwitch.Position.X and mPos.X <= AutoHideSwitch.Position.X + AutoHideSwitch.Size.X and
               mPos.Y >= AutoHideSwitch.Position.Y and mPos.Y <= AutoHideSwitch.Position.Y + AutoHideSwitch.Size.Y then

                AutoHideSwitch_IsChecked = not AutoHideSwitch_IsChecked
                if AutoHideSwitch_IsChecked then
                    AutoHideSwitch_IndBorder.Position = AutoHideSwitch.Position + Vector2.new(26, 1)
                    AutoHideSwitch_Ind.Position = AutoHideSwitch.Position + Vector2.new(26, 1)
                else
                    AutoHideSwitch_IndBorder.Position = AutoHideSwitch.Position + Vector2.new(1, 1)
                    AutoHideSwitch_Ind.Position = AutoHideSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(AutoHideSwitch_IsChecked) end) end
            end

            if AutoRescanSwitch_Label.Visible and mPos.X >= AutoRescanSwitch.Position.X and mPos.X <= AutoRescanSwitch.Position.X + AutoRescanSwitch.Size.X and
               mPos.Y >= AutoRescanSwitch.Position.Y and mPos.Y <= AutoRescanSwitch.Position.Y + AutoRescanSwitch.Size.Y then

                AutoRescanSwitch_IsChecked = not AutoRescanSwitch_IsChecked
                if AutoRescanSwitch_IsChecked then
                    AutoRescanSwitch_IndBorder.Position = AutoRescanSwitch.Position + Vector2.new(26, 1)
                    AutoRescanSwitch_Ind.Position = AutoRescanSwitch.Position + Vector2.new(26, 1)
                else
                    AutoRescanSwitch_IndBorder.Position = AutoRescanSwitch.Position + Vector2.new(1, 1)
                    AutoRescanSwitch_Ind.Position = AutoRescanSwitch.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(AutoRescanSwitch_IsChecked) end) end
            end

            if ToggleUIvisiblity.Visible and mPos.X >= ToggleUIvisiblity.Position.X and mPos.X <= ToggleUIvisiblity.Position.X + ToggleUIvisiblity.Size.X and
               mPos.Y >= ToggleUIvisiblity.Position.Y and mPos.Y <= ToggleUIvisiblity.Position.Y + ToggleUIvisiblity.Size.Y then
                pcall(function() onKeyChanged() end)

                ToggleUIvisiblity_IsListening = true
                ToggleUIvisiblity_Text.Text = "..."
                ToggleUIvisiblity_Text.Color = Color3.fromHex("#FFFF00")
            end

            if SwitchForESPitems_Label.Visible and mPos.X >= SwitchForESPitems.Position.X and mPos.X <= SwitchForESPitems.Position.X + SwitchForESPitems.Size.X and
               mPos.Y >= SwitchForESPitems.Position.Y and mPos.Y <= SwitchForESPitems.Position.Y + SwitchForESPitems.Size.Y then

                SwitchForESPitems_IsChecked = not SwitchForESPitems_IsChecked
                if SwitchForESPitems_IsChecked then
                    SwitchForESPitems_IndBorder.Position = SwitchForESPitems.Position + Vector2.new(21, 1)
                    SwitchForESPitems_Ind.Position = SwitchForESPitems.Position + Vector2.new(21, 1)
                else
                    SwitchForESPitems_IndBorder.Position = SwitchForESPitems.Position + Vector2.new(1, 1)
                    SwitchForESPitems_Ind.Position = SwitchForESPitems.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(SwitchForESPitems_IsChecked) end) end
            end

            if ESPswitchToCurrency_Label.Visible and mPos.X >= ESPswitchToCurrency.Position.X and mPos.X <= ESPswitchToCurrency.Position.X + ESPswitchToCurrency.Size.X and
               mPos.Y >= ESPswitchToCurrency.Position.Y and mPos.Y <= ESPswitchToCurrency.Position.Y + ESPswitchToCurrency.Size.Y then

                ESPswitchToCurrency_IsChecked = not ESPswitchToCurrency_IsChecked
                if ESPswitchToCurrency_IsChecked then
                    ESPswitchToCurrency_IndBorder.Position = ESPswitchToCurrency.Position + Vector2.new(21, 1)
                    ESPswitchToCurrency_Ind.Position = ESPswitchToCurrency.Position + Vector2.new(21, 1)
                else
                    ESPswitchToCurrency_IndBorder.Position = ESPswitchToCurrency.Position + Vector2.new(1, 1)
                    ESPswitchToCurrency_Ind.Position = ESPswitchToCurrency.Position + Vector2.new(1, 1)
                end
                if onSwitch then pcall(function() onSwitch(ESPswitchToCurrency_IsChecked) end) end
            end

            if Main1.Visible and mPos.X >= Main1.Position.X and mPos.X <= Main1.Position.X + Main1.Size.X and
               mPos.Y >= Main1.Position.Y and mPos.Y <= Main1.Position.Y + Main1.Size.Y then
                dragging = Main1
                dragStart = mPos
                startPos = Main1.Position
            end

            if SliderForESPdistance_Knob.Visible and mPos.X >= SliderForESPdistance_Knob.Position.X and mPos.X <= SliderForESPdistance_Knob.Position.X + SliderForESPdistance_Knob.Size.X and
               mPos.Y >= SliderForESPdistance_Knob.Position.Y and mPos.Y <= SliderForESPdistance_Knob.Position.Y + SliderForESPdistance_Knob.Size.Y then
                dragging = SliderForESPdistance_Knob
                dragStart = mPos
                startPos = SliderForESPdistance_Knob.Position
            end
        end

        if not mouse1 and lastMouse1 then
            dragging = nil
        end

        if dragging and mouse1 then
            local delta = mPos - dragStart
            dragging.Position = startPos + delta
            if dragging == SliderForESPdistance_Knob then

                local minX = SliderForESPdistance.Position.X
                local maxX = SliderForESPdistance.Position.X + SliderForESPdistance.Size.X
                if dragging.Position.X < minX then dragging.Position = Vector2.new(minX, dragging.Position.Y) end
                if dragging.Position.X > maxX then dragging.Position = Vector2.new(maxX, dragging.Position.Y) end
                dragging.Position = Vector2.new(dragging.Position.X, SliderForESPdistance.Position.Y + 5 - dragging.Size.Y/2)

                local percent = (dragging.Position.X - minX) / (SliderForESPdistance.Size.X)
                local value = 25 + (1488 - 25) * percent
                SliderForESPdistance_Value = value
                SliderForESPdistance_ValueText.Text = tostring(math.floor(value)) .. ""
                pcall(function() onChanged(value) end)
            end
            if dragging == Main1 then
                do local gSteps=50 local gW=604
                    for i,sq in ipairs(VeryTopPlace_Parts) do
                        sq.Position=Vector2.new(dragging.Position.X+(i-1)*math.floor(gW/gSteps),dragging.Position.Y)
                    end end
                Circle5.Position = dragging.Position + Vector2.new(25, 23)
                TextRATHUB.Position = dragging.Position + Vector2.new(54, 17)
                PlaceTabs.Position = dragging.Position + Vector2.new(2, 46)
                VisualsTab.Position = dragging.Position + Vector2.new(8, 50)
                VisualsTab_Text.Position = VisualsTab.Position + Vector2.new(77/2, 36/2)
                ExploitsTab.Position = dragging.Position + Vector2.new(100, 50)
                ExploitsTab_Text.Position = ExploitsTab.Position + Vector2.new(71/2, 35/2)
                MiscTab.Position = dragging.Position + Vector2.new(186, 50)
                MiscTab_Text.Position = MiscTab.Position + Vector2.new(73/2, 35/2)
                SettingsTab.Position = dragging.Position + Vector2.new(273, 50)
                SettingsTab_Text.Position = SettingsTab.Position + Vector2.new(73/2, 35/2)
                Line1.Position = dragging.Position + Vector2.new(0, 45)
                Line2.Position = dragging.Position + Vector2.new(0, 89)
                ContentPageVisuals.Position = dragging.Position + Vector2.new(25, 114)
                ContentPageVisuals_Border.Position = ContentPageVisuals.Position
                ESPkeycardSwitch.Position = dragging.Position + Vector2.new(506, 123)
                ESPkeycardSwitch_Bg.Position = ESPkeycardSwitch.Position
                ESPkeycardSwitch_Label.Position = ESPkeycardSwitch.Position + Vector2.new(50, 4)
                if ESPkeycardSwitch_IsChecked then
                    ESPkeycardSwitch_IndBorder.Position = ESPkeycardSwitch.Position + Vector2.new(21, 1)
                    ESPkeycardSwitch_Ind.Position = ESPkeycardSwitch.Position + Vector2.new(21, 1)
                else
                    ESPkeycardSwitch_IndBorder.Position = ESPkeycardSwitch.Position + Vector2.new(1, 1)
                    ESPkeycardSwitch_Ind.Position = ESPkeycardSwitch.Position + Vector2.new(1, 1)
                end
                EspKeycardtext.Position = dragging.Position + Vector2.new(34, 123)
                EspDoorText.Position = dragging.Position + Vector2.new(34, 149)
                ESPDoorsSwitch.Position = dragging.Position + Vector2.new(506, 149)
                ESPDoorsSwitch_Bg.Position = ESPDoorsSwitch.Position
                ESPDoorsSwitch_Label.Position = ESPDoorsSwitch.Position + Vector2.new(50, 4)
                if ESPDoorsSwitch_IsChecked then
                    ESPDoorsSwitch_IndBorder.Position = ESPDoorsSwitch.Position + Vector2.new(21, 1)
                    ESPDoorsSwitch_Ind.Position = ESPDoorsSwitch.Position + Vector2.new(21, 1)
                else
                    ESPDoorsSwitch_IndBorder.Position = ESPDoorsSwitch.Position + Vector2.new(1, 1)
                    ESPDoorsSwitch_Ind.Position = ESPDoorsSwitch.Position + Vector2.new(1, 1)
                end
                ContentPageVisuals2.Position = dragging.Position + Vector2.new(25, 260)
                ContentPageVisuals2_Border.Position = ContentPageVisuals2.Position
                TextNofiticationAngler.Position = dragging.Position + Vector2.new(34, 275)
                NoffiticationAnglerSwitch.Position = dragging.Position + Vector2.new(516, 275)
                NoffiticationAnglerSwitch_Bg.Position = NoffiticationAnglerSwitch.Position
                NoffiticationAnglerSwitch_Label.Position = NoffiticationAnglerSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationAnglerSwitch_IsChecked then
                    NoffiticationAnglerSwitch_IndBorder.Position = NoffiticationAnglerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationAnglerSwitch_Ind.Position = NoffiticationAnglerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationAnglerSwitch_IndBorder.Position = NoffiticationAnglerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationAnglerSwitch_Ind.Position = NoffiticationAnglerSwitch.Position + Vector2.new(1, 1)
                end
                NofFrogerText.Position = dragging.Position + Vector2.new(34, 295)
                NofPinkieText.Position = dragging.Position + Vector2.new(34, 315)
                NofBlitzText.Position = dragging.Position + Vector2.new(34, 335)
                NofChainsmokerText.Position = dragging.Position + Vector2.new(34, 355)
                NofPandemoniumText.Position = dragging.Position + Vector2.new(34, 375)
                NofA60text.Position = dragging.Position + Vector2.new(34, 395)
                NofHarbingerText.Position = dragging.Position + Vector2.new(34, 415)
                NofPainterRoomText.Position = dragging.Position + Vector2.new(34, 435)
                NoffiticationFrogerSwitch.Position = dragging.Position + Vector2.new(516, 295)
                NoffiticationFrogerSwitch_Bg.Position = NoffiticationFrogerSwitch.Position
                NoffiticationFrogerSwitch_Label.Position = NoffiticationFrogerSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationFrogerSwitch_IsChecked then
                    NoffiticationFrogerSwitch_IndBorder.Position = NoffiticationFrogerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationFrogerSwitch_Ind.Position = NoffiticationFrogerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationFrogerSwitch_IndBorder.Position = NoffiticationFrogerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationFrogerSwitch_Ind.Position = NoffiticationFrogerSwitch.Position + Vector2.new(1, 1)
                end
                NoffiticationPinkieSwitch.Position = dragging.Position + Vector2.new(516, 315)
                NoffiticationPinkieSwitch_Bg.Position = NoffiticationPinkieSwitch.Position
                NoffiticationPinkieSwitch_Label.Position = NoffiticationPinkieSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationPinkieSwitch_IsChecked then
                    NoffiticationPinkieSwitch_IndBorder.Position = NoffiticationPinkieSwitch.Position + Vector2.new(18, 1)
                    NoffiticationPinkieSwitch_Ind.Position = NoffiticationPinkieSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationPinkieSwitch_IndBorder.Position = NoffiticationPinkieSwitch.Position + Vector2.new(1, 1)
                    NoffiticationPinkieSwitch_Ind.Position = NoffiticationPinkieSwitch.Position + Vector2.new(1, 1)
                end
                NoffiticationBlitzSwitch.Position = dragging.Position + Vector2.new(516, 335)
                NoffiticationBlitzSwitch_Bg.Position = NoffiticationBlitzSwitch.Position
                NoffiticationBlitzSwitch_Label.Position = NoffiticationBlitzSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationBlitzSwitch_IsChecked then
                    NoffiticationBlitzSwitch_IndBorder.Position = NoffiticationBlitzSwitch.Position + Vector2.new(18, 1)
                    NoffiticationBlitzSwitch_Ind.Position = NoffiticationBlitzSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationBlitzSwitch_IndBorder.Position = NoffiticationBlitzSwitch.Position + Vector2.new(1, 1)
                    NoffiticationBlitzSwitch_Ind.Position = NoffiticationBlitzSwitch.Position + Vector2.new(1, 1)
                end
                NoffiticationChainsmokerSwitch.Position = dragging.Position + Vector2.new(516, 355)
                NoffiticationChainsmokerSwitch_Bg.Position = NoffiticationChainsmokerSwitch.Position
                NoffiticationChainsmokerSwitch_Label.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationChainsmokerSwitch_IsChecked then
                    NoffiticationChainsmokerSwitch_IndBorder.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationChainsmokerSwitch_Ind.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationChainsmokerSwitch_IndBorder.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationChainsmokerSwitch_Ind.Position = NoffiticationChainsmokerSwitch.Position + Vector2.new(1, 1)
                end
                NoffiticationPandemoniumSwitch.Position = dragging.Position + Vector2.new(516, 375)
                NoffiticationPandemoniumSwitch_Bg.Position = NoffiticationPandemoniumSwitch.Position
                NoffiticationPandemoniumSwitch_Label.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationPandemoniumSwitch_IsChecked then
                    NoffiticationPandemoniumSwitch_IndBorder.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(18, 1)
                    NoffiticationPandemoniumSwitch_Ind.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationPandemoniumSwitch_IndBorder.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(1, 1)
                    NoffiticationPandemoniumSwitch_Ind.Position = NoffiticationPandemoniumSwitch.Position + Vector2.new(1, 1)
                end
                NoffiticationA60Switch.Position = dragging.Position + Vector2.new(516, 395)
                NoffiticationA60Switch_Bg.Position = NoffiticationA60Switch.Position
                NoffiticationA60Switch_Label.Position = NoffiticationA60Switch.Position + Vector2.new(40, 0.5)
                if NoffiticationA60Switch_IsChecked then
                    NoffiticationA60Switch_IndBorder.Position = NoffiticationA60Switch.Position + Vector2.new(18, 1)
                    NoffiticationA60Switch_Ind.Position = NoffiticationA60Switch.Position + Vector2.new(18, 1)
                else
                    NoffiticationA60Switch_IndBorder.Position = NoffiticationA60Switch.Position + Vector2.new(1, 1)
                    NoffiticationA60Switch_Ind.Position = NoffiticationA60Switch.Position + Vector2.new(1, 1)
                end
                NoffiticationHarbingerSwitch.Position = dragging.Position + Vector2.new(516, 415)
                NoffiticationHarbingerSwitch_Bg.Position = NoffiticationHarbingerSwitch.Position
                NoffiticationHarbingerSwitch_Label.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationHarbingerSwitch_IsChecked then
                    NoffiticationHarbingerSwitch_IndBorder.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(18, 1)
                    NoffiticationHarbingerSwitch_Ind.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationHarbingerSwitch_IndBorder.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(1, 1)
                    NoffiticationHarbingerSwitch_Ind.Position = NoffiticationHarbingerSwitch.Position + Vector2.new(1, 1)
                end
                NoffiticationPainterRoomSwitch.Position = dragging.Position + Vector2.new(516, 435)
                NoffiticationPainterRoomSwitch_Bg.Position = NoffiticationPainterRoomSwitch.Position
                NoffiticationPainterRoomSwitch_Label.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(40, 0.5)
                if NoffiticationPainterRoomSwitch_IsChecked then
                    NoffiticationPainterRoomSwitch_IndBorder.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(18, 1)
                    NoffiticationPainterRoomSwitch_Ind.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(18, 1)
                else
                    NoffiticationPainterRoomSwitch_IndBorder.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(1, 1)
                    NoffiticationPainterRoomSwitch_Ind.Position = NoffiticationPainterRoomSwitch.Position + Vector2.new(1, 1)
                end
                ContentPageVisuals3.Position = dragging.Position + Vector2.new(25, 477)
                ContentPageVisuals3_Border.Position = ContentPageVisuals3.Position
                EnableWatermarkText.Position = dragging.Position + Vector2.new(34, 485)
                EnableWatermarkSwitch.Position = dragging.Position + Vector2.new(516, 485)
                EnableWatermarkSwitch_Bg.Position = EnableWatermarkSwitch.Position
                EnableWatermarkSwitch_Label.Position = EnableWatermarkSwitch.Position + Vector2.new(40, 0.5)
                if EnableWatermarkSwitch_IsChecked then
                    EnableWatermarkSwitch_IndBorder.Position = EnableWatermarkSwitch.Position + Vector2.new(18, 1)
                    EnableWatermarkSwitch_Ind.Position = EnableWatermarkSwitch.Position + Vector2.new(18, 1)
                else
                    EnableWatermarkSwitch_IndBorder.Position = EnableWatermarkSwitch.Position + Vector2.new(1, 1)
                    EnableWatermarkSwitch_Ind.Position = EnableWatermarkSwitch.Position + Vector2.new(1, 1)
                end
                TextToRescanForce.Position = dragging.Position + Vector2.new(118, 123)
                EspItemsText.Position = dragging.Position + Vector2.new(34, 172)
                SwitchForESPitems.Position = dragging.Position + Vector2.new(506, 172)
                SwitchForESPitems_Bg.Position = SwitchForESPitems.Position
                SwitchForESPitems_Label.Position = SwitchForESPitems.Position + Vector2.new(50, 4)
                if SwitchForESPitems_IsChecked then
                    SwitchForESPitems_IndBorder.Position = SwitchForESPitems.Position + Vector2.new(21, 1)
                    SwitchForESPitems_Ind.Position = SwitchForESPitems.Position + Vector2.new(21, 1)
                else
                    SwitchForESPitems_IndBorder.Position = SwitchForESPitems.Position + Vector2.new(1, 1)
                    SwitchForESPitems_Ind.Position = SwitchForESPitems.Position + Vector2.new(1, 1)
                end
                TextESPCurrency.Position = dragging.Position + Vector2.new(34, 198)
                ESPswitchToCurrency.Position = dragging.Position + Vector2.new(506, 198)
                ESPswitchToCurrency_Bg.Position = ESPswitchToCurrency.Position
                ESPswitchToCurrency_Label.Position = ESPswitchToCurrency.Position + Vector2.new(50, 4)
                if ESPswitchToCurrency_IsChecked then
                    ESPswitchToCurrency_IndBorder.Position = ESPswitchToCurrency.Position + Vector2.new(21, 1)
                    ESPswitchToCurrency_Ind.Position = ESPswitchToCurrency.Position + Vector2.new(21, 1)
                else
                    ESPswitchToCurrency_IndBorder.Position = ESPswitchToCurrency.Position + Vector2.new(1, 1)
                    ESPswitchToCurrency_Ind.Position = ESPswitchToCurrency.Position + Vector2.new(1, 1)
                end
                ContentPageExploits.Position = dragging.Position + Vector2.new(19, 107)
                ContentPageExploits_Border.Position = ContentPageExploits.Position
                AutoHideSwitch.Position = dragging.Position + Vector2.new(493, 125)
                AutoHideSwitch_Bg.Position = AutoHideSwitch.Position
                AutoHideSwitch_Label.Position = AutoHideSwitch.Position + Vector2.new(50, 1.5)
                if AutoHideSwitch_IsChecked then
                    AutoHideSwitch_IndBorder.Position = AutoHideSwitch.Position + Vector2.new(26, 1)
                    AutoHideSwitch_Ind.Position = AutoHideSwitch.Position + Vector2.new(26, 1)
                else
                    AutoHideSwitch_IndBorder.Position = AutoHideSwitch.Position + Vector2.new(1, 1)
                    AutoHideSwitch_Ind.Position = AutoHideSwitch.Position + Vector2.new(1, 1)
                end
                AutoHideText.Position = dragging.Position + Vector2.new(33, 125)
                ContentPageMisc.Position = dragging.Position + Vector2.new(14, 106)
                ContentPageMisc_Border.Position = ContentPageMisc.Position
                AutoRescanSwitch.Position = dragging.Position + Vector2.new(294, 124)
                AutoRescanSwitch_Bg.Position = AutoRescanSwitch.Position
                AutoRescanSwitch_Label.Position = AutoRescanSwitch.Position + Vector2.new(50, 1.5)
                if AutoRescanSwitch_IsChecked then
                    AutoRescanSwitch_IndBorder.Position = AutoRescanSwitch.Position + Vector2.new(26, 1)
                    AutoRescanSwitch_Ind.Position = AutoRescanSwitch.Position + Vector2.new(26, 1)
                else
                    AutoRescanSwitch_IndBorder.Position = AutoRescanSwitch.Position + Vector2.new(1, 1)
                    AutoRescanSwitch_Ind.Position = AutoRescanSwitch.Position + Vector2.new(1, 1)
                end
                AutoRescanText.Position = dragging.Position + Vector2.new(20, 124)
                ContentPageMisc2.Position = dragging.Position + Vector2.new(14, 271)
                ContentPageMisc2_Border.Position = ContentPageMisc2.Position
                SliderForESPdistance.Position = dragging.Position + Vector2.new(20, 293)
                local percent = (SliderForESPdistance_Value - 25) / (1488 - 25)
                SliderForESPdistance_Knob.Position = SliderForESPdistance.Position + Vector2.new(200 * percent - 10, 5 - 10)
                SliderForESPdistance_ValueText.Position = SliderForESPdistance.Position + Vector2.new(200/2, -10)
                TextUnderSliderEspDis.Position = dragging.Position + Vector2.new(20, 317)
                ContentPageSettings.Position = dragging.Position + Vector2.new(25, 111)
                ContentPageSettings_Border.Position = ContentPageSettings.Position
                ToggleUIvisiblity.Position = dragging.Position + Vector2.new(37, 125)
                ToggleUIvisiblity_Text.Position = ToggleUIvisiblity.Position + Vector2.new(74/2, 16/2)
            end
        end

        lastMouse1 = mouse1
    end
end
