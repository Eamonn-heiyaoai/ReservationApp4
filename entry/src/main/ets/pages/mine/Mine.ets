//页面的切换有两种方式：
// 系统的路由对象router(简洁,页面顶部与底部需要自定义)，Navigation导航组件(功能强大，自带顶部与底航条)。
//导入导航子组件文件
import Info from './TestInfo';
//导入Player实体类
import Player from '../../entity/Player'
import PlayerDao from '../../utils/PlayerDao'

//声明方法，获取当前登录的用户名
function go() {
  let uname = AppStorage.get('username') as string;
  if (uname != undefined && uname != null && uname != "") {
    return uname;
  } else {
    return '';
  }
}

/**
 * 关于我的组件
 */
@Preview
@Component
export default struct Mine {
  @State message: string = "您今天没有预约哦~";
  @State username: string = ''; //调用函数
  //隐藏或显示预约按钮
  @State flag1: Visibility = Visibility.Visible;
  //隐藏或显示出示二维码接钮
  @State flag2: Visibility = Visibility.None;
  //二维码码显示设置
  @State qcflag: Visibility = Visibility.None;
  //今天的玩家报名信息,用于生成二维码
  @State curPlayer: Player | null = null;
  //切换登录与注销
  @State login: string = '用户登录';
  @State loginColor: string = '#fff';
  ////导航路径栈,官方建议通过Navigation实现跳转,用于替代router,进阶课程将全面应用它///
  private navpath: NavPathStack = new NavPathStack();

  //Navigation导航组件，要求声明切换到目标页面的函数
  @Builder
  pageMap(name: string) {
    //指定的页面名称
    if (name == 'info') {
      //加载目标组件页面
      Info();
    }
  }

  //初始化预约数据,注意组件生命周期的特点,不能用aboutappear
  aboutToAppear() {
    //取已登录过的用户
    this.username = go();
    //获取登录用户的手机号,以便获得报名信息
    let mobile = AppStorage.get<string>('mobile') as string;
    if (this.username != '') {
      this.login = "用户退出"
      this.loginColor = '#fcc';
      if (mobile != undefined) {
        ////修改为通过http请示：查询json-server服务器拿到数据////
        //查询内置SQLite数据库,用户所有的预约信息,注意此下的调用方式
        PlayerDao.queryAll(mobile).then((data) => {
          if (data.length > 0) { //直接将数据提供给UI
            for (let i = 0; i < data.length; i++) {
              if (data[i].state == '进行中') {
                this.curPlayer = data[i];
                this.message = this.curPlayer.venue;
                this.flag1 = Visibility.None;
                this.flag2 = Visibility.Visible;
                break;
              }
            }
          } else {
            this.message = '您今天没有预约哦！';
            this.flag1 = Visibility.Visible;
            this.flag2 = Visibility.None;
          }
        })
      }
    } else { //用户未登录
      this.flag1 = Visibility.Visible;
      this.flag2 = Visibility.None;
      this.login = "用户登录"
      this.loginColor = '#fff';
    }
  }

  ////构建UI
  build() {
    ////使用一下官方推荐的导航组件Navigation实现跳转,在进阶课程将完全使用此组件////
    Navigation(this.navpath) {
      Column() {
        //生成当前用户对应的二维码
        Column() {
          //将当前用户报名信息生成二维码
          Text('预约人：' + (this.curPlayer != null ? this.curPlayer?.name : '') + ' ' +
            (this.curPlayer != null ? this.curPlayer?.pdate : ''))
            .fontSize(20).height(30).margin({ top: 10 })
          //二维码组件,传一个json字符串
          QRCode(JSON.stringify(this.curPlayer)).size({ width: 230, height: 230 }).margin({ top: 10, bottom: 20 })
          Button('退出展示')
            .width(150)
            .backgroundColor(Color.Pink)
            .fontColor('#555')
            .fontSize(16)
            .onClick(() => { //隐藏二维码
              this.qcflag = Visibility.None;
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.White)
        //用到了定位
        .position({ y: 200 })
        .zIndex(88)
        .visibility(this.qcflag);

        ////再包一个列,当切换方向时确保子组件整体居中////
        Column() {
          ////顶部注册////
          Row() { //一行左边的
            Button()
              .backgroundColor(Color.Transparent)
              .backgroundImage($r('app.media.my_index'))
              .backgroundImagePosition(Alignment.Center)
              .width(60)
              .height(60)
              .margin({ right: 20, left: -20 })
              .onClick(() => { //跳转为首页,日志提示有未定义数据
                //路由跳转切换到主页
                this.getUIContext().getRouter().pushUrl({ url: 'pages/Index' })
              })
            //注册与登录
            Column() {
              Text(this.username + '欢迎光临')
                .fontColor(Color.White)
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10, left: -19 })
              Button('没有账号，马上注册').margin({ top: 15 }).fontSize(18).backgroundColor(Color.Grey)
                .onClick(() => {
                  //路由跳转切换页面
                  this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Register' })
                })
              Button(this.login)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10 })
                .backgroundColor(Color.Transparent)
                .offset({ x: 75 })
                .fontColor(this.loginColor)
                .onClick(() => {
                  if (this.login == '用户登录') { //登录
                    this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Login' })
                  } else {
                    ////重置为初始状态
                    this.username = '';
                    this.login = '用户登录';
                    this.loginColor = '#fff';
                    ////清二维码
                    this.message = '您今天没有预约哦！';
                    this.flag1 = Visibility.Visible;
                    this.flag2 = Visibility.None;
                    ////清除编存,重置
                    AppStorage.clear();
                  }
                });
            }
          }.backgroundColor('#27C189')
          .alignSelf(ItemAlign.Center)
          .height('26%')
        }.width('100%').backgroundColor('#27C189');

        ////1.今日预约
        Column() {
          Text('今日预约').fontSize(26).fontWeight(FontWeight.Bold).margin({ left: 20 })
          Row() {
            //提示信息
            Text(this.message).fontSize(20).fontColor(Color.Grey).margin({ left: 20 })
            //去预约
            Button('马上预约')
              .backgroundColor(Color.Transparent)
              .fontSize(18)
              .fontColor(Color.Red)
              .onClick(() => {
                if (this.username == null || this.username == undefined || this.username == '') {
                  AlertDialog.show({ title: '登录提示', message: '请您先登录后再进行修改!' })
                } else {
                  this.getUIContext()
                    .getRouter()
                    .pushUrl({ url: 'pages/restime/MyRestime', params: { player: this.curPlayer } })
                }
              })
              .visibility(this.flag1);
            //生成二维码
            Button('出示二维码')
              .backgroundColor(Color.Transparent)
              .fontSize(18)
              .fontColor('#27C189')
              .visibility(this.flag2)
              .onClick(() => {
                this.qcflag = Visibility.Visible;
              })
            //直接生成二维码
          }.margin({ top: 20 })
        }
        .width('92%')
        .height('18%')
        .backgroundColor(Color.White)
        .borderRadius(10)
        .margin({ top: 10 })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)

