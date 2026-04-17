import Player from '../../entity/Player';
import PlayerDao from '../../utils/PlayerDao';
import { promptAction } from '@kit.ArkUI';

/**
 * 用户所有预约信息
 */
@Entry
@Component
struct Reports {
  @State message: string = '所有预约'
  ////保存用户所有预约信息
  @State curPlayers: Player[] | null = null;
  //创建动态路径栈对象
  @State navPath: NavPathStack = new NavPathStack();

  //查询当前用户所有预约信息
  aboutToAppear() {
    //获取登录用户的手机号
    let mobile = AppStorage.get<string>('mobile') as string;
    if (mobile != undefined) {
      //查询用户所有的预约信息
      PlayerDao.queryAll(mobile).then((data) => {
        this.curPlayers = data;
      })
    }
  }

  ////生成UI页面
  build() {
    NavDestination() {
      Column() {
        ////1.顶部导航,所有预约
        Row() {
          Text('<')
            .width('10%')
            .height('100%')
            .textAlign(TextAlign.Center)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .onClick(() => { //返回关于
              this.navPath.clear()
            })
          Text(this.message)
            .width('70%')
            .height('100%')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
          Text('去预约').fontSize(20).fontColor(Color.White).fontWeight(FontWeight.Bold)
            .onClick(() => { //去预约首页
              AppStorage.setOrCreate<string>('res', 'ok');
              this.navPath.pushPath({ name: "restime" })
            })
        }.width('100%')
        .height('12%')
        .backgroundColor('#27C189')

        ////2.显示所有预约内容
        if (this.curPlayers != null && this.curPlayers.length > 0) {
          //预约场馆
          Row() {
            Text('场馆名称').width('35%').fontSize(20).height(50).textAlign(TextAlign.Center);
            Text('预约日期').width('35%').fontSize(20).height(50).textAlign(TextAlign.Center);
            Text('当前状态').width('30%').fontSize(20).height(50).textAlign(TextAlign.Center);
          }

          //列表
          List() {
            ForEach(this.curPlayers, (item: Player) => {
              ListItem() {
                Column() {
                  Row() { //取消预约，待完善
                    Text(item.venue)//场馆
                      .width('35%')
                      .height(50)
                      .fontSize(18)
                      .padding({ left: 10 })
                      .fontColor(Color.Grey)
                    Text(item.pdate)//日期
                      .width('35%')
                      .height(50)
                      .fontSize(18)
                      .padding({ left: 10 })
                      .fontColor(Color.Grey)
                    Text(item.state)//状态
                      .width('30%')
                      .height(50)
                      .fontSize(18)
                      .padding({ left: 10 })
                      .fontColor(Color.Grey)
                      .textAlign(TextAlign.Center)
                  }
                  //水平线
                  Divider().color(Color.Pink).height(1);
                }
              }.width('100%').height(80)

              //for,list要设置高宽,直接求数组的长度再计算列表所有元素的高度传入即可
            }) //如果设置了返回函数(item)=>item列表只有一个元素,请注意,加上分隔线的高度
          }.width('100%').height(this.curPlayers.length * 81).listDirection(Axis.Vertical).alignSelf(ItemAlign.Center);

          //暂未实现，下一版完善优化
          Button('分发到其它设备')
            .width(300)
            .height(40)
            .margin({ top: 10, bottom: 10 })
            .alignSelf(ItemAlign.Center)
            .backgroundColor('#27C189')
            .fontSize(18)
            .onClick(() => {
              promptAction.openToast({ message: '完善优化中，敬请期待...' })
            });
          //形象图片
          Image('imgs/yuyue/reserv.png').height(180).alignSelf(ItemAlign.Center)
        } else {
          Text('您还没有预约')
            .fontSize(24)
            .height(100)
            .padding({ left: 36 })
            .backgroundImage('imgs/yuyue/timer.png')
            .backgroundImageSize({ width: 30 })
            .backgroundImagePosition(Alignment.Start)
            .margin({ left: 10 })
          Button('去预约')
            .width(300)
            .height(40)
            .alignSelf(ItemAlign.Center)
            .backgroundColor('#27C189')
            .fontSize(18)
            .onClick(() => {
              AppStorage.setOrCreate<string>('res', 'ok');
              this.navPath.pushPath({ name: "restime" })
            })
        }

      } //column-end
      .alignItems(HorizontalAlign.Start)
      .width('100%')
    }.onReady((context: NavDestinationContext) => {
      this.navPath = context.pathStack;
    })
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}