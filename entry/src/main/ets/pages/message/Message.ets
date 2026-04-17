//导入公共的类
import Msg from '../../entity/News';
/**
 * 场馆动态组件
 */
@Preview
@Component
export default struct Message {
  @State message: string = '场馆动态'
  //用于动态显示返回按钮
  // @State flag: Visibility = Visibility.Hidden
  //测试数据
  private common: string = 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quasi cupiditate esse nulla, eveniet dicta, quos blanditiis facere laborum id obcaecati consequuntur porro.';
  //声明对象数组
  private msgs: Array<Msg> = [
    new Msg("play5", "优天地的网球馆已重新开放啦，场外扫码自助管理，方便快捷", "因静安网球馆前台系统升级" + this.common, "2024-5-22"),
    new Msg("play2", "公告 | 羽毛球场恢复对外开放通知", "羽毛球馆重新开放" + this.common, "2024-5-20"),
    new Msg("play4", "喜欢乒乓球的伙伴们注意啦，请提前预订，一分钟搞定", "乒乓球" + this.common, "2024-5-20"),
    new Msg("play1", "通知 | 明晚社区将举办足球友谊赛，敬请报名观看", "足球比赛" + this.common, "2024-5-18"),
    new Msg("play3", "生活广场篮球场地暂时关闭，开放时间待通知", "篮球场因为" + this.common, "2024-5-16")
  ]

  ////构建UI页面
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
          //  .visibility(this.flag) //根据路由传参动态设置
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
          .padding({right:36})
      }.width('100%')
      .height('12%')
      .backgroundColor('#27C189')
      //2.动态列表
      List({ space: 10 }) {
        ForEach(this.msgs, (item: Msg) => {
          ListItem() {
            Column() { //嵌套列
              //标题
              Text(item.title).fontSize(20).fontWeight(FontWeight.Bold)
                .margin({ bottom: 10 })
              //图文
              Row() {//'imgs/yuyue/'
                Image($rawfile(`imgs/yuyue/`+item.pic+`.jpg`)).width(100).height(80)
                  .margin({ right: 4 }).borderRadius(8)
                Text(item.info)
                  .height(80)
                  .width(220)
                  .fontSize(18)
                  .fontColor('#555')
                  .textOverflow({ overflow: TextOverflow.Clip })
                  .borderRadius(8)
                  .padding({ right: 10 })
                  .maxLines(4)
                  .align(Alignment.TopStart)
              }
              //发布日期
              Text(item.date).width('100%').fontColor(Color.Grey).margin({ top: 8 })
            }
          }
          .backgroundColor('#fff')
          .borderRadius(10)
          .padding(10).onClick(()=>{//去场馆消息
            //路由对象切换并传参，参数中所有属性的值都必须是字符串，如果不是字符串是一个对象则需要通过JSON.stringify(对象名)
            //将对象转换类为json字符串
            this.getUIContext().getRouter().pushUrl({url:'pages/common/MyDetail',params:{title:'场馆动态',jsonstr:JSON.stringify(item)}})
          })
        })
        ////list-end
      }
      .width('94%')
      .height('100%') //填充剩余的所有
      //不加布局权重,无法滑动
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
  }
}