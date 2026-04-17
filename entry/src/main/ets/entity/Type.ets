/**
 * 场馆类型实体类
 */
export default class Type {
  pic: string;//图片
  title: string;//标题
  info: string;//场馆动态信息
  tips: string//提示
  //构造函数
  constructor(pic: string, title: string, info: string, tips: string) {
    this.pic = pic;
    this.title = title;
    this.info = info;
    this.tips = tips;
  }
}