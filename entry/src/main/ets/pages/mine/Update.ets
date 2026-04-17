import { router } from '@kit.ArkUI';
import User from '../../entity/User';
////请修改为http方式与json-server方式来实现
import UserDao from '../../utils/UserDao';

/**
 * 更新个人资料
 */
@Entry
@Component
struct Update {
  @State message: string = '个人资料更新'
  //用户基本信息
  @State username: string = '';
  @State mobile: string = '';
  @State password: string = '';
  @State user: User | null = null;

  //初始用户信息
  aboutToAppear() {
    this.user = AppStorage.get<User>('user') as User;
    //重新赋值
    if (this.user != null) {
      this.username = this.user.username;
      this.password = this.user.password;
      this.mobile = this.user.mobile;
    }
  }

  ////构建UI
  build() {
    Column() {
      ////1.修改提示
      Row() {
        Text('<')
          .width('10%')
          .height('100%')
          .textAlign(TextAlign.Center)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .onClick(() => { //返回我的
            router.back();
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

      ////2.用户信息修改
      //用户
      Text('用户名：').fontSize(20).margin({ top: 50, left: 10 })
      TextInput({ placeholder: '修改用户名', text: this.username })
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .onChange((value: string) => {
          this.username = value;
        })

      //密码
      Text(`密   码：`).fontSize(20).margin({ top: 20, left: 10 })
      TextInput({ placeholder: '修改密码', text: this.password })
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .type(InputType.Password)
        .onChange((value: string) => {
          this.password = value;
        })
      Text('手机号：').fontSize(20).margin({ top: 20, left: 10 })
      TextInput({ placeholder: '修改手机号', text: this.mobile })
        .width('80%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .margin({ top: 20 })
        .fontSize(18)
        .onChange((value: string) => {
          this.mobile = value;
        })

      Button('确认修改')
        .width('86%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .backgroundColor(0x27C189)
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })
        .onClick(() => { //执行修改
          if (this.username == '') {
            //系统对话框提示
            AlertDialog.show({ message: '用户名不能为空' })
            return;
          }
          if (this.password == '') {
            //系统对话框提示
            AlertDialog.show({ message: '密码不能为空' })
            return;
          }
          if (this.mobile == '') {
            //系统对话框提示
            AlertDialog.show({ message: '手机号不能为空' })
            return;
          }
          if (this.user != null) {
            //更新用户信息
            this.user.username = this.username;
            this.user.password = this.password;
            this.user.mobile = this.mobile;
            //执行数据库修改
            UserDao.updateById(this.user.id,this.user);
          }
          //重新存入缓存
          AppStorage.setOrCreate<string>('username',this.username);
          AppStorage.setOrCreate<string>('mobile',this.mobile);
          AppStorage.setOrCreate<User>('user', this.user);
          //修改成功直接返回
          AlertDialog.show({ message: '修改成功!' })
        })
    } //column-end
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}