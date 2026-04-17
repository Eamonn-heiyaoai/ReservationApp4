////这里为备份文件，用于通用请求设置////
////导入系统的http库
import http from '@ohos.net.http';
//import { BusinessError } from '@ohos.base';
//发格式：定义请求配置接口,就是一个简单对象
export interface RequestConfig {//接口类，只有属性
  url: string;
  method?: http.RequestMethod;//?表示此属性值为空
  header?: Record<string, string>;
  extraData?: Record<string, Object>;//post方法传递的对象，?表示此属性值为空
  connectTimeout?: number; // 单位：毫秒，?表示此属性值为空，延时设置
  readTimeout?: number; // 单位：毫秒，?表示此属性值为空，延时设置
}
//接收格式：定义通用的响应数据结构，服务返回的格式
export interface ApiResponse<T> {//接口类，只有属性
  code: number;//200,500,404,401
  message: string;//返回的提示文字
  data: T;//不确定的数据类型，通用的类型，代表任意类型
}
//工具类，实现网络通信
class NetworkManager {
  private static instance: NetworkManager;
  //json-server服务器的地址,可能要改成为ip地址
  private baseUrl: string = 'http://127.0.0.1:3000/'; // 替换为你的基础URL
  // 私有构造函数，防止外部直接实例化
  private constructor() {}
  // 获取当前类的单例对象
  public static getInstance(): NetworkManager {
    if (!NetworkManager.instance) {
      NetworkManager.instance = new NetworkManager();
    }
    return NetworkManager.instance;
  }
  /**
   * 一、发送请求的方法
   * 这里用到了同步方法async与异步请求Promise<ApiResponse<T>>
   * 与awit结合使用，表示将异步转换同步方式执行，让代码按顺序
   */
  async request<T>(config: RequestConfig): Promise<T> {//返回正常与错误信息
    // 1. 构建完整的 URL
    const fullUrl = config.url.startsWith('http') ? config.url :
      `${this.baseUrl}${config.url}`;
    ///////// 2. 创建 HttpRequest对象//////
    let httpRequest = http.createHttp();
    // 3. 设置请求头（可以在这里统一添加 Token 等公共参数）
    const headers = config.header || {};
    // 例如：统一添加 Token
    // headers['Authorization'] = 'Bearer ' + getToken();
    try {
      // 4. 发起请求,获取响应对象，一直等待服务返回数据给response，才执行下边的代码
      const response = await httpRequest.request(fullUrl, {
        method: config.method || http.RequestMethod.GET,
        header: headers,
        extraData: config.extraData,
        connectTimeout: config.connectTimeout || 10000, // 默认10秒
        readTimeout: config.readTimeout || 10000, // 默认10秒
      });
      // 5. 处理响应
      if (response.responseCode === 200) {
        // 这里假设后端返回的数据结构是 ApiResponse<T>
        // 如果后端直接返回data数组或对象，需要根据实际情况调整
        let result = response.result as T;
        //正常返回的值
        return result;
      } else {
        //这个类负责处理底层的 HTTP 调用，并统一处理 Promise 异步逻辑。
        // 处理 HTTP 错误状态码
        console.error('Network Error:', response.responseCode);
        //中止执行,返回错误信息
        throw new Error(`HTTP Error: ${response.responseCode}`);
      }
    } catch (err) {
      // 6. 统一错误处理
      console.error('Request Failed:', JSON.stringify(err));
      //出现异常，返回错误
      throw new Error(err);
    } finally {
      // 7. 销毁请求对象，释放资源
      httpRequest.destroy();
    }
  }
  /**
   * 二.GET 请求快捷方法
   */
  get<T>(url: string, params?: Record<string, string>, header?: Record<string,
  string>): Promise<T> {
    // 简单处理URL参数拼接
    let fullUrl = url;
    if (params) {
      const queryString = Object.keys(params)
        .map(key => `${key}=${params[key]}`)
        .join('&');
      fullUrl += (url.includes('?') ? '&' : '?') + queryString;
    }
    return this.request<T>({
      url: fullUrl,
      method: http.RequestMethod.GET,
      header: header
    });
  }
  /**
   * 三.POST 请求快捷方法
   */
  post<T>(url: string, data?: Record<string, Object>, header?: Record<string,
  string>): Promise<T> {
    return this.request<T>({
      url: url,
      method: http.RequestMethod.POST,
      extraData: data,
      header: header
    });
  }
}
// 导出单例对象
export const httpManager = NetworkManager.getInstance();