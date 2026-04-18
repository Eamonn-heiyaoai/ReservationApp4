//导入公共的类，新闻咨讯的热门内容，此处取个别名为Hot
import Hot from '../../entity/News';
import MyParams from '../../entity/MyParams'
////导入http网络请求工具////
import myhttp from '../../utils/MyHttp'
////导入Quick
import Quick from '../../entity/Quick'

//用作预览
@Preview
@Component
export default struct Home { //导出,以便其它组件导入复用
  ////////////以下内容建议从json-server后台服务器获取，此处直接提供数据///////////////
  //1.声明响应式数组(动态对象)，存取从后台获取的金刚区数据
  @State quicks: Quick[]=[];
  //2.声明对象数组,推送的热门内容，包含有场馆动态与运动常识新闻咨讯的部分
  private hots: Array<Hot> = [
    ////此处直接提供内容，建议从json-server服务中取
    new Hot("ad2", "滑雪属于高危运动，这些安全常识你知道吗",
      "我们滑雪过程中如何做到尽兴又安全？首先，除了掌握熟练的滑雪技巧和灵活的应变能力，作好自身安全防护装备和快速准确的自我急救知识也是重要保障。",
      '2024-5-22'),
    new Hot("ad3", "享受自行车骑行的同时，也要注意这些事情",
      "骑行自行车时，应该保持良好的心态。不要过于紧张或者冒险，要放松心情，享受骑行的乐趣。", '2024-5-20'),
    new Hot("ad4", "去健身房锻炼时关注这些问题，做到文明健身!",
      "在健身房锻炼的时候，我们除了要文明健身外，还需要知道科学的健身流程，避免盲目瞎练。", '2024-5-20'),
    new Hot("ad1", "跑步做好这几项是非常有益的",
      "有些跑者换上装备就直接开跑，没有做充分的热身运动，这样抽筋，跟腱酸痛等毛病会很容易找上门。开始运动时，可以做循序渐进的方式，原地踏步，随后进行跨步，最后在活动一下各关节，这样就能降低跑步受伤的概率。",
      '2024-5-18')
  ]
   //声明远程服务器地址
  // private serverUrl: string = 'http://192.168.110.116:3000/';     //使用模拟器时使用该项
  private serverUrl: string = 'http://10.5.86.185:3000/';
  // private serverUrl: string = `http://127.0.0.1:3000/`;           //若使用预览器则使用该项
  ////初始化数据////
 aboutToAppear():void{
    ////获取json-server服务器的数据/////
    myhttp.getAllImages().then(res=>{
      this.quicks = res;
      //console.log("=========:",this.quicks[0].title)
    })
  }