        ////2.所有预约
        Column() {
          Row() {
            Text('我的所有预约').fontSize(22).fontColor('#666').width('80%')
            Button('>')
              .backgroundColor(Color.Transparent)
              .fontColor('#27C189')
              .fontSize(24)
              .width('20%')
          }.width('100%').padding({ left: 20 })
          .onClick(() => {
            if (this.username == '' || this.username == null || this.username == undefined) {
              AlertDialog.show({ title: '查询提示', message: '请先登录后再查询！' })
            } else { //我的报告
              this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Reports' })
            }
          })

          //水平线
          Divider().margin({ left: 4, top: 18, bottom: 18 }).width('98%')
          Row() {
            Text('修改个人资料').fontSize(22).fontColor('#666').width('80%')
            Button('>')
              .backgroundColor(Color.Transparent)
              .fontColor('#27C189')
              .fontSize(24)
              .width('20%')
          }.width('100%').padding({ left: 20 })
          .onClick(() => {
            if (this.username == '' || this.username == undefined) {
              //最的对话框，需要通过上下文对象来取
              this.getUIContext().showAlertDialog({ title: '登录提示', message: '请您先登录后再进行修改!' })
            } else { //我的更新
              this.getUIContext().getRouter().pushUrl({ url: 'pages/mine/Update' })
            }
          })
        }
        .width('92%')
        .height('20%')
        .backgroundColor(Color.White)
        .borderRadius(10)
        .margin({ top: 10 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)

        //关于我们
        Column() {
          Row() {
            Text('关于我们').fontSize(22).fontColor('#666').width('80%')
            Button('>')
              .backgroundColor(Color.Transparent)
              .fontColor('#27C189')
              .fontSize(24)
              .width('20%')
          }.width('100%').padding({ left: 20 })
          .onClick(() => {
            this.getUIContext().showAlertDialog({
              title: '超客天涯',
              message: '致力于新技术的学习与传播，以近于技术，快于成长，贵于交流为宗旨！'
            });
          })

          //水平线
          Divider().margin({ left: 4, top: 16, bottom: 16 }).width('98%')
          Row() {
            Text('Navigation跳转').fontSize(22).fontColor(Color.Brown).width('80%').backgroundColor(Color.White)
            Button('>')
              .backgroundColor(Color.Transparent)
              .fontColor('#27C189')
              .fontSize(24)
              .width('20%')
          }.width('100%').padding({ left: 20 })
          .onClick(() => {
            //通过导航组件跳转到下一页TestInfo：组件名,传递参数
            //name的值必须与pageMap方法中定义的name==“名称”中的名称一样
            this.navpath.pushPath({ name: 'info', param: '你好DeepSeek!' })
            //或者
            //this.navpath.pushPathByName('Info','你好DeepSeek!');
          })
        }
        .width('92%')
        .height('20%')
        .backgroundColor(Color.White)
        .borderRadius(10)
        .margin({ top: 10 })
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .alignSelf(ItemAlign.Center);
      ////目标导航组件设置,传一个跳转方法名,不能带()////
    }.navDestination(this.pageMap)
    ///隐藏菜单标题
    .hideTitleBar(true)
    ///隐藏底部导航条
    .hideToolBar(true)
    //标题模式，这里是全屏模式:free,mini
    .titleMode(NavigationTitleMode.Full)
  } //build
}