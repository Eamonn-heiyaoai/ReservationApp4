//导入公共的类
import Knowlanguage from '../../entity/News';
//过时的路由对象，请修改改为最新路由方式
//import {router} from '@kit.ArkUI';
/**
 * 运动常识组件
 */
@Component
@Preview
export default struct Know {
  @State message: string = '运动常识'
  //动态显示返回按钮
  @State flag: Visibility = Visibility.Hidden
  ////声明对象数组,测试数据
  private knows: Array<Knowlanguage> = [
    new Knowlanguage("ad5", "慢跑亦称为缓步，缓跑或缓步跑，是一种中等强度的有氧运动", "慢跑对于保持中老年人良好的心脏功能，防止肺组织弹性衰退，预防肌肉萎缩，防治冠心病、高血压、动脉硬化等，具有积极的作用。同时也必须关注慢跑鞋等一些细节。可加速脂肪消耗达到快速的减肥目的。也可以增强自身体质，提高抵抗力。", '2024-5-23'),
    new Knowlanguage("ad2", "滑雪属于高危运动，这些安全常识你知道吗", "滑雪如何做到尽兴又安全？首先，除了掌握熟练的滑雪技巧和灵活的应变能力，作好自身安全防护装备和快速准确的自我急救知识也是重要保障。", '2024-5-22'),
    new Knowlanguage("ad3", "享受自行车骑行的同时，也要注意这些事情", "在骑行自行车时，应该保持良好的心态。不要过于紧张或者冒险，要放松心情，享受骑行的乐趣。", '2024-5-20'),
    new Knowlanguage("ad4", "去健身房锻炼时关注这些问题，做到文明健身!", "在健身房锻炼的时候，我们除了要文明健身外，还需要知道科学的健身流程，避免盲目瞎练。", '2024-5-20'),
    new Knowlanguage("ad1", "跑步做好这几项是非常有益的", "有些跑者换上装备就直接开跑，没有做充分的热身运动，这样抽筋，跟腱酸痛等毛病会很容易找上门。开始运动时，可以做循序渐进的方式，原地踏步，随后进行跨步，最后在活动一下各关节，这样就能降低跑步受伤的概率。", '2024-5-18'),
  ]

  ////构建UI
  build() {
    Column() {
      //1.顶部
      Row() {
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => { //返回
            this.getUIContext().getRouter().back();
          })
        Text(this.message)
          .width('90%')
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
          .padding({ right: 36 })
      }.width('100%')
      .height('12%')
      .backgroundColor('#27C189')
      //2.动态列表
      List({ space: 10 }) {
        ForEach(this.knows, (item: Knowlanguage) => {
          ListItem() {
            Column() { //嵌套列
              //标题
              Text(item.title).fontSize(20).fontWeight(FontWeight.Bold)
                .margin({ bottom: 10 })
              //图文
              Row() {
                Text(item.info)
                  .height(82)
                  .width('68%')
                  .fontColor('#555')
                  .fontSize(18)
                  .borderRadius(8)
                  .align(Alignment.TopStart)
                  .padding({ right: 4 })
                  .maxLines(4)
                  .textOverflow({ overflow: TextOverflow.Clip })
                //'imgs/types/'
                Image($rawfile(`imgs/types/`+ item.pic + `.jpg`)).width(100).height(80)
                  .borderRadius(8)
              }

              Text(item.date).width('100%').fontColor(Color.Grey).margin({ top: 8 })
            }
          }
          .backgroundColor('#fff')
          .borderRadius(10)
          .padding(10)
          .onClick(() => { //去显示运动详情
            //router路由对象已过时，请使用最新API去实现
          this.getUIContext().getRouter().pushUrl({ url: 'pages/common/MyDetail', params: { title: '运动常识', jsonstr: JSON.stringify(item) } })
          })
        })
        ////list-end
      }
      .width('94%')
      //不加布局权重,无法滑动
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .height('100%') //填充剩余的所有
      .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
  }
}