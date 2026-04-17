/**
 * 使用App的用户:也可能是Player
 */
export default class User {
  //用户编号
  id: number = 0;
  //用户名
  username: string;
  //密码
  password: string;
  //手机
  mobile: string;
  ////通过可选参数方式实现多个构造函数方式,此处id?号可选(表示可以为空)////
  constructor(username: string, password: string, mobile: string, id?: number) {
    this.username = username;
    this.password = password;
    this.mobile = mobile;
    ////可选的判断,也就是为空的判断
    if (id != undefined) {
      this.id = id;
    }
  }
}