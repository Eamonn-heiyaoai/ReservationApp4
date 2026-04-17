import Content from '../../entity/News';
/**
 * 场馆动态与运动常识展示详情页
 */
@Entry
@Component
struct MyDetail {
  //场馆动态详情，运动常识详情
  @State message: string = '详情'
  private msg: string =
    'numquam officiis cum, quaerat ab eaque magni distinctio labore eos? Asperiores commodi velit, eveniet facilis, hic sed porro mollitia eos optio dicta quae iste ducimus nostrum cum cupiditate fugiat voluptatibus, exercitationem omnis iusto? Maiores explicabo sint error minus ipsam quasi autem aut nostrum illo possimus saepe pariatur suscipit est itaque voluptate non vel quae, qui praesentium.';
  //内容对象
  @State obj: Content | null = null;

  //获取路由参数
  aboutToAppear() {
    //获取上一页传来的参数值
    let titles = this.getUIContext().getRouter().getParams() as string[];
    let temp = titles["title"] as string;
    this.message = temp + this.message
    let json = this.getUIContext().getRouter().getParams() as string[];
    let str = json['jsonstr'] as string;
    this.obj = JSON.parse(str); //赋给动态对象
  }

  ////构建ui
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

      ////2.详情内容
      Column() {
        //详情标题
        Text(this.obj != null ? this.obj.title : '')
          .width('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, bottom: 10 })
          .padding({ left: 10, right: 10 })
        Image($rawfile(`imgs/types/` + (this.obj != null ? this.obj.pic : '') + `.jpg`)).width(240).borderRadius(120)
        Text(this.obj != null ? this.obj.info : '' + this.msg).width('100%').fontSize(18).padding(4)
      }.width('94%').height(500).backgroundColor(Color.White).height('100%')
      //------------外层column-end----------------//
    }.width('100%').height('100%').backgroundColor('#eee')
  }
}