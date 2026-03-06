local Mouse = game.Players.LocalPlayer:GetMouse()
local Viewport = workspace.CurrentCamera.ViewportSize

local activeTab = nil
local advancedWindowOpen = false
local closeKey = 0x70

local function UpdateSwitchColor(sw, checked)
    if checked then
        sw.Color = Color3.fromHex("#1a1a1a")
    else
        sw.Color = Color3.fromHex("#cbcfd5")
    end
end

local MainSwitchNotification = { IsChecked = false, Bg = nil, Ind = nil, IndBorder = nil }
local MainSwitchESP = { IsChecked = false, Bg = nil, Ind = nil, IndBorder = nil }
local MainSwitchAutoHide = { IsChecked = false, Bg = nil, Ind = nil, IndBorder = nil }

local AdvSwitchESP, AdvSwitchESP4, AdvSwitchItems, AdvSwitchCurrency, AdvSwitchKeycards, AdvSwitchDoors, AdvSwitchRich
local AdvSwitchNotif, AdvSwitchWatermark, AdvSwitchNotifKeycards

local uiElements = {}

local Overlay = Drawing.new("Square")
Overlay.Visible = false
Overlay.Transparency = 0.5
Overlay.ZIndex = 5
Overlay.Color = Color3.fromHex("#000000")
Overlay.Position = Vector2.new(0, 0)
Overlay.Size = Viewport
Overlay.Filled = true
table.insert(uiElements, Overlay)

local VeryBackGUI = Drawing.new("Square")
VeryBackGUI.Visible = false
VeryBackGUI.Transparency = 1
VeryBackGUI.ZIndex = 10
VeryBackGUI.Color = Color3.fromHex("#0d0c0c")
VeryBackGUI.Position = Vector2.new(118, 29)
VeryBackGUI.Size = Vector2.new(569, 42)
VeryBackGUI.Filled = true
VeryBackGUI.Corner = 4
table.insert(uiElements, VeryBackGUI)

local VeryBackGUI_Border = Drawing.new("Square")
VeryBackGUI_Border.Visible = false
VeryBackGUI_Border.Transparency = 1
VeryBackGUI_Border.ZIndex = 11
VeryBackGUI_Border.Color = Color3.fromHex("#1b1b1a")
VeryBackGUI_Border.Filled = false
VeryBackGUI_Border.Thickness = 1
VeryBackGUI_Border.Position = VeryBackGUI.Position
VeryBackGUI_Border.Size = VeryBackGUI.Size
VeryBackGUI_Border.Corner = 4
table.insert(uiElements, VeryBackGUI_Border)

local Line1 = Drawing.new("Square")
Line1.Visible = false
Line1.Transparency = 1
Line1.ZIndex = 30
Line1.Color = Color3.fromHex("#1b1b1a")
Line1.Position = VeryBackGUI.Position + Vector2.new(0, 41.5)
Line1.Size = Vector2.new(569, 0.5)
Line1.Filled = true
Line1.Corner = 1
table.insert(uiElements, Line1)

local BackGUItabs = Drawing.new("Square")
BackGUItabs.Visible = false
BackGUItabs.Transparency = 1
BackGUItabs.ZIndex = 20
BackGUItabs.Color = Color3.fromHex("#0d0c0c")
BackGUItabs.Position = VeryBackGUI.Position + Vector2.new(0, 42)
BackGUItabs.Size = Vector2.new(568, 42)
BackGUItabs.Filled = true
table.insert(uiElements, BackGUItabs)

local Line3 = Drawing.new("Square")
Line3.Visible = false
Line3.Transparency = 1
Line3.ZIndex = 90
Line3.Color = Color3.fromHex("#1b1b1a")
Line3.Position = VeryBackGUI.Position + Vector2.new(-2.5, 84)
Line3.Size = Vector2.new(569, 1)
Line3.Filled = true
table.insert(uiElements, Line3)

local Line2 = Drawing.new("Square")
Line2.Visible = false
Line2.Transparency = 1
Line2.ZIndex = 40
Line2.Color = Color3.fromHex("#1b1b1a")
Line2.Position = VeryBackGUI.Position + Vector2.new(0, 42)
Line2.Size = Vector2.new(1, 42)
Line2.Filled = true
Line2.Corner = 1
table.insert(uiElements, Line2)

local TextRATHUB = Drawing.new("Text")
TextRATHUB.Visible = false
TextRATHUB.Transparency = 1
TextRATHUB.ZIndex = 50
TextRATHUB.Color = Color3.fromHex("#00c950")
TextRATHUB.Position = VeryBackGUI.Position + Vector2.new(48, 13)
TextRATHUB.Text = "RATHUB"
TextRATHUB.Size = 14
TextRATHUB.Center = false
TextRATHUB.Outline = true
TextRATHUB.Font = Drawing.Fonts.UI
table.insert(uiElements, TextRATHUB)

local TextLOGO = Drawing.new("Text")
TextLOGO.Visible = false
TextLOGO.Transparency = 1
TextLOGO.ZIndex = 60
TextLOGO.Color = Color3.fromHex("#00c950")
TextLOGO.Position = VeryBackGUI.Position + Vector2.new(20, 13)
TextLOGO.Text = ">_"
TextLOGO.Size = 14
TextLOGO.Center = false
TextLOGO.Outline = true
TextLOGO.Font = Drawing.Fonts.UI
table.insert(uiElements, TextLOGO)

local BackContentTabs = Drawing.new("Square")
BackContentTabs.Visible = false
BackContentTabs.Transparency = 1
BackContentTabs.ZIndex = 70
BackContentTabs.Color = Color3.fromHex("#111111")
BackContentTabs.Position = VeryBackGUI.Position + Vector2.new(0, 84)
BackContentTabs.Size = Vector2.new(569, 419)
BackContentTabs.Filled = true
BackContentTabs.Corner = 4
table.insert(uiElements, BackContentTabs)

local BackContentTabs_Border = Drawing.new("Square")
BackContentTabs_Border.Visible = false
BackContentTabs_Border.Transparency = 1
BackContentTabs_Border.ZIndex = 71
BackContentTabs_Border.Color = Color3.fromHex("#1b1b1a")
BackContentTabs_Border.Filled = false
BackContentTabs_Border.Thickness = 1
BackContentTabs_Border.Position = BackContentTabs.Position
BackContentTabs_Border.Size = BackContentTabs.Size
BackContentTabs_Border.Corner = 4
table.insert(uiElements, BackContentTabs_Border)

local BackGUI2 = Drawing.new("Square")
BackGUI2.Visible = false
BackGUI2.Transparency = 1
BackGUI2.ZIndex = 80
BackGUI2.Color = Color3.fromHex("#0c0c0d")
BackGUI2.Position = VeryBackGUI.Position + Vector2.new(0, 488)
BackGUI2.Size = Vector2.new(569, 15)
BackGUI2.Filled = true
table.insert(uiElements, BackGUI2)

local BackGUI2_Border = Drawing.new("Square")
BackGUI2_Border.Visible = false
BackGUI2_Border.Transparency = 1
BackGUI2_Border.ZIndex = 81
BackGUI2_Border.Color = Color3.fromHex("#1b1a1b")
BackGUI2_Border.Filled = false
BackGUI2_Border.Thickness = 1
BackGUI2_Border.Position = BackGUI2.Position
BackGUI2_Border.Size = BackGUI2.Size
table.insert(uiElements, BackGUI2_Border)

local TabVisuals = Drawing.new("Square")
TabVisuals.Visible = false
TabVisuals.Transparency = 1
TabVisuals.ZIndex = 100
TabVisuals.Color = Color3.fromHex("#0c0c0d")
TabVisuals.Position = VeryBackGUI.Position + Vector2.new(11, 51.5)
TabVisuals.Size = Vector2.new(86, 22)
TabVisuals.Filled = true
TabVisuals.Corner = 4
table.insert(uiElements, TabVisuals)

local TabVisuals_Text = Drawing.new("Text")
TabVisuals_Text.Text = "Visuals"
TabVisuals_Text.Size = 14
TabVisuals_Text.Center = true
TabVisuals_Text.Outline = true
TabVisuals_Text.Font = 0
TabVisuals_Text.Color = Color3.fromHex("#6b7382")
TabVisuals_Text.Position = TabVisuals.Position + Vector2.new(86/2, 22/2)
TabVisuals_Text.Visible = false
TabVisuals_Text.ZIndex = 102
table.insert(uiElements, TabVisuals_Text)

local TabExploits = Drawing.new("Square")
TabExploits.Visible = false
TabExploits.Transparency = 1
TabExploits.ZIndex = 120
TabExploits.Color = Color3.fromHex("#0c0c0d")
TabExploits.Position = VeryBackGUI.Position + Vector2.new(105, 51.5)
TabExploits.Size = Vector2.new(86, 22)
TabExploits.Filled = true
TabExploits.Corner = 4
table.insert(uiElements, TabExploits)

local TabExploits_Text = Drawing.new("Text")
TabExploits_Text.Text = "Exploits"
TabExploits_Text.Size = 14
TabExploits_Text.Center = true
TabExploits_Text.Outline = true
TabExploits_Text.Font = 0
TabExploits_Text.Color = Color3.fromHex("#6b7382")
TabExploits_Text.Position = TabExploits.Position + Vector2.new(86/2, 22/2)
TabExploits_Text.Visible = false
TabExploits_Text.ZIndex = 122
table.insert(uiElements, TabExploits_Text)

local TabMisc = Drawing.new("Square")
TabMisc.Visible = false
TabMisc.Transparency = 1
TabMisc.ZIndex = 130
TabMisc.Color = Color3.fromHex("#0c0c0d")
TabMisc.Position = VeryBackGUI.Position + Vector2.new(197, 52)
TabMisc.Size = Vector2.new(86, 22)
TabMisc.Filled = true
TabMisc.Corner = 4
table.insert(uiElements, TabMisc)

local TabMisc_Text = Drawing.new("Text")
TabMisc_Text.Text = "Misc"
TabMisc_Text.Size = 14
TabMisc_Text.Center = true
TabMisc_Text.Outline = true
TabMisc_Text.Font = 0
TabMisc_Text.Color = Color3.fromHex("#6b7382")
TabMisc_Text.Position = TabMisc.Position + Vector2.new(86/2, 22/2)
TabMisc_Text.Visible = false
TabMisc_Text.ZIndex = 132
table.insert(uiElements, TabMisc_Text)

local TabInfo = Drawing.new("Square")
TabInfo.Visible = false
TabInfo.Transparency = 1
TabInfo.ZIndex = 140
TabInfo.Color = Color3.fromHex("#0c0c0d")
TabInfo.Position = VeryBackGUI.Position + Vector2.new(290, 52)
TabInfo.Size = Vector2.new(86, 22)
TabInfo.Filled = true
TabInfo.Corner = 4
table.insert(uiElements, TabInfo)

local TabInfo_Text = Drawing.new("Text")
TabInfo_Text.Text = "Info"
TabInfo_Text.Size = 14
TabInfo_Text.Center = true
TabInfo_Text.Outline = true
TabInfo_Text.Font = 0
TabInfo_Text.Color = Color3.fromHex("#6b7382")
TabInfo_Text.Position = TabInfo.Position + Vector2.new(86/2, 22/2)
TabInfo_Text.Visible = false
TabInfo_Text.ZIndex = 142
table.insert(uiElements, TabInfo_Text)

local Square16 = Drawing.new("Square")
Square16.Visible = false
Square16.Transparency = 1
Square16.ZIndex = 110
Square16.Color = Color3.fromHex("#1b1b1a")
Square16.Position = VeryBackGUI.Position + Vector2.new(567, 41.5)
Square16.Size = Vector2.new(1, 42)
Square16.Filled = true
Square16.Corner = 1
table.insert(uiElements, Square16)

local TabVisuals_Border = Drawing.new("Square")
TabVisuals_Border.Visible = false
TabVisuals_Border.Transparency = 1
TabVisuals_Border.ZIndex = 101
TabVisuals_Border.Color = Color3.fromHex("#085226")
TabVisuals_Border.Filled = false
TabVisuals_Border.Thickness = 1
TabVisuals_Border.Position = TabVisuals.Position
TabVisuals_Border.Size = TabVisuals.Size
TabVisuals_Border.Corner = 4
table.insert(uiElements, TabVisuals_Border)

local TabExploits_Border = Drawing.new("Square")
TabExploits_Border.Visible = false
TabExploits_Border.Transparency = 1
TabExploits_Border.ZIndex = 121
TabExploits_Border.Color = Color3.fromHex("#085226")
TabExploits_Border.Filled = false
TabExploits_Border.Thickness = 1
TabExploits_Border.Position = TabExploits.Position
TabExploits_Border.Size = TabExploits.Size
TabExploits_Border.Corner = 4
table.insert(uiElements, TabExploits_Border)

local TabMisc_Border = Drawing.new("Square")
TabMisc_Border.Visible = false
TabMisc_Border.Transparency = 1
TabMisc_Border.ZIndex = 131
TabMisc_Border.Color = Color3.fromHex("#085226")
TabMisc_Border.Filled = false
TabMisc_Border.Thickness = 1
TabMisc_Border.Position = TabMisc.Position
TabMisc_Border.Size = TabMisc.Size
TabMisc_Border.Corner = 4
table.insert(uiElements, TabMisc_Border)

local TabInfo_Border = Drawing.new("Square")
TabInfo_Border.Visible = false
TabInfo_Border.Transparency = 1
TabInfo_Border.ZIndex = 141
TabInfo_Border.Color = Color3.fromHex("#085226")
TabInfo_Border.Filled = false
TabInfo_Border.Thickness = 1
TabInfo_Border.Position = TabInfo.Position
TabInfo_Border.Size = TabInfo.Size
TabInfo_Border.Corner = 4
table.insert(uiElements, TabInfo_Border)

local VisualsContent1 = Drawing.new("Square")
VisualsContent1.Visible = false
VisualsContent1.Transparency = 1
VisualsContent1.ZIndex = 150
VisualsContent1.Color = Color3.fromHex("#111010")
VisualsContent1.Position = VeryBackGUI.Position + Vector2.new(20, 97)
VisualsContent1.Size = Vector2.new(224, 51)
VisualsContent1.Filled = true
VisualsContent1.Corner = 5
table.insert(uiElements, VisualsContent1)

local VisualsContent1_Border = Drawing.new("Square")
VisualsContent1_Border.Visible = false
VisualsContent1_Border.Transparency = 1
VisualsContent1_Border.ZIndex = 151
VisualsContent1_Border.Color = Color3.fromHex("#1b1a1b")
VisualsContent1_Border.Filled = false
VisualsContent1_Border.Thickness = 1
VisualsContent1_Border.Position = VisualsContent1.Position
VisualsContent1_Border.Size = VisualsContent1.Size
VisualsContent1_Border.Corner = 5
table.insert(uiElements, VisualsContent1_Border)

local NotificationTEXT = Drawing.new("Text")
NotificationTEXT.Visible = false
NotificationTEXT.Transparency = 1
NotificationTEXT.ZIndex = 170
NotificationTEXT.Color = Color3.fromHex("#d1d4dd")
NotificationTEXT.Position = VisualsContent1.Position + Vector2.new(10, 13)
NotificationTEXT.Text = "Notification"
NotificationTEXT.Size = 14
NotificationTEXT.Center = false
NotificationTEXT.Outline = true
NotificationTEXT.Font = Drawing.Fonts.UI
table.insert(uiElements, NotificationTEXT)

local DescryptionNofitication = Drawing.new("Text")
DescryptionNofitication.Visible = false
DescryptionNofitication.Transparency = 1
DescryptionNofitication.ZIndex = 190
DescryptionNofitication.Color = Color3.fromHex("#6b7382")
DescryptionNofitication.Position = VisualsContent1.Position + Vector2.new(16, 28)
DescryptionNofitication.Text = "Enable notifications for entitys"
DescryptionNofitication.Size = 11
DescryptionNofitication.Center = false
DescryptionNofitication.Outline = true
DescryptionNofitication.Font = Drawing.Fonts.UI
table.insert(uiElements, DescryptionNofitication)

local SwitchNotification = Drawing.new("Square")
SwitchNotification.Visible = false
SwitchNotification.Transparency = 1
SwitchNotification.Color = Color3.fromHex("#000000")
SwitchNotification.Thickness = 1
SwitchNotification.Filled = false
SwitchNotification.Size = Vector2.new(25, 15)
SwitchNotification.Position = VeryBackGUI.Position + Vector2.new(210, 106)
SwitchNotification.ZIndex = 210
SwitchNotification.Corner = 10
table.insert(uiElements, SwitchNotification)

local SwitchNotification_Bg = Drawing.new("Square")
SwitchNotification_Bg.Visible = false
SwitchNotification_Bg.Transparency = 1
SwitchNotification_Bg.Color = Color3.fromHex("#cbcfd5")
SwitchNotification_Bg.Filled = true
SwitchNotification_Bg.Size = SwitchNotification.Size
SwitchNotification_Bg.Position = SwitchNotification.Position
SwitchNotification_Bg.ZIndex = 210
SwitchNotification_Bg.Corner = 10
table.insert(uiElements, SwitchNotification_Bg)

local SwitchNotification_IndBorder = Drawing.new("Square")
SwitchNotification_IndBorder.Visible = false
SwitchNotification_IndBorder.Transparency = 1
SwitchNotification_IndBorder.Color = Color3.fromHex("#000000")
SwitchNotification_IndBorder.Thickness = 1
SwitchNotification_IndBorder.Filled = false
SwitchNotification_IndBorder.Size = Vector2.new(13, 13)
SwitchNotification_IndBorder.ZIndex = 212
SwitchNotification_IndBorder.Corner = 10
table.insert(uiElements, SwitchNotification_IndBorder)

local SwitchNotification_Ind = Drawing.new("Square")
SwitchNotification_Ind.Visible = false
SwitchNotification_Ind.Transparency = 1
SwitchNotification_Ind.Color = Color3.fromHex("#ffffff")
SwitchNotification_Ind.Filled = true
SwitchNotification_Ind.Size = Vector2.new(13, 13)
SwitchNotification_Ind.ZIndex = 212
SwitchNotification_Ind.Corner = 10
table.insert(uiElements, SwitchNotification_Ind)

local SwitchNotification_Label = Drawing.new("Text")
SwitchNotification_Label.Visible = false
SwitchNotification_Label.Text = ""
SwitchNotification_Label.Size = 8
SwitchNotification_Label.Color = Color3.fromHex("#FFFFFF")
SwitchNotification_Label.Outline = true
SwitchNotification_Label.Font = Drawing.Fonts.UI
SwitchNotification_Label.Position = SwitchNotification.Position + Vector2.new(35, 3.5)
SwitchNotification_Label.ZIndex = 211
table.insert(uiElements, SwitchNotification_Label)

MainSwitchNotification.Bg = SwitchNotification_Bg
MainSwitchNotification.Ind = SwitchNotification_Ind
MainSwitchNotification.IndBorder = SwitchNotification_IndBorder

local VisualsContent2 = Drawing.new("Square")
VisualsContent2.Visible = false
VisualsContent2.Transparency = 1
VisualsContent2.ZIndex = 160
VisualsContent2.Color = Color3.fromHex("#111010")
VisualsContent2.Position = VisualsContent1.Position + Vector2.new(0, 59)
VisualsContent2.Size = Vector2.new(224, 51)
VisualsContent2.Filled = true
VisualsContent2.Corner = 5
table.insert(uiElements, VisualsContent2)

local VisualsContent2_Border = Drawing.new("Square")
VisualsContent2_Border.Visible = false
VisualsContent2_Border.Transparency = 1
VisualsContent2_Border.ZIndex = 161
VisualsContent2_Border.Color = Color3.fromHex("#1b1a1b")
VisualsContent2_Border.Filled = false
VisualsContent2_Border.Thickness = 1
VisualsContent2_Border.Position = VisualsContent2.Position
VisualsContent2_Border.Size = VisualsContent2.Size
VisualsContent2_Border.Corner = 5
table.insert(uiElements, VisualsContent2_Border)

local TextESP = Drawing.new("Text")
TextESP.Visible = false
TextESP.Transparency = 1
TextESP.ZIndex = 180
TextESP.Color = Color3.fromHex("#d1d4dd")
TextESP.Position = VisualsContent1.Position + Vector2.new(10, 71)
TextESP.Text = "ESP"
TextESP.Size = 14
TextESP.Center = false
TextESP.Outline = true
TextESP.Font = Drawing.Fonts.UI
table.insert(uiElements, TextESP)

local ESPdescryption = Drawing.new("Text")
ESPdescryption.Visible = false
ESPdescryption.Transparency = 1
ESPdescryption.ZIndex = 200
ESPdescryption.Color = Color3.fromHex("#6b7382")
ESPdescryption.Position = VisualsContent1.Position + Vector2.new(16, 87)
ESPdescryption.Text = "Enable ESP's for misc"
ESPdescryption.Size = 11
ESPdescryption.Center = false
ESPdescryption.Outline = true
ESPdescryption.Font = Drawing.Fonts.UI
table.insert(uiElements, ESPdescryption)

local SwitchESP = Drawing.new("Square")
SwitchESP.Visible = false
SwitchESP.Transparency = 1
SwitchESP.Color = Color3.fromHex("#000000")
SwitchESP.Thickness = 1
SwitchESP.Filled = false
SwitchESP.Size = Vector2.new(25, 15)
SwitchESP.Position = VeryBackGUI.Position + Vector2.new(210, 162)
SwitchESP.ZIndex = 220
SwitchESP.Corner = 10
table.insert(uiElements, SwitchESP)

