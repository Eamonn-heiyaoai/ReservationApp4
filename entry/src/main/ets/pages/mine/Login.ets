import { promptAction } from '@kit.ArkUI';
import Request from '../../utils/MyHttp'

@Entry
@Component
struct Login {
  @State message: string = '用户登录';
  //存用户名与密码
  @State username: string = '';
  @State password: string = '';

  ////构建UI
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
          .onClick(() => { //返回个人中心
            this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/MyMine' })
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

      ////2.登录设计
      Text('用户名：').fontSize(20).margin({ top: 80, left: 10 })
      TextInput({ placeholder: '请输入用户名' })
        .width('76%')
        .height(50)
        .margin({ top: 20 })
        .alignSelf(ItemAlign.Center)
        .fontSize(18)
        .onChange((value: string) => {
          this.username = value
        })
      Text(`密    码：`).fontSize(20).margin({ top: 40, left: 10 })
      TextInput({ placeholder: '请输入密码' })
        .width('76%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        })
      Button('提 交')
        .width('85%')
        .height(40)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(Color.Red)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })
        .onClick(() => { //执行登录
          if (this.username == '' || this.username == undefined || this.username == null) {
            promptAction.openToast({ message: '用户名不能为空' })
            return;
          } else if (this.password == '' || this.password == undefined || this.password == null) {
            promptAction.openToast({ message: '密码不能为空' })
            return;
          }
          //////请使用后台服务器json-sever完成登录操作//////
          Request.login(this.username, this.password).then((res: string) => {
            //console.log('=============',res);
            if (res === 'ok') {
              //将用户名保存到本地(手机中)，所有组件页都可以获取
              AppStorage.setOrCreate<string>('username', this.username)
              ////返回个中心首页
              this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/MyMine' })
              return;
            } else {//用户名或密码错误
               //console.log('-------',res)
               promptAction.openToast({ message: res })
            }
          })
        })//登录按钮
      ////3.去注册,使用新的导航组件实现组件或页面间跳转。
      Button('去注册')
        .fontColor(Color.White)
        .width('85%')
        .height(40)
        .alignSelf(ItemAlign.Center)
        .backgroundColor('#27C189')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Register' })
        })
    } //column-end
    .alignItems(HorizontalAlign.Start)
  } //build
}