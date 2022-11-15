
class RemoteRecord {
  RemoteRecord(this.boardstate, this.mov, this.matchid);

  String boardstate;
  String mov;
  String matchid;


  @override
  String toString() {
    return '${boardstate} ${mov} ${matchid}';
  }
}