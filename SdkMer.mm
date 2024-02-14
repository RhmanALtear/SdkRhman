//
//  MenuWindow.m
//  Dolphins
//
//  Created by XBK on 2022/4/25.
//

#import "View/MenuWindow.h"
#import "View/OverlayView.h"
#import "mahoa.h"





@implementation MenuWindow

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
BOOL k1 = NO;
INI* config;

static float val{};
extern bool  lineaimplayer;


const char *optionItemName[] = {"Notice", "Player Draw", "Items Draw", "Aimng"};
int optionItemCurrent = 0;
// Văn bản phần tự nhắm
int aimbotIntensity;
const char *aimbotIntensityText[] = {"micro","Low", "middle", "high", "super high", "strong lock", "lock up"};
// Văn bản phần tự nhắm
const char *aimbotModeText[] = {"Scope start", "fire start", "scope fire start", "Automatic mode start", "touch position start"};
// Văn bản phần tự nhắm
const char *aimbotPartsText[] = {"Priority head (missed)", "Prioritize the body (missed)", "Automatic mode (missed)", "fixed head", "fixed body"};

OverlayView *overlayView;


- (instancetype)initWithFrame:(ModuleControl*)control {
    self.moduleControl = control;
    //获取Documents目录路径
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //初始化文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //拼接文件路径
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"dolphins.ini"];
    //文件不存在
    if(![fileManager fileExistsAtPath:filePath]){
        //创建文件
        [fileManager createFileAtPath:filePath contents:[NSData data] attributes:nil];
    }
    //获取ini文件数据
    config = ini_load((char*)filePath.UTF8String);
    
    return [super init];
}

-(void)setOverlayView:(OverlayView*)ov{
    overlayView = ov;
    //读配置项
    [self readIniConfig];
}






-(void)drawMenuWindow {
    //设置下一个窗口的大小
    ImGuiIO & io = ImGui::GetIO();
    ImGui::SetNextWindowSize({1300, 600}, ImGuiCond_FirstUseEver);
//    ImGui::SetNextWindowPos({172, 172}, ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowPos(ImVec2(io.DisplaySize.x * 0.5f, io.DisplaySize.y * 0.5f), 0, ImVec2(0.5f, 0.5f));
     if (ImGui::Begin("GENERAL CRACKER .GL.3.0 DEV.Rhman ",&self.moduleControl->menuStatus, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize)) {
        ImGuiContext& g = *GImGui;
        if(g.NavWindow == NULL){
            self.moduleControl->menuStatus = !self.moduleControl->menuStatus;
        }

          ImGui::BeginChild("##cop", {calcTextSize("option layout") + 32.0f, 0}, false, ImGuiWindowFlags_None);
        for (int i = 0; i < 4; ++i) {
            if (optionItemCurrent != i) {
                 ImGui::PushStyleColor(ImGuiCol_Button, ImColor(0, 0, 0, 0).Value);
                ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImColor(0, 0, 0, 0).Value);
                ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImColor(0, 0, 0, 0).Value);
            }
            bool isClick = ImGui::Button(optionItemName[i]);
            if (optionItemCurrent != i) {
                ImGui::PopStyleColor(3);
            }
            if (isClick) {
                optionItemCurrent = i;
            }
        }
        ImGui::EndChild();

        ImGui::SameLine();
        ImGui::BeginChild("##cop", {0, 0}, false, ImGuiWindowFlags_None);
        switch (optionItemCurrent) {
            case 0:
                [self showSystemInfo];
                break;
            case 1:
                [self showPlayerControl];
                break;
            case 2:
                [self showMaterialControl];
                break;
            case 3:
                [self showAimbotControl];
                break;
        }
        ImGui::EndChild();
        
        
        ImGui::End();
    }
}



-(void)showSystemInfo {




             


    ImGui::BulletColorText(ImColor(57, 100, 177, 155).Value, "Draw FPS");
    if (ImGui::RadioButton("60FPS", &self.moduleControl->fps, 0)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 60;
    }
    ImGui::SameLine();
    if (ImGui::RadioButton("90FPS", &self.moduleControl->fps, 1)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 90;
    }
    ImGui::SameLine();
    if (ImGui::RadioButton("120FPS", &self.moduleControl->fps, 2)) {
        configManager::putInteger(config,"mainSwitch", "fps",self.moduleControl->fps);
        overlayView.preferredFramesPerSecond = 120;
    }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "control switch");
    
    if (ImGui::Checkbox("PLAYER ESP", &self.moduleControl->mainSwitch.playerStatus)) {
        configManager::putBoolean(config,"mainSwitch", "player", self.moduleControl->mainSwitch.playerStatus);
           }
    ImGui::SameLine();
    if (ImGui::Checkbox("ITEMS ESP", &self.moduleControl->mainSwitch.materialStatus)) {
        configManager::putBoolean(config,"mainSwitch", "material", self.moduleControl->mainSwitch.materialStatus);
        }

    ImGui::SameLine();
    if (ImGui::Checkbox("Aimbot", &self.moduleControl->mainSwitch.aimbotStatus)) {
        configManager::putBoolean(config,"mainSwitch", "aimbot", self.moduleControl->mainSwitch.aimbotStatus);

}





    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Notice");
    
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));
    ImGui::TextWrapped("%s", "VERSION 0.0.1 , BECAUSE THIS IS A BETA VERSION , SO DO NOT BUY !");
    ImGui::PopStyleVar();
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Mesenger ");
    

    ImGui::Text("Rhma_n ");


    ImGui::Text("SILVER IOS .3.0.");
    




ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Contact");



    ImGui::Text("Telegram : https://t.me/iph0ne2");
}