local SwitchESP_Bg = Drawing.new("Square")
SwitchESP_Bg.Visible = false
SwitchESP_Bg.Transparency = 1
SwitchESP_Bg.Color = Color3.fromHex("#cbcfd5")
SwitchESP_Bg.Filled = true
SwitchESP_Bg.Size = SwitchESP.Size
SwitchESP_Bg.Position = SwitchESP.Position
SwitchESP_Bg.ZIndex = 220
SwitchESP_Bg.Corner = 10
table.insert(uiElements, SwitchESP_Bg)

local SwitchESP_IndBorder = Drawing.new("Square")
SwitchESP_IndBorder.Visible = false
SwitchESP_IndBorder.Transparency = 1
SwitchESP_IndBorder.Color = Color3.fromHex("#000000")
SwitchESP_IndBorder.Thickness = 1
SwitchESP_IndBorder.Filled = false
SwitchESP_IndBorder.Size = Vector2.new(13, 13)
SwitchESP_IndBorder.ZIndex = 222
SwitchESP_IndBorder.Corner = 10
table.insert(uiElements, SwitchESP_IndBorder)

local SwitchESP_Ind = Drawing.new("Square")
SwitchESP_Ind.Visible = false
SwitchESP_Ind.Transparency = 1
SwitchESP_Ind.Color = Color3.fromHex("#ffffff")
SwitchESP_Ind.Filled = true
SwitchESP_Ind.Size = Vector2.new(13, 13)
SwitchESP_Ind.ZIndex = 222
SwitchESP_Ind.Corner = 10
table.insert(uiElements, SwitchESP_Ind)

local SwitchESP_Label = Drawing.new("Text")
SwitchESP_Label.Visible = false
SwitchESP_Label.Text = ""
SwitchESP_Label.Size = 8
SwitchESP_Label.Color = Color3.fromHex("#FFFFFF")
SwitchESP_Label.Outline = true
SwitchESP_Label.Font = Drawing.Fonts.UI
SwitchESP_Label.Position = SwitchESP.Position + Vector2.new(35, 3.5)
SwitchESP_Label.ZIndex = 221
table.insert(uiElements, SwitchESP_Label)

MainSwitchESP.Bg = SwitchESP_Bg
MainSwitchESP.Ind = SwitchESP_Ind
MainSwitchESP.IndBorder = SwitchESP_IndBorder

local ContentExploits1 = Drawing.new("Square")
ContentExploits1.Visible = false
ContentExploits1.Transparency = 1
ContentExploits1.ZIndex = 240
ContentExploits1.Color = Color3.fromHex("#111010")
ContentExploits1.Position = VeryBackGUI.Position + Vector2.new(20, 97)
ContentExploits1.Size = Vector2.new(224, 51)
ContentExploits1.Filled = true
ContentExploits1.Corner = 5
table.insert(uiElements, ContentExploits1)

local ContentExploits1_Border = Drawing.new("Square")
ContentExploits1_Border.Visible = false
ContentExploits1_Border.Transparency = 1
ContentExploits1_Border.ZIndex = 241
ContentExploits1_Border.Color = Color3.fromHex("#1b1a1b")
ContentExploits1_Border.Filled = false
ContentExploits1_Border.Thickness = 1
ContentExploits1_Border.Position = ContentExploits1.Position
ContentExploits1_Border.Size = ContentExploits1.Size
ContentExploits1_Border.Corner = 5
table.insert(uiElements, ContentExploits1_Border)

local AutoHideText = Drawing.new("Text")
AutoHideText.Visible = false
AutoHideText.Transparency = 1
AutoHideText.ZIndex = 270
AutoHideText.Color = Color3.fromHex("#d1d4dd")
AutoHideText.Position = ContentExploits1.Position + Vector2.new(15, 12)
AutoHideText.Text = "AutoHide"
AutoHideText.Size = 14
AutoHideText.Center = false
AutoHideText.Outline = true
AutoHideText.Font = Drawing.Fonts.UI
table.insert(uiElements, AutoHideText)

local AutoHideDescryption = Drawing.new("Text")
AutoHideDescryption.Visible = false
AutoHideDescryption.Transparency = 1
AutoHideDescryption.ZIndex = 260
AutoHideDescryption.Color = Color3.fromHex("#6b7382")
AutoHideDescryption.Position = ContentExploits1.Position + Vector2.new(23, 29)
AutoHideDescryption.Text = "Enable Auto-Hide from entity's"
AutoHideDescryption.Size = 11
AutoHideDescryption.Center = false
AutoHideDescryption.Outline = true
AutoHideDescryption.Font = Drawing.Fonts.UI
table.insert(uiElements, AutoHideDescryption)

local SwitchAutoHide = Drawing.new("Square")
SwitchAutoHide.Visible = false
SwitchAutoHide.Transparency = 1
SwitchAutoHide.Color = Color3.fromHex("#000000")
SwitchAutoHide.Thickness = 1
SwitchAutoHide.Filled = false
SwitchAutoHide.Size = Vector2.new(25, 15)
SwitchAutoHide.Position = VeryBackGUI.Position + Vector2.new(212, 109)
SwitchAutoHide.ZIndex = 250
SwitchAutoHide.Corner = 10
table.insert(uiElements, SwitchAutoHide)

local SwitchAutoHide_Bg = Drawing.new("Square")
SwitchAutoHide_Bg.Visible = false
SwitchAutoHide_Bg.Transparency = 1
SwitchAutoHide_Bg.Color = Color3.fromHex("#cbcfd5")
SwitchAutoHide_Bg.Filled = true
SwitchAutoHide_Bg.Size = SwitchAutoHide.Size
SwitchAutoHide_Bg.Position = SwitchAutoHide.Position
SwitchAutoHide_Bg.ZIndex = 250
SwitchAutoHide_Bg.Corner = 10
table.insert(uiElements, SwitchAutoHide_Bg)

local SwitchAutoHide_IndBorder = Drawing.new("Square")
SwitchAutoHide_IndBorder.Visible = false
SwitchAutoHide_IndBorder.Transparency = 1
SwitchAutoHide_IndBorder.Color = Color3.fromHex("#000000")
SwitchAutoHide_IndBorder.Thickness = 1
SwitchAutoHide_IndBorder.Filled = false
SwitchAutoHide_IndBorder.Size = Vector2.new(13, 13)
SwitchAutoHide_IndBorder.ZIndex = 252
SwitchAutoHide_IndBorder.Corner = 10
table.insert(uiElements, SwitchAutoHide_IndBorder)

local SwitchAutoHide_Ind = Drawing.new("Square")
SwitchAutoHide_Ind.Visible = false
SwitchAutoHide_Ind.Transparency = 1
SwitchAutoHide_Ind.Color = Color3.fromHex("#ffffff")
SwitchAutoHide_Ind.Filled = true
SwitchAutoHide_Ind.Size = Vector2.new(13, 13)
SwitchAutoHide_Ind.ZIndex = 252
SwitchAutoHide_Ind.Corner = 10
table.insert(uiElements, SwitchAutoHide_Ind)

local SwitchAutoHide_Label = Drawing.new("Text")
SwitchAutoHide_Label.Visible = false
SwitchAutoHide_Label.Text = ""
SwitchAutoHide_Label.Size = 8
SwitchAutoHide_Label.Color = Color3.fromHex("#FFFFFF")
SwitchAutoHide_Label.Outline = true
SwitchAutoHide_Label.Font = Drawing.Fonts.UI
SwitchAutoHide_Label.Position = SwitchAutoHide.Position + Vector2.new(35, 3.5)
SwitchAutoHide_Label.ZIndex = 251
table.insert(uiElements, SwitchAutoHide_Label)

MainSwitchAutoHide.Bg = SwitchAutoHide_Bg
MainSwitchAutoHide.Ind = SwitchAutoHide_Ind
MainSwitchAutoHide.IndBorder = SwitchAutoHide_IndBorder

local InvisibleSquare = Drawing.new("Square")
InvisibleSquare.Visible = false
InvisibleSquare.Transparency = 0
InvisibleSquare.ZIndex = 290
InvisibleSquare.Color = Color3.fromHex("#FFFFFF")
InvisibleSquare.Position = VeryBackGUI.Position + Vector2.new(-87, 96)
InvisibleSquare.Size = Vector2.new(10, 53)
InvisibleSquare.Filled = true
table.insert(uiElements, InvisibleSquare)

local HereNoContentText = Drawing.new("Text")
HereNoContentText.Visible = false
HereNoContentText.Transparency = 1
HereNoContentText.ZIndex = 280
HereNoContentText.Color = Color3.fromHex("#ff0000")
HereNoContentText.Position = InvisibleSquare.Position + Vector2.new(117, 20)
HereNoContentText.Text = "Here no content"
HereNoContentText.Size = 43
HereNoContentText.Center = false
HereNoContentText.Outline = false
HereNoContentText.Font = Drawing.Fonts.UI
table.insert(uiElements, HereNoContentText)

local ContentInfo1 = Drawing.new("Square")
ContentInfo1.Visible = false
ContentInfo1.Transparency = 1
ContentInfo1.ZIndex = 300
ContentInfo1.Color = Color3.fromHex("#111010")
ContentInfo1.Position = VeryBackGUI.Position + Vector2.new(11, 101)
ContentInfo1.Size = Vector2.new(545, 75)
ContentInfo1.Filled = true
ContentInfo1.Corner = 5
table.insert(uiElements, ContentInfo1)

local ContentInfo1_Border = Drawing.new("Square")
ContentInfo1_Border.Visible = false
ContentInfo1_Border.Transparency = 1
ContentInfo1_Border.ZIndex = 301
ContentInfo1_Border.Color = Color3.fromHex("#1b1a1b")
ContentInfo1_Border.Filled = false
ContentInfo1_Border.Thickness = 1
ContentInfo1_Border.Position = ContentInfo1.Position
ContentInfo1_Border.Size = ContentInfo1.Size
ContentInfo1_Border.Corner = 5
table.insert(uiElements, ContentInfo1_Border)

local TextInfo1 = Drawing.new("Text")
TextInfo1.Visible = false
TextInfo1.Transparency = 1
TextInfo1.ZIndex = 310
TextInfo1.Color = Color3.fromHex("#47f109")
TextInfo1.Position = ContentInfo1.Position + Vector2.new(9, 38)
TextInfo1.Text = "To open advanced settings, hover over the button and right-click!!"
TextInfo1.Size = 15
TextInfo1.Center = false
TextInfo1.Outline = false
TextInfo1.Font = Drawing.Fonts.UI
table.insert(uiElements, TextInfo1)

local TextInfo2 = Drawing.new("Text")
TextInfo2.Visible = false
TextInfo2.Transparency = 1
TextInfo2.ZIndex = 320
TextInfo2.Color = Color3.fromHex("#e3e3e3")
TextInfo2.Position = ContentInfo1.Position + Vector2.new(17, 11)
TextInfo2.Text = "Some usefull info"
TextInfo2.Size = 17
TextInfo2.Center = false
TextInfo2.Outline = true
TextInfo2.Font = Drawing.Fonts.UI
table.insert(uiElements, TextInfo2)

local ContentInfo2 = Drawing.new("Square")
ContentInfo2.Visible = false
ContentInfo2.Transparency = 1
ContentInfo2.ZIndex = 300
ContentInfo2.Color = Color3.fromHex("#111010")
ContentInfo2.Position = ContentInfo1.Position + Vector2.new(0, 84)
ContentInfo2.Size = Vector2.new(544, 156)
ContentInfo2.Filled = true
ContentInfo2.Corner = 5
table.insert(uiElements, ContentInfo2)

local ContentInfo2_Border = Drawing.new("Square")
ContentInfo2_Border.Visible = false
ContentInfo2_Border.Transparency = 1
ContentInfo2_Border.ZIndex = 301
ContentInfo2_Border.Color = Color3.fromHex("#1b1a1b")
ContentInfo2_Border.Filled = false
ContentInfo2_Border.Thickness = 1
ContentInfo2_Border.Position = ContentInfo2.Position
ContentInfo2_Border.Size = ContentInfo2.Size
ContentInfo2_Border.Corner = 5
table.insert(uiElements, ContentInfo2_Border)

local TextInfo3 = Drawing.new("Text")
TextInfo3.Visible = false
TextInfo3.Transparency = 1
TextInfo3.ZIndex = 340
TextInfo3.Color = Color3.fromHex("#00c950")
TextInfo3.Position = ContentInfo2.Position + Vector2.new(15, 14)
TextInfo3.Text = "Changelogs for ver 6.0:"
TextInfo3.Size = 14
TextInfo3.Center = false
TextInfo3.Outline = true
TextInfo3.Font = Drawing.Fonts.UI
table.insert(uiElements, TextInfo3)

local Changelog1 = Drawing.new("Text")
Changelog1.Visible = false
Changelog1.Transparency = 1
Changelog1.ZIndex = 340
Changelog1.Color = Color3.fromHex("#00ff66")
Changelog1.Position = ContentInfo2.Position + Vector2.new(23, 30)
Changelog1.Text = "+ Redesigned UI"
Changelog1.Size = 14
Changelog1.Center = false
Changelog1.Outline = true
Changelog1.Font = Drawing.Fonts.UI
table.insert(uiElements, Changelog1)

local Changelog3 = Drawing.new("Text")
Changelog3.Visible = false
Changelog3.Transparency = 1
Changelog3.ZIndex = 340
Changelog3.Color = Color3.fromHex("#b62020")
Changelog3.Position = ContentInfo2.Position + Vector2.new(23, 45)
Changelog3.Text = "- Removed themes, etc"
Changelog3.Size = 14
Changelog3.Center = false
Changelog3.Outline = true
Changelog3.Font = Drawing.Fonts.UI
table.insert(uiElements, Changelog3)

local Changelog2 = Drawing.new("Text")
Changelog2.Visible = false
Changelog2.Transparency = 1
Changelog2.ZIndex = 340
Changelog2.Color = Color3.fromHex("#00ff66")
Changelog2.Position = ContentInfo2.Position + Vector2.new(23, 60)
Changelog2.Text = "+ Recode ESP's, because library discount"
Changelog2.Size = 14
Changelog2.Center = false
Changelog2.Outline = true
Changelog2.Font = Drawing.Fonts.UI
table.insert(uiElements, Changelog2)

local MainWatermark = Drawing.new("Square")
MainWatermark.Visible = false
MainWatermark.Transparency = 1
MainWatermark.ZIndex = 20
MainWatermark.Color = Color3.fromHex("#0b0b0b")
MainWatermark.Position = Vector2.new(302, 42.5)
MainWatermark.Size = Vector2.new(205, 106)
MainWatermark.Filled = true
MainWatermark.Corner = 8
table.insert(uiElements, MainWatermark)

local MainWatermark_Border = Drawing.new("Square")
MainWatermark_Border.Visible = false
MainWatermark_Border.Transparency = 1
MainWatermark_Border.ZIndex = 21
MainWatermark_Border.Color = Color3.fromHex("#1b1a1b")
MainWatermark_Border.Filled = false
MainWatermark_Border.Thickness = 1
MainWatermark_Border.Position = MainWatermark.Position
MainWatermark_Border.Size = MainWatermark.Size
MainWatermark_Border.Corner = 8
table.insert(uiElements, MainWatermark_Border)

local LineWatermark1 = Drawing.new("Square")
LineWatermark1.Visible = false
LineWatermark1.Transparency = 1
LineWatermark1.ZIndex = 30
LineWatermark1.Color = Color3.fromHex("#1b1a1b")
LineWatermark1.Position = MainWatermark.Position + Vector2.new(35, 36.5)
LineWatermark1.Size = Vector2.new(126, 1)
LineWatermark1.Filled = true
table.insert(uiElements, LineWatermark1)

local TextRATHUB34 = Drawing.new("Text")
TextRATHUB34.Visible = false
TextRATHUB34.Transparency = 1
TextRATHUB34.ZIndex = 40
TextRATHUB34.Color = Color3.fromHex("#01b349")
TextRATHUB34.Position = MainWatermark.Position + Vector2.new(62, 12.5)
TextRATHUB34.Text = "RATHUB"
TextRATHUB34.Size = 14
TextRATHUB34.Center = false
TextRATHUB34.Outline = true
TextRATHUB34.Font = Drawing.Fonts.SystemBold
table.insert(uiElements, TextRATHUB34)

local LogoRathub34 = Drawing.new("Text")
LogoRathub34.Visible = false
LogoRathub34.Transparency = 1
LogoRathub34.ZIndex = 50
LogoRathub34.Color = Color3.fromHex("#01b349")
LogoRathub34.Position = MainWatermark.Position + Vector2.new(35, 11.5)
LogoRathub34.Text = ">_"
LogoRathub34.Size = 14
LogoRathub34.Center = false
LogoRathub34.Outline = true
LogoRathub34.Font = Drawing.Fonts.SystemBold
table.insert(uiElements, LogoRathub34)

local StatusWatermark = Drawing.new("Text")
StatusWatermark.Visible = false
StatusWatermark.Transparency = 1
StatusWatermark.ZIndex = 60
StatusWatermark.Color = Color3.fromHex("#656c7b")
StatusWatermark.Position = MainWatermark.Position + Vector2.new(18, 47.5)
StatusWatermark.Text = "Status:"
StatusWatermark.Size = 14
StatusWatermark.Center = false
StatusWatermark.Outline = true
StatusWatermark.Font = Drawing.Fonts.System
table.insert(uiElements, StatusWatermark)

local CurrentEntity = Drawing.new("Text")
CurrentEntity.Visible = false
CurrentEntity.Transparency = 1
CurrentEntity.ZIndex = 70
CurrentEntity.Color = Color3.fromHex("#656c7b")
CurrentEntity.Position = MainWatermark.Position + Vector2.new(68, 47.5)
CurrentEntity.Text = "None"
CurrentEntity.Size = 14
CurrentEntity.Center = false
CurrentEntity.Outline = true
CurrentEntity.Font = Drawing.Fonts.System
table.insert(uiElements, CurrentEntity)

local notifX = Viewport.X - 280
local notifY = Viewport.Y - 70

local MainNotificationScriptExecut = Drawing.new("Square")
MainNotificationScriptExecut.Visible = false
MainNotificationScriptExecut.Transparency = 0.65
MainNotificationScriptExecut.ZIndex = 400
MainNotificationScriptExecut.Color = Color3.fromHex("#171d1e")
MainNotificationScriptExecut.Position = Vector2.new(notifX, notifY)
MainNotificationScriptExecut.Size = Vector2.new(263, 56)
MainNotificationScriptExecut.Filled = true
MainNotificationScriptExecut.Corner = 8
table.insert(uiElements, MainNotificationScriptExecut)

local MainNotificationScriptExecut_Border = Drawing.new("Square")
MainNotificationScriptExecut_Border.Visible = false
MainNotificationScriptExecut_Border.Transparency = 0.65
MainNotificationScriptExecut_Border.ZIndex = 401
MainNotificationScriptExecut_Border.Color = Color3.fromHex("#10502e")
MainNotificationScriptExecut_Border.Filled = false
MainNotificationScriptExecut_Border.Thickness = 1
MainNotificationScriptExecut_Border.Position = MainNotificationScriptExecut.Position
MainNotificationScriptExecut_Border.Size = MainNotificationScriptExecut.Size
MainNotificationScriptExecut_Border.Corner = 8
table.insert(uiElements, MainNotificationScriptExecut_Border)

local TextScriptExecuted = Drawing.new("Text")
TextScriptExecuted.Visible = false
TextScriptExecuted.Transparency = 1
TextScriptExecuted.ZIndex = 410
TextScriptExecuted.Color = Color3.fromHex("#e4e6eb")
TextScriptExecuted.Position = Vector2.new(notifX + 35, notifY + 10)
TextScriptExecuted.Text = "Script executed"
TextScriptExecuted.Size = 11
TextScriptExecuted.Center = false
TextScriptExecuted.Outline = true
TextScriptExecuted.Font = Drawing.Fonts.Monospace
table.insert(uiElements, TextScriptExecuted)

local NotificationDesc = Drawing.new("Text")
NotificationDesc.Visible = false
NotificationDesc.Transparency = 1
NotificationDesc.ZIndex = 420
NotificationDesc.Color = Color3.fromHex("#656e7c")
NotificationDesc.Position = Vector2.new(notifX + 45, notifY + 26)
NotificationDesc.Text = "Script has been succesfully executed"
NotificationDesc.Size = 10
NotificationDesc.Center = false
NotificationDesc.Outline = true
NotificationDesc.Font = Drawing.Fonts.Monospace
table.insert(uiElements, NotificationDesc)

local LogoNotificatorExecut = Drawing.new("Text")
LogoNotificatorExecut.Visible = false
LogoNotificatorExecut.Transparency = 1
LogoNotificatorExecut.ZIndex = 430
LogoNotificatorExecut.Color = Color3.fromHex("#13a300")
LogoNotificatorExecut.Position = Vector2.new(notifX + 14, notifY + 10)
LogoNotificatorExecut.Text = "+"
LogoNotificatorExecut.Size = 23
LogoNotificatorExecut.Center = false
LogoNotificatorExecut.Outline = true
LogoNotificatorExecut.Font = Drawing.Fonts.Monospace
table.insert(uiElements, LogoNotificatorExecut)

