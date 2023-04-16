
void title(){
  background(0);
  textAlign(CENTER);
  textSize(100);
  text("CHIMERASH",width/2,height/2);
  textSize(30);
  if(frameCount%fps<=fps/2){
    text("press Enter to start",width/2,height*2/3);
  }
}

void musicselect(){
  background(0);
  textAlign(LEFT);
  textSize(70);
  text("Music Select",30,100);
  text(Songs[select].name,30,500);
  stroke(255);
  strokeWeight(3);
  line(30,520,30+textWidth(Songs[select].name),520);
  textSize(50);
  text("Music:"+Songs[select].composer,30,580);
  text("Chart:"+Songs[select].producer,30,640);
  if(select==0){
    text("BPM:???",30,700);
  }else{
    text("BPM:"+Songs[select].bpm,30,700);
  }
  textSize(30);
  text("Select:↑↓     Play:Enter     Config:Space",30,770);
  rect(550,300,-250,50);
  rect(565,385,-200,40);
  rect(565,225,-200,40);
  rect(580,460,-150,30);
  rect(580,160,-150,30);
  fill(0);
  textSize(40);
  text(Songs[select].name,310,345);
  textSize(30);
  text(Songs[(select+Songs.length-1)%Songs.length].name,375,260);
  text(Songs[(select+1)%Songs.length].name,375,420);
  textSize(20);
  text(Songs[(select+Songs.length-2)%Songs.length].name,435,185);
  text(Songs[(select+2)%Songs.length].name,435,485);
  fill(255);
  rect(29,149,241,241);
  fill(0);
  textAlign(CENTER);
  text("NO IMAGE",150,height/2-115);
  fill(255);
  img=loadImage(Songs[select].album);
  image(img,30,150,240,240);
}

void result(){
  background(0);
  fill(255);
  textAlign(LEFT);
  textSize(60);
  text("Result",30,100);
  
  text(Songs[select].name,30,200);
  strokeWeight(3);
  line(30,210,30+textWidth(Songs[select].name),210);
  
  
  ellipse(420,400,250,250);
  float rate=(float)round(1000*score/maxscore)/10;
  String rank="E";
  if(rate>20)rank="D";
  if(rate>40)rank="C";
  if(rate>60)rank="B";
  if(rate>80)rank="A";
  if(rate>90)rank="S";
  
  fill(0);
  textSize(40);
  textAlign(CENTER);
  text("Rank",420,330);
  textSize(180);
  text(rank,420,480);
  
  fill(255);
  if(score==maxscore){
    textSize(60);
    text("~Perfect~",420,590);
  }else if(maxcombo==maxscore){
    textSize(50);
    text("~Full Combo~",420,590);
  }
  
  textSize(30);
  text("Max Combo:"+maxcombo,420,650);

  
  textAlign(LEFT);
  fill(255);
  textSize(70);
  text(rate+"%",30,350);
  
  textSize(40);
  text("Perfect:"+judges[0],30,470);
  fill(0,0,255);
  text("Fast:"+judges[1],30,530);
  fill(255,0,0);
  text("Late:"+judges[2],30,590);
  fill(128);
  text("Miss:"+(maxscore-judges[0]-judges[1]-judges[2]),30,650);
  
  textSize(30);
  fill(255);
  text("Play Again:Enter      Select Music:Space",30,770);
}

void config(){
  background(0);
  fill(255);
  textAlign(LEFT);
  textSize(70);
  text("Config",30,100);
  
  
  textSize(50);
  text("Speed:",80,200);
  text("Offset:",80,300);
  text("Frame Rate:",80,400);
  text("Judge Lv:",80,500);
  text("Volume:",80,600);
  text("SE",80,700);
  
  textAlign(CENTER);
  text(round(speed)+".0",470,200);
  
  if(adjust>0) text("+"+adjust+"ms",470,300);
  else if(adjust==0) text("±0ms",470,300);
  else text(adjust+"ms",470,300);
  
  text(fps+"fps",470,400);
  
  text("Lv."+judgelevel,470,500);
  
  if(volume>=0) text("+"+volume+"db",470,600);
  else text(volume+"db",470,600);
  
  if(se_on) text("ON",470,700);
  else text("OFF",470,700);
  
  textSize(30);
  textAlign(LEFT);
  text("Exit:Space     Reset:Enter",80,770);
  
  if(frameCount%fps<=fps/2){
    triangle(33,160+cursor*100,33,200+cursor*100,63,180+cursor*100);
  }
  
  triangle(560,163+cursor*100,560,203+cursor*100,580,183+cursor*100);
  triangle(380,163+cursor*100,380,203+cursor*100,360,183+cursor*100);
}


