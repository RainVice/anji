import {
  AxisBase,
  BarChartModel,
  BarData,
  BarDataSet,
  BarEntry,
  IAxisValueFormatter,
  IBarDataSet,
  JArrayList,
  XAxisPosition
} from '@ohos/mpchart'
import { BarChart } from '@ohos/mpchart/src/main/ets/components/chartcomponents/BarChart'
import { LearnRecordHelper } from '../../../utils'

@Component
export struct Statistics {
  @Prop @Watch("updateChart") tabsIndex: number
  model: BarChartModel = new BarChartModel()

  build() {
    Column() {
      BarChart({ model: this.model })
        .width('80%')
        .height('40%')
    }
  }

  async updateChart() {

    if (this.tabsIndex != 2) {
      return
    }

    // 设置 xy 轴样式
    this.model.getXAxis()?.setPosition(XAxisPosition.BOTTOM)
    this.model.getXAxis()?.setDrawGridLines(false)
    this.model.getXAxis()?.setValueFormatter(new XAxisValueFormatter())
    this.model.getAxisRight()?.setEnabled(false)
    this.model.setDrawValueAboveBar(false)
    this.model.getAxisLeft()?.setDrawGridLines(false)
    this.model.getAxisLeft()?.setAxisMinimum(0)
    this.model.getLegend()?.setEnabled(false)
    // 设置描述信息
    this.model.setDescription(null)
    // 设置数据
    const value = await this.getDate()
    const barDataSet = new BarDataSet(value, "")
    // 柱子颜色
    barDataSet.setColorByColor(getContext().resourceManager.getColorSync($r('app.color.easy')))
    barDataSet.setDrawValues(false)
    // 设置数据
    const dataSetList = new JArrayList<IBarDataSet>()
    dataSetList.add(barDataSet)
    const data = new BarData(dataSetList)
    //设置柱状图宽度
    data.setBarWidth(0.5);
    //设置顶部圆角半径
    data.setTopRadius(5);
    this.model.setData(data)
    this.model.animateY(500)
  }

  /**
   * 获取过去七天数据
   * @returns
   */
  async getDate(): Promise<JArrayList<BarEntry>> {
    const now = new Date()
    const value = new JArrayList<BarEntry>()
    for (let i = 0; i < 7; i++) {
      value.add(
        new BarEntry(
          i,
          await LearnRecordHelper.getRecord(
            new Date(now.getTime() - i * 24 * 60 * 60 * 1000)
          )
        )
      )
    }
    return value
  }
}

// 横轴信息
class XAxisValueFormatter implements IAxisValueFormatter {
  private arr: string[] = ["今天", "昨天", "前天", "四天前", "五天前", "六天前", "七天前"]

  getFormattedValue(value: number, _axis: AxisBase): string {
    return this.arr[value]
  }
}
