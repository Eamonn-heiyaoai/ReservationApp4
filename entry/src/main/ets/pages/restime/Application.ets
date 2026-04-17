import Player from '../../entity/Player';
import PlayerDao from '../../utils/PlayerDao';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 预约报名组件
 */
@Entry
@Component
struct Application {
  //顶部标题
  @State message: string = '预约报名'
  //场馆名称
  @State rname: string = '无预约场馆';
  //预约日期，带星期的
  @State rdate: string = ''
  //预约日期，简单的传下一页
  @State rd: string = '';
  //报名人员信息
  @State name: string = ''; //姓名
  @State gender: string = ''; //性别
  @State mobile: string = '13101234567'; //电话
  //动态变量控制日历组件的状态
  @State flag: Visibility = Visibility.Hidden;

  ////打开页面完成后，获取路由传参,有路由关系的提前完成
  aboutToAppear() {
    ////1.预约日期处理
    //设置日期信息
    let weeks = ['日', "一", "二", '三', '四', '五', '六'];
    let temp = new Date(); //获取当天日期
    let strs = this.getUIContext().getRouter().getParams() as string[];
    let tmp = strs['rd'] as string; //传过来的预约日期
    ////如果之前已选预约日期,则使用此日期,如果没有则使用当前日期
    if (tmp != null && tmp != undefined && tmp != '') { //预约日期,字符串判断
      ////新建日期对象
      temp = new Date(tmp);
    }
    //获取日期并拼装,声明年月日,星期数
    let year = temp.getFullYear(), month = temp.getMonth() + 1, date = temp.getDate(), week = temp.getDay();
    ///完全的预约日期格式
    this.rdate = year + '年' + month + '月' + date + '日 星期' + weeks[week];
    ///简单日期格式
    this.rd = year + '-' + month + '-' + date;
    ////2.预约场馆名称
    let res = this.getUIContext().getRouter().getParams() as string[];
    let rn = res['rname'] as string; //场馆名称
    if (rn != null && rn != undefined && rn != '') { //场馆名,字符串判断
      this.rname = rn;
    }
    ////3.手机号直接从登录用户中取到
    this.mobile = AppStorage.get<string>('mobile') as string;
  }

  ////构建UI
  build() {
    Column() {
      ////日期选择器,通过定位来实现布局结构
      Column() {
        //更改时间
        DatePicker({
          ////日期选择器
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected: new Date()
        }).onDateChange((value: Date) => {
          let week = ['日', "一", "二", '三', '四', '五', '六'];
          let year = value.getFullYear(); //年份
          let month = value.getMonth() + 1; //月份
          let date = value.getDate(); //日份
          let day = value.getDay(); //星期数
          //如果预约时间小于系统当前时间,可以给出错误提示消息
          this.rdate = year + '年' + month + '月' + date + '日' + ' 星期' + week[day];
          //传报名的日期
          this.rd = year + '-' + month + '-' + date;
        })
          .height(180)
          .backgroundColor(Color.Transparent)
        //时间选后取退出
        Button('确  定').width(200).fontSize(18).backgroundColor('#27C189')
          .onClick(() => {
            this.flag = Visibility.Hidden;
          })
      }
      .width('100%')
      .visibility(this.flag)
      .height('100%')
      .backgroundColor(Color.White)
      .position({ y: 220 })
      .zIndex(99)

      ////1.顶部标题
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

      //2.预约信息
      Column() {
        Text(this.rname).fontSize(24).fontWeight(FontWeight.Bold)
          .width('100%').height(60)
        Text('自' + this.rdate + ' 00:00-23:59')
          .width('100%')
          .height(50)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        //改时间
        Button('更改时段')
          .fontSize(14)
          .height(30)
          .width(88)
          .fontColor(Color.Orange)
          .backgroundColor('#ffeeee')
          .offset({ x: 110 })
          .onClick(() => { //更改时间
            this.flag = Visibility.Visible;
          })
      }
      .width('94%')
      .height(170)
      .backgroundColor(Color.White)
      .borderRadius(10)
      .alignSelf(ItemAlign.Center)
      .margin({ top: 10, bottom: 20 })
      .padding(10)

      //3.预约填写
      Column() {
        //标题
        Text() {
          Span('填写资料,带').fontColor(Color.Gray);
          Span('*').fontColor(Color.Red);
          Span('号为必填项').fontColor(Color.Gray)
        }.fontSize(16).height(40)

        //姓名
        Divider().color('#ccc')
        Row() {
          Text() {
            Span('*').fontColor(Color.Red).fontSize(16);
            Span('姓名：').fontWeight(FontWeight.Bold).fontSize(16)
          }.height(50)

          TextInput({ placeholder: '请输入姓名' })
            .placeholderColor('#aaa')
            .width(200)
            .backgroundColor(Color.Transparent)
            .fontSize(16)
            .fontColor(Color.Gray)
            .onChange((value: string) => {
              this.name = value;
            })
        }.width('100%').height(50)

        //姓别
        Divider().color('#ccc')
        Row() {
          Text() {
            Span('*').fontColor(Color.Red).fontSize(16);
            Span('性别：').fontWeight(FontWeight.Bold).fontSize(16)
          }.height(50)

          Text('男').fontSize(16).fontColor(Color.Gray);
          Radio({ value: 'boy', group: 'rs' }).width(16).onChange((isCheck: boolean) => {
            if (isCheck) {
              this.gender = '男';
            }
          })
          Text('女').fontSize(16).fontColor(Color.Gray).margin({ left: 8 })
          Radio({ value: 'girl', group: 'rs' }).width(16).onChange((isCheck: boolean) => {
            if (isCheck) {
              this.gender = '女';
            }
          })
        }.width('100%').height(50)

        //手机
        Divider().color('#ccc')
        Row() {
          Text() {
            Span('*').fontColor(Color.Red).fontSize(16);
            Span('手机：').fontWeight(FontWeight.Bold).fontSize(16);
          }.height(50)

          //直接获取注册的用户手机号
          Text(this.mobile)
            .width(200)
            .backgroundColor(Color.Transparent)
            .fontSize(16)
            .fontColor(Color.Gray)
        }.width('100%').height(50)

        //自定义提交按钮
        Button({ type: 3 }) { //按钮类型
          Text('提 交').fontColor(Color.White).fontSize(18).fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height(40)
        .margin({ top: 30 })
        .backgroundColor(Color.Red)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .borderRadius(10)
        .onClick(() => { //提交预约,并存储用户报名信息到数据库,这量一律使用AppStorage实现
          if (this.name == undefined || this.name == null || this.name == '') {
            AlertDialog.show({ message: '姓名不能为空!' })
            return;
          }
          if (this.gender == undefined || this.gender == null || this.gender == '') {
            AlertDialog.show({ message: '性别不能为空!' })
            return;
          }
          //生成报名信息：姓名，性别，(电话，预约的场馆名称,预约日期)
          let player = new Player(this.name, this.gender, this.mobile, this.rname, this.rd);
          PlayerDao.register(player).then((id) => {
            if (id > 0) {
              //报名人员信息传下一页
              this.getUIContext().getRouter().pushUrl({ url: 'pages/restime/ReserDetail', params: { player: JSON.stringify(player) } })
            } else {
              AlertDialog.show({ message: '报名失败' })
            }
          }).catch((err: BusinessError) => {
            console.log(err.message);
          })
        }) ////单击事件
      }
      .width('94%')
      .height(205)
      .backgroundColor(Color.White)
      .borderRadius(10)
      .alignSelf(ItemAlign.Center)
      .padding(10)
    } //column-end
    .backgroundColor('#eee')
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
  }
}