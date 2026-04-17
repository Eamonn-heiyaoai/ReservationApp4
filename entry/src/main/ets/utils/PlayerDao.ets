import { relationalStore } from "@kit.ArkData";
import Player from "../entity/Player";
import DBTools from "./DBTools";
import { BusinessError } from "@kit.BasicServicesKit";

/**
 * 预约报名表管理
 * 查询：自定义返回值，可以是记录的id号，也可以是数组等
 * 添加：返回的是最后一条记录的记录号
 * 删除与更新：一律返回的记录条数
 */
export default class PlayerDao {
  ////1.添加记录,返回id号,实现注册
  static register(player: Player): Promise<number> { //返回异步对象
    let data: relationalStore.ValuesBucket = {
      'name': player.name, //姓名
      'gender': player.gender, //性别
      'mobile': player.mobile, //手机
      'venue': player.venue, //场馆
      'pdate': player.pdate, //预约日期
      'state': player.state//预约状态
    }
    //返回记录号,否则返回-1
    return DBTools.getStore().insert('PLAYER', data);
  }

  ////2.查询手机用户的所有预约信息
  static queryAll(mobile:string): Promise<Array<Player>> {
    let pd = new relationalStore.RdbPredicates('PLAYER');
    pd.equalTo('mobile',mobile);
    return new Promise<Array<Player>>((resolve, reject) => {
      DBTools.getStore().query(pd).then((rs) => {
        let players = Array<Player>();
        while (rs.goToNextRow()) {
          let player = new Player(//或rs.getString(1)
            rs.getString(rs.getColumnIndex('name')),
            rs.getString(rs.getColumnIndex('gender')),
            rs.getString(rs.getColumnIndex('mobile')),
            rs.getString(rs.getColumnIndex('venue')),
            rs.getString(rs.getColumnIndex('pdate'))
          )
          players.push(player);
        }
        //返回异步数组对象,不为空,长度>=0
        resolve(players);
      }).catch((err: BusinessError) => {
        reject(err);
      })
    })
  }
}