-(void) showPlayerControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "ESP PLAYER");
    if (ImGui::Checkbox("WEAPON LABEL PLAYER", &self.moduleControl->playerSwitch.SCStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_6", self.moduleControl->playerSwitch.SCStatus);
    }
    ImGui::SameLine();

    if (ImGui::Checkbox("METERIAL LABEL", &self.moduleControl->playerSwitch.WZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_8", self.moduleControl->playerSwitch.WZStatus);
    }

    if (ImGui::Checkbox("WARNING ALERT", &self.moduleControl->playerSwitch.WZWZStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_9", self.moduleControl->playerSwitch.WZWZStatus);
}

    if (ImGui::Checkbox(" BOX", &self.moduleControl->playerSwitch.boxStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_0", self.moduleControl->playerSwitch.boxStatus);




   
 }
    ImGui::SameLine();
    if (ImGui::Checkbox(" BONE", &self.moduleControl->playerSwitch.boneStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_1", self.moduleControl->playerSwitch.boneStatus);


    }
        ImGui::SameLine();
    if (ImGui::Checkbox("PLAYER LINE", &self.moduleControl->playerSwitch.lineStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_2", self.moduleControl->playerSwitch.lineStatus);
    }

    if (ImGui::Checkbox("PLAYER INFO", &self.moduleControl->playerSwitch.infoStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_3", self.moduleControl->playerSwitch.infoStatus);
    }
        ImGui::SameLine();
    if (ImGui::Checkbox("RADAR ", &self.moduleControl->playerSwitch.radarStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_4", self.moduleControl->playerSwitch.radarStatus);
    }
        ImGui::SameLine();
    if (ImGui::Checkbox("ALERT 360", &self.moduleControl->playerSwitch.backStatus)) {
        configManager::putBoolean(config,"playerSwitch", "playerSwitch_5", self.moduleControl->playerSwitch.backStatus);
    }
    
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "radar adjustment");
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("RadarX") - 32.0f);
    if (ImGui::SliderFloat("RadarX##radarX", &self.moduleControl->playerSwitch.radarCoord.x, 0.0f, ([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].nativeScale), "%.0f")) {
        configManager::putFloat(config,"playerSwitch", "radarX", self.moduleControl->playerSwitch.radarCoord.x);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("RadarY") - 32.0f);
    if (ImGui::SliderFloat("RadarY##radarY", &self.moduleControl->playerSwitch.radarCoord.y, 0.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale), "%.0f")) {
        configManager::putFloat(config,"playerSwitch", "radarY", self.moduleControl->playerSwitch.radarCoord.y);
    }
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("RadarSize") - 32.0f);
    if (ImGui::SliderFloat("RadarSize##radarSize", &self.moduleControl->playerSwitch.radarSize, 1.0f, 100, "%.0f%%")) {
        configManager::putFloat(config,"playerSwitch", "radarSize", self.moduleControl->playerSwitch.radarSize);
    }
}

-(void) showMaterialControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "item drawing");
    
    if (ImGui::Checkbox("Display Vehicle", &self.moduleControl->materialSwitch[Vehicle])) {
        std::string str = "materialSwitch_" + std::to_string(Vehicle);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Vehicle]);
    }

    if (ImGui::Checkbox("LootBox", &self.moduleControl->materialSwitch[Airdrop])) {
        std::string str = "materialSwitch_" + std::to_string(Airdrop);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Airdrop]);
    }

    if (ImGui::Checkbox("Display FlareGun", &self.moduleControl->materialSwitch[FlareGun])) {
        std::string str = "materialSwitch_" + std::to_string(FlareGun);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[FlareGun]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Show Sniper", &self.moduleControl->materialSwitch[Sniper])) {
        std::string str = "materialSwitch_" + std::to_string(Sniper);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Sniper]);
    }
    
    if (ImGui::Checkbox("Show Rifle", &self.moduleControl->materialSwitch[Rifle])) {
        std::string str = "materialSwitch_" + std::to_string(Rifle);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Rifle]);
    }

    if (ImGui::Checkbox("Show Throw", &self.moduleControl->materialSwitch[Missile])) {
        std::string str = "materialSwitch_" + std::to_string(Missile);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Missile]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Backpack And Armor", &self.moduleControl->materialSwitch[Armor])) {
        std::string str = "materialSwitch_" + std::to_string(Armor);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Armor]);
    }

    if (ImGui::Checkbox("Sniper Accessories", &self.moduleControl->materialSwitch[SniperParts])) {
        std::string str = "materialSwitch_" + std::to_string(SniperParts);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[SniperParts]);
    }
    
    if (ImGui::Checkbox("Rifle accessories", &self.moduleControl->materialSwitch[RifleParts])) {
        std::string str = "materialSwitch_" + std::to_string(RifleParts);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[RifleParts]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Display Drug", &self.moduleControl->materialSwitch[Drug])) {
        std::string str = "materialSwitch_" + std::to_string(Drug);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Drug]);
    }

    if (ImGui::Checkbox("Display Bullet", &self.moduleControl->materialSwitch[Bullet])) {
        std::string str = "materialSwitch_" + std::to_string(Bullet);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Bullet]);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Show Grip", &self.moduleControl->materialSwitch[Grip])) {
        std::string str = "materialSwitch_" + std::to_string(Grip);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Grip]);
    }
        ImGui::SameLine();
    if (ImGui::Checkbox("Display Sight", &self.moduleControl->materialSwitch[Sight])) {
        std::string str = "materialSwitch_" + std::to_string(Sight);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Sight]);
    }

    if (ImGui::Checkbox("Grenade Warning", &self.moduleControl->materialSwitch[Warning])) {
        std::string str = "materialSwitch_" + std::to_string(Warning);
        configManager::putBoolean(config,"materialSwitch", str.c_str(), self.moduleControl->materialSwitch[Warning]);
    }
}