local MainNotificationMob = Drawing.new("Square")
MainNotificationMob.Visible = false
MainNotificationMob.Transparency = 0.65
MainNotificationMob.ZIndex = 400
MainNotificationMob.Color = Color3.fromHex("#1a1112")
MainNotificationMob.Position = Vector2.new(notifX, notifY - 70)
MainNotificationMob.Size = Vector2.new(263, 56)
MainNotificationMob.Filled = true
MainNotificationMob.Corner = 8
table.insert(uiElements, MainNotificationMob)

local MainNotificationMob_Border = Drawing.new("Square")
MainNotificationMob_Border.Visible = false
MainNotificationMob_Border.Transparency = 0.65
MainNotificationMob_Border.ZIndex = 401
MainNotificationMob_Border.Color = Color3.fromHex("#5c181c")
MainNotificationMob_Border.Filled = false
MainNotificationMob_Border.Thickness = 1
MainNotificationMob_Border.Position = MainNotificationMob.Position
MainNotificationMob_Border.Size = MainNotificationMob.Size
MainNotificationMob_Border.Corner = 8
table.insert(uiElements, MainNotificationMob_Border)

local WhatEntitySpawned = Drawing.new("Text")
WhatEntitySpawned.Visible = false
WhatEntitySpawned.Transparency = 1
WhatEntitySpawned.ZIndex = 410
WhatEntitySpawned.Color = Color3.fromHex("#e4e6eb")
WhatEntitySpawned.Position = Vector2.new(notifX + 35, notifY - 60 + 10)
WhatEntitySpawned.Text = "Entity spawned"
WhatEntitySpawned.Size = 11
WhatEntitySpawned.Center = false
WhatEntitySpawned.Outline = true
WhatEntitySpawned.Font = Drawing.Fonts.Monospace
table.insert(uiElements, WhatEntitySpawned)

local LogoNotificationMob = Drawing.new("Text")
LogoNotificationMob.Visible = false
LogoNotificationMob.Transparency = 1
LogoNotificationMob.ZIndex = 420
LogoNotificationMob.Color = Color3.fromHex("#cc5c00")
LogoNotificationMob.Position = Vector2.new(notifX + 14, notifY - 60 + 9)
LogoNotificationMob.Text = "!"
LogoNotificationMob.Size = 22
LogoNotificationMob.Center = false
LogoNotificationMob.Outline = true
LogoNotificationMob.Font = Drawing.Fonts.SystemBold
table.insert(uiElements, LogoNotificationMob)

local function ShowNotification(msgType, entityName)
    if msgType == "script" then
        MainNotificationScriptExecut.Visible = true
        MainNotificationScriptExecut_Border.Visible = true
        TextScriptExecuted.Visible = true
        NotificationDesc.Visible = true
        LogoNotificatorExecut.Visible = true
        task.spawn(function()
            task.wait(3)
            MainNotificationScriptExecut.Visible = false
            MainNotificationScriptExecut_Border.Visible = false
            TextScriptExecuted.Visible = false
            NotificationDesc.Visible = false
            LogoNotificatorExecut.Visible = false
        end)
    elseif msgType == "mob" then
        WhatEntitySpawned.Text = entityName .. " spawned"
        MainNotificationMob.Visible = true
        MainNotificationMob_Border.Visible = true
        WhatEntitySpawned.Visible = true
        LogoNotificationMob.Visible = true
        task.spawn(function()
            task.wait(3)
            MainNotificationMob.Visible = false
            MainNotificationMob_Border.Visible = false
            WhatEntitySpawned.Visible = false
            LogoNotificationMob.Visible = false
        end)
    end
end

Settings = {
    notificationsEnabled = { Angler = false, Froger = false, Pinkie = false, Blitz = false,
        Pandemonium = false, Chainsmoker = false, ["A60"] = false, Harbinger = false, Painter = false },
    keycardESPEnabled = false,
    doorESPEnabled = false,
    itemsESPEnabled = false,
    currencyESPEnabled = false,
    currencyRichEnabled = false,
    autoRescanEnabled = true,
    espDistance = 150,
    watermarkEnabled = false,
    watermarkMobsEnabled = { Angler = true, Blitz = true, Pinkie = true, Pandemonium = true, Froger = true,
        Chainsmoker = true, ["A60"] = true, Harbinger = true, Painter = false }
}

TrackedMobs = {"Angler", "Blitz", "Pinkie", "Pandemonium", "Froger", "Chainsmoker",
    "RidgeAngler","RidgeBlitz","RidgePinkie","RidgePandemonium","RidgeFroger","RidgeChainsmoker","A60","Harbinger"}

detectedMobs = {}

function CheckForMobs()
    local currentFrameMobs = {}
    local anyMob = false
    for _, obj in ipairs(workspace:GetChildren()) do
        local mobName = obj.Name
        for _, targetMob in ipairs(TrackedMobs) do
            if mobName == targetMob then
                currentFrameMobs[mobName] = true
                anyMob = true
                if not detectedMobs[mobName] then
                    detectedMobs[mobName] = true
                    local simpleName = mobName:gsub("Ridge", "")
                    if Settings.notificationsEnabled[simpleName] then
                        ShowNotification("mob", mobName)
                    end
                end
                break
            end
        end
    end
    local painterKey = "__Painter__"
    local gf = workspace:FindFirstChild("GameplayFolder")
    if gf then
        local rooms = gf:FindFirstChild("Rooms")
        if rooms then
            for _, room in ipairs(rooms:GetChildren()) do
                if room:FindFirstChild("Painter") then
                    currentFrameMobs[painterKey] = true
                    anyMob = true
                    if not detectedMobs[painterKey] then
                        detectedMobs[painterKey] = true
                        if Settings.notificationsEnabled.Painter then
                            ShowNotification("mob", "Painter")
                        end
                    end
                    break
                end
            end
        end
    end
    for mobName, _ in pairs(detectedMobs) do
        if not currentFrameMobs[mobName] then
            detectedMobs[mobName] = nil
        end
    end
    if MainWatermark.Visible then
        local displayed = false
        for mob,_ in pairs(detectedMobs) do
            local simple = mob:gsub("Ridge","")
            if Settings.watermarkMobsEnabled[simple] then
                CurrentEntity.Text = mob
                displayed = true
                break
            end
        end
        if not displayed then
            CurrentEntity.Text = "None"
        end
    end
end

espObjects = {}
espDoorObjects = {}

function getPosition(instance)
    if instance.Position then return instance.Position end
    for _, child in ipairs(instance:GetChildren()) do
        local pos = getPosition(child)
        if pos then return pos end
    end
    return nil
end

function getObjectType(instance)
    local success, attr = pcall(function() return instance:GetAttribute("InteractionType") end)
    if success and attr then return attr end
    return nil
end

function parseCurrencyAmount(name)
    local amount = name:match("%d+")
    return amount and tonumber(amount) or nil
end

function createESPForObject(obj, objType)
    if espObjects[obj] then return false end
    local color = Color3.fromRGB(255,255,255)
    local displayName = obj.Name
    if objType == "KeyCard" then
        color = Color3.fromRGB(0,255,0)
    elseif objType == "InnerKeyCard" then
        color = Color3.fromRGB(28,57,187)
    elseif objType == "RidgeKeyCard" then
        color = Color3.fromRGB(169,169,169)
    elseif objType == "PasswordPaper" then
        color = Color3.fromRGB(255,200,0)
        displayName = "Password"
    elseif objType == "CurrencyBase" then
        color = Color3.fromRGB(60,179,113)
        local amount = parseCurrencyAmount(obj.Name)
        displayName = amount and ("$"..amount) or "Currency"
    elseif objType == "ItemBase" then
        color = Color3.fromRGB(135,206,250)
        displayName = obj.Name
    end
    local text = Drawing.new("Text")
    text.Text = displayName
    text.Color = color
    text.Size = 16
    text.Font = Drawing.Fonts.SystemBold
    text.Outline = true
    text.Center = true
    text.Visible = true
    espObjects[obj] = { text = text, objType = objType, lastSeen = tick() }
    return true
end

function createDoorESP(doorPart, doorKey)
    if espDoorObjects[doorKey] then return false end
    local text = Drawing.new("Text")
    text.Text = "Door"
    text.Color = Color3.fromRGB(255,165,0)
    text.Size = 16
    text.Font = Drawing.Fonts.SystemBold
    text.Outline = true
    text.Center = true
    text.Visible = true
    espDoorObjects[doorKey] = { text = text, part = doorPart, lastSeen = tick() }
    return true
end

function removeESPForObject(obj)
    if espObjects[obj] then
        if espObjects[obj].text then espObjects[obj].text:Remove() end
        espObjects[obj] = nil
    end
end

function removeDoorESP(key)
    if espDoorObjects[key] then
        if espDoorObjects[key].text then espDoorObjects[key].text:Remove() end
        espDoorObjects[key] = nil
    end
end

function updateAllESP()
    for obj, espData in pairs(espObjects) do
        if obj and obj.Parent then
            local currentType = getObjectType(obj)
            local enabled = false
            if currentType == "KeyCard" or currentType == "InnerKeyCard" or currentType == "RidgeKeyCard" or currentType == "PasswordPaper" then
                enabled = Settings.keycardESPEnabled
            elseif currentType == "CurrencyBase" then
                enabled = Settings.currencyESPEnabled
                if enabled and Settings.currencyRichEnabled then
                    local amount = parseCurrencyAmount(obj.Name)
                    if amount and amount < 25 then
                        enabled = false
                    end
                end
            elseif currentType == "ItemBase" then
                enabled = Settings.itemsESPEnabled
            end
            if not enabled then
                removeESPForObject(obj)
            elseif currentType ~= espData.objType then
                removeESPForObject(obj)
                if enabled then createESPForObject(obj, currentType) end
            else
                if espData.objType == "CurrencyBase" then
                    local amount = parseCurrencyAmount(obj.Name)
                    if amount then espData.text.Text = "$"..amount end
                elseif espData.objType == "ItemBase" then
                    espData.text.Text = obj.Name
                end
                local pos = getPosition(obj)
                if pos then
                    local screenPos, onScreen = WorldToScreen(pos)
                    if onScreen and screenPos.X>-500 and screenPos.X<5000 and screenPos.Y>-500 and screenPos.Y<5000 then
                        espData.text.Position = Vector2.new(screenPos.X, screenPos.Y-30)
                        espData.text.Visible = true
                        espData.lastSeen = tick()
                    else espData.text.Visible = false end
                else espData.text.Visible = false end
            end
        else removeESPForObject(obj) end
    end
    for key, espData in pairs(espDoorObjects) do
        if espData.part and espData.part.Parent then
            if Settings.doorESPEnabled then
                local pos = getPosition(espData.part)
                if pos then
                    local screenPos, onScreen = WorldToScreen(pos)
                    if onScreen and screenPos.X>-500 and screenPos.X<5000 and screenPos.Y>-500 and screenPos.Y<5000 then
                        espData.text.Position = Vector2.new(screenPos.X, screenPos.Y-30)
                        espData.text.Visible = true
                        espData.lastSeen = tick()
                    else espData.text.Visible = false end
                else espData.text.Visible = false end
            else espData.text.Visible = false end
        else removeDoorESP(key) end
    end
end

ChunkScanner = {}
ChunkScanner.__index = ChunkScanner
function ChunkScanner.new()
    local self = setmetatable({}, ChunkScanner)
    self.allFolders = {}
    self.currentChunk = 1
    self.chunkSize = 30
    self.scanComplete = false
    self.foundObjects = {}
    self.lastFullScan = 0
    self.scanInterval = 30
    return self
end

function ChunkScanner:collectFolders()
    self.allFolders = {}
    self.foundObjects = {}
    local gf = workspace:FindFirstChild("GameplayFolder")
    if gf then
        local rooms = gf:FindFirstChild("Rooms")
        if rooms then
            for _, room in ipairs(rooms:GetChildren()) do
                table.insert(self.allFolders, room)
                local exits = room:FindFirstChild("Exits")
                if exits then
                    for _, exit in ipairs(exits:GetChildren()) do table.insert(self.allFolders, exit) end
                end
                local interactables = room:FindFirstChild("Interactables")
                if interactables then
                    for _, obj in ipairs(interactables:GetChildren()) do table.insert(self.allFolders, obj) end
                end
                local spawnLocations = room:FindFirstChild("SpawnLocations")
                if spawnLocations then
                    for _, spawn in ipairs(spawnLocations:GetChildren()) do table.insert(self.allFolders, spawn) end
                end
            end
        end
    end
    if #self.allFolders == 0 then
        for _, child in ipairs(workspace:GetChildren()) do
            if child:IsA("Folder") or child:IsA("Model") then table.insert(self.allFolders, child) end
        end
    end
end

