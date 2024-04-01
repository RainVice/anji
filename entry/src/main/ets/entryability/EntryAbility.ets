import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { DictHelper, LearnRecordHelper } from '../utils';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {


  }

  onDestroy(): void {

  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {

    // 初始化数据库连接
    await DictHelper.init(this.context)
    // 初始化学习记录
    await LearnRecordHelper.init(this.context)
    // 设置状态栏颜色
    windowStage.getMainWindowSync().setWindowSystemBarProperties({
      statusBarColor: "#" + this.context.resourceManager
        .getColorSync($r('app.color.start_window_background')).toString(16)
    })
    // 跳转到主页
    windowStage.loadContent('pages/Index/Index');
  }

  onWindowStageDestroy(): void {

  }

  onForeground(): void {


  }

  onBackground(): void {


  }
}
