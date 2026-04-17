
/**
 * 测试信息组件,用于检验Navigation导航组件:实现页面切换用法
 * 在Mine.ets中导入
 */
@Preview
@Component
export default struct TestInfo {
  @State info: string = '';
  //声明路径栈对象
  @State navstack: NavPathStack = new NavPathStack();
  //生成UI
  build() {
    ////使用相对复杂,但功能强大
    NavDestination() {//Navigation的子组件
      Column() {
        Text('欢迎使用Navigation组件').fontColor(Color.Blue).fontSize(25).height(60)
        Text('接收到的信息：' + this.info).fontColor(Color.Green).fontSize(20)

      }.width('100%')
      //.height('100%')
    }.onReady((context: NavDestinationContext) => {
      //获取上一组件传过到的路径栈对象,功能强大
      this.navstack = context.pathStack;
      let temp = this.navstack.getParamByName('info') as string[];
      //获取上一组件传过到参数值，在字符串数组的第一个元素中
      this.info = temp[0];
    })
    //导航子组件标题
    .title('Navigation导航组件')
  }
}