  //ui设计
  build() {
    //{space:20}设置布局行间距
    Column() {
      Text(this.quicks?.length+'')
      //1.顶部第一行bannner
      Row() { //行布局
        //取base/media/图片
        Image($r("app.media.indexbg"))
          .width('100%')
          .height('100%')
          .interpolation(ImageInterpolation.High) //图片宽高充满
      }
      .width('100%')
      .height('30%')

      //2.金刚区:显示主要内容区域,也可以使用一个实体类来集中存储数据
      Row() {
        Grid() { //网格布局
          //循环组件(数组对象,(数组元素,元素索引号)=>{})
          ForEach(this.quicks, (item:Quick, index: number) => {
            GridItem() { // Grid的一个子组件，加载列表项目
              Column() {
                //小图标'imgs/quicks/' + item + '.png'
                //此处需要使用模板字符串反单号``来拼接动态图片路径
                //嵌入的变量用${变量名}输出
                ///////////金刚区的内容，这里为本加载////////////////
                //Image($rawfile(`imgs/quicks/${item}.png`)).width(50).height(50)
                ////////////金刚区的内容，通过http请求远程加载////////////////
                Image(`${this.serverUrl}imgs/quicks/` + item.pic).width(50).height(50)
                //标题
                Text(item.title)
              }.padding({ top: 13 })
            }.selectable(true) //设置能点击
            .onClick(() => { //通过索引号判断,前两索引号对应message数组中的场馆动态与运动常识
              if (index == 0) { //场馆动态
                //通过当前对象的上下文对象Context的getRouter()放法获取系统自带路由对象router
                //再通过router对象的pushUrl实现跳转并传参
                //手写News类的对象并传递
                let hot = new Hot("ad4", "去健身房锻炼时关注这些问题，做到文明健身!",
                  "在健身房锻炼的时候，我们除了要文明健身外，还需要知道科学的健身流程，避免盲目瞎练。", '2024-5-20');
                //创建传参对象
                let myparams: MyParams = {
                  myIndex: 0,
                  obj: hot
                }
                ////路由传递的必须是一个对象
                this.getUIContext().getRouter().pushUrl({ url: 'pages/message/MyMessage', params: myparams });
              } else if (index == 1) { //运动常识
                this.getUIContext().getRouter().pushUrl({ url: 'pages/know/MyKnow', params: { myIndex: '1' } })
              } else { //其它为场馆预约,索引号要减2,表示去除场馆动态与运动常识的索引
                this.getUIContext()
                  .getRouter()
                  .pushUrl({ url: 'pages/common/YuyueList', params: { myIndex: (index - 2) } })
              }
            })
          }) //fore
        } //grid
        //分列样式:分3列,列间距均分
        .columnsTemplate('1fr 1fr 1fr')
        //分2行,无需指定，动态生成
        //.rowsTemplate('1fr 1fr')
        .rowsGap(8) //行间距
        //.columnsGap()//列间距,无需设置
      } //gird row
      .width('94%')
      .height(280)
      .backgroundColor('#fff')
      .borderRadius(10) //圆解边框
      .margin({ top: -20 }) //外边距

      // 3.动态列表行,热门内容
      List({ space: 12 }) { //行间距,列表布局;列表父组件
        ForEach(this.hots, (item: Hot) => {
          ListItem() { //列表项子组件,它的里边最外层只能包含有一个子组件
            Row() { //只能有一个组件
              //左边图片'imgs/types/' + item.pic + '.jpg'
              //用模板字符串拼接图片动态路径
              Image($rawfile(`imgs/types/${item.pic}.jpg`)).width(100).height(120)
                .borderRadius(8).margin({ right: 8 })
              Column() {
                //右边标题
                Text(item.title)
                  .width('94%')
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Center)
                  .maxLines(1) //保证只有一行后设为省略号
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                //右边内容
                Text(item.info)
                  .fontSize(16)
                  .padding({ top: 8 })
                  .fontColor('#555')
                  .textAlign(TextAlign.Start)//水平对齐
                  .maxLines(3)//最大行数
                  .textOverflow({ overflow: TextOverflow.Clip })//文本溢出设置为...
                  .align(Alignment.TopStart) //顶部左对齐,Top顶部居中
                  .width('92%')
                  .height(68)
                //发布时间
                Text(item.date).textAlign(TextAlign.End).width('92%').fontColor(Color.Grey)
                ////布局也要设置高宽
              }.padding({ top: 10, bottom: 10 }) //内间距
              .justifyContent(FlexAlign.Start)
              .height('100%')
            }
          }
          .onClick(() => { //去运动常识详情
            //通过当前对象的上下文对象Context的getRouter()放法获取系统自带路由对象router
            //再通过router对象的pushUrl实现跳转并传参
            this.getUIContext()
              .getRouter()
              .pushUrl({ url: 'pages/common/MyDetail', params: { title: '运动常识', jsonstr: JSON.stringify(item) } })
          })
          .height('58%')
          .align(Alignment.Start)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .padding({ right: 100 })
        }) //for
      }
      .width('94%')
      .height('100%')
      //不加布局权重,无法上下滑动
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .margin({ top: 12 })
      .backgroundColor('#eee')
    } //colum
  } //build
}