function ChunkScanner:scanChunk()
    if #self.allFolders == 0 then self:collectFolders() end
    local startIdx = self.currentChunk
    local endIdx = math.min(startIdx+self.chunkSize-1, #self.allFolders)
    for i = startIdx, endIdx do
        local folder = self.allFolders[i]
        if folder and folder.Parent then
            for _, obj in ipairs(folder:GetDescendants()) do
                local objType = getObjectType(obj)
                if objType == "KeyCard" or objType == "InnerKeyCard" or objType == "RidgeKeyCard" or objType == "PasswordPaper" or objType == "CurrencyBase" or objType == "ItemBase" then
                    self.foundObjects[obj] = true
                    if not espObjects[obj] then
                        local enabled = false
                        if objType == "KeyCard" or objType == "InnerKeyCard" or objType == "RidgeKeyCard" or objType == "PasswordPaper" then
                            enabled = Settings.keycardESPEnabled
                        elseif objType == "CurrencyBase" then
                            enabled = Settings.currencyESPEnabled
                        elseif objType == "ItemBase" then
                            enabled = Settings.itemsESPEnabled
                        end
                        if enabled then createESPForObject(obj, objType) end
                    end
                end
            end
        end
    end
    self.currentChunk = endIdx+1
    if self.currentChunk > #self.allFolders then
        self.currentChunk = 1
        self.scanComplete = true
        self:cleanupRemoved()
    end
end

function ChunkScanner:cleanupRemoved()
    for obj,_ in pairs(espObjects) do
        if not self.foundObjects[obj] then removeESPForObject(obj) end
    end
    self.foundObjects = {}
end

function ChunkScanner:fullScan()
    self:collectFolders()
    self.currentChunk = 1
    self.scanComplete = false
    self.lastFullScan = tick()
end

function ChunkScanner:update()
    local ct = tick()
    if ct - self.lastFullScan > self.scanInterval then
        self:fullScan()
    end
    if not self.scanComplete then self:scanChunk() end
end

DoorScanner = {}
DoorScanner.__index = DoorScanner
function DoorScanner.new()
    local self = setmetatable({}, DoorScanner)
    self.lastScan = 0
    self.scanInterval = 5
    return self
end

function DoorScanner:scan()
    if not Settings.doorESPEnabled then
        for k,_ in pairs(espDoorObjects) do removeDoorESP(k) end
        return
    end
    local ct = tick()
    if ct - self.lastScan < self.scanInterval then return end
    self.lastScan = ct
    local gf = workspace:FindFirstChild("GameplayFolder")
    if not gf then return end
    local rooms = gf:FindFirstChild("Rooms")
    if not rooms then return end
    local foundKeys = {}
    for _, room in ipairs(rooms:GetChildren()) do
        local exits = room:FindFirstChild("Exits")
        if exits then
            for _, exit in ipairs(exits:GetChildren()) do
                local part = exit:IsA("BasePart") and exit or exit:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    local key = exit:GetFullName()
                    foundKeys[key] = part
                    if not espDoorObjects[key] then createDoorESP(part, key) end
                end
            end
        end
    end
    for k,_ in pairs(espDoorObjects) do
        if not foundKeys[k] then removeDoorESP(k) end
    end
end

local scanner = ChunkScanner.new()
scanner:fullScan()
local doorScanner = DoorScanner.new()

function ForceRescanESP()
    scanner:fullScan()
end

AutoHideSystem = { enabled = false, isHiding = false, originalPosition = nil, checkInterval = 0.05, lastCheckTime = 0, holdLoop = false }
TrackedMobsSet = {}
for _, name in ipairs(TrackedMobs) do TrackedMobsSet[name] = true end

function getHRP()
    local p = game.Players.LocalPlayer
    if not p or not p.Character then return nil end
    return p.Character:FindFirstChild("HumanoidRootPart")
end

function forceTeleport(pos)
    for i=1,5 do
        local h = getHRP()
        if h then
            h.AssemblyLinearVelocity = Vector3.new(0,0,0)
            h.Position = pos
        end
        wait()
    end
end

function AutoHideSystem:CheckForMobs()
    for _, obj in ipairs(workspace:GetChildren()) do
        if TrackedMobsSet[obj.Name] then return true end
    end
    return false
end

function AutoHideSystem:Hide()
    if self.isHiding then return end
    local hrp = getHRP()
    if not hrp then return end
    self.originalPosition = hrp.Position
    self.isHiding = true
    self.holdLoop = true
    spawn(function() forceTeleport(self.originalPosition + Vector3.new(0,1000,0)) end)
    spawn(function()
        while self.holdLoop do
            local h = getHRP()
            if h then h.AssemblyLinearVelocity = Vector3.new(0,0,0) end
            wait()
        end
    end)
end

function AutoHideSystem:Unhide()
    if not self.isHiding then return end
    self.holdLoop = false
    self.isHiding = false
    local sp = self.originalPosition
    self.originalPosition = nil
    spawn(function() if sp then forceTeleport(sp) end end)
end

function AutoHideSystem:Update()
    if not self.enabled then
        if self.isHiding then self:Unhide() end
        return
    end
    if self.isHiding and not self.originalPosition then
        self.isHiding = false
        self.holdLoop = false
    end
    local ct = os.clock()
    if ct - self.lastCheckTime < self.checkInterval then return end
    self.lastCheckTime = ct
    if self:CheckForMobs() then
        if not self.isHiding then self:Hide() end
    else
        if self.isHiding then self:Unhide() end
    end
end

spawn(function()
    while true do
        AutoHideSystem:Update()
        wait()
    end
end)

local function HideAllTabs()
    VisualsContent1.Visible = false; VisualsContent1_Border.Visible = false
    NotificationTEXT.Visible = false; DescryptionNofitication.Visible = false
    SwitchNotification.Visible = false; SwitchNotification_Bg.Visible = false
    SwitchNotification_IndBorder.Visible = false; SwitchNotification_Ind.Visible = false
    SwitchNotification_Label.Visible = false
    VisualsContent2.Visible = false; VisualsContent2_Border.Visible = false
    TextESP.Visible = false; ESPdescryption.Visible = false
    SwitchESP.Visible = false; SwitchESP_Bg.Visible = false
    SwitchESP_IndBorder.Visible = false; SwitchESP_Ind.Visible = false
    SwitchESP_Label.Visible = false
    ContentExploits1.Visible = false; ContentExploits1_Border.Visible = false
    AutoHideText.Visible = false; AutoHideDescryption.Visible = false
    SwitchAutoHide.Visible = false; SwitchAutoHide_Bg.Visible = false
    SwitchAutoHide_IndBorder.Visible = false; SwitchAutoHide_Ind.Visible = false
    SwitchAutoHide_Label.Visible = false
    InvisibleSquare.Visible = false; HereNoContentText.Visible = false
    ContentInfo1.Visible = false; ContentInfo1_Border.Visible = false
    TextInfo1.Visible = false; TextInfo2.Visible = false
    ContentInfo2.Visible = false; ContentInfo2_Border.Visible = false
    TextInfo3.Visible = false; Changelog1.Visible = false
    Changelog3.Visible = false; Changelog2.Visible = false
end

local function SetActiveTab(tabName, tabButton, tabBorder, tabText)
    local tabs = {
        {btn = TabVisuals, border = TabVisuals_Border, txt = TabVisuals_Text},
        {btn = TabExploits, border = TabExploits_Border, txt = TabExploits_Text},
        {btn = TabMisc, border = TabMisc_Border, txt = TabMisc_Text},
        {btn = TabInfo, border = TabInfo_Border, txt = TabInfo_Text}
    }
    for _, t in ipairs(tabs) do
        t.btn.Color = Color3.fromHex("#0c0c0d")
        t.txt.Color = Color3.fromHex("#6b7382")
        t.border.Visible = false
    end
    if tabName then
        tabButton.Color = Color3.fromHex("#0c2014")
        tabText.Color = Color3.fromHex("#01c34c")
        tabBorder.Visible = true
        activeTab = tabName
    else
        activeTab = nil
    end
end

local KeyNames = {
    [0x70] = "F1",
}

local function CloseAdvancedWindows()
    advancedWindowOpen = false
    Overlay.Visible = false
    if _G.adv_esp then
        for _, el in ipairs(_G.adv_esp.elements) do
            pcall(function() el:Remove() end)
        end
        _G.adv_esp = nil
    end
    if _G.adv_notif then
        for _, el in ipairs(_G.adv_notif.elements) do
            pcall(function() el:Remove() end)
        end
        _G.adv_notif = nil
    end
    AdvSwitchESP4 = nil
    AdvSwitchItems = nil
    AdvSwitchCurrency = nil
    AdvSwitchDoors = nil
    AdvSwitchRich = nil
    AdvSwitchNotif = nil
    AdvSwitchWatermark = nil
end

local function UpdateAdvancedPositions()
    if not advancedWindowOpen then return end
    local basePos = VeryBackGUI.Position + Vector2.new(VeryBackGUI.Size.X + 20, 0)
    if _G.adv_esp and _G.adv_esp.basePos then
        local delta = basePos - _G.adv_esp.basePos
        for _, el in ipairs(_G.adv_esp.elements) do
            if el and el.Position then
                el.Position = el.Position + delta
            end
        end
        _G.adv_esp.basePos = basePos
    end
    if _G.adv_notif and _G.adv_notif.basePos then
        local delta = basePos - _G.adv_notif.basePos
        for _, el in ipairs(_G.adv_notif.elements) do
            if el and el.Position then
                el.Position = el.Position + delta
            end
        end
        _G.adv_notif.basePos = basePos
    end
end

local function CreateAdvancedESP()
    if advancedWindowOpen then
        CloseAdvancedWindows()
        return
    end
    advancedWindowOpen = true
    Overlay.Visible = true

    local basePos = VeryBackGUI.Position + Vector2.new(VeryBackGUI.Size.X + 20, 0)

    local win2 = Drawing.new("Square")
    win2.Visible = true
    win2.Transparency = 1
    win2.ZIndex = 1000
    win2.Color = Color3.fromHex("#111010")
    win2.Position = basePos
    win2.Size = Vector2.new(286, 46)
    win2.Filled = true
    table.insert(uiElements, win2)

    local closeBtn = Drawing.new("Square")
    closeBtn.Visible = true
    closeBtn.Transparency = 1
    closeBtn.ZIndex = 1010
    closeBtn.Color = Color3.fromHex("#111010")
    closeBtn.Position = win2.Position + Vector2.new(245, 5.5)
    closeBtn.Size = Vector2.new(28, 28)
    closeBtn.Filled = true
    table.insert(uiElements, closeBtn)

    local closeText = Drawing.new("Text")
    closeText.Visible = true
    closeText.Text = "X"
    closeText.Size = 18
    closeText.Center = true
    closeText.Outline = true
    closeText.Font = 0
    closeText.Color = Color3.fromHex("#b5b5b5")
    closeText.Position = closeBtn.Position + Vector2.new(14, 14)
    closeText.ZIndex = 1012
    table.insert(uiElements, closeText)

    local win = Drawing.new("Square")
    win.Visible = true
    win.Transparency = 1
    win.ZIndex = 1000
    win.Color = Color3.fromHex("#0c0c0d")
    win.Position = win2.Position + Vector2.new(-1, 43)
    win.Size = Vector2.new(287, 506)
    win.Filled = true
    table.insert(uiElements, win)

    local s1 = Drawing.new("Square")
    s1.Visible = true
    s1.Transparency = 1
    s1.ZIndex = 1040
    s1.Color = Color3.fromHex("#111010")
    s1.Position = win2.Position + Vector2.new(16, 52)
    s1.Size = Vector2.new(247, 65)
    s1.Filled = true
    s1.Corner = 5
    table.insert(uiElements, s1)

    local s1b = Drawing.new("Square")
    s1b.Visible = true
    s1b.Transparency = 1
    s1b.ZIndex = 1041
    s1b.Color = Color3.fromHex("#1b1a1b")
    s1b.Filled = false
    s1b.Thickness = 1
    s1b.Position = s1.Position
    s1b.Size = s1.Size
    s1b.Corner = 5
    table.insert(uiElements, s1b)

    local title = Drawing.new("Text")
    title.Visible = true
    title.Transparency = 1
    title.ZIndex = 1070
    title.Color = Color3.fromHex("#04c838")
    title.Position = win2.Position + Vector2.new(16, 12)
    title.Text = "ESP Settings"
    title.Size = 17
    title.Center = false
    title.Outline = true
    title.Font = Drawing.Fonts.UI
    table.insert(uiElements, title)

    local espTxt = Drawing.new("Text")
    espTxt.Visible = true
    espTxt.Transparency = 1
    espTxt.ZIndex = 1080
    espTxt.Color = Color3.fromHex("#d1d4dd")
    espTxt.Position = win2.Position + Vector2.new(27, 66)
    espTxt.Text = "ESP"
    espTxt.Size = 14
    espTxt.Center = false
    espTxt.Outline = true
    espTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, espTxt)

    local desc = Drawing.new("Text")
    desc.Visible = true
    desc.Transparency = 1
    desc.ZIndex = 1100
    desc.Color = Color3.fromHex("#6b7382")
    desc.Position = win2.Position + Vector2.new(35, 90)
    desc.Text = "Turn enable/disable ESP's"
    desc.Size = 11
    desc.Center = false
    desc.Outline = true
    desc.Font = Drawing.Fonts.UI
    table.insert(uiElements, desc)

    local sw = Drawing.new("Square")
    sw.Visible = true
    sw.Transparency = 1
    sw.Color = Color3.fromHex("#000000")
    sw.Thickness = 1
    sw.Filled = false
    sw.Size = Vector2.new(30, 15)
    sw.Position = win2.Position + Vector2.new(223, 66)
    sw.ZIndex = 1120
    sw.Corner = 10
    table.insert(uiElements, sw)

    local swBg = Drawing.new("Square")
    swBg.Visible = true
    swBg.Transparency = 1
    swBg.Color = Color3.fromHex("#cbcfd5")
    swBg.Filled = true
    swBg.Size = sw.Size
    swBg.Position = sw.Position
    swBg.ZIndex = 1120
    swBg.Corner = 10
    table.insert(uiElements, swBg)

    local swIndBorder = Drawing.new("Square")
    swIndBorder.Visible = true
    swIndBorder.Transparency = 1
    swIndBorder.Color = Color3.fromHex("#000000")
    swIndBorder.Thickness = 1
    swIndBorder.Filled = false
    swIndBorder.Size = Vector2.new(13, 13)
    swIndBorder.ZIndex = 1122
    swIndBorder.Corner = 10
    table.insert(uiElements, swIndBorder)

    local swInd = Drawing.new("Square")
    swInd.Visible = true
    swInd.Transparency = 1
    swInd.Color = Color3.fromHex("#ffffff")
    swInd.Filled = true
    swInd.Size = Vector2.new(13, 13)
    swInd.ZIndex = 1122
    swInd.Corner = 10
    table.insert(uiElements, swInd)

    local swLabel = Drawing.new("Text")
    swLabel.Visible = true
    swLabel.Text = ""
    swLabel.Size = 1
    swLabel.Color = Color3.fromHex("#FFFFFF")
    swLabel.Outline = true
    swLabel.Font = Drawing.Fonts.UI
    swLabel.Position = sw.Position + Vector2.new(40, 7)
    swLabel.ZIndex = 1121
    table.insert(uiElements, swLabel)

    AdvSwitchESP4 = { Bg = swBg, Ind = swInd, IndBorder = swIndBorder, IsChecked = Settings.keycardESPEnabled }
    if AdvSwitchESP4.IsChecked then
        AdvSwitchESP4.IndBorder.Position = AdvSwitchESP4.Bg.Position + Vector2.new(16, 1)
        AdvSwitchESP4.Ind.Position = AdvSwitchESP4.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchESP4.IndBorder.Position = AdvSwitchESP4.Bg.Position + Vector2.new(1, 1)
        AdvSwitchESP4.Ind.Position = AdvSwitchESP4.Bg.Position + Vector2.new(1, 1)
    end
    UpdateSwitchColor(AdvSwitchESP4.Bg, AdvSwitchESP4.IsChecked)

    local s2 = Drawing.new("Square")
    s2.Visible = true
    s2.Transparency = 1
    s2.ZIndex = 1050
    s2.Color = Color3.fromHex("#111010")
    s2.Position = win2.Position + Vector2.new(16, 132)
    s2.Size = Vector2.new(247, 90)
    s2.Filled = true
    s2.Corner = 5
    table.insert(uiElements, s2)

    local s2b = Drawing.new("Square")
    s2b.Visible = true
    s2b.Transparency = 1
    s2b.ZIndex = 1051
    s2b.Color = Color3.fromHex("#1b1a1b")
    s2b.Filled = false
    s2b.Thickness = 1
    s2b.Position = s2.Position
    s2b.Size = s2.Size
    s2b.Corner = 5
    table.insert(uiElements, s2b)

    local distTxt = Drawing.new("Text")
    distTxt.Visible = true
    distTxt.Transparency = 1
    distTxt.ZIndex = 1090
    distTxt.Color = Color3.fromHex("#d1d4dd")
    distTxt.Position = win2.Position + Vector2.new(35, 144)
    distTxt.Text = "ESP distance"
    distTxt.Size = 14
    distTxt.Center = false
    distTxt.Outline = true
    distTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, distTxt)

    local sliderVal = Settings.espDistance
    local sliderTrack = Drawing.new("Square")
    sliderTrack.Visible = true
    sliderTrack.Transparency = 1
    sliderTrack.Color = Color3.fromHex("#2a2a2a")
    sliderTrack.Filled = true
    sliderTrack.Size = Vector2.new(200, 4)
    sliderTrack.Position = win2.Position + Vector2.new(35, 172)
    sliderTrack.ZIndex = 1130
    sliderTrack.Corner = 2
    table.insert(uiElements, sliderTrack)

    local sliderFill = Drawing.new("Square")
    sliderFill.Visible = true
    sliderFill.Transparency = 1
    sliderFill.Color = Color3.fromHex("#04c838")
    sliderFill.Filled = true
    sliderFill.Size = Vector2.new(200 * ((sliderVal-15)/(500-15)), 4)
    sliderFill.Position = sliderTrack.Position
    sliderFill.ZIndex = 1131
    sliderFill.Corner = 2
    table.insert(uiElements, sliderFill)

    local sliderKnob = Drawing.new("Circle")
    sliderKnob.Visible = true
    sliderKnob.Transparency = 1
    sliderKnob.Color = Color3.fromHex("#04c838")
    sliderKnob.Filled = true
    sliderKnob.Radius = 6
    sliderKnob.NumSides = 16
    sliderKnob.Position = sliderTrack.Position + Vector2.new(200 * ((sliderVal-15)/(500-15)), 2)
    sliderKnob.ZIndex = 1132
    table.insert(uiElements, sliderKnob)

    local sliderValText = Drawing.new("Text")
    sliderValText.Visible = true
    sliderValText.Text = tostring(math.floor(sliderVal)) .. ""
    sliderValText.Size = 14
    sliderValText.Center = true
    sliderValText.Outline = true
    sliderValText.Color = Color3.fromHex("#ffffff")
    sliderValText.Position = sliderTrack.Position + Vector2.new(100, -20)
    sliderValText.ZIndex = 1133
    table.insert(uiElements, sliderValText)

    local sliderDesc = Drawing.new("Text")
    sliderDesc.Visible = true
    sliderDesc.Transparency = 1
    sliderDesc.ZIndex = 1110
    sliderDesc.Color = Color3.fromHex("#6b7382")
    sliderDesc.Position = win2.Position + Vector2.new(48, 194)
    sliderDesc.Text = "Distance for ESP"
    sliderDesc.Size = 11
    sliderDesc.Center = false
    sliderDesc.Outline = true
    sliderDesc.Font = Drawing.Fonts.UI
    table.insert(uiElements, sliderDesc)

    local s3 = Drawing.new("Square")
    s3.Visible = true
    s3.Transparency = 1
    s3.ZIndex = 1060
    s3.Color = Color3.fromHex("#111010")
    s3.Position = win2.Position + Vector2.new(16, 236)
    s3.Size = Vector2.new(247, 65)
    s3.Filled = true
    s3.Corner = 5
    table.insert(uiElements, s3)

    local s3b = Drawing.new("Square")
    s3b.Visible = true
    s3b.Transparency = 1
    s3b.ZIndex = 1061
    s3b.Color = Color3.fromHex("#1b1a1b")
    s3b.Filled = false
    s3b.Thickness = 1
    s3b.Position = s3.Position
    s3b.Size = s3.Size
    s3b.Corner = 5
    table.insert(uiElements, s3b)

    local kcTxt = Drawing.new("Text")
    kcTxt.Visible = true
    kcTxt.Transparency = 1
    kcTxt.ZIndex = 1080
    kcTxt.Color = Color3.fromHex("#d1d4dd")
    kcTxt.Position = win2.Position + Vector2.new(27, 246)
    kcTxt.Text = "ESP Keycard"
    kcTxt.Size = 14
    kcTxt.Center = false
    kcTxt.Outline = true
    kcTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, kcTxt)

    local dropdownItems = {
        { name = "Normal keycard", checked = true },
        { name = "Inner keycard", checked = true },
        { name = "Ridge keycard", checked = true }
    }
    local dropdownOpen = false
    local dropdownMain = Drawing.new("Square")
    dropdownMain.Visible = true
    dropdownMain.Transparency = 1
    dropdownMain.Color = Color3.fromHex("#1b1a1b")
    dropdownMain.Filled = true
    dropdownMain.Size = Vector2.new(140, 24)
    dropdownMain.Position = win2.Position + Vector2.new(41, 261)
    dropdownMain.ZIndex = 1140
    dropdownMain.Corner = 4
    table.insert(uiElements, dropdownMain)

    local dropdownText = Drawing.new("Text")
    dropdownText.Visible = true
    dropdownText.Text = "Keycards: all"
    dropdownText.Size = 14
    dropdownText.Outline = true
    dropdownText.Font = 0
    dropdownText.Color = Color3.fromHex("#d1d4dd")
    dropdownText.Position = dropdownMain.Position + Vector2.new(8, 4)
    dropdownText.ZIndex = 1142
    table.insert(uiElements, dropdownText)

    local dropdownArrow = Drawing.new("Text")
    dropdownArrow.Visible = true
    dropdownArrow.Text = "▼"
    dropdownArrow.Size = 12
    dropdownArrow.Outline = true
    dropdownArrow.Color = Color3.fromHex("#d1d4dd")
    dropdownArrow.Position = dropdownMain.Position + Vector2.new(120, 4)
    dropdownArrow.ZIndex = 1142
    table.insert(uiElements, dropdownArrow)

    local dropdownBoxes = {}
    for idx, item in ipairs(dropdownItems) do
        local box = Drawing.new("Square")
        box.Visible = false
        box.Transparency = 1
        box.Color = Color3.fromHex("#111010")
        box.Filled = true
        box.Size = Vector2.new(140, 24)
        box.Position = dropdownMain.Position + Vector2.new(0, 24 * idx)
        box.ZIndex = 1145
        box.Corner = 4
        table.insert(uiElements, box)

        local check = Drawing.new("Square")
        check.Visible = false
        check.Transparency = 1
        check.Color = item.checked and Color3.fromHex("#04c838") or Color3.fromHex("#3a3a3a")
        check.Filled = true
        check.Size = Vector2.new(12, 12)
        check.Position = box.Position + Vector2.new(6, 6)
        check.ZIndex = 1146
        check.Corner = 2
        table.insert(uiElements, check)

        local txt = Drawing.new("Text")
        txt.Visible = false
        txt.Text = item.name
        txt.Size = 14
        txt.Outline = true
        txt.Font = 0
        txt.Color = Color3.fromHex("#d1d4dd")
        txt.Position = box.Position + Vector2.new(24, 4)
        txt.ZIndex = 1146
        table.insert(uiElements, txt)

        table.insert(dropdownBoxes, { Box = box, Check = check, Text = txt, Data = item })
    end

    local function UpdateDropdownText()
        local sel = {}
        for _, it in ipairs(dropdownItems) do
            if it.checked then table.insert(sel, it.name:match("(%a+) keycard") or it.name) end
        end
        if #sel == 0 then dropdownText.Text = "Keycards: none"
        elseif #sel == #dropdownItems then dropdownText.Text = "Keycards: all"
        else dropdownText.Text = "Keycards: " .. table.concat(sel, ", ") end
    end

    local s4 = Drawing.new("Square")
    s4.Visible = true
    s4.Transparency = 1
    s4.ZIndex = 1060
    s4.Color = Color3.fromHex("#111010")
    s4.Position = win2.Position + Vector2.new(16, 321)
    s4.Size = Vector2.new(251, 46)
    s4.Filled = true
    s4.Corner = 5
    table.insert(uiElements, s4)

    local s4b = Drawing.new("Square")
    s4b.Visible = true
    s4b.Transparency = 1
    s4b.ZIndex = 1061
    s4b.Color = Color3.fromHex("#1b1a1b")
    s4b.Filled = false
    s4b.Thickness = 1
    s4b.Position = s4.Position
    s4b.Size = s4.Size
    s4b.Corner = 5
    table.insert(uiElements, s4b)

    local itemsTxt = Drawing.new("Text")
    itemsTxt.Visible = true
    itemsTxt.Transparency = 1
    itemsTxt.ZIndex = 1080
    itemsTxt.Color = Color3.fromHex("#d1d4dd")
    itemsTxt.Position = win2.Position + Vector2.new(27, 331)
    itemsTxt.Text = "ESP Items"
    itemsTxt.Size = 14
    itemsTxt.Center = false
    itemsTxt.Outline = true
    itemsTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, itemsTxt)

    local swItems = Drawing.new("Square")
    swItems.Visible = true
    swItems.Transparency = 1
    swItems.Color = Color3.fromHex("#000000")
    swItems.Thickness = 1
    swItems.Filled = false
    swItems.Size = Vector2.new(30, 15)
    swItems.Position = win2.Position + Vector2.new(223, 331)
    swItems.ZIndex = 1120
    swItems.Corner = 10
    table.insert(uiElements, swItems)

    local swItemsBg = Drawing.new("Square")
    swItemsBg.Visible = true
    swItemsBg.Transparency = 1
    swItemsBg.Color = Color3.fromHex("#cbcfd5")
    swItemsBg.Filled = true
    swItemsBg.Size = swItems.Size
    swItemsBg.Position = swItems.Position
    swItemsBg.ZIndex = 1120
    swItemsBg.Corner = 10
    table.insert(uiElements, swItemsBg)

    local swItemsIndBorder = Drawing.new("Square")
    swItemsIndBorder.Visible = true
    swItemsIndBorder.Transparency = 1
    swItemsIndBorder.Color = Color3.fromHex("#000000")
    swItemsIndBorder.Thickness = 1
    swItemsIndBorder.Filled = false
    swItemsIndBorder.Size = Vector2.new(13, 13)
    swItemsIndBorder.ZIndex = 1122
    swItemsIndBorder.Corner = 10
    table.insert(uiElements, swItemsIndBorder)

    local swItemsInd = Drawing.new("Square")
    swItemsInd.Visible = true
    swItemsInd.Transparency = 1
    swItemsInd.Color = Color3.fromHex("#ffffff")
    swItemsInd.Filled = true
    swItemsInd.Size = Vector2.new(13, 13)
    swItemsInd.ZIndex = 1122
    swItemsInd.Corner = 10
    table.insert(uiElements, swItemsInd)

    local swItemsLabel = Drawing.new("Text")
    swItemsLabel.Visible = true
    swItemsLabel.Text = ""
    swItemsLabel.Size = 1
    swItemsLabel.Color = Color3.fromHex("#FFFFFF")
    swItemsLabel.Outline = true
    swItemsLabel.Font = Drawing.Fonts.UI
    swItemsLabel.Position = swItems.Position + Vector2.new(40, 7)
    swItemsLabel.ZIndex = 1121
    table.insert(uiElements, swItemsLabel)

    AdvSwitchItems = { Bg = swItemsBg, Ind = swItemsInd, IndBorder = swItemsIndBorder, IsChecked = Settings.itemsESPEnabled }
    UpdateSwitchColor(AdvSwitchItems.Bg, AdvSwitchItems.IsChecked)
    if AdvSwitchItems.IsChecked then
        AdvSwitchItems.IndBorder.Position = AdvSwitchItems.Bg.Position + Vector2.new(16, 1)
        AdvSwitchItems.Ind.Position = AdvSwitchItems.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchItems.IndBorder.Position = AdvSwitchItems.Bg.Position + Vector2.new(1, 1)
        AdvSwitchItems.Ind.Position = AdvSwitchItems.Bg.Position + Vector2.new(1, 1)
    end

    local itemsDesc = Drawing.new("Text")
    itemsDesc.Visible = true
    itemsDesc.Transparency = 1
    itemsDesc.ZIndex = 1100
    itemsDesc.Color = Color3.fromHex("#6b7382")
    itemsDesc.Position = win2.Position + Vector2.new(35, 346)
    itemsDesc.Text = "Turn enable/disable ESP's for all items"
    itemsDesc.Size = 11
    itemsDesc.Center = false
    itemsDesc.Outline = true
    itemsDesc.Font = Drawing.Fonts.UI
    table.insert(uiElements, itemsDesc)

    local s5 = Drawing.new("Square")
    s5.Visible = true
    s5.Transparency = 1
    s5.ZIndex = 1060
    s5.Color = Color3.fromHex("#111010")
    s5.Position = win2.Position + Vector2.new(16, 380)
    s5.Size = Vector2.new(251, 70)
    s5.Filled = true
    s5.Corner = 5
    table.insert(uiElements, s5)

    local s5b = Drawing.new("Square")
    s5b.Visible = true
    s5b.Transparency = 1
    s5b.ZIndex = 1061
    s5b.Color = Color3.fromHex("#1b1a1b")
    s5b.Filled = false
    s5b.Thickness = 1
    s5b.Position = s5.Position
    s5b.Size = s5.Size
    s5b.Corner = 5
    table.insert(uiElements, s5b)

    local currTxt = Drawing.new("Text")
    currTxt.Visible = true
    currTxt.Transparency = 1
    currTxt.ZIndex = 1080
    currTxt.Color = Color3.fromHex("#d1d4dd")
    currTxt.Position = win2.Position + Vector2.new(27, 388)
    currTxt.Text = "ESP Currency"
    currTxt.Size = 14
    currTxt.Center = false
    currTxt.Outline = true
    currTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, currTxt)

    local swCurr = Drawing.new("Square")
    swCurr.Visible = true
    swCurr.Transparency = 1
    swCurr.Color = Color3.fromHex("#000000")
    swCurr.Thickness = 1
    swCurr.Filled = false
    swCurr.Size = Vector2.new(30, 15)
    swCurr.Position = win2.Position + Vector2.new(223, 388)
    swCurr.ZIndex = 1120
    swCurr.Corner = 10
    table.insert(uiElements, swCurr)

    local swCurrBg = Drawing.new("Square")
    swCurrBg.Visible = true
    swCurrBg.Transparency = 1
    swCurrBg.Color = Color3.fromHex("#cbcfd5")
    swCurrBg.Filled = true
    swCurrBg.Size = swCurr.Size
    swCurrBg.Position = swCurr.Position
    swCurrBg.ZIndex = 1120
    swCurrBg.Corner = 10
    table.insert(uiElements, swCurrBg)

    local swCurrIndBorder = Drawing.new("Square")
    swCurrIndBorder.Visible = true
    swCurrIndBorder.Transparency = 1
    swCurrIndBorder.Color = Color3.fromHex("#000000")
    swCurrIndBorder.Thickness = 1
    swCurrIndBorder.Filled = false
    swCurrIndBorder.Size = Vector2.new(13, 13)
    swCurrIndBorder.ZIndex = 1122
    swCurrIndBorder.Corner = 10
    table.insert(uiElements, swCurrIndBorder)

    local swCurrInd = Drawing.new("Square")
    swCurrInd.Visible = true
    swCurrInd.Transparency = 1
    swCurrInd.Color = Color3.fromHex("#ffffff")
    swCurrInd.Filled = true
    swCurrInd.Size = Vector2.new(13, 13)
    swCurrInd.ZIndex = 1122
    swCurrInd.Corner = 10
    table.insert(uiElements, swCurrInd)

    local swCurrLabel = Drawing.new("Text")
    swCurrLabel.Visible = true
    swCurrLabel.Text = ""
    swCurrLabel.Size = 1
    swCurrLabel.Color = Color3.fromHex("#FFFFFF")
    swCurrLabel.Outline = true
    swCurrLabel.Font = Drawing.Fonts.UI
    swCurrLabel.Position = swCurr.Position + Vector2.new(40, 7)
    swCurrLabel.ZIndex = 1121
    table.insert(uiElements, swCurrLabel)

    AdvSwitchCurrency = { Bg = swCurrBg, Ind = swCurrInd, IndBorder = swCurrIndBorder, IsChecked = Settings.currencyESPEnabled }
    UpdateSwitchColor(AdvSwitchCurrency.Bg, AdvSwitchCurrency.IsChecked)
    if AdvSwitchCurrency.IsChecked then
        AdvSwitchCurrency.IndBorder.Position = AdvSwitchCurrency.Bg.Position + Vector2.new(16, 1)
        AdvSwitchCurrency.Ind.Position = AdvSwitchCurrency.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchCurrency.IndBorder.Position = AdvSwitchCurrency.Bg.Position + Vector2.new(1, 1)
        AdvSwitchCurrency.Ind.Position = AdvSwitchCurrency.Bg.Position + Vector2.new(1, 1)
    end

    local richTxt = Drawing.new("Text")
    richTxt.Visible = true
    richTxt.Transparency = 1
    richTxt.ZIndex = 1080
    richTxt.Color = Color3.fromHex("#d1d4dd")
    richTxt.Position = win2.Position + Vector2.new(27, 415)
    richTxt.Text = "Rich mode (>=25)"
    richTxt.Size = 12
    richTxt.Center = false
    richTxt.Outline = true
    richTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, richTxt)

    local swRich = Drawing.new("Square")
    swRich.Visible = true
    swRich.Transparency = 1
    swRich.Color = Color3.fromHex("#000000")
    swRich.Thickness = 1
    swRich.Filled = false
    swRich.Size = Vector2.new(30, 15)
    swRich.Position = win2.Position + Vector2.new(223, 414)
    swRich.ZIndex = 1120
    swRich.Corner = 10
    table.insert(uiElements, swRich)

    local swRichBg = Drawing.new("Square")
    swRichBg.Visible = true
    swRichBg.Transparency = 1
    swRichBg.Color = Color3.fromHex("#cbcfd5")
    swRichBg.Filled = true
    swRichBg.Size = swRich.Size
    swRichBg.Position = swRich.Position
    swRichBg.ZIndex = 1120
    swRichBg.Corner = 10
    table.insert(uiElements, swRichBg)

    local swRichIndBorder = Drawing.new("Square")
    swRichIndBorder.Visible = true
    swRichIndBorder.Transparency = 1
    swRichIndBorder.Color = Color3.fromHex("#000000")
    swRichIndBorder.Thickness = 1
    swRichIndBorder.Filled = false
    swRichIndBorder.Size = Vector2.new(13, 13)
    swRichIndBorder.ZIndex = 1122
    swRichIndBorder.Corner = 10
    table.insert(uiElements, swRichIndBorder)

    local swRichInd = Drawing.new("Square")
    swRichInd.Visible = true
    swRichInd.Transparency = 1
    swRichInd.Color = Color3.fromHex("#ffffff")
    swRichInd.Filled = true
    swRichInd.Size = Vector2.new(13, 13)
    swRichInd.ZIndex = 1122
    swRichInd.Corner = 10
    table.insert(uiElements, swRichInd)

    local swRichLabel = Drawing.new("Text")
    swRichLabel.Visible = true
    swRichLabel.Text = ""
    swRichLabel.Size = 1
    swRichLabel.Color = Color3.fromHex("#FFFFFF")
    swRichLabel.Outline = true
    swRichLabel.Font = Drawing.Fonts.UI
    swRichLabel.Position = swRich.Position + Vector2.new(40, 7)
    swRichLabel.ZIndex = 1121
    table.insert(uiElements, swRichLabel)

    AdvSwitchRich = { Bg = swRichBg, Ind = swRichInd, IndBorder = swRichIndBorder, IsChecked = Settings.currencyRichEnabled }
    UpdateSwitchColor(AdvSwitchRich.Bg, AdvSwitchRich.IsChecked)
    if AdvSwitchRich.IsChecked then
        AdvSwitchRich.IndBorder.Position = AdvSwitchRich.Bg.Position + Vector2.new(16, 1)
        AdvSwitchRich.Ind.Position = AdvSwitchRich.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchRich.IndBorder.Position = AdvSwitchRich.Bg.Position + Vector2.new(1, 1)
        AdvSwitchRich.Ind.Position = AdvSwitchRich.Bg.Position + Vector2.new(1, 1)
    end

    local currDesc = Drawing.new("Text")
    currDesc.Visible = true
    currDesc.Transparency = 1
    currDesc.ZIndex = 1100
    currDesc.Color = Color3.fromHex("#6b7382")
    currDesc.Position = win2.Position + Vector2.new(35, 436)
    currDesc.Text = "Show only currency >= 25"
    currDesc.Size = 11
    currDesc.Center = false
    currDesc.Outline = true
    currDesc.Font = Drawing.Fonts.UI
    table.insert(uiElements, currDesc)

    local s6 = Drawing.new("Square")
    s6.Visible = true
    s6.Transparency = 1
    s6.ZIndex = 1060
    s6.Color = Color3.fromHex("#111010")
    s6.Position = win2.Position + Vector2.new(16, 460)
    s6.Size = Vector2.new(251, 46)
    s6.Filled = true
    s6.Corner = 5
    table.insert(uiElements, s6)

    local s6b = Drawing.new("Square")
    s6b.Visible = true
    s6b.Transparency = 1
    s6b.ZIndex = 1061
    s6b.Color = Color3.fromHex("#1b1a1b")
    s6b.Filled = false
    s6b.Thickness = 1
    s6b.Position = s6.Position
    s6b.Size = s6.Size
    s6b.Corner = 5
    table.insert(uiElements, s6b)

    local doorsTxt = Drawing.new("Text")
    doorsTxt.Visible = true
    doorsTxt.Transparency = 1
    doorsTxt.ZIndex = 1080
    doorsTxt.Color = Color3.fromHex("#d1d4dd")
    doorsTxt.Position = win2.Position + Vector2.new(27, 469)
    doorsTxt.Text = "ESP Doors"
    doorsTxt.Size = 14
    doorsTxt.Center = false
    doorsTxt.Outline = true
    doorsTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, doorsTxt)

    local swDoors = Drawing.new("Square")
    swDoors.Visible = true
    swDoors.Transparency = 1
    swDoors.Color = Color3.fromHex("#000000")
    swDoors.Thickness = 1
    swDoors.Filled = false
    swDoors.Size = Vector2.new(30, 15)
    swDoors.Position = win2.Position + Vector2.new(223, 469)
    swDoors.ZIndex = 1120
    swDoors.Corner = 10
    table.insert(uiElements, swDoors)

    local swDoorsBg = Drawing.new("Square")
    swDoorsBg.Visible = true
    swDoorsBg.Transparency = 1
    swDoorsBg.Color = Color3.fromHex("#cbcfd5")
    swDoorsBg.Filled = true
    swDoorsBg.Size = swDoors.Size
    swDoorsBg.Position = swDoors.Position
    swDoorsBg.ZIndex = 1120
    swDoorsBg.Corner = 10
    table.insert(uiElements, swDoorsBg)

    local swDoorsIndBorder = Drawing.new("Square")
    swDoorsIndBorder.Visible = true
    swDoorsIndBorder.Transparency = 1
    swDoorsIndBorder.Color = Color3.fromHex("#000000")
    swDoorsIndBorder.Thickness = 1
    swDoorsIndBorder.Filled = false
    swDoorsIndBorder.Size = Vector2.new(13, 13)
    swDoorsIndBorder.ZIndex = 1122
    swDoorsIndBorder.Corner = 10
    table.insert(uiElements, swDoorsIndBorder)

    local swDoorsInd = Drawing.new("Square")
    swDoorsInd.Visible = true
    swDoorsInd.Transparency = 1
    swDoorsInd.Color = Color3.fromHex("#ffffff")
    swDoorsInd.Filled = true
    swDoorsInd.Size = Vector2.new(13, 13)
    swDoorsInd.ZIndex = 1122
    swDoorsInd.Corner = 10
    table.insert(uiElements, swDoorsInd)

    local swDoorsLabel = Drawing.new("Text")
    swDoorsLabel.Visible = true
    swDoorsLabel.Text = ""
    swDoorsLabel.Size = 1
    swDoorsLabel.Color = Color3.fromHex("#FFFFFF")
    swDoorsLabel.Outline = true
    swDoorsLabel.Font = Drawing.Fonts.UI
    swDoorsLabel.Position = swDoors.Position + Vector2.new(40, 7)
    swDoorsLabel.ZIndex = 1121
    table.insert(uiElements, swDoorsLabel)

    AdvSwitchDoors = { Bg = swDoorsBg, Ind = swDoorsInd, IndBorder = swDoorsIndBorder, IsChecked = Settings.doorESPEnabled }
    UpdateSwitchColor(AdvSwitchDoors.Bg, AdvSwitchDoors.IsChecked)
    if AdvSwitchDoors.IsChecked then
        AdvSwitchDoors.IndBorder.Position = AdvSwitchDoors.Bg.Position + Vector2.new(16, 1)
        AdvSwitchDoors.Ind.Position = AdvSwitchDoors.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchDoors.IndBorder.Position = AdvSwitchDoors.Bg.Position + Vector2.new(1, 1)
        AdvSwitchDoors.Ind.Position = AdvSwitchDoors.Bg.Position + Vector2.new(1, 1)
    end

    local doorsDesc = Drawing.new("Text")
    doorsDesc.Visible = true
    doorsDesc.Transparency = 1
    doorsDesc.ZIndex = 1100
    doorsDesc.Color = Color3.fromHex("#6b7382")
    doorsDesc.Position = win2.Position + Vector2.new(35, 484)
    doorsDesc.Text = "Turn enable/disable ESP's for nearest doors"
    doorsDesc.Size = 11
    doorsDesc.Center = false
    doorsDesc.Outline = true
    doorsDesc.Font = Drawing.Fonts.UI
    table.insert(uiElements, doorsDesc)

    _G.adv_esp = {
        elements = {win2, closeBtn, closeText, win, s1, s1b, title, espTxt, desc, sw, swBg, swIndBorder, swInd, swLabel,
                    s2, s2b, distTxt, sliderTrack, sliderFill, sliderKnob, sliderValText, sliderDesc,
                    s3, s3b, kcTxt, dropdownMain, dropdownText, dropdownArrow,
                    s4, s4b, itemsTxt, swItems, swItemsBg, swItemsIndBorder, swItemsInd, swItemsLabel, itemsDesc,
                    s5, s5b, currTxt, swCurr, swCurrBg, swCurrIndBorder, swCurrInd, swCurrLabel, richTxt, swRich, swRichBg, swRichIndBorder, swRichInd, swRichLabel, currDesc,
                    s6, s6b, doorsTxt, swDoors, swDoorsBg, swDoorsIndBorder, swDoorsInd, swDoorsLabel, doorsDesc},
        dropdownBoxes = dropdownBoxes,
        dropdownItems = dropdownItems,
        dropdownOpen = dropdownOpen,
        dropdownText = dropdownText,
        UpdateDropdown = UpdateDropdownText,
        swESP4 = AdvSwitchESP4,
        swItems = AdvSwitchItems,
        swCurrency = AdvSwitchCurrency,
        swRich = AdvSwitchRich,
        swDoors = AdvSwitchDoors,
        closeBtn = closeBtn,
        basePos = basePos,
        sliderTrack = sliderTrack,
        sliderKnob = sliderKnob,
        sliderFill = sliderFill,
        sliderValText = sliderValText,
        sliderDragging = false,
    }

    for _, box in ipairs(dropdownBoxes) do
        if _G.adv_esp and _G.adv_esp.elements then
            table.insert(_G.adv_esp.elements, box.Box)
            table.insert(_G.adv_esp.elements, box.Check)
            table.insert(_G.adv_esp.elements, box.Text)
        end
    end
