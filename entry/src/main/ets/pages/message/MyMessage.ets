//显示一系列新闻咨讯
//导入场馆动态组件，直接在此网页中单独渲染
import Message from './Message'
//导入参数实体类
import MyParams from '../../entity/MyParams'
//导入News类
import News from '../../entity/News'

//通过路由直接打开的页面
@Entry
  //Entry组件装饰器,直接渲染内容
@Component
  //自定义组件装饰器
struct MyMessage {
  //在组件将要显示自动执行此方法，只执行一次
  //用于初始化数据
  aboutToAppear(): void {
    ////接收上一页传递的所有路由参数,并强转MyParams对象
    let params = this.getUIContext().getRouter().getParams() as MyParams;
    //直接输出索引号
    console.log('------myIndex:' + params.myIndex);
    //获取关联对象,并通过as强转为News对象
    let news = params.obj as News
    //输出新闻咨讯
    console.log('------news:' + news.info);
  }

  //生成UI
  build() {
    //最外层必须有一个布局容器组件
    Column() {
      //使用Message组件
      Message();
    }
  }
}