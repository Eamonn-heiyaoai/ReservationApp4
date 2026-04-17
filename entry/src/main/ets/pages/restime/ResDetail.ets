import {router} from '@kit.ArkUI';
import Player from '../../entity/Player';

/**
 * 预约详情与生成二维码
 */
@Entry
@Component
struct ResDetail {
  //顶部标题
  @State message: string = '预约详情'
  //声明健身人员对象
  @State player: Player | null = null;
  //生成二维码的字符串
  @State qcstr: string = '';
  ////提前获取报名信息
  aboutToAppear() {
    //获取键值对json字符串,以例生成二维码,微信提示暂时识别不了,应该是有权限原因
    let temp = router.getParams() as string[];
    //获取报名信息
    this.qcstr = temp['player'] as string;
    //生成报名表对象
    this.player = JSON.parse(this.qcstr);
  }

  ////构建UI
  build() {
    Column() {
      ////1.顶部标题
      Row() {
        //布局用百分比,具体的组件用vp权重单位,安装到手机模拟器就是正常的
        Button()
          .height(60)
          .width(60)
          .backgroundColor(Color.Transparent)
          .backgroundImage('imgs/yuyue/myback.png')
          .margin({ left: 20 })
          .backgroundImageSize({ width: '100%', height: '100%' })
          .onClick(() => { //返回我的
            router.pushUrl({ url: 'pages/mine/MyMine'})
          })
        Text(this.message)//此处充当布局与组件
          .width('100%')
          .padding({ right: 100 })
          .height('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)
      }.width('100%')
      .height('12%')
      .backgroundColor('#27C189')

      ////2.预约基本信息
      Column() {//场馆名
        Text(this.player != null ? this.player.venue : '')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .height(50)
          .padding({ left: 10 })
          .lineHeight(20)
        ///运动达人预约时间
        Text(this.player != null ? this.player.pdate + ' 00:00-23:59' : '00:00-00:00')
          .height(40)
          .width('100%')
          .backgroundColor(Color.White)
          //预约时间小图片
          .backgroundImage('imgs/yuyue/timer.png')
          .backgroundImageSize({ width: 20 })
          .padding({left:30})
          .margin({left:20})
          .backgroundImagePosition(Alignment.Start)
        ////预约
        Row() {
          Text('预约成功').fontColor('#27C189').margin({ right: 10 });
        }.width('100%').height(30).padding({ left: 14 })

        ///返回首页
        Row() {
          Button('返回我的').height(30).margin({ right: 10 }).backgroundColor('#27C189').onClick(() => { //返回首页
            router.pushUrl({ url: 'pages/mine/MyMine' })
          })
          //添加到手机日程,暂时不用
          Button('手机日程').height(30).backgroundColor('#27C189').onClick(() => {
            AlertDialog.show({ title: '日程管理', message: '手机日程待完善!' })
          })
        }.width('100%').margin({ top: 10 }).justifyContent(FlexAlign.Center);
      }
      .width('94%')
      .height(170)
      .backgroundColor(Color.White)
      .alignSelf(ItemAlign.Center)
      .borderRadius(10)
      .margin({ top: 10 })

      ////3.生成二维码存储用户报名信息，创新部分；参加后由工作人员扫码核销
      Column() {
        Text() {
          Span('预约码').fontSize(20).fontWeight(FontWeight.Bold);
          Span('(向工作人员出示核销)')
        }.margin({ bottom: 10 })

        ////将json字符串生成二维码；微信为安全考虑不支持系统生成的,手写的微信能识别////
        QRCode(this.qcstr).size({ width: 200, height: 200 }).backgroundColor(Color.White)
      }
      .width('94%')
      .height(260)
      .backgroundColor(Color.White)
      .margin({ top: 10, bottom: 10 })
      .alignSelf(ItemAlign.Center)
      .borderRadius(10)
      .padding({ top: 12 })

      ////4.预约人员信息文本提示
      Column() {
        Text("预约人员信息")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, bottom: 10 })
          .width('100%')
          .textAlign(TextAlign.Center)
        Text() { //姓名
          Span('姓名：').fontSize(18).fontWeight(FontWeight.Bold);
          Span(this.player != null ? this.player.name : '').fontSize(18);
        }.width('100%').height(20)

        Divider().margin({ top: 8, bottom: 10 })
        Text() { //手机
          Span('手机：').fontSize(18).fontWeight(FontWeight.Bold);
          Span(this.player!=null?this.player.mobile:'').fontSize(18)
        }.width('100%').height(20)

        Divider().margin({ top: 8, bottom: 10 })
        Text() { //性别
          Span('性别：').fontSize(18).fontWeight(FontWeight.Bold);
          Span(this.player!=null?this.player.gender:'').fontSize(18)
        }.width('100%').height(20)
      }
      .width('94%')
      .height(160)
      .backgroundColor(Color.White)
      .alignSelf(ItemAlign.Center)
      .borderRadius(10)
      .padding({ left: 20, right: 20 })
    } //column-end
    .backgroundColor('#eee')
    .alignItems(HorizontalAlign.Start)
    .height('100%')
    .width('100%')
  }
}