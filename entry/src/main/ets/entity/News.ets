/**
 * 运动咨讯实体：包含有场馆动态Message与运动常识Know内容
 */
export default class News {
  pic: string;//图片
  title: string;//标题
  info: string;//显示信息(内容)
  date: string;//发布日期,此处用字符串表示'2026-04-15'
  //构造函数
  constructor(pic: string, title: string, info: string, date: string) {
    this.pic = pic;
    this.title = title;
    this.info = info;
    this.date = date;
  }
}