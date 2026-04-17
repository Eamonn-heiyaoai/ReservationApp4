/**
 * 数据库工具类：存取数据库操作对象store
 * relationalStore: 关系型数据库操作对象,用于连接数据库，并实现CURD
 * 类似于jdbc中的Connection对象
 */
import { relationalStore } from '@kit.ArkData'

export default class DBTools {
  //声明静态的数据库操作对象,实现数据库连接
  private static mystore: relationalStore.RdbStore;

  //声明方法存store对象,用于打开数据库
  public static setStore(store: relationalStore.RdbStore) {
    DBTools.mystore = store;
  }

  //声明方法取store对象
  public static getStore(): relationalStore.RdbStore {
    return DBTools.mystore;
  }

  //关闭数据库对象，以便从内存清空
  public static closeRdb() {
    //如果对象不为空,或有定义
    if (DBTools.mystore != null && DBTools.mystore != undefined) {
      DBTools.mystore.close();
    }
  }
}