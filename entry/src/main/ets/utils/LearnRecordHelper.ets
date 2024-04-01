import { Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';
import data from '@ohos.telephony.data';


const learnRecordName = "LearnRecord"

export class LearnRecordHelper {

  private static pre: preferences.Preferences


  static async init(context:Context){
    LearnRecordHelper.pre = await preferences.getPreferences(context,learnRecordName)
  }


  /**
   * 添加记录
   * @param date
   */
  static async addRecord(date: Date = new Date()){
    const num = await LearnRecordHelper.getRecord(date)
    await LearnRecordHelper.pre.put(date.toLocaleDateString(),num + 1)
    await LearnRecordHelper.pre.flush()
  }
  /**
   * 删除记录
   * @param date
   */
  static async deleteRecord(date: Date = new Date()){
    const num = await LearnRecordHelper.getRecord(date)
    await LearnRecordHelper.pre.put(date.toLocaleDateString(),num - 1)
    await LearnRecordHelper.pre.flush()
  }
  /**
   * 获取记录
   * @param date
   * @returns
   */
  static async getRecord(date: Date = new Date()): Promise<number>{
    return (await LearnRecordHelper.pre.get(date.toLocaleDateString(),0)) as number
  }

}