end

local function CreateAdvancedNotifications()
    if advancedWindowOpen then
        CloseAdvancedWindows()
        return
    end
    advancedWindowOpen = true
    Overlay.Visible = true

    local basePos = VeryBackGUI.Position + Vector2.new(VeryBackGUI.Size.X + 20, 0)

    local win2 = Drawing.new("Square")
    win2.Visible = true
    win2.Transparency = 1
    win2.ZIndex = 1000
    win2.Color = Color3.fromHex("#111010")
    win2.Position = basePos
    win2.Size = Vector2.new(286, 46)
    win2.Filled = true
    table.insert(uiElements, win2)

    local closeBtn = Drawing.new("Square")
    closeBtn.Visible = true
    closeBtn.Transparency = 1
    closeBtn.ZIndex = 1010
    closeBtn.Color = Color3.fromHex("#111010")
    closeBtn.Position = win2.Position + Vector2.new(245, 5.5)
    closeBtn.Size = Vector2.new(28, 28)
    closeBtn.Filled = true
    table.insert(uiElements, closeBtn)

    local closeText = Drawing.new("Text")
    closeText.Visible = true
    closeText.Text = "X"
    closeText.Size = 18
    closeText.Center = true
    closeText.Outline = true
    closeText.Font = 0
    closeText.Color = Color3.fromHex("#b5b5b5")
    closeText.Position = closeBtn.Position + Vector2.new(14, 14)
    closeText.ZIndex = 1012
    table.insert(uiElements, closeText)

    local win = Drawing.new("Square")
    win.Visible = true
    win.Transparency = 1
    win.ZIndex = 1000
    win.Color = Color3.fromHex("#0c0c0d")
    win.Position = win2.Position + Vector2.new(-1, 43)
    win.Size = Vector2.new(287, 506)
    win.Filled = true
    table.insert(uiElements, win)

    local s1 = Drawing.new("Square")
    s1.Visible = true
    s1.Transparency = 1
    s1.ZIndex = 1040
    s1.Color = Color3.fromHex("#111010")
    s1.Position = win2.Position + Vector2.new(16, 52)
    s1.Size = Vector2.new(247, 65)
    s1.Filled = true
    s1.Corner = 5
    table.insert(uiElements, s1)

    local s1b = Drawing.new("Square")
    s1b.Visible = true
    s1b.Transparency = 1
    s1b.ZIndex = 1041
    s1b.Color = Color3.fromHex("#1b1a1b")
    s1b.Filled = false
    s1b.Thickness = 1
    s1b.Position = s1.Position
    s1b.Size = s1.Size
    s1b.Corner = 5
    table.insert(uiElements, s1b)

    local title = Drawing.new("Text")
    title.Visible = true
    title.Transparency = 1
    title.ZIndex = 1070
    title.Color = Color3.fromHex("#04c838")
    title.Position = win2.Position + Vector2.new(16, 12)
    title.Text = "Notification Settings"
    title.Size = 17
    title.Center = false
    title.Outline = true
    title.Font = Drawing.Fonts.UI
    table.insert(uiElements, title)

    local notifTxt = Drawing.new("Text")
    notifTxt.Visible = true
    notifTxt.Transparency = 1
    notifTxt.ZIndex = 1080
    notifTxt.Color = Color3.fromHex("#d1d4dd")
    notifTxt.Position = win2.Position + Vector2.new(27, 66)
    notifTxt.Text = "Notification"
    notifTxt.Size = 14
    notifTxt.Center = false
    notifTxt.Outline = true
    notifTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, notifTxt)

    local desc = Drawing.new("Text")
    desc.Visible = true
    desc.Transparency = 1
    desc.ZIndex = 1100
    desc.Color = Color3.fromHex("#6b7382")
    desc.Position = win2.Position + Vector2.new(35, 90)
    desc.Text = "Turn enable/disable notifications"
    desc.Size = 11
    desc.Center = false
    desc.Outline = true
    desc.Font = Drawing.Fonts.UI
    table.insert(uiElements, desc)

    local sw = Drawing.new("Square")
    sw.Visible = true
    sw.Transparency = 1
    sw.Color = Color3.fromHex("#000000")
    sw.Thickness = 1
    sw.Filled = false
    sw.Size = Vector2.new(30, 15)
    sw.Position = win2.Position + Vector2.new(223, 66)
    sw.ZIndex = 1120
    sw.Corner = 10
    table.insert(uiElements, sw)

    local swBg = Drawing.new("Square")
    swBg.Visible = true
    swBg.Transparency = 1
    swBg.Color = Color3.fromHex("#cbcfd5")
    swBg.Filled = true
    swBg.Size = sw.Size
    swBg.Position = sw.Position
    swBg.ZIndex = 1120
    swBg.Corner = 10
    table.insert(uiElements, swBg)

    local swIndBorder = Drawing.new("Square")
    swIndBorder.Visible = true
    swIndBorder.Transparency = 1
    swIndBorder.Color = Color3.fromHex("#000000")
    swIndBorder.Thickness = 1
    swIndBorder.Filled = false
    swIndBorder.Size = Vector2.new(13, 13)
    swIndBorder.ZIndex = 1122
    swIndBorder.Corner = 10
    table.insert(uiElements, swIndBorder)

    local swInd = Drawing.new("Square")
    swInd.Visible = true
    swInd.Transparency = 1
    swInd.Color = Color3.fromHex("#ffffff")
    swInd.Filled = true
    swInd.Size = Vector2.new(13, 13)
    swInd.ZIndex = 1122
    swInd.Corner = 10
    table.insert(uiElements, swInd)

    local swLabel = Drawing.new("Text")
    swLabel.Visible = true
    swLabel.Text = ""
    swLabel.Size = 1
    swLabel.Color = Color3.fromHex("#FFFFFF")
    swLabel.Outline = true
    swLabel.Font = Drawing.Fonts.UI
    swLabel.Position = sw.Position + Vector2.new(40, 7)
    swLabel.ZIndex = 1121
    table.insert(uiElements, swLabel)

    AdvSwitchNotif = { Bg = swBg, Ind = swInd, IndBorder = swIndBorder, IsChecked = MainSwitchNotification.IsChecked }
    if AdvSwitchNotif.IsChecked then
        AdvSwitchNotif.IndBorder.Position = AdvSwitchNotif.Bg.Position + Vector2.new(16, 1)
        AdvSwitchNotif.Ind.Position = AdvSwitchNotif.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchNotif.IndBorder.Position = AdvSwitchNotif.Bg.Position + Vector2.new(1, 1)
        AdvSwitchNotif.Ind.Position = AdvSwitchNotif.Bg.Position + Vector2.new(1, 1)
    end
    UpdateSwitchColor(AdvSwitchNotif.Bg, AdvSwitchNotif.IsChecked)

    local s3 = Drawing.new("Square")
    s3.Visible = true
    s3.Transparency = 1
    s3.ZIndex = 1060
    s3.Color = Color3.fromHex("#111010")
    s3.Position = win2.Position + Vector2.new(10, 138)
    s3.Size = Vector2.new(247, 65)
    s3.Filled = true
    s3.Corner = 5
    table.insert(uiElements, s3)

    local s3b = Drawing.new("Square")
    s3b.Visible = true
    s3b.Transparency = 1
    s3b.ZIndex = 1061
    s3b.Color = Color3.fromHex("#1b1a1b")
    s3b.Filled = false
    s3b.Thickness = 1
    s3b.Position = s3.Position
    s3b.Size = s3.Size
    s3b.Corner = 5
    table.insert(uiElements, s3b)

    local targetsTxt = Drawing.new("Text")
    targetsTxt.Visible = true
    targetsTxt.Transparency = 1
    targetsTxt.ZIndex = 1080
    targetsTxt.Color = Color3.fromHex("#d1d4dd")
    targetsTxt.Position = win2.Position + Vector2.new(21, 148)
    targetsTxt.Text = "Notification Targets"
    targetsTxt.Size = 14
    targetsTxt.Center = false
    targetsTxt.Outline = true
    targetsTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, targetsTxt)

    local targetItems = {
        { name = "Angler", checked = true },
        { name = "Blitz", checked = true },
        { name = "Froger", checked = true },
        { name = "Pinkie", checked = true },
        { name = "Chainsmoker", checked = true },
        { name = "Pandemonium", checked = true },
        { name = "A60", checked = true },
        { name = "Harbinger", checked = true },
        { name = "Painter", checked = false }
    }
    local targetOpen = false
    local targetMain = Drawing.new("Square")
    targetMain.Visible = true
    targetMain.Transparency = 1
    targetMain.Color = Color3.fromHex("#1b1a1b")
    targetMain.Filled = true
    targetMain.Size = Vector2.new(140, 24)
    targetMain.Position = win2.Position + Vector2.new(35, 163)
    targetMain.ZIndex = 1140
    targetMain.Corner = 4
    table.insert(uiElements, targetMain)

    local targetText = Drawing.new("Text")
    targetText.Visible = true
    targetText.Text = "Targets: all"
    targetText.Size = 14
    targetText.Outline = true
    targetText.Font = 0
    targetText.Color = Color3.fromHex("#d1d4dd")
    targetText.Position = targetMain.Position + Vector2.new(8, 4)
    targetText.ZIndex = 1142
    table.insert(uiElements, targetText)

    local targetArrow = Drawing.new("Text")
    targetArrow.Visible = true
    targetArrow.Text = "▼"
    targetArrow.Size = 12
    targetArrow.Outline = true
    targetArrow.Color = Color3.fromHex("#d1d4dd")
    targetArrow.Position = targetMain.Position + Vector2.new(120, 4)
    targetArrow.ZIndex = 1142
    table.insert(uiElements, targetArrow)

    local targetBoxes = {}
    for idx, item in ipairs(targetItems) do
        local box = Drawing.new("Square")
        box.Visible = false
        box.Transparency = 1
        box.Color = Color3.fromHex("#111010")
        box.Filled = true
        box.Size = Vector2.new(140, 24)
        box.Position = targetMain.Position + Vector2.new(0, 24 * idx)
        box.ZIndex = 1145
        box.Corner = 4
        table.insert(uiElements, box)

        local check = Drawing.new("Square")
        check.Visible = false
        check.Transparency = 1
        check.Color = item.checked and Color3.fromHex("#04c838") or Color3.fromHex("#3a3a3a")
        check.Filled = true
        check.Size = Vector2.new(12, 12)
        check.Position = box.Position + Vector2.new(6, 6)
        check.ZIndex = 1146
        check.Corner = 2
        table.insert(uiElements, check)

        local txt = Drawing.new("Text")
        txt.Visible = false
        txt.Text = item.name
        txt.Size = 14
        txt.Outline = true
        txt.Font = 0
        txt.Color = Color3.fromHex("#d1d4dd")
        txt.Position = box.Position + Vector2.new(24, 4)
        txt.ZIndex = 1146
        table.insert(uiElements, txt)

        table.insert(targetBoxes, { Box = box, Check = check, Text = txt, Data = item })
    end

    local function UpdateTargetText()
        local sel = {}
        for _, it in ipairs(targetItems) do
            if it.checked then table.insert(sel, it.name) end
        end
        if #sel == 0 then targetText.Text = "Targets: none"
        elseif #sel == #targetItems then targetText.Text = "Targets: all"
        else targetText.Text = "Targets: " .. #sel .. "/" .. #targetItems end
    end

    local s4 = Drawing.new("Square")
    s4.Visible = true
    s4.Transparency = 1
    s4.ZIndex = 1060
    s4.Color = Color3.fromHex("#111010")
    s4.Position = win2.Position + Vector2.new(10, 223)
    s4.Size = Vector2.new(251, 46)
    s4.Filled = true
    s4.Corner = 5
    table.insert(uiElements, s4)

    local s4b = Drawing.new("Square")
    s4b.Visible = true
    s4b.Transparency = 1
    s4b.ZIndex = 1061
    s4b.Color = Color3.fromHex("#1b1a1b")
    s4b.Filled = false
    s4b.Thickness = 1
    s4b.Position = s4.Position
    s4b.Size = s4.Size
    s4b.Corner = 5
    table.insert(uiElements, s4b)

    local wmTxt = Drawing.new("Text")
    wmTxt.Visible = true
    wmTxt.Transparency = 1
    wmTxt.ZIndex = 1080
    wmTxt.Color = Color3.fromHex("#d1d4dd")
    wmTxt.Position = win2.Position + Vector2.new(21, 233)
    wmTxt.Text = "Watermark"
    wmTxt.Size = 14
    wmTxt.Center = false
    wmTxt.Outline = true
    wmTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, wmTxt)

    local swWm = Drawing.new("Square")
    swWm.Visible = true
    swWm.Transparency = 1
    swWm.Color = Color3.fromHex("#000000")
    swWm.Thickness = 1
    swWm.Filled = false
    swWm.Size = Vector2.new(30, 15)
    swWm.Position = win2.Position + Vector2.new(217, 233)
    swWm.ZIndex = 1120
    swWm.Corner = 10
    table.insert(uiElements, swWm)

    local swWmBg = Drawing.new("Square")
    swWmBg.Visible = true
    swWmBg.Transparency = 1
    swWmBg.Color = Color3.fromHex("#cbcfd5")
    swWmBg.Filled = true
    swWmBg.Size = swWm.Size
    swWmBg.Position = swWm.Position
    swWmBg.ZIndex = 1120
    swWmBg.Corner = 10
    table.insert(uiElements, swWmBg)

    local swWmIndBorder = Drawing.new("Square")
    swWmIndBorder.Visible = true
    swWmIndBorder.Transparency = 1
    swWmIndBorder.Color = Color3.fromHex("#000000")
    swWmIndBorder.Thickness = 1
    swWmIndBorder.Filled = false
    swWmIndBorder.Size = Vector2.new(13, 13)
    swWmIndBorder.ZIndex = 1122
    swWmIndBorder.Corner = 10
    table.insert(uiElements, swWmIndBorder)

    local swWmInd = Drawing.new("Square")
    swWmInd.Visible = true
    swWmInd.Transparency = 1
    swWmInd.Color = Color3.fromHex("#ffffff")
    swWmInd.Filled = true
    swWmInd.Size = Vector2.new(13, 13)
    swWmInd.ZIndex = 1122
    swWmInd.Corner = 10
    table.insert(uiElements, swWmInd)

    local swWmLabel = Drawing.new("Text")
    swWmLabel.Visible = true
    swWmLabel.Text = ""
    swWmLabel.Size = 1
    swWmLabel.Color = Color3.fromHex("#FFFFFF")
    swWmLabel.Outline = true
    swWmLabel.Font = Drawing.Fonts.UI
    swWmLabel.Position = swWm.Position + Vector2.new(40, 7)
    swWmLabel.ZIndex = 1121
    table.insert(uiElements, swWmLabel)

    AdvSwitchWatermark = { Bg = swWmBg, Ind = swWmInd, IndBorder = swWmIndBorder, IsChecked = Settings.watermarkEnabled }
    UpdateSwitchColor(AdvSwitchWatermark.Bg, AdvSwitchWatermark.IsChecked)
    if AdvSwitchWatermark.IsChecked then
        AdvSwitchWatermark.IndBorder.Position = AdvSwitchWatermark.Bg.Position + Vector2.new(16, 1)
        AdvSwitchWatermark.Ind.Position = AdvSwitchWatermark.Bg.Position + Vector2.new(16, 1)
    else
        AdvSwitchWatermark.IndBorder.Position = AdvSwitchWatermark.Bg.Position + Vector2.new(1, 1)
        AdvSwitchWatermark.Ind.Position = AdvSwitchWatermark.Bg.Position + Vector2.new(1, 1)
    end

    local wmDesc = Drawing.new("Text")
    wmDesc.Visible = true
    wmDesc.Transparency = 1
    wmDesc.ZIndex = 1100
    wmDesc.Color = Color3.fromHex("#6b7382")
    wmDesc.Position = win2.Position + Vector2.new(29, 248)
    wmDesc.Text = "Turn enable/disable Watermark"
    wmDesc.Size = 11
    wmDesc.Center = false
    wmDesc.Outline = true
    wmDesc.Font = Drawing.Fonts.UI
    table.insert(uiElements, wmDesc)

    local s5 = Drawing.new("Square")
    s5.Visible = true
    s5.Transparency = 1
    s5.ZIndex = 1060
    s5.Color = Color3.fromHex("#111010")
    s5.Position = win2.Position + Vector2.new(10, 280)
    s5.Size = Vector2.new(251, 65)
    s5.Filled = true
    s5.Corner = 5
    table.insert(uiElements, s5)

    local s5b = Drawing.new("Square")
    s5b.Visible = true
    s5b.Transparency = 1
    s5b.ZIndex = 1061
    s5b.Color = Color3.fromHex("#1b1a1b")
    s5b.Filled = false
    s5b.Thickness = 1
    s5b.Position = s5.Position
    s5b.Size = s5.Size
    s5b.Corner = 5
    table.insert(uiElements, s5b)

    local wmTargetsTxt = Drawing.new("Text")
    wmTargetsTxt.Visible = true
    wmTargetsTxt.Transparency = 1
    wmTargetsTxt.ZIndex = 1080
    wmTargetsTxt.Color = Color3.fromHex("#d1d4dd")
    wmTargetsTxt.Position = win2.Position + Vector2.new(21, 290)
    wmTargetsTxt.Text = "Watermark Targets"
    wmTargetsTxt.Size = 14
    wmTargetsTxt.Center = false
    wmTargetsTxt.Outline = true
    wmTargetsTxt.Font = Drawing.Fonts.UI
    table.insert(uiElements, wmTargetsTxt)

    local wmTargetItems = {
        { name = "Angler", checked = Settings.watermarkMobsEnabled.Angler },
        { name = "Blitz", checked = Settings.watermarkMobsEnabled.Blitz },
        { name = "Froger", checked = Settings.watermarkMobsEnabled.Froger },
        { name = "Pinkie", checked = Settings.watermarkMobsEnabled.Pinkie },
        { name = "Chainsmoker", checked = Settings.watermarkMobsEnabled.Chainsmoker },
        { name = "Pandemonium", checked = Settings.watermarkMobsEnabled.Pandemonium },
        { name = "A60", checked = Settings.watermarkMobsEnabled["A60"] },
        { name = "Harbinger", checked = Settings.watermarkMobsEnabled.Harbinger },
        { name = "Painter", checked = Settings.watermarkMobsEnabled.Painter }
    }
    local wmTargetOpen = false
    local wmTargetMain = Drawing.new("Square")
    wmTargetMain.Visible = true
    wmTargetMain.Transparency = 1
    wmTargetMain.Color = Color3.fromHex("#1b1a1b")
    wmTargetMain.Filled = true
    wmTargetMain.Size = Vector2.new(140, 24)
    wmTargetMain.Position = win2.Position + Vector2.new(35, 305)
    wmTargetMain.ZIndex = 1140
    wmTargetMain.Corner = 4
    table.insert(uiElements, wmTargetMain)

    local wmTargetText = Drawing.new("Text")
    wmTargetText.Visible = true
    wmTargetText.Text = "Watermark: all"
    wmTargetText.Size = 14
    wmTargetText.Outline = true
    wmTargetText.Font = 0
    wmTargetText.Color = Color3.fromHex("#d1d4dd")
    wmTargetText.Position = wmTargetMain.Position + Vector2.new(8, 4)
    wmTargetText.ZIndex = 1142
    table.insert(uiElements, wmTargetText)

    local wmTargetArrow = Drawing.new("Text")
    wmTargetArrow.Visible = true
    wmTargetArrow.Text = "▼"
    wmTargetArrow.Size = 12
    wmTargetArrow.Outline = true
    wmTargetArrow.Color = Color3.fromHex("#d1d4dd")
    wmTargetArrow.Position = wmTargetMain.Position + Vector2.new(120, 4)
    wmTargetArrow.ZIndex = 1142
    table.insert(uiElements, wmTargetArrow)

    local wmTargetBoxes = {}
    for idx, item in ipairs(wmTargetItems) do
        local box = Drawing.new("Square")
        box.Visible = false
        box.Transparency = 1
        box.Color = Color3.fromHex("#111010")
        box.Filled = true
        box.Size = Vector2.new(140, 24)
        box.Position = wmTargetMain.Position + Vector2.new(0, 24 * idx)
        box.ZIndex = 1145
        box.Corner = 4
        table.insert(uiElements, box)

        local check = Drawing.new("Square")
        check.Visible = false
        check.Transparency = 1
        check.Color = item.checked and Color3.fromHex("#04c838") or Color3.fromHex("#3a3a3a")
        check.Filled = true
        check.Size = Vector2.new(12, 12)
        check.Position = box.Position + Vector2.new(6, 6)
        check.ZIndex = 1146
        check.Corner = 2
        table.insert(uiElements, check)

        local txt = Drawing.new("Text")
        txt.Visible = false
        txt.Text = item.name
        txt.Size = 14
        txt.Outline = true
        txt.Font = 0
        txt.Color = Color3.fromHex("#d1d4dd")
        txt.Position = box.Position + Vector2.new(24, 4)
        txt.ZIndex = 1146
        table.insert(uiElements, txt)

        table.insert(wmTargetBoxes, { Box = box, Check = check, Text = txt, Data = item })
    end

    local function UpdateWMTargetText()
        local sel = {}
        for _, it in ipairs(wmTargetItems) do
            if it.checked then table.insert(sel, it.name) end
        end
        if #sel == 0 then wmTargetText.Text = "Watermark: none"
        elseif #sel == #wmTargetItems then wmTargetText.Text = "Watermark: all"
        else wmTargetText.Text = "Watermark: " .. #sel .. "/" .. #wmTargetItems end
    end

    _G.adv_notif = {
        elements = {win2, closeBtn, closeText, win, s1, s1b, title, notifTxt, desc, sw, swBg, swIndBorder, swInd, swLabel,
                    s3, s3b, targetsTxt, targetMain, targetText, targetArrow,
                    s4, s4b, wmTxt, swWm, swWmBg, swWmIndBorder, swWmInd, swWmLabel, wmDesc,
                    s5, s5b, wmTargetsTxt, wmTargetMain, wmTargetText, wmTargetArrow},
        targetBoxes = targetBoxes,
        targetItems = targetItems,
        targetOpen = targetOpen,
        targetText = targetText,
        UpdateTarget = UpdateTargetText,
        wmTargetBoxes = wmTargetBoxes,
        wmTargetItems = wmTargetItems,
        wmTargetOpen = wmTargetOpen,
        wmTargetText = wmTargetText,
        UpdateWMTarget = UpdateWMTargetText,
        swNotif = AdvSwitchNotif,
        swWatermark = AdvSwitchWatermark,
        closeBtn = closeBtn,
        basePos = basePos,
    }

    for _, box in ipairs(targetBoxes) do
        if _G.adv_notif and _G.adv_notif.elements then
            table.insert(_G.adv_notif.elements, box.Box)
            table.insert(_G.adv_notif.elements, box.Check)
            table.insert(_G.adv_notif.elements, box.Text)
        end
    end
    for _, box in ipairs(wmTargetBoxes) do
        if _G.adv_notif and _G.adv_notif.elements then
            table.insert(_G.adv_notif.elements, box.Box)
            table.insert(_G.adv_notif.elements, box.Check)
            table.insert(_G.adv_notif.elements, box.Text)
        end
    end
