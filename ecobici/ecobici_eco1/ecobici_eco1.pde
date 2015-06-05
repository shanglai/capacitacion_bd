
int def=700, scr_w=900, scr_h=600;
float lon_centro= -99.16968294, lat_centro=19.40754875;
float escala_w= 5500.0, escala_h=5500.0;
//int offset_w= scr_w/2, offset_h=scr_h/2;
int offset_w= 350, offset_h=scr_h/2;


String file_src="datgeo0.txt";
String estaciones_src="estaciones.csv";
int nViajes= 0, nEstaciones=0;
viaje[] viajes;
estacion[] estaciones;

int[][] colorEstaciones= {
  {
    0, 100, 0, 100
  }
  , {
    0, 200, 0, 100
  }
};

//color original: stroke(38, 162, 209);
int[][] colorViajes= {
  {0,36,143},
  {38,162,209},
  {255,0,0},
  {255,0,0},
  {128,0,0}
};


int contador=0, contadorMinutos=0, timeRate=20, epochRate=timeRate*2, frameRt=timeRate, minuteRate=round(epochRate/10);
int dia=0, timestamp=0;
int minutos=0,hrs=0,ultMin=0,ultHr=0;
String fecha="", hora="";

float fix_lon(float lon) {
  return ((-1)*(lon_centro-lon)*(escala_w))+(offset_w);
}
float fix_lat(float lat) {
  return ((lat_centro-lat)*(escala_h))+(offset_h);
}

int[][] viajesHora={
  {0,0},{0,0},{0,0},{0,0},{0,0}
};
/*{{1,100},{2,200},{3,300},{4,200},{5,100}};*/
int[][] colorViajesHora={
  {0,122,0},{0,143,0},{0,163,0},{0,184,0},{0,204,0}
};
int ultId=-1;
int totViajes=0;
  
class viaje {
  int id, dt, hr01, hr02, n;
  float lon01, lat01, lon02, lat02, dur_prom;
  viaje (int _id, int _dt, int _hr01, int _hr02, float _lon01, float _lat01, float _lon02, float _lat02, int _n, float _dur_prom) {
    dt=_dt; 
    hr01=_hr01; 
    hr02=_hr02;
    lon01=_lon01; 
    lat01=_lat01; 
    lon02=_lon02; 
    lat02=_lat02;
    n=_n; 
    dur_prom= _dur_prom;
    id=_id;
  }
  void printViaje() {
    println(id, dt, hr01, hr02, n, lon01, lat01, lon02, lat02, dur_prom);
  }
}

class estacion {
  int id;
  String tipo;
  float lon, lat;
  estacion(int _id, float _lon, float _lat, String _tipo) {
    id=_id; 
    lon=_lon; 
    lat=_lat; 
    tipo=_tipo;
  }
  void printEstacion() {
    println(id, tipo, lon, lat);
  }
}

void cargaViajes() {
  Table table= loadTable(file_src, "csv");
  nViajes= table.getRowCount();
  viajes= new viaje[nViajes];
  viaje v;
  int i=0;
  for (TableRow r : table.rows ()) {
    v= new viaje(i, r.getInt(0), r.getInt(1), r.getInt(2), fix_lon(r.getFloat(3)), fix_lat(r.getFloat(4)), fix_lon(r.getFloat(5)), fix_lat(r.getFloat(6)), r.getInt(7), r.getFloat(8));
    //v.printViaje();
    viajes[i]= v;
    i=i+1;
  }
  //Asigna la fecha del primer viaje del día. Por default es 2015-01-dt
  fecha="2015-01-"+String.format("%02d",viajes[0].dt);
  println(fecha);
}

