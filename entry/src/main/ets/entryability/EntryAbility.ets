import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { DictHelper } from '../utils/DictHelper';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {


  }

  onDestroy(): void {

  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    await DictHelper.init(this.context)
    windowStage.getMainWindowSync().setWindowSystemBarProperties({
      statusBarColor: "#" + this.context.resourceManager
        .getColorSync($r('app.color.start_window_background')).toString(16)
    })
    windowStage.loadContent('pages/Index/Index');
  }

  onWindowStageDestroy(): void {

  }

  onForeground(): void {


  }

  onBackground(): void {


  }
}
