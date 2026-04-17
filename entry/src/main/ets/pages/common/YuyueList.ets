import Type from '../../entity/Type'
/**
 * 预约场馆列表页
 */
@Entry
@Component
struct YuyueList {
  @State message: string = '足球场预约';
  //数组元素索引号从0开始
  @State messages: Array<string> =
    ['足球场预约', '羽笔球场预约', '篮球场预约', '乒乓球场预约', '网球场预约', '游泳馆预约', '健身房预约'];
  //通用信息
  private info: string =
    'Lorem ipsum dolor sit am etconsectetur adip isicing elit. Quasi cupi ditate esse nulla, eveniet dicta, quos blanditiis facere laborum id obcaecati';
  ////7个场馆类型初测试数据////
  //1.足球
  private footballs: Array<Type> = [
    new Type('type1-1', '室内专用足球场预约', this.info, '30天可预约'),
    new Type('type1-2', '足球场预约', this.info, '24天可预约'),
    new Type('type1-3', '五人制足球场预约', this.info, '28天可预约'),
    new Type('type1-4', '七人制足球场预约', this.info, '30天可预约'),
    new Type('type1-5', '八人制足球场预约', this.info, '32天可预约'),
  ]
  //2.羽毛球
  private badmintons: Array<Type> = [
    new Type('type2-1', '羽毛球竞赛场预约', this.info, '32天可预约'),
    new Type('type2-2', '羽毛球陪练预约', this.info, '30天可预约'),
    new Type('type2-3', '羽毛球高等级场预约', this.info, '28天可预约'),
    new Type('type2-4', '羽毛球教练预约', this.info, '26天可预约'),
    new Type('type2-5', '羽毛球场预约', this.info, '28天可预约'),
  ]
  //3.篮球
  private basketballs: Array<Type> = [
    new Type('type3-1', '室外篮球场预约', this.info, '28天可预约'),
    new Type('type3-2', '篮球场预约', this.info, '32天可预约'),
    new Type('type3-3', '篮球竞赛场预约', this.info, '28天可预约'),
    new Type('type3-4', '室内篮球场预约', this.info, '26天可预约'),
  ]
  //4.乒乓球
  private tabletennis: Array<Type> = [
    new Type('type4-1', '乒乓球竞赛场预约', this.info, '35天可预约'),
    new Type('type4-2', '室内专用乒乓球场预约', this.info, '30天可预约'),
    new Type('type4-3', '乒乓球场预约', this.info, '28天可预约'),
    new Type('type4-4', '乒乓球陪练预约', this.info, '26天可预约')
  ]
  //5.网球
  private tennis: Array<Type> = [
    new Type('type5-1', '室内专用网球场预约', this.info, '26天可预约'),
    new Type('type5-2', '网球场预约', this.info, '30天可预约'),
    new Type('type5-3', '网球竞赛场预约', this.info, '26天可预约'),
    new Type('type5-4', '网球陪练预约', this.info, '28天可预约')
  ]
  //6.游泳馆
  private swimmings: Array<Type> = [
    new Type('type6-1', '室外游泳馆预约', this.info, '25天可预约'),
    new Type('type6-2', '游泳教练预约', this.info, '18天可预约'),
    new Type('type6-3', '会员专享训练预约', this.info, '28天可预约'),
    new Type('type6-4', '室内专用游泳馆预约', this.info, '25天可预约'),
    new Type('type6-5', '游泳馆预约', this.info, '30天可预约')
  ]
  //7.健身房
  private gyms: Array<Type> = [
    new Type('type7-1', '健身房预约', this.info, '26天可预约'),
    new Type('type7-2', '健身房团课预约', this.info, '22天可预约'),
    new Type('type7-3', '健身私教预约', this.info, '30天可预约'),
    new Type('type7-4', '会员专享训练预约', this.info, '20天可预约')
  ]
  ////数组中再存入数组
  private types: Array<Array<Type>> = [this.footballs, this.badmintons, this.basketballs, this.tabletennis,
    this.tennis, this.swimmings, this.gyms]
  ////声明渲染时的数组
  @State mytypes: Array<Type> = [];

  ////页面打开前执行
  aboutToAppear() {
    let temp = this.getUIContext().getRouter().getParams() as number[];
    //此处一定要做判断
    if (temp != null) {
      //获取对应预约场馆的索引号,在Home.ets中已做了优化
      let index = temp['myIndex'] as number;
      //获取对应的预约场馆
      this.message = this.messages[index];
      //获取场馆对应的预约类型：比如室外、室内等
      this.mytypes = this.types[index];
    }
  }

  ////构建UI////
  build() {
    Column() {
      ////1.顶部导航
      Row() {
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => { //返回
            this.getUIContext().getRouter().back()
          });
        Text(this.message)
          .width('58%')
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
        Text('去登录')
          .fontSize(20)
          .width('32%')
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
          .height('100%')
          .padding({ right: 10 })
          .onClick(() => {
           this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Login' })
          })
      }.width('100%')
      .height('12%')
      .backgroundColor('#27C189')

      ////2.每个场馆预约类型列表
      List({ space: 30 }) { //行间距
        ForEach(this.mytypes, (item: Type) => {
          //只能有一个子组件
          ListItem() {
            Row() {
              //左边图片
              Image($rawfile(`imgs/types/` + item.pic + `.jpg`)).width(100).height(120)
                .borderRadius(8).margin({ right: 8 })
              Column() {
                //右边标题
                Text(item.title)
                  .width('94%')
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .maxLines(1)//保证只有一行后设为省略号
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                //右边内容
                Text(item.info)
                  .fontSize(18)
                  .fontColor('#555')
                  .textAlign(TextAlign.Start)
                  .maxLines(3)
                  .textOverflow({ overflow: TextOverflow.Clip })//顶部左对齐,Top顶部居中
                  .align(Alignment.TopStart)
                  .width('92%')
                  .height(68)
                //可预约时间
                Text(item.tips)
                  .textAlign(TextAlign.End)
                  .alignSelf(ItemAlign.End)
                  .height(30)
                  .padding({ left: 30 })
                  .fontColor(Color.Grey)
                  .backgroundColor(Color.Transparent)
                  .backgroundImage($rawfile('imgs/yuyue/timer.png'))
                  .backgroundImageSize({ width: 30, height: 30 })
                  .backgroundImagePosition(Alignment.Start);
                //布局要设置高宽
              }
              .padding({ top: 10, bottom: 10 })
              .justifyContent(FlexAlign.Start)
              .height(140)
            }
          }
          .width('100%')
          .height('24%')
          .align(Alignment.Start)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .padding({ right: 100 })
          .onClick(() => { //跳转到预约报名页
            let username = AppStorage.get<string>('username')
            if (username != null && username != undefined && username != '') {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/restime/Application', params: { rname: item.title } })
            } else {
              AlertDialog.show({ title: '预约提示', message: '请先登录后再预约' })
            }

          })
        }) //for
      }
      .width('94%')
      .height('100%')
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .margin({ top: 20 })

      //column-end
    }.width('100%').backgroundColor('#eee')
  }
}