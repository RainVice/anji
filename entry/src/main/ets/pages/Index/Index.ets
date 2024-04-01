import { FULL_PERCENTAGE } from '../../constants';
import { TabBarInfo, tabBarInfos } from '../../model';
import { Dict } from './Dict/Dict';
import { Review } from './Review/Review';
import { Statistics } from './Statistics/Statistics';

@Entry
@Component
struct Index {

  /**
   * 当前 tab 索引
   */
  @State tabsIndex:number = 0;

  build() {
    // Tab 栏
    Tabs({index: $$this.tabsIndex}) {
      ForEach(tabBarInfos,(item:TabBarInfo,index: number) => {
        TabContent() {
          if (item.id === 0) Review()
          if (item.id === 1) Dict()
          if (item.id === 2) Statistics({tabsIndex: this.tabsIndex})
        }
        .tabBar(this.tabMenu(item))
      })
    }
    .barPosition(BarPosition.End)
    .width(FULL_PERCENTAGE)
    .height(FULL_PERCENTAGE)
    .backgroundColor($r('app.color.background'))
  }

  /**
   * 菜单栏
   * @param tabBarInfo
   */
  @Builder
  tabMenu(tabBarInfo: TabBarInfo) {
    Column(){
      Image(tabBarInfo.image).width(30).height(30)
      if (this.tabsIndex === tabBarInfo.id){
        Text(tabBarInfo.title).width(FULL_PERCENTAGE).textAlign(TextAlign.Center)
      }
    }
  }
}