import ddf.minim.*;

Minim minim;
AudioPlayer music;//音楽
AudioSample se;//効果音
PImage img;//アルバムアート


//config系
float speed=800.0;//ノーツの落下速度[px/s]
int fps=60;//フレームレート
boolean se_on=true;//SE有効/無効
char [] keyconfig={' ','a','f','j',';'};//キーコンフィング
int judgelevel=8;//判定の厳しさ
float gscore=0.7f;//fast,late時のscore
int volume=-10;//音量を調整[db]
int adjust=0;//判定調整[ms]

//曲データ系 playの描画に関係
int bpm;
float jlineY;//判定ラインのy座標
int endtime;//曲の小節数
float offset=2.50;//オフセット(秒数)

//実行中のデータ保存用
boolean [] keys=new boolean[5];
boolean [] keyflags={true,true,true,true,true};
boolean [] keypressing=new boolean[5];
boolean [] keyrelease=new boolean[5];
int startf=0;//曲開始時のフレーム
int frame;//曲開始からのフレーム数
int last_se;//SEのクールタイム
float score=0;//
int combo=0;
int maxscore=0;
int maxcombo=0;
int judges[]={0,0,0};
float Notes[][];
int scene=0;
int select=0;
int cursor=0;
Song [] Songs = new Song[4];

void setup(){
  size(600,800);
  //fullScreen();
  
  Load_config();
  frameRate(fps);
  jlineY=height*5/6;
  minim = new Minim(this);
  music=minim.loadFile("random.mp3");
  se = minim.loadSample("SE.mp3");
  se.setGain(-10);
  setsongs();
  
}

void draw(){
  if(scene==0){
    title();
  }else if(scene==1){
    musicselect();
  }else if(scene==2){
    play();
  }else if(scene==3){
    result();
  }else if(scene==4){
    config();
  }
}

void keyPressed(){
  //エンターキーの処理
  if(key==ENTER){
    switch(scene){
      case 0://楽曲選択へ進む
        scene=1;
      break;
      
      case 1://楽曲選択&リトライ
      case 3:
      if(select==0){
        select=(int)random(Songs.length-1)+1;
      }
      load(Songs[select]);
      scene=2;
      break;
      
      case 2://プレイ中断
      scene=3;
      music.close();
      Save_config();
      break;
      
      case 4:
      speed=800.0;
      adjust=0;
      fps=60;
      frameRate(fps);
      judgelevel=8;
      volume=-10;
      music.setGain(volume);
      se_on=true;
      break;
    }
  }
  
  if(key==' '){
    switch(scene){
      
      case 1://configを開く
      scene=4;
      break;
      
      case 3://楽曲選択へ戻る
      scene=1;
      music = minim.loadFile(Songs[select].filename);  //button01a.mp3をロードする
      music.setGain(volume);
      music.play();  //再生
      break;
      
      case 4://configを閉じる
      scene=1;
      Save_config();
      break;
    }
  }
  //選曲画面
  if(scene==1){
    
    switch(keyCode){
      case UP:
      select-=2;
      case DOWN:
      select++;
      if(music.isPlaying())music.close();
      select=(select+Songs.length)%Songs.length;
      if(select!=0){
        music = minim.loadFile(Songs[select].filename);  //button01a.mp3をロードする
        music.setGain(volume);
        music.play();  //再生
      }
    }
  }
  
  else if(scene==2){
    switch(keyCode){
      case UP:
          adjust=min(990,adjust+10);
      break;
      
      case DOWN:
        adjust=max(-990,adjust-10);
      break;
      
      case RIGHT:
          speed=min(2000,speed+10);
      break;
      
      case LEFT:
        speed=max(10,speed-10);
      break;
    }
  }
  
  //config画面
  else if(scene==4){
    if(keyCode==UP)cursor--;
    if(keyCode==DOWN)cursor++;
    cursor=(cursor+6)%6;
    if(keyCode==RIGHT){
      switch(cursor){
        case 0:
          speed=min(2000,speed+10);
        break;
        case 1:
          adjust=min(990,adjust+10);
        break;
        case 2:
          fps=min(120,fps+1);
          frameRate(fps);
        break;
        case 3:
          judgelevel=min(15,judgelevel+1);
        break;
        case 4:
          volume=min(10,volume+1);
          music.setGain(volume);
        break;
        case 5:
          se_on=!se_on;
        break;
      }
    }
    if(keyCode==LEFT){
      switch(cursor){
        case 0:
          speed=max(10,speed-10);
        break;
        case 1:
          adjust=max(-990,adjust-10);
        break;
        case 2:
          fps=max(15,fps-1);
          frameRate(fps);
        break;
        case 3:
          judgelevel=max(1,judgelevel-1);
        break;
        case 4:
          volume=max(-30,volume-1);
          music.setGain(volume);
        break;
        case 5:
          se_on=!se_on;
        break;
      }
    }
  }
  
  //play中
  for(int i=0;i<keyconfig.length;i++){
    if(key==keyconfig[i]){
      if(keyflags[i])keys[i]=true;
      keyflags[i]=false;
      keypressing[i]=true;
    }
  }
}


void keyReleased() {
  for(int i=0;i<keyconfig.length;i++){
    if(key==keyconfig[i]){
      keyflags[i]=true;
      keyrelease[i]=true;
      keypressing[i]=false;
    }
  }
}

void SE(){
  if(se_on&&(frameCount-last_se>bpm/60)){
    se.trigger();
    se.setGain(volume-10);
    last_se=frameCount;
  }
}

//以下はシーンに関する処理