void cargaViajesDia(int diaCarga) {
  //Patron del archivo: datosgeodiaXX
  String file="";
  if(diaCarga<1 || diaCarga>31) { diaCarga=1; } else {
    file= String.format("datosgeodia%02d",diaCarga);
  }
  Table table= loadTable(file, "csv");
  nViajes= table.getRowCount();
  viajes= new viaje[nViajes];
  viaje v;
  int i=0;
  for (TableRow r : table.rows ()) {
    v= new viaje(i, r.getInt(0), r.getInt(1), r.getInt(2), fix_lon(r.getFloat(3)), fix_lat(r.getFloat(4)), fix_lon(r.getFloat(5)), fix_lat(r.getFloat(6)), r.getInt(7), r.getFloat(8));
    //v.printViaje();
    viajes[i]= v;
    i=i+1;
  }
  //Asigna la fecha del primer viaje del día. Por default es 2015-01-dt
  fecha="2015-01-"+String.format("%02d",viajes[0].dt);
  println(fecha);
  totViajes= 0;
}

void cargaEstaciones() {
  Table table= loadTable(estaciones_src, "header,csv");
  nEstaciones= table.getRowCount();
  estaciones= new estacion[nEstaciones];
  estacion e;
  int i=0;
  for (TableRow r : table.rows ()) {
    e= new estacion(r.getInt(0), fix_lon(r.getFloat(1)), fix_lat(r.getFloat(2)), r.getString(3));
    //e.printEstacion();
    estaciones[i]= e;
    i=i+1;
  }
}

void calculaTiempos() {
  //fecha=String.format("2015-01-%02d",round(contador/epochRate/6/24)+1);
  minutos= round(contador/minuteRate)%60;
  hrs= round(contador/epochRate/6)%24;
  hora=String.format("%02d:%02d",hrs,minutos);
}

void dibujaDt() {
  fill(94,240,95);
  stroke(94,240,95);
  rect(25,20,140,65);
  fill(255);
  stroke(255);
  //text((round(contador/epochRate)), 10, 10);
  //text((round(contador/minuteRate)), 10, 20);
  textSize(18);
  text(fecha,30,40);
  text(hora,30,70);
}

void dibujaEstaciones() {
  int i;
  int x0, y0, tam=6;
  estacion e;
  for (i=0; i<nEstaciones; i++) {
    e= estaciones[i];
    //e.printEstacion();
    if (e.tipo.equals("BIKE")) {
      stroke(colorEstaciones[0][0], colorEstaciones[0][1], colorEstaciones[0][2], colorEstaciones[0][3]);
      fill(colorEstaciones[0][0], colorEstaciones[0][1], colorEstaciones[0][2], colorEstaciones[0][3]);
    } else {
      stroke(colorEstaciones[1][0], colorEstaciones[1][1], colorEstaciones[1][2], colorEstaciones[1][3]);
      fill(colorEstaciones[1][0], colorEstaciones[1][1], colorEstaciones[1][2], colorEstaciones[1][3]);
    }
    x0=round(e.lon-(tam/2));
    y0=round(e.lat-(tam/2));
    ellipse(x0, y0, tam, tam);
  }
}