-(void) showAimbotControl {
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "auto aim");
    
    ImGui::SetNextItemWidth(calcTextSize("Self-aiming strength placeholder"));
    if (ImGui::Combo("Self-aiming strength", &aimbotIntensity, aimbotIntensityText, IM_ARRAYSIZE(aimbotIntensityText))) {
        configManager::putInteger(config,"aimbotControl", "intensity",aimbotIntensity);
        switch (aimbotIntensity) {
            case 0:
                self.moduleControl->aimbotController.aimbotIntensity = 0.1f;
                break;
            case 1:
                self.moduleControl->aimbotController.aimbotIntensity = 0.2f;
                break;
            case 2:
                self.moduleControl->aimbotController.aimbotIntensity = 0.3f;
                break;
            case 3:
                self.moduleControl->aimbotController.aimbotIntensity = 0.4f;
                break;
            case 4:
                self.moduleControl->aimbotController.aimbotIntensity = 0.5f;
                break;
            case 5:
                self.moduleControl->aimbotController.aimbotIntensity = 1.0f;
                break;
            case 6:
                self.moduleControl->aimbotController.aimbotIntensity = 1.2f;
                break;
        }
    }

    if (ImGui::Checkbox("Aiming range", &self.moduleControl->aimbotController.showAimbotRadius)) {
        configManager::putBoolean(config,"aimbotControl", "showRadius", self.moduleControl->aimbotController.showAimbotRadius);
    }
    ImGui::SameLine();
    if (ImGui::Checkbox("Falling down without aiming", &self.moduleControl->aimbotController.fallNotAim)) {
        configManager::putBoolean(config,"aimbotControl", "fall", self.moduleControl->aimbotController.fallNotAim);
    }

    if (ImGui::Checkbox("Smoke does not aim", &self.moduleControl->aimbotController.smoke)) {
        configManager::putBoolean(config,"aimbotControl", "smoke", self.moduleControl->aimbotController.smoke);
    }
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() / 2 - calcTextSize("Self-aiming mode") - 32.0f);
    if (ImGui::Combo("Self-aiming mode", &self.moduleControl->aimbotController.aimbotMode, aimbotModeText, IM_ARRAYSIZE(aimbotModeText))) {
        configManager::putInteger(config,"aimbotControl", "mode", self.moduleControl->aimbotController.aimbotMode);
    }
    ImGui::SameLine();
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() / 2 - calcTextSize("Self-aiming part") - 32.0f);
    if (ImGui::Combo("Self-aiming part", &self.moduleControl->aimbotController.aimbotParts, aimbotPartsText, IM_ARRAYSIZE(aimbotPartsText))) {
        configManager::putBoolean(config,"aimbotControl", "parts", self.moduleControl->aimbotController.aimbotParts);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("Aiming range") - 32.0f);
    if (ImGui::SliderFloat("Aiming range", &self.moduleControl->aimbotController.aimbotRadius, 0.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale) / 2, "%.0f")) {
        configManager::putFloat(config,"aimbotControl", "radius", self.moduleControl->aimbotController.aimbotRadius);
    }
    
    ImGui::SetNextItemWidth(ImGui::GetWindowContentRegionWidth() - calcTextSize("Self-aiming distance") - 32.0f);
    if (ImGui::SliderFloat("Self-aiming distance", &self.moduleControl->aimbotController.distance, 0.0f, 450.0f, "%.0fM")) {
        configManager::putFloat(config,"aimbotControl", "distance", self.moduleControl->aimbotController.distance);
    }
    ImGui::BulletColorText(ImColor(97, 167, 217, 255).Value, "Self-aiming instructions");
    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(32.0f, 32.0f));
    ImGui::TextWrapped( "Automatic mode start: single-shot gun is self-aiming when opening the scope, and continuous-fire gun is self-aiming when firing\nAutomatic mode position: single-shot gun starts at the head, and continuous-shot gun hits the chest");
    ImGui::PopStyleVar();
}

