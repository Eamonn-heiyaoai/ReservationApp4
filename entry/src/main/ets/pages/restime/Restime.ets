/**
 * 场馆实体
 */
class MyReservation {
  pic: string //图片
  name: string //场馆名称

  constructor(pic: string, name: string) {
    this.pic = pic;
    this.name = name;
  }
}

/**
 * 场馆预约组件
 */
@Preview
@Component
export default struct Restime {
  @State message: string = '场馆预约';
  //日期选择器
  @State isLunar: boolean = false
  //动态显示返回按钮
  @State flag: Visibility = Visibility.Hidden
  //预约选取的日期
  @State mydate: string = ''
  //传到报名页的日期
  @State rd: string = '';
  //设置一个当前的日期,以便再次返回时匹配上
  @State curDate: Date = new Date();
  //测试数据,声明待预约场馆信息
  private myReservations: Array<MyReservation> = [
    new MyReservation('play1', '足球场预约'),
    new MyReservation('play2', '羽毛球场预约'),
    new MyReservation('play3', '篮球场预约'),
    new MyReservation('play4', '乒乓球场预约'),
    new MyReservation('play5', '网球场预约'),
    new MyReservation('play6', '游泳馆预约'),
    new MyReservation('play7', '健身房预约')
  ];

  //在build之前完成,onPageshow在build之后
  aboutToAppear() {
    let md = new Date();
    let week = ['日', "一", "二", '三', '四', '五', '六'];
    let year = md.getFullYear() //年
    let month = md.getMonth() + 1; //月
    let date = md.getDate(); //日
    let day = md.getDay(); //星期数
    //生成自定义日期对象,计算出星期
    //如果预约时间小于系统当前时间,请给出错误提示消息
    this.mydate = year + '年' + month + '月' + date + '日' + ' 星期' + week[day];
    //生成传下一页的简单日期
    this.rd = year + '-' + month + '-' + date;
  }

  ////ui设计
  build() {
    Column() {
      ////1.顶部导航
      Row() {
        /////////由于系统DatePicker有误,这里自定义日历///////////
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => { //返回
            this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/MyMine' })
          });
        Text(this.message)
          .width('55%')
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
        Text('去登录')
          .fontSize(20)
          .width('35%')
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

      ////2.选择日期
      Row() {
        Text('选取日期：')
          .height(50)
          .fontSize(20)
          .margin({ left: 8 })
          .fontWeight(FontWeight.Bold)
        Text(this.mydate).fontSize(16)
      }.width('100%')

      ////模拟机上可以用了,应该是selected:后日期对象设置不正确,报不是一个Date Object////
      DatePicker({
        start: new Date('1970-1-1'),
        end: new Date('2100-1-1'),
        selected: new Date()
      })
        .lunar(this.isLunar)
        .onDateChange((value: Date) => {
          let week = ['日', "一", "二", '三', '四', '五', '六'];
          let year = value.getFullYear(); //年
          let month = value.getMonth() + 1; //月
          let date = value.getDate(); //日
          let day = value.getDay(); //星期数
          //如果预约时间小于系统当前时间,请给出错误提示消息
          this.mydate = year + '年' + month + '月' + date + '日' + ' 星期' + week[day];
          //传下一页简单日期
          this.rd = year + '-' + month + '-' + date;
        })
        .height(160)
        .backgroundColor(Color.White)
        .width('94%')

      ////3.选择预约的场馆列表，需要登录
      List({ space: 10 }) { //第一行的间距
        ForEach(this.myReservations, (item: MyReservation) => {
          ListItem() { //只能有一个子组件
            Row() { //'imgs/yuyue/'
              Image($rawfile(`imgs/yuyue/` + item.pic + `.jpg`)).width(60).height(60)
                .borderRadius(30).margin({ left: 10, right: 10 })
              Text(item.name)
                .width('52%')
                .height(80)
                .fontSize(20)
              Text('0:00')
                .fontColor(Color.Grey)
                .backgroundImage('imgs/yuyue/timer.png')//时刻小图标
                //左边上下自动居中
                .backgroundImageSize({ width: 30, height: 30 })
                .backgroundImagePosition(Alignment.Start)
                .height(50)
                .width(68)
                .textAlign(TextAlign.End)
                .padding({ right: 6 })
            }
          } //设置单击事件
          .align(Alignment.Start)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .width('100%')
          .onClick(() => { //单击,根据索引号自行匹配,并传用户预约日期与场馆信息
            let username = AppStorage.get<string>('username');
            if (username != null && username != undefined && username != '') {
              //跳转到报名页：传场馆名,预约日期
              this.getUIContext()
                .getRouter()
                .pushUrl({ url: 'pages/restime/Application', params: { rname: item.name, rd: this.rd } })
            } else {
              //系统对话框
              this.getUIContext().getPromptAction().showToast({
                message: '请先登录后再预约',
                duration: 2000
              })
            }
          });
        }) //foreach
      } //list end
      .width('94%')
      .height('100%') //剩余的所有
      //不加布局权重,无法滑动
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .margin({ top: 16 })
    } //column end
    .width('100%')
    .height('100%')
  }
}