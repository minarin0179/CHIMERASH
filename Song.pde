
public class Song{//楽曲のデータクラス
  String name;//曲名
  String filename;//dataフォルダー内でのファイル名
  String album;
  String composer;//作曲者の名前
  String producer;//譜面製作者の名前
  int bpm;//曲のbpm
  int diff;//難易度
  int endtime;//曲の総小節数
  float offset;//曲の前の空白
  float [][]musicalscore;
  int maxscore=0;
  
  
  Song(String n,String f,String a,String c,String p,int b,int d,int e,float o,float m[][]){
    name=n; filename=f; album=a; composer=c; producer=p; bpm=b; diff=d; endtime=e; offset=o;  
    musicalscore=m;
    for(int i=0;i<m.length;i++){
      switch((int)m[i][1]){
        case 5:
        case 6:
        case 7:
        case 8:
        case 10:
        maxscore++;
        case 1:
        case 2:
        case 3:
        case 4:
        case 9:
        maxscore++;
        break;
      }
    }
  }
}
