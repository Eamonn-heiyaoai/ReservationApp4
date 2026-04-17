import { promptAction} from '@kit.ArkUI';
import User from '../../entity/User';
//导入http请求对象
import  MyHttp from '../../utils/MyHttp'
@Entry
@Component
struct Register {
  @State message: string = '用户注册'
  //获取用户名，手机与密码
  @State username: string = '';
  //设置默认电知
  @State mobile: string = '13501234567';
  @State password: string = '';

  ////构建用户界面
  build() {
    Column() {
      ////1.顶部提示
      Row() {
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => { //返回我的
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

      ////2.注册设计
      Text('用户名：').fontSize(20).margin({ top: 50, left: 10 })
      TextInput({ placeholder: '请输入用户名' })
        .width('76%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .onChange((value: string) => {
          if (value != "" && value != undefined && value != null) {
            this.username = value;
          }
        })
      Text('手机号：').fontSize(20).margin({ top: 20, left: 10 })
      TextInput({ placeholder: '请输入手机号' })
        .width('76%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .onChange((value: string) => {
          if (value != "" && value != undefined && value != null) {
            this.mobile = value;
          }
        })
      Text(`密   码：`).fontSize(20).margin({ top: 20, left: 10 })
      TextInput({ placeholder: '请输入密码' })
        .width('76%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .type(InputType.Password)
        .onChange((value: string) => {
          if (value != "" && value != undefined && value != null) {
            this.password = value;
          }
        })
      ////提交注册////
      Button('提 交')
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(Color.Red)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30, bottom: 20 })
        .onClick(() => { //执行注册,一律使用AppStorage实现
          if (this.username == '' || this.username == undefined || this.username == null) {
            promptAction.openToast({ message: '用户名不能为空' })
            return;
          } else if (this.mobile == '' || this.mobile == undefined || this.mobile == null) {
            promptAction.openToast({ message: '手机号不能为空' })
            return;
          } else if (this.password == '' || this.password == undefined || this.password == null) {
            promptAction.openToast({ message: '密码不能为空' })
            return;
          } //判断结束
          //去注册,id号不用传,系统自动生成
          let user=new User(this.username,this.password,this.mobile);
          //////使用json-sevrer实现交互,完成用户注册/////
          //返回一个Promise<string>,要用.then((res)=>{})方法取
          MyHttp.register(user).then((res)=>{
            if(res==='ok'){//跳转到登录页
              this.getUIContext().getRouter().pushUrl({url:'pages/mine/Login'})
            }else{
              promptAction.openToast({message:res})
            }
          })
          ///click-end///
        });
      ////去登录////
      Text('去登录')
        .fontColor(Color.Grey)
        .margin({ right: 10 })
        .width('20%')
        .height(40)
        .alignSelf(ItemAlign.End)
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .onClick(() => {
         this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Login' })
        })
    } //column-end
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }
}