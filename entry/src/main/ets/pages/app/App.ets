////项目的根组件,类似于vue中的App.vue文件
////它是主组件,也可以称为根组件
////也需导出给Index.ets调用
////生成底部导航条，并进行页面的切换
////组件必须有：@Component注解与build(){}
////1.导入需要的切换组件文件
import Home from '../home/Home'
import Message from '../message/Message'
import Know from '../know/Know'
import Restime from '../restime/Restime'
import Mine from '../mine/Mine'

@Preview
@Component
export default struct App {
  //生成UI：包含底部导航条，切换内容，通过Tabs组件实现
  //参考官网：https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-container-tabs#%E7%A4%BA%E4%BE%8B9%E9%A1%B5%E9%9D%A2%E5%88%87%E6%8D%A2%E6%8B%A6%E6%88%AA
  ////2.声明变量与对象
  //当前点击按钮的索引号，名称:类型
  @State currentIndex: number = 0;
  //创建Tabs的控制器对象
  private tabsController: TabsController = new TabsController();

  //3.创建方法，生成底部导航条，自定义UI
  //生成一个按钮
  @Builder
  //可以在build使用此方法
  buildTabs(title: string, targetIndex: number, selectIcon: Resource, normalIcon: Resource) {
    Column() {
      Image(this.currentIndex == targetIndex ? selectIcon : normalIcon)
        .size({ width: 22, height: 22 })
        .objectFit(ImageFit.Fill) //拉伸充满
      Text(title)
        .fontColor(this.currentIndex == targetIndex ? '#43D4AE' : Color.Grey)
        .fontSize(12)
    }
    .alignItems(HorizontalAlign.Center) //水平居中
    .width('100%')
    .height(70)
    .justifyContent(FlexAlign.Center) //上下居中
    .backgroundColor(Color.White)
    .border({width:{top:1},color:'#ddd'})
    .onClick(() => { //单击按钮
      //将目标按钮的索引号赋组当前索引变量
      this.currentIndex = targetIndex;
      //将目标按钮的索引号赋值组选项卡控制器对象
      this.tabsController.changeIndex(targetIndex);
    })
  }

  //生成UI
  build() {
    //调用选项卡布局，传对象：{导航条位置,控制器}
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) { //选项卡父布避
      //1.首页组件
      TabContent() { //选项目内容布局
        Home()
      }.tabBar(this.buildTabs('首页', 0, $rawfile('tabs/home_cur.png'), $rawfile('tabs/home.png')))

      //2.场馆动态组件
      TabContent() { //选项目内容布局
        Message()
      }.tabBar(this.buildTabs('场馆动态', 1, $rawfile('tabs/msg_cur.png'), $rawfile('tabs/msg.png')))

      //3.运动常识组件
      TabContent() { //选项目内容布局
        Know()
      }.tabBar(this.buildTabs('运动常识', 2, $rawfile('tabs/know_cur.png'), $rawfile('tabs/know.png')))

      //4.健身预约组件
      TabContent() { //选项目内容布局
        Restime()
      }.tabBar(this.buildTabs('场馆预约', 3, $rawfile('tabs/restime_cur.png'), $rawfile('tabs/restime.png')))

      //5.个人中心组件
      TabContent() { //选项目内容布局
        Mine()
      }.tabBar(this.buildTabs('我的', 4, $rawfile('tabs/mine_cur.png'), $rawfile('tabs/mine.png')))
    } //tabs-end
    .onChange((index: number) => { //实现手势功能
      //将滑动后拿到索引号赋值给当前索引变量。
      this.currentIndex = index;
    })
  } //buld-end
}