-(void)readIniConfig{
    self.moduleControl->fps = configManager::readInteger(config,"mainSwitch", "fps", 0);
    switch(self.moduleControl->fps){
        case 0:
            overlayView.preferredFramesPerSecond = 60;
            break;
        case 1:
            overlayView.preferredFramesPerSecond = 90;
            break;
        case 2:
            overlayView.preferredFramesPerSecond = 120;
            break;
        default:
            overlayView.preferredFramesPerSecond = 120;
            break;
    }
    //主开关
    self.moduleControl->mainSwitch.playerStatus = configManager::readBoolean(config,"mainSwitch", "player", false);
    self.moduleControl->mainSwitch.materialStatus = configManager::readBoolean(config,"mainSwitch", "material", false);
    self.moduleControl->mainSwitch.aimbotStatus = configManager::readBoolean(config,"mainSwitch", "aimbot", false);
    //人物开关
    for (int i = 0; i < 10; ++i) {
        std::string str = "playerSwitch_" + std::to_string(i);
        *((bool *) &self.moduleControl->playerSwitch + sizeof(bool) * i) = configManager::readBoolean(config,"playerSwitch", str.c_str(), false);
    }
    //雷达坐标
    self.moduleControl->playerSwitch.radarSize = configManager::readFloat(config,"playerSwitch", "radarSize", 70);
    self.moduleControl->playerSwitch.radarCoord.x = configManager::readFloat(config,"playerSwitch", "radarX", 500);
    self.moduleControl->playerSwitch.radarCoord.y = configManager::readFloat(config,"playerSwitch", "radarY", 500);
    //物资开关
    for (int i = 0; i < All; ++i) {
        std::string str = "materialSwitch_" + std::to_string(i);
        self.moduleControl->materialSwitch[i] = configManager::readBoolean(config,"materialSwitch", str.c_str(), false);
    }
    //倒地不瞄
    self.moduleControl->aimbotController.fallNotAim = configManager::readBoolean(config,"aimbotControl", "fall", false);
    self.moduleControl->aimbotController.showAimbotRadius = configManager::readBoolean(config,"aimbotControl", "showRadius", true);
    self.moduleControl->aimbotController.aimbotRadius = configManager::readFloat(config,"aimbotControl", "radius", 320);
    
    self.moduleControl->aimbotController.smoke = configManager::readBoolean(config,"aimbotControl", "smoke", true);
    
    //自瞄模式
    self.moduleControl->aimbotController.aimbotMode = configManager::readInteger(config,"aimbotControl", "mode", 3);
    //自瞄部位
    self.moduleControl->aimbotController.aimbotParts = configManager::readInteger(config,"aimbotControl", "parts", 2);
    //自瞄强度
    aimbotIntensity = configManager::readInteger(config,"aimbotControl", "intensity", 2);
    switch (aimbotIntensity) {
        case 0:
            self.moduleControl->aimbotController.aimbotIntensity = 0.1f;
            break;
        case 1:
            self.moduleControl->aimbotController.aimbotIntensity = 0.2f;
            break;
        case 2:
            self.moduleControl->aimbotController.aimbotIntensity = 0.3f;
            break;
        case 3:
            self.moduleControl->aimbotController.aimbotIntensity = 0.4f;
            break;
        case 4:
            self.moduleControl->aimbotController.aimbotIntensity = 0.5f;
            break;
        case 5:
            self.moduleControl->aimbotController.aimbotIntensity = 1.0f;
            break;
        case 6:
            self.moduleControl->aimbotController.aimbotIntensity = 1.2f;
            break;
    }
    //自瞄距离
    self.moduleControl->aimbotController.distance = configManager::readFloat(config,"aimbotControl", "distance", 450);
}

@end
