import http from '@ohos.net.http'
import Quick from '../entity/Quick';
import User from '../entity/User';
import { httpManager } from './bakMyHttp';

/**
 * @Date 2026-04-17
 * @Author 天涯
 * @Email t8899@sina.com
 * 与后台服务器交互的网络请求
 * http封装各种方法，实现get/post/delete/put请求
 * 请将以下代码封装为通用方式：结合async(同步)与await及Promise异步对象，实现异步方式同步执行。
 */
export default class MyHttp {
  //通用的IP地址，在Previewer中可用，手机模拟器不可用。
  // private static baseUrl: string = 'http://127.0.0.1:3000/'
  ////这里用ipconfig查询到真实IP后，改为你自己的IP地址，手机模拟器可用。
  // private static baseUrl: string = 'http://192.168.43.5:3000/'
  // private static baseUrl: string = 'http://192.168.110.116:3000/'
  private static baseUrl: string = 'http://10.5.86.185:3000/'
  /**
   * 1.实现网络请求，查询金刚区所有图片文件
   */
  static getAllImages(): Promise<Array<Quick>> {
    return new Promise<Array<Quick>>((resolve, reject) => {
      //创建请求对象
      let httpRequest = http.createHttp();
      //服务器中表的地址
      httpRequest.request(MyHttp.baseUrl + 'quicks', {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        },
        connectTimeout: 3000,
        readTimeout: 3000
      }, //取数据
        (err, data) => {
          if (err) {
            reject(err);
          } else {
            //创建数组
            let quicks: Array<Quick> = [];
            quicks = JSON.parse(data.result.toString());
            //返回的数据
            resolve(quicks);
          }
        }
      )
    })
  }

  /**
   * 2.用户登录,在服务中添加数据
   */
  static login(username: string, password: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      let httpRequest = http.createHttp();
      // ✅ 修改：使用查询字符串传递参数
      const params: Record<string, string> = {
        'username':username
      };
      let fullUrl = MyHttp.baseUrl + 'user';
      if (params) {
        const queryString = Object.keys(params)
          .map(key => `${key}=${params[key]}`)
          .join('&');
        fullUrl += (MyHttp.baseUrl.includes('?') ? '&' : '?') + queryString;
      }
      httpRequest.request(
        fullUrl,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json'
          },
          connectTimeout: 3000,
          readTimeout: 3000
        },
        (err, data) => {
          if (err) {
            reject(err)
            return;
          }
          // resolve(fullUrl)
          // resolve(data.result.toString() + fullUrl)
          let temp = JSON.parse(data.result.toString()) as Array<User>;
          // resolve(temp[0].password)
          // resolve(data.result.toString() + fullUrl)
          let i = 0;
          for(i;i<temp.length;i++){
            if (temp[i].password == password) {
              // 存储用户信息
              AppStorage.setOrCreate<User>("user", temp[i]);
              AppStorage.setOrCreate<string>('username', temp[i].username);
              AppStorage.setOrCreate<string>('mobile', temp[i].mobile);
              AppStorage.setOrCreate<number>('Id', temp[i].id);
              resolve('ok')
              break;
            }
          }
          resolve('用户名或密码有误')
        }
      )
    })
  }


  /**
   * 3.用户注册
   */
  static register(user: User): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      let httpRequest = http.createHttp();

      httpRequest.request(MyHttp.baseUrl + 'user', {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        // ✅ 修改：extraData 应该是 JSON 字符串
        extraData: JSON.stringify({
          username: user.username,
          password: user.password,
          mobile: user.mobile
        }),
        connectTimeout: 3000,
        readTimeout: 3000
      }, (err, data) => {
        if (err) {
          reject(err)
          return;
        }

        // ✅ 修改：POST 成功返回的是创建的对象，不是数组
        let createdUser = JSON.parse(data.result.toString()) as User;
        // resolve(data.result.toString())
        // resolve(createdUser.username)
        // 检查是否有 id 属性，说明创建成功
        if (createdUser && createdUser.id) {
          resolve('ok')
        } else {
          resolve('用户注册有误')
        }
      })
    })
  }
  /////////////////以下实现更新方法///////////////////
   /**
    * 4.通过http实现用户资料修改
    */
  static updateById(id: number, user: User): Promise<string>{
    return new Promise<string>((resolve, reject) => {
      let httpRequest = http.createHttp();

      const updateData: Record<string, Object> = {};
      if (user.username) updateData.username = user.username;
      if (user.password) updateData.password = user.password;
      if (user.mobile) updateData.mobile = user.mobile;

      httpRequest.request(
        MyHttp.baseUrl + `user/${id}`,
        {
          method: http.RequestMethod.PUT,
          header: {
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify(updateData),
          connectTimeout: 3000,
          readTimeout: 3000
        },
        (err, data) => {
          if (err) {
            console.error('HTTP 请求失败：', JSON.stringify(err));
            reject(err);
            return;
          }
          let updatedUser = JSON.parse(data.result.toString()) as User;
          if (updatedUser && updatedUser.id === user.id) {
            resolve('ok');
          } else {
            resolve('用户信息更新异常');
          }
      })
    })
  }
}