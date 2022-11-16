
class RemoteRecord {
  RemoteRecord(this.boardstate, this.mov, this.victory, this.matchid);

  String boardstate;
  String mov;
  String victory;
  String matchid;


  @override
  String toString() {
    return 'bs:${boardstate} mov:${mov} v:${victory} id:${matchid}';
  }
}