void load(Song data){
  Notes=new float[data.musicalscore.length][3];
  //System.arraycopy(data.musicalscore,0,Notes,0,data.musicalscore.length);//譜面データをNotesにコピー
  //Notes=data.musicalscore.clone();
  for(int i=0;i<data.musicalscore.length;i++){
    for(int j=0;j<data.musicalscore[i].length;j++){
      Notes[i][j]=data.musicalscore[i][j];
    }
  }
  for(int i=0;i<judges.length;i++){
    judges[i]=0;
  }
  print(data.musicalscore[1][1]);
  bpm=data.bpm;
  maxscore=data.maxscore;
  endtime=data.endtime;
  offset=data.offset;
  endtime=data.endtime;
  
  startf=frameCount;
  score=0;//
  combo=0;
  maxcombo=0;
      
  
  if(music.isPlaying())music.close();
  music = minim.loadFile(data.filename);  //button01a.mp3をロードする
  music.setGain(volume);
  music.play();  //再生
  music.rewind();  //再生が終わったら巻き戻しておく
}
  
void play(){
  background(0);
  maxcombo=max(combo,maxcombo);
  frame=bpm*(frameCount-startf)/fps+(fps*adjust/1000);
  
  if(endtime*240+offset*bpm-frame<0){
    scene=3;
    Save_config();
  }//終わったらリザルトへ遷移
  
  //小節線の表示
  for(int i=0;i<endtime;i++){
    float y=-i*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;
    if(y<0)break;
    stroke(200);
    strokeWeight(1);
    line(0,y,width,y);
  }
  
  //ノーツの読み込みとノーツの種類ごとの処理
  for(int i=0;i<Notes.length;i++){
    int sw=(int)Notes[i][1];
    switch(sw){
      case -1://すでに判定済みのノーツは無視
      break;
      
      //タップノーツ
      case 1:
      case 2:
      case 3:
      case 4:
      float y=-Notes[i][0]*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;
      if(y<0)break;//画面外なら処理しない
      
      //判定内かつ該当キーが押されていたら
      if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel && keys[sw]){
        SE();
        keys[sw]=false;
        Notes[i][1]=-1;
        combo++;
        if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel/2){
          score++;
          judges[0]++;
          fill(255);
        }else if(Notes[i][0]*240+offset*bpm-frame>0){
          score+=gscore;
          judges[1]++;
          fill(0,0,255);
        }else{
          score+=gscore;
          judges[2]++;
          fill(255,0,0);
        }
          rect(width/4*(sw-1),0,width/4,jlineY);
          
      }
      if(Notes[i][0]*240+offset*bpm-frame <- bpm/judgelevel){
        Notes[i][1]=-1;
        combo=0;
      }
      
      stroke(255,0,0);
      strokeWeight(15);
      line(width/4*(sw-1),y,width/4*sw,y);
      stroke(255);
      strokeWeight(1);
      line(width/4*(sw-1),y,width/4*sw,y);
      break;
      
      //ホールドノーツ
      case 5:
      case 6:
      case 7:
      case 8:
      
      float sy=-Notes[i][0]*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;//ホールド始点の座標
      float ey=-Notes[i][2]*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;//ホールド終点の座標
      
      if(sy<0)break;
      
      if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel && keys[sw-4]){//ホールド始点のタップ判定
        SE();
        combo++;
        if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel/2){//perfect
          score++;
          judges[0]++;
          stroke(255);
        }else if(Notes[i][0]*240+offset*bpm-frame>0){//fast
          score+=gscore;
          judges[1]++;
          fill(0,0,255);
          stroke(0,0,255);
        }else{//late
          score+=gscore;
          judges[2]++;
          fill(255,0,0);
          stroke(255,0,0);
        }
      
        strokeWeight(12);
        line(width*(sw-5)/4,jlineY+12,width*(sw-4)/4,jlineY+12);
        fill(255);

      }
      if(abs(Notes[i][2]*240+offset*bpm-frame) < bpm/judgelevel && keyrelease[sw-4]){//ホールド終端の離した判定
        SE();
        Notes[i][1]=-1;
        combo++;
        if(abs(Notes[i][2]*240+offset*bpm-frame) < bpm/judgelevel/2){//perfect
          score++;
          judges[0]++;
          fill(0);
          stroke(255);
        }else if(Notes[i][2]*240+offset*bpm-frame>0){//fast
          score+=gscore;
          judges[1]++;
          fill(0,0,255);
          stroke(0,0,255);
        }else{//late
          score+=gscore;
          judges[2]++;
          fill(255,0,0);
          stroke(255,0,0);
        }
        noStroke();
        rect(width/4*(sw-5),0,width/4,jlineY);
        sy=jlineY;
      }else if(Notes[i][0]*240+offset*bpm<frame&&frame<Notes[i][2]*240+offset*bpm+bpm/judgelevel){//ホールドノーツ継続中に離した判定
        if(keyrelease[sw-4]){
          Notes[i][1]=-1;
          combo=0;
        }else if(keypressing[sw-4]){
          sy=jlineY;
          strokeWeight(12);
          stroke(255);
          line(width*(sw-5)/4,jlineY+5,width*(sw-4)/4,jlineY+5);
        }else if(Notes[i][0]*240+offset*bpm-frame < -bpm/judgelevel){//タップせずに通り過ぎた判定
          Notes[i][1]=-1;
          combo=0;
          sy=jlineY;
        }
      }
      if(Notes[i][2]*240+offset*bpm-frame < -bpm/judgelevel){//離さずに通り過ぎた判定
        Notes[i][1]=-1;
        combo=0;
        sy=jlineY;
        break;
      }
      
      fill(0,256,0,96);
      noStroke();
      rect(width/4*(sw-5),sy,width/4,min(0,ey-sy));
      break;
      
      //スペースタップ
      case 9:
      y=-Notes[i][0]*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;
      if(y<0)break;//画面外なら処理しない
      
      //判定内かつ該当キーが押されていたら
      if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel && keys[0]){
        SE();
        keys[0]=false;
        Notes[i][1]=-1;
        combo++;
        if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel/2){
          score++;
          judges[0]++;
          stroke(255);
        }else if(Notes[i][0]*240+offset*bpm-frame>0){
          score+=gscore;
          judges[1]++;
          stroke(0,0,255);
        }else{
          score+=gscore;
          judges[2]++;
          stroke(255,0,0);
        }
        strokeWeight(12);
        line(0,jlineY+5,width,jlineY+5);
      }
      if(Notes[i][0]*240+offset*bpm-frame <- bpm/judgelevel){
        Notes[i][1]=-1;
        combo=0;
        
      }
      
      stroke(0,90,181);
      strokeWeight(15);
      line(0,y,width,y);
      stroke(255);
      strokeWeight(1);
      line(0,y,width,y);
      break;
      
      //スペースホールド
      case 10:
      
      sy=-Notes[i][0]*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;//ホールド始点の座標
      ey=-Notes[i][2]*240*speed/bpm+frame*speed/bpm-offset*speed+jlineY;//ホールド終点の座標
      
      if(sy<0)break;
      
      
      if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel && keys[0]){//ホールド始点のタップ判定
        SE();
        combo++;
        if(abs(Notes[i][0]*240+offset*bpm-frame) < bpm/judgelevel/2){//perfect
          score++;
          judges[0]++;
        }else if(Notes[i][0]*240+offset*bpm-frame>0){//fast
          score+=gscore;
          judges[1]++;
          fill(0,0,255);
        }else{//late
          score+=gscore;
          judges[2]++;
          fill(255,0,0);
        }
      }
      if(abs(Notes[i][2]*240+offset*bpm-frame) < bpm/judgelevel && keyrelease[0]){//ホールド終端の離した判定
        SE();
        Notes[i][1]=-1;
        combo++;
        if(abs(Notes[i][2]*240+offset*bpm-frame) < bpm/judgelevel/2){//perfect
          score++;
          judges[0]++;
        }else if(Notes[i][2]*240+offset*bpm-frame>0){//fast
          score+=gscore;
          judges[1]++;
          fill(0,0,255);
        }else{//late
          score+=gscore;
          judges[2]++;
          fill(255,0,0);
        }
        sy=jlineY;
      }else if(Notes[i][0]*240+offset*bpm<frame&&frame<Notes[i][2]*240+offset*bpm+bpm/judgelevel){//ホールドノーツ継続中に離した判定
        if(keyrelease[0]){
          Notes[i][1]=-1;
          combo=0;
          
        }else if(keypressing[0]){
          sy=jlineY;
          strokeWeight(20);
          stroke(153,217,234);
          line(0,jlineY+10,width,jlineY+10);
          println(sw);
        }else if(Notes[i][0]*240+offset*bpm-frame < -bpm/judgelevel){//タップせずに通り過ぎた判定
          Notes[i][1]=-1;
          combo=0;
          sy=jlineY;
        }
      }
      if(Notes[i][2]*240+offset*bpm-frame < -bpm/judgelevel){//離さずに通り過ぎた判定
        Notes[i][1]=-1;
        combo=0;
        sy=jlineY;
        break;
      }
      fill(0,0,256,96);
      noStroke();
      rect(0,sy,width,ey-sy);
      fill(255);
      break; 
    }
  }
  
    for(int i=0;i<5;i++){
      keys[i]=false;
      keyrelease[i]=false;
    }
  field();
}


void field(){//ゲーム画面描画
  stroke(255);
  strokeWeight(1);
  fill(255);
  line(width/4 ,0 ,width/4 ,height);
  line(width/2 ,0 ,width/2 ,height);
  line(width*3/4 ,0 ,width*3/4 ,height);
  line(0 ,height*5/6 ,width ,height*5/6);
  textAlign(CENTER);
  textSize(50);
  text("combo:"+combo,width/2,height/2);
  for(int i=1;i<5;i++){
  text(keyconfig[i],width*(2*i-1)/8,jlineY);
  //text("F",width*3/8,jlineY);
  //text("J",width*5/8,jlineY);
  //text(";",width*7/8,jlineY);
  }
  
  textAlign(RIGHT);
  text((float)round(1000*score/maxscore)/10+"%",width,100);
  
  textAlign(LEFT,DOWN);
  textSize(30);
  text("speed:←"+speed+"→    Offset:↑↓"+adjust,10,780);
  
}
