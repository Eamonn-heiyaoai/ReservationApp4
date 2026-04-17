/**
 * 数据库用户管理：实现用户的增删改查C(create)U(update)R(reseach)D(delete)
 * 查询：自定义返回值，可以是记录的id号，也可以是数组等
 * 添加：返回的是最后一条记录的记录号
 * 删除与更新：一律返回的记录条数
 */
import { relationalStore } from '@kit.ArkData'
import User from '../entity/User';
import DBTools from './DBTools'
import { BusinessError } from '@kit.BasicServicesKit';

export default class UserDao {
  //1.实现用户登录,此方法要获取数据库的返回值,要用到Promise<泛型>类对象,返回手机号以便之后查询报名信息
  public static login(username: string, password: string): Promise<string> { //返回异步对象传入记录条数
    //let store:relationalStore.RdbStore=DBTools.getStore();
    //获取数据库操作对象
    let store = DBTools.getStore();
    //创建设置条件的对象，传入查询的表
    let pre = new relationalStore.RdbPredicates('user');
    //设置用户名匹配的值
    pre.equalTo('username', username);
    //设置密码匹配的值
    pre.equalTo('password', password);
    //返回异步对象，可以做同步操作(正常返回的对象,查询错误的对象)
    return new Promise<string>((resolve, reject) => { //以下代码执行完成后返回对象Promise<number>
      //设置一个整型变量,用于保存查询成功的用户id号
      let temp = ''; //空白表示未查到
      //链接式代码方式
      store.query(pre).then((rs) => { //rs结果集对象
        if (rs.goToNextRow()) {
          //取出查到用户信息
          //rs.getString(rs.getColumnIndex("username"))
          //rs.getString(rs.getColumnIndex("password"))
          let id = rs.getLong(rs.getColumnIndex("id"));
          let mobile = rs.getString(rs.getColumnIndex("mobile"))
          let user = new User(username, password, mobile, id);
          //缓存用户对象到本地，以便下次取出修改
          AppStorage.setOrCreate<User>('user', user);
          //缓存用户名到本地，用于判断是否登录或输出用户名
          AppStorage.setOrCreate<string>('username', username);
          //缓存手机号到本地，用于报名
          AppStorage.setOrCreate<string>('mobile', mobile);
          //取用户名
          //比如：AppStorage.get<string>('username') as string;
          temp = mobile;
        }
        //返回值,查询正常：正整数(查到)，负数(用户不存在)
        resolve(temp);
      }).catch((err: BusinessError) => {
        //系统异常
        reject(err);
      })
    })
  }

  //2.1 用户注册
  public static register(user: User): Promise<number> {
    //获取数据库操作对象
    let store = DBTools.getStore();
    //创建要添加到表中的对象,是SQLite接收ValuesBucket对象
    let us: relationalStore.ValuesBucket = {
      username: user.username,
      password: user.password,
      mobile: user.mobile
    }
    //判断用户是否存在，请到UI中直接调用
    //return store.insert("表名",对象)
    return store.insert("user", us);
  }


  //2.2 用户注册前查询用户是否存在,请与注册进行整合
  public static judgeUsername(username: string): Promise<boolean> {
    //获取数据库操作对象
    let store = DBTools.getStore();
    //创建设置条件的对象，传入查询的表
    let pre = new relationalStore.RdbPredicates('user');
    //设置用户名匹配的值
    pre.equalTo('username', username);
    return new Promise<boolean>((resolve, reject) => {
      let flag = false; //代表用户不存在
      store.query(pre).then((rs) => {
        if (rs.goToNextRow()) {
          flag = true; //用户存在
        } else {
          flag = false; //用户不存在
        }
        //返回布尔值
        resolve(flag);
      }).catch((err: BusinessError) => {
        reject(err);
      })
    })
  }

  ////3.通过id更新数据
  static updateById(id: number, user: User): Promise<number> {
    let pd = new relationalStore.RdbPredicates('USER');
    //根据id号来修改
    pd.equalTo('id', id);
    //修改内容
    let data: relationalStore.ValuesBucket = {
      username: user.username,
      password: user.password,
      mobile: user.mobile
    }
    ////传入数据、条件,正常返回记录条数,否则返回-1
    return DBTools.getStore().update(data, pd);
  }

  //////以下代码用作参考///////
  //查询所有
  static queryAll(): Promise<Array<User>> {
    let pd = new relationalStore.RdbPredicates('USER');
    return new Promise<Array<User>>((resolve, reject) => {
      DBTools.getStore().query(pd).then((rs) => {
        let users = Array<User>();
        while (rs.goToNextRow()) {
          let user = new User(
            rs.getString(1),
            rs.getString(2),
            rs.getString(3)
          )
          users.push(user);
        }
        //解析正确的数据
        resolve(users);
      }).catch((err: BusinessError) => {
        reject(err);
      })
    })
  }

  //删除记录:通过id
  static deleteById(id: number) { //:Promise<number>
    let pd = new relationalStore.RdbPredicates('USER');
    pd.equalTo('id', id);
    //传入删除条件,正常返回记录条数,否则返回-1
    return DBTools.getStore().delete(pd);
  }
}