void dibujaViajes() {
  int i;
  int j=0, k;
  String[] textos= new String[nViajes];
  //viaje v;
  int tam=6;
  int tiempo=round(contador/epochRate);
  int tiempoMin=round(contador/minuteRate);
  int x0=0, y0=0, xStep=0, yStep=0, nStep=0, totSteps=0;
  int totViajesHora=0;
  int[] nColor= new int[3];
  String texto="";
  //int ultId=-1;
  //println(ultId);
  for (viaje v : viajes) {
    /*if(v.hr01==tiempo &&) {*/
    nStep= tiempoMin-(v.hr01*10);
    totSteps=int(v.dur_prom);
    
    /*if (tiempo >= v.hr01 && tiempo <= v.hr02 && nStep <=totSteps && round(contador/epochRate/6/24)+1 == v.dt) {*/
    if (tiempo >= v.hr01 && tiempo <= v.hr02 && nStep <=totSteps) {
      if(v.n>5) { nColor= colorViajes[4]; } else { nColor= colorViajes[v.n-1]; }
      stroke(nColor[0],nColor[1],nColor[2],100);
      fill(nColor[0],nColor[1],nColor[2],100);
      line(v.lon01,v.lat01,v.lon02,v.lat02);
      xStep= round((v.lon02-v.lon01)/totSteps * nStep);
      yStep= round((v.lat02-v.lat01)/totSteps * nStep);
      x0= round(v.lon01 + xStep);
      y0= round(v.lat01 + yStep);
      stroke(nColor[0],nColor[1],nColor[2],255);
      fill(nColor[0],nColor[1],nColor[2],255);
      ellipse(round(x0-tam/2),round(y0-tam/2),tam,tam);
      textos[j]="contador " + contador + ", h01: " + v.hr01 + ", h02: " + v.hr02 + ", id: " + v.id + ", x: " + x0 + ", y: " + y0 + ", nStep: " + nStep + ", totSteps: " + totSteps + ", n: " + v.n;
      j=j+1;
      String x="";
      if(v.id > ultId) {
        totViajes= totViajes+v.n;
        if(hrs==ultHr) {
          totViajesHora= totViajesHora + v.n;
          viajesHora[4][1]= totViajesHora;
          x="igual";
        }
        else {
          viajesHora[0][0]=viajesHora[1][0]; viajesHora[0][1]=viajesHora[1][1];
          viajesHora[1][0]=viajesHora[2][0]; viajesHora[1][1]=viajesHora[2][1];
          viajesHora[2][0]=viajesHora[3][0]; viajesHora[2][1]=viajesHora[3][1];
          viajesHora[3][0]=viajesHora[4][0]; viajesHora[3][1]=viajesHora[4][1];
          viajesHora[4][0]=hrs;
          totViajesHora= v.n;
          viajesHora[4][1]= totViajesHora;
          ultHr=hrs;
          x="distinto";
        }
        ultId= v.id;
        println(ultHr,hrs,minutos,totViajesHora,x,v.n,ultId);
      }
      
    }
  }
  stroke(30);
  fill(30);
  textSize(10);
  for (k=0; k<j; k++) {
    //text(textos[k], 10, 10+(k*10));
  }
}

void dibujaViajesHora() {
  int xIniViajesHora= 700, yIniViajesHora= 70;
  int span_h= 12,span_w=22,blockLen=120;
  int i;
  int maxViajesHora=0;
  for(i=0;i<5;i++) { if(viajesHora[i][1]>maxViajesHora) { maxViajesHora=viajesHora[i][1]; } }
  textSize(12);
  for(i=0;i<5;i++) {
    fill(colorViajesHora[i][0],colorViajesHora[i][1],colorViajesHora[i][2]);
    stroke(colorViajesHora[i][0],colorViajesHora[i][1],colorViajesHora[i][2]);
    rect(xIniViajesHora+span_w,yIniViajesHora+i*span_h,round(viajesHora[i][1]*blockLen/maxViajesHora),span_h);
    fill(0,184,0);
    stroke(0,184,0);
    text(viajesHora[i][0],xIniViajesHora,(yIniViajesHora+i*span_h)+span_h);
    fill(255);
    stroke(255);
    text(viajesHora[i][1],xIniViajesHora+span_w,(yIniViajesHora+i*span_h)+span_h);
    fill(38,162,209);
    rect(330,50,70,20);
    fill(255);
    stroke(255);
    textSize(12);
    text(totViajes,350,70);
    
  }
    
}

void cargaPreventiva() {
}

//*******************************************************************************************************************

void setup() {
  frameRate=frameRt;
  background(255);
  size(scr_w, scr_h);
  cargaViajesDia(5);
  cargaEstaciones();
  println(nViajes, nEstaciones);
}

void draw() {
  clear();
  background(255);
  contador++;
  calculaTiempos();
  dibujaDt();
  dibujaEstaciones();
  dibujaViajes();
  dibujaViajesHora();
  cargaPreventiva();
}


//*******************************************************************************************************************






/*
int cargaDatos() {
 BufferedReader reader;
 String linea;
 reader= createReader(file_src);
 try {
 linea= reader.readLine();
 }
 catch(IOException e) {
 e.printStrackTrace();
 linea=null;
 }
 if linea==null { return -1; }
 else {
 while linea
 */