end

local dragging = false
local dragStart = nil
local startPos = nil
local lastMouse1 = false
local lastMouse2 = false
local watermarkDragging = false
local watermarkStartPos = nil
local watermarkDragStart = nil
local sliderDragging = false

spawn(function()
    while true do
        updateAllESP()
        scanner:update()
        doorScanner:scan()
        CheckForMobs()
        task.wait(0.03)
    end
end)

local MainLoader1 = Drawing.new("Square")
MainLoader1.Visible = true
MainLoader1.Transparency = 1
MainLoader1.ZIndex = 10
MainLoader1.Color = Color3.fromHex("#111010")
MainLoader1.Position = Vector2.new(187, 146)
MainLoader1.Size = Vector2.new(426, 289)
MainLoader1.Filled = true
MainLoader1.Corner = 6

local MainLoader1_Border = Drawing.new("Square")
MainLoader1_Border.Visible = true
MainLoader1_Border.Transparency = 1
MainLoader1_Border.ZIndex = 11
MainLoader1_Border.Color = Color3.fromHex("#1b1a1b")
MainLoader1_Border.Filled = false
MainLoader1_Border.Thickness = 1
MainLoader1_Border.Position = MainLoader1.Position
MainLoader1_Border.Size = MainLoader1.Size
MainLoader1_Border.Corner = 6

local LogoLoader = Drawing.new("Text")
LogoLoader.Visible = true
LogoLoader.Transparency = 1
LogoLoader.ZIndex = 20
LogoLoader.Color = Color3.fromHex("#00c950")
LogoLoader.Position = MainLoader1.Position + Vector2.new(23, 16)
LogoLoader.Text = ">_"
LogoLoader.Size = 26
LogoLoader.Center = false
LogoLoader.Outline = true
LogoLoader.Font = Drawing.Fonts.Monospace

local Initilizing = Drawing.new("Text")
Initilizing.Visible = true
Initilizing.Transparency = 1
Initilizing.ZIndex = 30
Initilizing.Color = Color3.fromHex("#00c950")
Initilizing.Position = MainLoader1.Position + Vector2.new(67, 29)
Initilizing.Text = "Initializing..."
Initilizing.Size = 19
Initilizing.Center = false
Initilizing.Outline = true
Initilizing.Font = Drawing.Fonts.Monospace

local LoadLogs = {}
for i=1,5 do
    local log = Drawing.new("Text")
    log.Visible = false
    log.Transparency = 1
    log.ZIndex = 40 + i
    log.Color = Color3.fromHex("#00c950")
    log.Position = MainLoader1.Position + Vector2.new(23, 72 + (i-1)*22)
    log.Text = ""
    log.Size = 14
    log.Center = false
    log.Outline = true
    log.Font = Drawing.Fonts.Monospace
    table.insert(LoadLogs, log)
    table.insert(uiElements, log)
end

local AnimatingLineLoad = Drawing.new("Square")
AnimatingLineLoad.Visible = true
AnimatingLineLoad.Transparency = 1
AnimatingLineLoad.ZIndex = 80
AnimatingLineLoad.Color = Color3.fromHex("#00c950")
AnimatingLineLoad.Position = MainLoader1.Position + Vector2.new(29.5, 262)
AnimatingLineLoad.Size = Vector2.new(0, 6)
AnimatingLineLoad.Filled = true
AnimatingLineLoad.Corner = 8

local Loadingscripttext = Drawing.new("Text")
Loadingscripttext.Visible = true
Loadingscripttext.Transparency = 1
Loadingscripttext.ZIndex = 90
Loadingscripttext.Color = Color3.fromHex("#6b7382")
Loadingscripttext.Position = MainLoader1.Position + Vector2.new(29.5, 240)
Loadingscripttext.Text = "Loading script.."
Loadingscripttext.Size = 14
Loadingscripttext.Center = false
Loadingscripttext.Outline = true
Loadingscripttext.Font = Drawing.Fonts.Monospace

local CountLoadScript = Drawing.new("Text")
CountLoadScript.Visible = true
CountLoadScript.Transparency = 1
CountLoadScript.ZIndex = 100
CountLoadScript.Color = Color3.fromHex("#6b7382")
CountLoadScript.Position = MainLoader1.Position + Vector2.new(381, 240)
CountLoadScript.Text = "0/20"
CountLoadScript.Size = 14
CountLoadScript.Center = false
CountLoadScript.Outline = true
CountLoadScript.Font = Drawing.Fonts.Monospace

local loadMessages = {
    "Loading core modules",
    "Initializing ESP system",
    "Connecting to game services",
    "Setting up UI elements",
    "Loading AutoHide module",
    "Loading Notification system",
    "Loading Watermark",
    "Applying configurations",
    "Scanning for entities",
    "Loading Keycard ESP",
    "Loading Item ESP",
    "Loading Currency ESP",
    "Loading Door ESP",
    "Loading Rich mode",
    "Finalizing",
    "Almost done",
    "Done",
    "Verifying integrity",
    "Starting services",
    "Ready"
}

local totalSteps = 20
local maxWidth = 367
local logIndex = 1
local duration = 4.0
local startTime = tick()

