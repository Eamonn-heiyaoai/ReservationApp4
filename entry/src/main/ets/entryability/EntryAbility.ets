import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
// 导入SQLite中数据库管理工具
import {relationalStore} from '@kit.ArkData'
import Player from '../entity/Player';
import DBTools from '../utils/DBTools';
const DOMAIN = 0x0000;
//应用能力组件：加载主页组件文件index.ets，用于管理UI，加载数据库，网络通信等初始
export default class EntryAbility extends UIAbility {
  ///////以下为当前组件的生命周期函数,共有6个///////
  //1.初建组件
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }
  //2.创建UI
  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    //////////////数据库管理//////////////
    //数库的配置对象
    const STORE_CONFIG :relationalStore.StoreConfig= {
      name: 'res.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别S1,S2,S3,S4,S5
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      customDir: 'jldx/rdb', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      isReadOnly: false //可读可写，可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };
    //让配置生效,同时获取数据库操作对象rdbStore(上下文对象,数库的配置对象,回调函数获取数据库操作对象(err,store)=>{})
    relationalStore.getRdbStore(this.context,STORE_CONFIG,(err,store)=>{
      if(err){//如果系统有误，则执行此处的代码中断程序执
        console.log(err.message)
        return;
      }
      //store对象需要保存到外部，再由其它页面组件实现CURD
      DBTools.setStore(store);
      //如果没有错误，则拿到数据库操作对象rdbStore,这里是store
      //创建两个sql语句
      //创建用户表
      const CREATE_USER_TABLE =
        'CREATE TABLE IF NOT EXISTS USER(ID INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT NOT NULL, PASSWORD TEXT NOT NULL,MOBILE TEXT NOT NULL)';
      //创建预约报名用户表venue地点
      const CREATE_PLAYER_TABLE =
        'CREATE TABLE IF NOT EXISTS Player(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT NOT NULL, GENDER TEXT NOT NULL,MOBILE TEXT NOT NULL,' +
          'VENUE TEXT NOT NULL,PDATE TEXT NOT NULL,STATE TEXT NOT NULL)';
      //建表
      store.executeSql(CREATE_USER_TABLE);
      store.executeSql(CREATE_PLAYER_TABLE);
      //user表添加了一次性添加两条记录，player表添加了一条记录
      //初始化两条记录
      let user1:relationalStore.ValuesBucket={
        'id':1000,
        'username':'tom',
        'password':'1234',
        'mobile':'13601234567'
      }
      let user2:relationalStore.ValuesBucket={
        'id':1001,
        'username':'bean',
        'password':'1234',
        'mobile':'13901234567'
      }
      let us:relationalStore.ValuesBucket[]=[user1,user2];
      //批量添加用户记录
      store.batchInsert('USER',us,(err,rowId)=>{
        if(err){//如果有误直接退出
          return;
        }
        console.log("===成功初始化用户表记录:"+rowId)
      });
      //第二个表
      let player=new Player('汤姆','男', '13601234567', '健身馆预约', '2025-7-13');
      //初始化tom用户的预约报名表
      let player1:relationalStore.ValuesBucket={
        'id':2000,//索引号或列号0
        'name':player.name,//索引号1
        'gender':player.gender,//索引号2
        'mobile':player.mobile,//索引号3
        'venue':player.venue,//索引号4
        'pdate':player.pdate,//索引号5
        'state':player.state//索引号6
      }
      store.insert('PLAYER',player1,(err,rowId)=>{
        if(err){
          return;
        }
        console.log("===成功初始化报名表记录:"+rowId)
      })

    })
    /////////////////加载主页文件/////////////////
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }
  //3.销毁窗口
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }
   //4.前台运行程序
  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }
   //5.后台运行程序
  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
  //6.销毁应用
  onDestroy(): void {
    //在此函数可以清空
    AppStorage.clear();
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }
}