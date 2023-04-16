
void Load_config(){
  Table data;
  
  data=loadTable("config.csv");
  
  speed=data.getFloat(0,1);
  adjust=data.getInt(1,1);
  fps=data.getInt(2,1);
  judgelevel=data.getInt(3,1);
  volume=data.getInt(4,1);
  se_on=data.getInt(5,1)!=0;
}


void Save_config(){
  PrintWriter config;
  
  config=createWriter("data/config.csv");
  
  config.println("Speed,"+speed);
  config.println("Offset,"+adjust);
  config.println("Frame rate,"+fps);
  config.println("Judge Lv,"+judgelevel);
  config.println("volume,"+volume);
  int se_out =se_on?1:0;
  config.println("SE,"+se_out);
  config.flush();
  config.close();
}