local logQueue = {}

local function AddLog(msg, status)
    local color
    if status == "success" then
        color = Color3.fromHex("#00c950")
        msg = "[+] " .. msg
    elseif status == "fail" then
        color = Color3.fromHex("#c70000")
        msg = "[-] " .. msg
    elseif status == "warn" then
        color = Color3.fromHex("#bac700")
        msg = "[?] " .. msg
    end
    table.insert(logQueue, { text = msg, color = color })
    if #logQueue > 5 then
        table.remove(logQueue, 1)
    end
    for i, log in ipairs(LoadLogs) do
        if i <= #logQueue then
            log.Visible = true
            log.Text = logQueue[i].text
            log.Color = logQueue[i].color
        else
            log.Visible = false
        end
    end
end

spawn(function()
    while tick() - startTime < duration do
        local elapsed = tick() - startTime
        local progress = elapsed / duration
        AnimatingLineLoad.Size = Vector2.new(maxWidth * progress, 6)
        local step = math.floor(progress * totalSteps) + 1
        if step > totalSteps then step = totalSteps end
        CountLoadScript.Text = step .. "/" .. totalSteps
        if step > logIndex and logIndex <= totalSteps then
            AddLog(loadMessages[logIndex], "success")
            logIndex = logIndex + 1
        end
        wait()
    end
    AnimatingLineLoad.Size = Vector2.new(maxWidth, 6)
    CountLoadScript.Text = totalSteps .. "/" .. totalSteps
    while logIndex <= totalSteps do
        AddLog(loadMessages[logIndex], "success")
        logIndex = logIndex + 1
        wait(0.1)
    end
    wait(0.5)
    AddLog("Script loaded successfully", "success")
    wait(1)
    MainLoader1.Visible = false
    MainLoader1_Border.Visible = false
    LogoLoader.Visible = false
    Initilizing.Visible = false
    for _, log in ipairs(LoadLogs) do
        log.Visible = false
    end
    AnimatingLineLoad.Visible = false
    Loadingscripttext.Visible = false
    CountLoadScript.Visible = false
    VeryBackGUI.Visible = true
    VeryBackGUI_Border.Visible = true
    Line1.Visible = true
    BackGUItabs.Visible = true
    Line3.Visible = true
    Line2.Visible = true
    TextRATHUB.Visible = true
    TextLOGO.Visible = true
    BackContentTabs.Visible = true
    BackContentTabs_Border.Visible = true
    BackGUI2.Visible = true
    BackGUI2_Border.Visible = true
    TabVisuals.Visible = true
    TabVisuals_Text.Visible = true
    TabExploits.Visible = true
    TabExploits_Text.Visible = true
    TabMisc.Visible = true
    TabMisc_Text.Visible = true
    TabInfo.Visible = true
    TabInfo_Text.Visible = true
    Square16.Visible = true
    HideAllTabs()
    SetActiveTab("Visuals", TabVisuals, TabVisuals_Border, TabVisuals_Text)
    VisualsContent1.Visible = true; VisualsContent1_Border.Visible = true
    NotificationTEXT.Visible = true; DescryptionNofitication.Visible = true
    SwitchNotification.Visible = true; SwitchNotification_Bg.Visible = true
    SwitchNotification_IndBorder.Visible = true; SwitchNotification_Ind.Visible = true
    SwitchNotification_Label.Visible = true
    VisualsContent2.Visible = true; VisualsContent2_Border.Visible = true
    TextESP.Visible = true; ESPdescryption.Visible = true
    SwitchESP.Visible = true; SwitchESP_Bg.Visible = true
    SwitchESP_IndBorder.Visible = true; SwitchESP_Ind.Visible = true
    SwitchESP_Label.Visible = true
    setrobloxinput(false)
end)

while true do
    wait(0.01)
    if pcall(ismouse1pressed) and isrbxactive() then
        local mouse1 = ismouse1pressed()
        local mouse2 = ismouse2pressed()
        local mPos = Vector2.new(Mouse.X, Mouse.Y)

        if iskeypressed(closeKey) then
            local newState = not VeryBackGUI.Visible
            VeryBackGUI.Visible = newState
            VeryBackGUI_Border.Visible = newState
            Line1.Visible = newState
            BackGUItabs.Visible = newState
            Line3.Visible = newState
            Line2.Visible = newState
            TextRATHUB.Visible = newState
            TextLOGO.Visible = newState
            BackContentTabs.Visible = newState
            BackContentTabs_Border.Visible = newState
            BackGUI2.Visible = newState
            BackGUI2_Border.Visible = newState
            TabVisuals.Visible = newState
            TabVisuals_Text.Visible = newState
            TabExploits.Visible = newState
            TabExploits_Text.Visible = newState
            TabMisc.Visible = newState
            TabMisc_Text.Visible = newState
            TabInfo.Visible = newState
            TabInfo_Text.Visible = newState
            Square16.Visible = newState
            TabVisuals_Border.Visible = newState and (activeTab == "Visuals")
            TabExploits_Border.Visible = newState and (activeTab == "Exploits")
            TabMisc_Border.Visible = newState and (activeTab == "Misc")
            TabInfo_Border.Visible = newState and (activeTab == "Info")
            if activeTab == "Visuals" then
                VisualsContent1.Visible = newState
                VisualsContent1_Border.Visible = newState
                NotificationTEXT.Visible = newState
                DescryptionNofitication.Visible = newState
                SwitchNotification.Visible = newState
                SwitchNotification_Bg.Visible = newState
                SwitchNotification_IndBorder.Visible = newState
                SwitchNotification_Ind.Visible = newState
                SwitchNotification_Label.Visible = newState
                VisualsContent2.Visible = newState
                VisualsContent2_Border.Visible = newState
                TextESP.Visible = newState
                ESPdescryption.Visible = newState
                SwitchESP.Visible = newState
                SwitchESP_Bg.Visible = newState
                SwitchESP_IndBorder.Visible = newState
                SwitchESP_Ind.Visible = newState
                SwitchESP_Label.Visible = newState
            elseif activeTab == "Exploits" then
                ContentExploits1.Visible = newState
                ContentExploits1_Border.Visible = newState
                AutoHideText.Visible = newState
                AutoHideDescryption.Visible = newState
                SwitchAutoHide.Visible = newState
                SwitchAutoHide_Bg.Visible = newState
                SwitchAutoHide_IndBorder.Visible = newState
                SwitchAutoHide_Ind.Visible = newState
                SwitchAutoHide_Label.Visible = newState
            elseif activeTab == "Misc" then
                InvisibleSquare.Visible = newState
                HereNoContentText.Visible = newState
            elseif activeTab == "Info" then
                ContentInfo1.Visible = newState
                ContentInfo1_Border.Visible = newState
                TextInfo1.Visible = newState
                TextInfo2.Visible = newState
                ContentInfo2.Visible = newState
                ContentInfo2_Border.Visible = newState
                TextInfo3.Visible = newState
                Changelog1.Visible = newState
                Changelog3.Visible = newState
                Changelog2.Visible = newState
            end
            if not newState and advancedWindowOpen then
                CloseAdvancedWindows()
            end
            if newState then
                setrobloxinput(false)
            else
                setrobloxinput(true)
            end
            wait(0.2)
        end

        local tabs = {
            {btn = TabVisuals, border = TabVisuals_Border, txt = TabVisuals_Text, name = "Visuals"},
            {btn = TabExploits, border = TabExploits_Border, txt = TabExploits_Text, name = "Exploits"},
            {btn = TabMisc, border = TabMisc_Border, txt = TabMisc_Text, name = "Misc"},
            {btn = TabInfo, border = TabInfo_Border, txt = TabInfo_Text, name = "Info"}
        }
        for _, t in ipairs(tabs) do
            if t.btn.Visible and mPos.X >= t.btn.Position.X and mPos.X <= t.btn.Position.X + t.btn.Size.X and
               mPos.Y >= t.btn.Position.Y and mPos.Y <= t.btn.Position.Y + t.btn.Size.Y then
                if t.name ~= activeTab then
                    t.btn.Color = Color3.fromHex("#1a1a1a")
                end
            else
                if t.name ~= activeTab then
                    t.btn.Color = Color3.fromHex("#0c0c0d")
                end
            end
        end

        local blocks = {
            {block = VisualsContent1, border = VisualsContent1_Border, visible = VisualsContent1.Visible},
            {block = VisualsContent2, border = VisualsContent2_Border, visible = VisualsContent2.Visible},
            {block = ContentExploits1, border = ContentExploits1_Border, visible = ContentExploits1.Visible},
            {block = ContentInfo1, border = ContentInfo1_Border, visible = ContentInfo1.Visible},
            {block = ContentInfo2, border = ContentInfo2_Border, visible = ContentInfo2.Visible},
        }
        for _, b in ipairs(blocks) do
            if b.visible and mPos.X >= b.block.Position.X and mPos.X <= b.block.Position.X + b.block.Size.X and
               mPos.Y >= b.block.Position.Y and mPos.Y <= b.block.Position.Y + b.block.Size.Y then
                b.border.Color = Color3.fromHex("#00c950")
            else
                b.border.Color = Color3.fromHex("#1b1a1b")
            end
        end

        if mouse1 and not lastMouse1 then
            if TabVisuals.Visible and mPos.X >= TabVisuals.Position.X and mPos.X <= TabVisuals.Position.X + TabVisuals.Size.X and
               mPos.Y >= TabVisuals.Position.Y and mPos.Y <= TabVisuals.Position.Y + TabVisuals.Size.Y then
                HideAllTabs()
                VisualsContent1.Visible = true; VisualsContent1_Border.Visible = true
                NotificationTEXT.Visible = true; DescryptionNofitication.Visible = true
                SwitchNotification.Visible = true; SwitchNotification_Bg.Visible = true
                SwitchNotification_IndBorder.Visible = true; SwitchNotification_Ind.Visible = true
                SwitchNotification_Label.Visible = true
                VisualsContent2.Visible = true; VisualsContent2_Border.Visible = true
                TextESP.Visible = true; ESPdescryption.Visible = true
                SwitchESP.Visible = true; SwitchESP_Bg.Visible = true
                SwitchESP_IndBorder.Visible = true; SwitchESP_Ind.Visible = true
                SwitchESP_Label.Visible = true
                SetActiveTab("Visuals", TabVisuals, TabVisuals_Border, TabVisuals_Text)
            end
            if TabExploits.Visible and mPos.X >= TabExploits.Position.X and mPos.X <= TabExploits.Position.X + TabExploits.Size.X and
               mPos.Y >= TabExploits.Position.Y and mPos.Y <= TabExploits.Position.Y + TabExploits.Size.Y then
                HideAllTabs()
                ContentExploits1.Visible = true; ContentExploits1_Border.Visible = true
                AutoHideText.Visible = true; AutoHideDescryption.Visible = true
                SwitchAutoHide.Visible = true; SwitchAutoHide_Bg.Visible = true
                SwitchAutoHide_IndBorder.Visible = true; SwitchAutoHide_Ind.Visible = true
                SwitchAutoHide_Label.Visible = true
                SetActiveTab("Exploits", TabExploits, TabExploits_Border, TabExploits_Text)
            end
            if TabMisc.Visible and mPos.X >= TabMisc.Position.X and mPos.X <= TabMisc.Position.X + TabMisc.Size.X and
               mPos.Y >= TabMisc.Position.Y and mPos.Y <= TabMisc.Position.Y + TabMisc.Size.Y then
                HideAllTabs()
                InvisibleSquare.Visible = true; HereNoContentText.Visible = true
                SetActiveTab("Misc", TabMisc, TabMisc_Border, TabMisc_Text)
            end
            if TabInfo.Visible and mPos.X >= TabInfo.Position.X and mPos.X <= TabInfo.Position.X + TabInfo.Size.X and
               mPos.Y >= TabInfo.Position.Y and mPos.Y <= TabInfo.Position.Y + TabInfo.Size.Y then
                HideAllTabs()
                ContentInfo1.Visible = true; ContentInfo1_Border.Visible = true
                TextInfo1.Visible = true; TextInfo2.Visible = true
                ContentInfo2.Visible = true; ContentInfo2_Border.Visible = true
                TextInfo3.Visible = true; Changelog1.Visible = true
                Changelog3.Visible = true; Changelog2.Visible = true
                SetActiveTab("Info", TabInfo, TabInfo_Border, TabInfo_Text)
            end

            if SwitchNotification_Label.Visible and mPos.X >= SwitchNotification.Position.X and mPos.X <= SwitchNotification.Position.X + SwitchNotification.Size.X and
               mPos.Y >= SwitchNotification.Position.Y and mPos.Y <= SwitchNotification.Position.Y + SwitchNotification.Size.Y then
                MainSwitchNotification.IsChecked = not MainSwitchNotification.IsChecked
                UpdateSwitchColor(SwitchNotification_Bg, MainSwitchNotification.IsChecked)
                if MainSwitchNotification.IsChecked then
                    SwitchNotification_IndBorder.Position = SwitchNotification.Position + Vector2.new(11, 1)
                    SwitchNotification_Ind.Position = SwitchNotification.Position + Vector2.new(11, 1)
                else
                    SwitchNotification_IndBorder.Position = SwitchNotification.Position + Vector2.new(1, 1)
                    SwitchNotification_Ind.Position = SwitchNotification.Position + Vector2.new(1, 1)
                end
                Settings.notificationsEnabled = {
                    Angler = MainSwitchNotification.IsChecked,
                    Froger = MainSwitchNotification.IsChecked,
                    Pinkie = MainSwitchNotification.IsChecked,
                    Blitz = MainSwitchNotification.IsChecked,
                    Pandemonium = MainSwitchNotification.IsChecked,
                    Chainsmoker = MainSwitchNotification.IsChecked,
                    ["A60"] = MainSwitchNotification.IsChecked,
                    Harbinger = MainSwitchNotification.IsChecked,
                    Painter = MainSwitchNotification.IsChecked
                }
                if AdvSwitchNotif then
                    AdvSwitchNotif.IsChecked = MainSwitchNotification.IsChecked
                    UpdateSwitchColor(AdvSwitchNotif.Bg, AdvSwitchNotif.IsChecked)
                    if AdvSwitchNotif.IsChecked then
                        AdvSwitchNotif.IndBorder.Position = AdvSwitchNotif.Bg.Position + Vector2.new(16, 1)
                        AdvSwitchNotif.Ind.Position = AdvSwitchNotif.Bg.Position + Vector2.new(16, 1)
                    else
                        AdvSwitchNotif.IndBorder.Position = AdvSwitchNotif.Bg.Position + Vector2.new(1, 1)
                        AdvSwitchNotif.Ind.Position = AdvSwitchNotif.Bg.Position + Vector2.new(1, 1)
                    end
                end
            end
            if SwitchESP_Label.Visible and mPos.X >= SwitchESP.Position.X and mPos.X <= SwitchESP.Position.X + SwitchESP.Size.X and
               mPos.Y >= SwitchESP.Position.Y and mPos.Y <= SwitchESP.Position.Y + SwitchESP.Size.Y then
                MainSwitchESP.IsChecked = not MainSwitchESP.IsChecked
                UpdateSwitchColor(SwitchESP_Bg, MainSwitchESP.IsChecked)
                if MainSwitchESP.IsChecked then
                    SwitchESP_IndBorder.Position = SwitchESP.Position + Vector2.new(11, 1)
                    SwitchESP_Ind.Position = SwitchESP.Position + Vector2.new(11, 1)
                else
                    SwitchESP_IndBorder.Position = SwitchESP.Position + Vector2.new(1, 1)
                    SwitchESP_Ind.Position = SwitchESP.Position + Vector2.new(1, 1)
                end
                Settings.keycardESPEnabled = MainSwitchESP.IsChecked
                if AdvSwitchESP4 then
                    AdvSwitchESP4.IsChecked = MainSwitchESP.IsChecked
                    UpdateSwitchColor(AdvSwitchESP4.Bg, AdvSwitchESP4.IsChecked)
                    if AdvSwitchESP4.IsChecked then
                        AdvSwitchESP4.IndBorder.Position = AdvSwitchESP4.Bg.Position + Vector2.new(16, 1)
                        AdvSwitchESP4.Ind.Position = AdvSwitchESP4.Bg.Position + Vector2.new(16, 1)
                    else
                        AdvSwitchESP4.IndBorder.Position = AdvSwitchESP4.Bg.Position + Vector2.new(1, 1)
                        AdvSwitchESP4.Ind.Position = AdvSwitchESP4.Bg.Position + Vector2.new(1, 1)
                    end
                end
            end
            if SwitchAutoHide_Label.Visible and mPos.X >= SwitchAutoHide.Position.X and mPos.X <= SwitchAutoHide.Position.X + SwitchAutoHide.Size.X and
               mPos.Y >= SwitchAutoHide.Position.Y and mPos.Y <= SwitchAutoHide.Position.Y + SwitchAutoHide.Size.Y then
                MainSwitchAutoHide.IsChecked = not MainSwitchAutoHide.IsChecked
                UpdateSwitchColor(SwitchAutoHide_Bg, MainSwitchAutoHide.IsChecked)
                if MainSwitchAutoHide.IsChecked then
                    SwitchAutoHide_IndBorder.Position = SwitchAutoHide.Position + Vector2.new(11, 1)
                    SwitchAutoHide_Ind.Position = SwitchAutoHide.Position + Vector2.new(11, 1)
                else
                    SwitchAutoHide_IndBorder.Position = SwitchAutoHide.Position + Vector2.new(1, 1)
                    SwitchAutoHide_Ind.Position = SwitchAutoHide.Position + Vector2.new(1, 1)
                end
                AutoHideSystem.enabled = MainSwitchAutoHide.IsChecked
            end

            if VeryBackGUI.Visible and mPos.X >= VeryBackGUI.Position.X and mPos.X <= VeryBackGUI.Position.X + VeryBackGUI.Size.X and
               mPos.Y >= VeryBackGUI.Position.Y and mPos.Y <= VeryBackGUI.Position.Y + VeryBackGUI.Size.Y then
                dragging = true
                dragStart = mPos
                startPos = VeryBackGUI.Position
            end

            if MainWatermark.Visible and mPos.X >= MainWatermark.Position.X and mPos.X <= MainWatermark.Position.X + MainWatermark.Size.X and
               mPos.Y >= MainWatermark.Position.Y and mPos.Y <= MainWatermark.Position.Y + MainWatermark.Size.Y then
                watermarkDragging = true
                watermarkDragStart = mPos
                watermarkStartPos = MainWatermark.Position
            end

            if advancedWindowOpen then
                if _G.adv_esp then
                    local a = _G.adv_esp
                    if a.swESP4 and a.swESP4.Bg and a.swESP4.Bg.Visible and mPos.X >= a.swESP4.Bg.Position.X and mPos.X <= a.swESP4.Bg.Position.X + a.swESP4.Bg.Size.X and
                       mPos.Y >= a.swESP4.Bg.Position.Y and mPos.Y <= a.swESP4.Bg.Position.Y + a.swESP4.Bg.Size.Y then
                        a.swESP4.IsChecked = not a.swESP4.IsChecked
                        UpdateSwitchColor(a.swESP4.Bg, a.swESP4.IsChecked)
                        if a.swESP4.IsChecked then
                            a.swESP4.IndBorder.Position = a.swESP4.Bg.Position + Vector2.new(16, 1)
                            a.swESP4.Ind.Position = a.swESP4.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swESP4.IndBorder.Position = a.swESP4.Bg.Position + Vector2.new(1, 1)
                            a.swESP4.Ind.Position = a.swESP4.Bg.Position + Vector2.new(1, 1)
                        end
                        MainSwitchESP.IsChecked = a.swESP4.IsChecked
                        UpdateSwitchColor(SwitchESP_Bg, MainSwitchESP.IsChecked)
                        if MainSwitchESP.IsChecked then
                            SwitchESP_IndBorder.Position = SwitchESP.Position + Vector2.new(11, 1)
                            SwitchESP_Ind.Position = SwitchESP.Position + Vector2.new(11, 1)
                        else
                            SwitchESP_IndBorder.Position = SwitchESP.Position + Vector2.new(1, 1)
                            SwitchESP_Ind.Position = SwitchESP.Position + Vector2.new(1, 1)
                        end
                        Settings.keycardESPEnabled = a.swESP4.IsChecked
                    end
                    if a.swItems and a.swItems.Bg and a.swItems.Bg.Visible and mPos.X >= a.swItems.Bg.Position.X and mPos.X <= a.swItems.Bg.Position.X + a.swItems.Bg.Size.X and
                       mPos.Y >= a.swItems.Bg.Position.Y and mPos.Y <= a.swItems.Bg.Position.Y + a.swItems.Bg.Size.Y then
                        a.swItems.IsChecked = not a.swItems.IsChecked
                        UpdateSwitchColor(a.swItems.Bg, a.swItems.IsChecked)
                        if a.swItems.IsChecked then
                            a.swItems.IndBorder.Position = a.swItems.Bg.Position + Vector2.new(16, 1)
                            a.swItems.Ind.Position = a.swItems.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swItems.IndBorder.Position = a.swItems.Bg.Position + Vector2.new(1, 1)
                            a.swItems.Ind.Position = a.swItems.Bg.Position + Vector2.new(1, 1)
                        end
                        Settings.itemsESPEnabled = a.swItems.IsChecked
                    end
                    if a.swCurrency and a.swCurrency.Bg and a.swCurrency.Bg.Visible and mPos.X >= a.swCurrency.Bg.Position.X and mPos.X <= a.swCurrency.Bg.Position.X + a.swCurrency.Bg.Size.X and
                       mPos.Y >= a.swCurrency.Bg.Position.Y and mPos.Y <= a.swCurrency.Bg.Position.Y + a.swCurrency.Bg.Size.Y then
                        a.swCurrency.IsChecked = not a.swCurrency.IsChecked
                        UpdateSwitchColor(a.swCurrency.Bg, a.swCurrency.IsChecked)
                        if a.swCurrency.IsChecked then
                            a.swCurrency.IndBorder.Position = a.swCurrency.Bg.Position + Vector2.new(16, 1)
                            a.swCurrency.Ind.Position = a.swCurrency.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swCurrency.IndBorder.Position = a.swCurrency.Bg.Position + Vector2.new(1, 1)
                            a.swCurrency.Ind.Position = a.swCurrency.Bg.Position + Vector2.new(1, 1)
                        end
                        Settings.currencyESPEnabled = a.swCurrency.IsChecked
                    end
                    if a.swRich and a.swRich.Bg and a.swRich.Bg.Visible and mPos.X >= a.swRich.Bg.Position.X and mPos.X <= a.swRich.Bg.Position.X + a.swRich.Bg.Size.X and
                       mPos.Y >= a.swRich.Bg.Position.Y and mPos.Y <= a.swRich.Bg.Position.Y + a.swRich.Bg.Size.Y then
                        a.swRich.IsChecked = not a.swRich.IsChecked
                        UpdateSwitchColor(a.swRich.Bg, a.swRich.IsChecked)
                        if a.swRich.IsChecked then
                            a.swRich.IndBorder.Position = a.swRich.Bg.Position + Vector2.new(16, 1)
                            a.swRich.Ind.Position = a.swRich.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swRich.IndBorder.Position = a.swRich.Bg.Position + Vector2.new(1, 1)
                            a.swRich.Ind.Position = a.swRich.Bg.Position + Vector2.new(1, 1)
                        end
                        Settings.currencyRichEnabled = a.swRich.IsChecked
                    end
                    if a.swDoors and a.swDoors.Bg and a.swDoors.Bg.Visible and mPos.X >= a.swDoors.Bg.Position.X and mPos.X <= a.swDoors.Bg.Position.X + a.swDoors.Bg.Size.X and
                       mPos.Y >= a.swDoors.Bg.Position.Y and mPos.Y <= a.swDoors.Bg.Position.Y + a.swDoors.Bg.Size.Y then
                        a.swDoors.IsChecked = not a.swDoors.IsChecked
                        UpdateSwitchColor(a.swDoors.Bg, a.swDoors.IsChecked)
                        if a.swDoors.IsChecked then
                            a.swDoors.IndBorder.Position = a.swDoors.Bg.Position + Vector2.new(16, 1)
                            a.swDoors.Ind.Position = a.swDoors.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swDoors.IndBorder.Position = a.swDoors.Bg.Position + Vector2.new(1, 1)
                            a.swDoors.Ind.Position = a.swDoors.Bg.Position + Vector2.new(1, 1)
                        end
                        Settings.doorESPEnabled = a.swDoors.IsChecked
                    end
                    if a.dropdownMain and a.dropdownMain.Visible and mPos.X >= a.dropdownMain.Position.X and mPos.X <= a.dropdownMain.Position.X + a.dropdownMain.Size.X and
                       mPos.Y >= a.dropdownMain.Position.Y and mPos.Y <= a.dropdownMain.Position.Y + a.dropdownMain.Size.Y then
                        a.dropdownOpen = not a.dropdownOpen
                        for _, box in ipairs(a.dropdownBoxes) do
                            if box and box.Box then
                                box.Box.Visible = a.dropdownOpen
                                box.Check.Visible = a.dropdownOpen
                                box.Text.Visible = a.dropdownOpen
                            end
                        end
                    end
                    if a.dropdownOpen then
                        for _, box in ipairs(a.dropdownBoxes) do
                            if box and box.Box and box.Box.Visible and mPos.X >= box.Box.Position.X and mPos.X <= box.Box.Position.X + box.Box.Size.X and
                               mPos.Y >= box.Box.Position.Y and mPos.Y <= box.Box.Position.Y + box.Box.Size.Y then
                                box.Data.checked = not box.Data.checked
                                box.Check.Color = box.Data.checked and Color3.fromHex("#04c838") or Color3.fromHex("#3a3a3a")
                                a.UpdateDropdown()
                                break
                            end
                        end
                    end
                    if a.sliderTrack and a.sliderTrack.Visible and mPos.X >= a.sliderTrack.Position.X and mPos.X <= a.sliderTrack.Position.X + a.sliderTrack.Size.X and
                       mPos.Y >= a.sliderTrack.Position.Y-10 and mPos.Y <= a.sliderTrack.Position.Y+10 then
                        sliderDragging = true
                        local relX = mPos.X - a.sliderTrack.Position.X
                        local newVal = 15 + (relX / a.sliderTrack.Size.X) * (500-15)
                        newVal = math.max(15, math.min(500, newVal))
                        Settings.espDistance = newVal
                        a.sliderValText.Text = tostring(math.floor(newVal))
                        a.sliderFill.Size = Vector2.new(a.sliderTrack.Size.X * ((newVal-15)/(500-15)), a.sliderFill.Size.Y)
                        a.sliderKnob.Position = a.sliderTrack.Position + Vector2.new(a.sliderTrack.Size.X * ((newVal-15)/(500-15)), 2)
                    end
                end
                if _G.adv_notif then
                    local a = _G.adv_notif
                    if a.swNotif and a.swNotif.Bg and a.swNotif.Bg.Visible and mPos.X >= a.swNotif.Bg.Position.X and mPos.X <= a.swNotif.Bg.Position.X + a.swNotif.Bg.Size.X and
                       mPos.Y >= a.swNotif.Bg.Position.Y and mPos.Y <= a.swNotif.Bg.Position.Y + a.swNotif.Bg.Size.Y then
                        a.swNotif.IsChecked = not a.swNotif.IsChecked
                        UpdateSwitchColor(a.swNotif.Bg, a.swNotif.IsChecked)
                        if a.swNotif.IsChecked then
                            a.swNotif.IndBorder.Position = a.swNotif.Bg.Position + Vector2.new(16, 1)
                            a.swNotif.Ind.Position = a.swNotif.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swNotif.IndBorder.Position = a.swNotif.Bg.Position + Vector2.new(1, 1)
                            a.swNotif.Ind.Position = a.swNotif.Bg.Position + Vector2.new(1, 1)
                        end
                        MainSwitchNotification.IsChecked = a.swNotif.IsChecked
                        UpdateSwitchColor(SwitchNotification_Bg, MainSwitchNotification.IsChecked)
                        if MainSwitchNotification.IsChecked then
                            SwitchNotification_IndBorder.Position = SwitchNotification.Position + Vector2.new(11, 1)
                            SwitchNotification_Ind.Position = SwitchNotification.Position + Vector2.new(11, 1)
                        else
                            SwitchNotification_IndBorder.Position = SwitchNotification.Position + Vector2.new(1, 1)
                            SwitchNotification_Ind.Position = SwitchNotification.Position + Vector2.new(1, 1)
                        end
                        Settings.notificationsEnabled = {
                            Angler = a.swNotif.IsChecked,
                            Froger = a.swNotif.IsChecked,
                            Pinkie = a.swNotif.IsChecked,
                            Blitz = a.swNotif.IsChecked,
                            Pandemonium = a.swNotif.IsChecked,
                            Chainsmoker = a.swNotif.IsChecked,
                            ["A60"] = a.swNotif.IsChecked,
                            Harbinger = a.swNotif.IsChecked,
                            Painter = a.swNotif.IsChecked
                        }
                    end
                    if a.swWatermark and a.swWatermark.Bg and a.swWatermark.Bg.Visible and mPos.X >= a.swWatermark.Bg.Position.X and mPos.X <= a.swWatermark.Bg.Position.X + a.swWatermark.Bg.Size.X and
                       mPos.Y >= a.swWatermark.Bg.Position.Y and mPos.Y <= a.swWatermark.Bg.Position.Y + a.swWatermark.Bg.Size.Y then
                        a.swWatermark.IsChecked = not a.swWatermark.IsChecked
                        UpdateSwitchColor(a.swWatermark.Bg, a.swWatermark.IsChecked)
                        if a.swWatermark.IsChecked then
                            a.swWatermark.IndBorder.Position = a.swWatermark.Bg.Position + Vector2.new(16, 1)
                            a.swWatermark.Ind.Position = a.swWatermark.Bg.Position + Vector2.new(16, 1)
                        else
                            a.swWatermark.IndBorder.Position = a.swWatermark.Bg.Position + Vector2.new(1, 1)
                            a.swWatermark.Ind.Position = a.swWatermark.Bg.Position + Vector2.new(1, 1)
                        end
                        Settings.watermarkEnabled = a.swWatermark.IsChecked
                        MainWatermark.Visible = a.swWatermark.IsChecked
                        MainWatermark_Border.Visible = a.swWatermark.IsChecked
                        LineWatermark1.Visible = a.swWatermark.IsChecked
                        TextRATHUB34.Visible = a.swWatermark.IsChecked
                        LogoRathub34.Visible = a.swWatermark.IsChecked
                        StatusWatermark.Visible = a.swWatermark.IsChecked
                        CurrentEntity.Visible = a.swWatermark.IsChecked
                    end
                    if a.targetMain and a.targetMain.Visible and mPos.X >= a.targetMain.Position.X and mPos.X <= a.targetMain.Position.X + a.targetMain.Size.X and
                       mPos.Y >= a.targetMain.Position.Y and mPos.Y <= a.targetMain.Position.Y + a.targetMain.Size.Y then
                        a.targetOpen = not a.targetOpen
                        for _, box in ipairs(a.targetBoxes) do
                            if box and box.Box then
                                box.Box.Visible = a.targetOpen
                                box.Check.Visible = a.targetOpen
                                box.Text.Visible = a.targetOpen
                            end
                        end
                    end
                    if a.targetOpen then
                        for _, box in ipairs(a.targetBoxes) do
                            if box and box.Box and box.Box.Visible and mPos.X >= box.Box.Position.X and mPos.X <= box.Box.Position.X + box.Box.Size.X and
                               mPos.Y >= box.Box.Position.Y and mPos.Y <= box.Box.Position.Y + box.Box.Size.Y then
                                box.Data.checked = not box.Data.checked
                                box.Check.Color = box.Data.checked and Color3.fromHex("#04c838") or Color3.fromHex("#3a3a3a")
                                a.UpdateTarget()
                                for _, mob in ipairs(TrackedMobs) do
                                    local simple = mob:gsub("Ridge","")
                                    if simple == box.Data.name then
                                        Settings.notificationsEnabled[simple] = box.Data.checked
                                    end
                                end
                                break
                            end
                        end
                    end
                    if a.wmTargetMain and a.wmTargetMain.Visible and mPos.X >= a.wmTargetMain.Position.X and mPos.X <= a.wmTargetMain.Position.X + a.wmTargetMain.Size.X and
                       mPos.Y >= a.wmTargetMain.Position.Y and mPos.Y <= a.wmTargetMain.Position.Y + a.wmTargetMain.Size.Y then
                        a.wmTargetOpen = not a.wmTargetOpen
                        for _, box in ipairs(a.wmTargetBoxes) do
                            if box and box.Box then
                                box.Box.Visible = a.wmTargetOpen
                                box.Check.Visible = a.wmTargetOpen
                                box.Text.Visible = a.wmTargetOpen
                            end
                        end
                    end
                    if a.wmTargetOpen then
                        for _, box in ipairs(a.wmTargetBoxes) do
                            if box and box.Box and box.Box.Visible and mPos.X >= box.Box.Position.X and mPos.X <= box.Box.Position.X + box.Box.Size.X and
                               mPos.Y >= box.Box.Position.Y and mPos.Y <= box.Box.Position.Y + box.Box.Size.Y then
                                box.Data.checked = not box.Data.checked
                                box.Check.Color = box.Data.checked and Color3.fromHex("#04c838") or Color3.fromHex("#3a3a3a")
                                a.UpdateWMTarget()
                                local simple = box.Data.name
                                if simple == "A60" then simple = "A60" end
                                Settings.watermarkMobsEnabled[simple] = box.Data.checked
                                break
                            end
                        end
                    end
                end
            end
        end

        if mouse2 and not lastMouse2 then
            if VisualsContent1.Visible and mPos.X >= VisualsContent1.Position.X and mPos.X <= VisualsContent1.Position.X + VisualsContent1.Size.X and
               mPos.Y >= VisualsContent1.Position.Y and mPos.Y <= VisualsContent1.Position.Y + VisualsContent1.Size.Y then
                if advancedWindowOpen and _G.adv_notif then
                    CloseAdvancedWindows()
                else
                    CreateAdvancedNotifications()
                end
            end
            if VisualsContent2.Visible and mPos.X >= VisualsContent2.Position.X and mPos.X <= VisualsContent2.Position.X + VisualsContent2.Size.X and
               mPos.Y >= VisualsContent2.Position.Y and mPos.Y <= VisualsContent2.Position.Y + VisualsContent2.Size.Y then
                if advancedWindowOpen and _G.adv_esp then
                    CloseAdvancedWindows()
                else
                    CreateAdvancedESP()
                end
            end
        end

        if not mouse1 and lastMouse1 then
            dragging = false
            watermarkDragging = false
            sliderDragging = false
        end

        if dragging and mouse1 then
            local delta = mPos - dragStart
            VeryBackGUI.Position = startPos + delta
            VeryBackGUI_Border.Position = VeryBackGUI.Position
            Line1.Position = VeryBackGUI.Position + Vector2.new(0, 41.5)
            BackGUItabs.Position = VeryBackGUI.Position + Vector2.new(0, 42)
            Line3.Position = VeryBackGUI.Position + Vector2.new(-2.5, 84)
            Line2.Position = VeryBackGUI.Position + Vector2.new(0, 42)
            TextRATHUB.Position = VeryBackGUI.Position + Vector2.new(48, 13)
            TextLOGO.Position = VeryBackGUI.Position + Vector2.new(20, 13)
            BackContentTabs.Position = VeryBackGUI.Position + Vector2.new(0, 84)
            BackContentTabs_Border.Position = BackContentTabs.Position
            BackGUI2.Position = VeryBackGUI.Position + Vector2.new(0, 488)
            BackGUI2_Border.Position = BackGUI2.Position
            TabVisuals.Position = VeryBackGUI.Position + Vector2.new(11, 51.5)
            TabVisuals_Text.Position = TabVisuals.Position + Vector2.new(86/2, 22/2)
            TabVisuals_Border.Position = TabVisuals.Position
            TabExploits.Position = VeryBackGUI.Position + Vector2.new(105, 51.5)
            TabExploits_Text.Position = TabExploits.Position + Vector2.new(86/2, 22/2)
            TabExploits_Border.Position = TabExploits.Position
            TabMisc.Position = VeryBackGUI.Position + Vector2.new(197, 52)
            TabMisc_Text.Position = TabMisc.Position + Vector2.new(86/2, 22/2)
            TabMisc_Border.Position = TabMisc.Position
            TabInfo.Position = VeryBackGUI.Position + Vector2.new(290, 52)
            TabInfo_Text.Position = TabInfo.Position + Vector2.new(86/2, 22/2)
            TabInfo_Border.Position = TabInfo.Position
            Square16.Position = VeryBackGUI.Position + Vector2.new(567, 41.5)

            VisualsContent1.Position = VeryBackGUI.Position + Vector2.new(20, 97)
            VisualsContent1_Border.Position = VisualsContent1.Position
            NotificationTEXT.Position = VeryBackGUI.Position + Vector2.new(30, 110)
            DescryptionNofitication.Position = VeryBackGUI.Position + Vector2.new(36, 125)
            SwitchNotification.Position = VeryBackGUI.Position + Vector2.new(210, 106)
            SwitchNotification_Bg.Position = SwitchNotification.Position
            SwitchNotification_Label.Position = SwitchNotification.Position + Vector2.new(35, 3.5)
            if MainSwitchNotification.IsChecked then
                SwitchNotification_IndBorder.Position = SwitchNotification.Position + Vector2.new(11, 1)
                SwitchNotification_Ind.Position = SwitchNotification.Position + Vector2.new(11, 1)
            else
                SwitchNotification_IndBorder.Position = SwitchNotification.Position + Vector2.new(1, 1)
                SwitchNotification_Ind.Position = SwitchNotification.Position + Vector2.new(1, 1)
            end

            VisualsContent2.Position = VeryBackGUI.Position + Vector2.new(20, 156)
            VisualsContent2_Border.Position = VisualsContent2.Position
            TextESP.Position = VeryBackGUI.Position + Vector2.new(30, 168)
            ESPdescryption.Position = VeryBackGUI.Position + Vector2.new(36, 184)
            SwitchESP.Position = VeryBackGUI.Position + Vector2.new(210, 162)
            SwitchESP_Bg.Position = SwitchESP.Position
            SwitchESP_Label.Position = SwitchESP.Position + Vector2.new(35, 3.5)
            if MainSwitchESP.IsChecked then
                SwitchESP_IndBorder.Position = SwitchESP.Position + Vector2.new(11, 1)
                SwitchESP_Ind.Position = SwitchESP.Position + Vector2.new(11, 1)
            else
                SwitchESP_IndBorder.Position = SwitchESP.Position + Vector2.new(1, 1)
                SwitchESP_Ind.Position = SwitchESP.Position + Vector2.new(1, 1)
            end

            ContentExploits1.Position = VeryBackGUI.Position + Vector2.new(20, 97)
            ContentExploits1_Border.Position = ContentExploits1.Position
            AutoHideText.Position = VeryBackGUI.Position + Vector2.new(35, 109)
            AutoHideDescryption.Position = VeryBackGUI.Position + Vector2.new(43, 126)
            SwitchAutoHide.Position = VeryBackGUI.Position + Vector2.new(212, 109)
            SwitchAutoHide_Bg.Position = SwitchAutoHide.Position
            SwitchAutoHide_Label.Position = SwitchAutoHide.Position + Vector2.new(35, 3.5)
            if MainSwitchAutoHide.IsChecked then
                SwitchAutoHide_IndBorder.Position = SwitchAutoHide.Position + Vector2.new(11, 1)
                SwitchAutoHide_Ind.Position = SwitchAutoHide.Position + Vector2.new(11, 1)
            else
                SwitchAutoHide_IndBorder.Position = SwitchAutoHide.Position + Vector2.new(1, 1)
                SwitchAutoHide_Ind.Position = SwitchAutoHide.Position + Vector2.new(1, 1)
            end

            InvisibleSquare.Position = VeryBackGUI.Position + Vector2.new(-87, 96)
            HereNoContentText.Position = VeryBackGUI.Position + Vector2.new(30, 116)

            ContentInfo1.Position = VeryBackGUI.Position + Vector2.new(11, 101)
            ContentInfo1_Border.Position = ContentInfo1.Position
            TextInfo1.Position = VeryBackGUI.Position + Vector2.new(20, 139)
            TextInfo2.Position = VeryBackGUI.Position + Vector2.new(28, 112)
            ContentInfo2.Position = VeryBackGUI.Position + Vector2.new(11, 185)
            ContentInfo2_Border.Position = ContentInfo2.Position
            TextInfo3.Position = VeryBackGUI.Position + Vector2.new(26, 199)
            Changelog1.Position = VeryBackGUI.Position + Vector2.new(34, 215)
            Changelog3.Position = VeryBackGUI.Position + Vector2.new(34, 230)
            Changelog2.Position = VeryBackGUI.Position + Vector2.new(34, 245)

            if advancedWindowOpen then
                UpdateAdvancedPositions()
            end
        end

        if watermarkDragging and mouse1 then
            local delta = mPos - watermarkDragStart
            MainWatermark.Position = watermarkStartPos + delta
            MainWatermark_Border.Position = MainWatermark.Position
            LineWatermark1.Position = MainWatermark.Position + Vector2.new(35, 36.5)
            TextRATHUB34.Position = MainWatermark.Position + Vector2.new(62, 12.5)
            LogoRathub34.Position = MainWatermark.Position + Vector2.new(35, 11.5)
            StatusWatermark.Position = MainWatermark.Position + Vector2.new(18, 47.5)
            CurrentEntity.Position = MainWatermark.Position + Vector2.new(68, 47.5)
        end

        if sliderDragging and mouse1 and _G.adv_esp then
            local a = _G.adv_esp
            local relX = mPos.X - a.sliderTrack.Position.X
            relX = math.max(0, math.min(a.sliderTrack.Size.X, relX))
            local newVal = 15 + (relX / a.sliderTrack.Size.X) * (500-15)
            newVal = math.max(15, math.min(500, newVal))
            Settings.espDistance = newVal
            a.sliderValText.Text = tostring(math.floor(newVal))
            a.sliderFill.Size = Vector2.new(a.sliderTrack.Size.X * ((newVal-15)/(500-15)), a.sliderFill.Size.Y)
            a.sliderKnob.Position = a.sliderTrack.Position + Vector2.new(a.sliderTrack.Size.X * ((newVal-15)/(500-15)), 2)
        end

        lastMouse1 = mouse1
        lastMouse2 = mouse2
    end
end
