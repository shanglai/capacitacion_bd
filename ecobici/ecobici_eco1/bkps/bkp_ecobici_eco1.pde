
int scr_w=300, scr_h=300;
double lon_centro= -99.16968294, lat_centro=19.40754875;
float escala_w= 10000.0, escala_h=1000.0;


String file_src="datgeo1.txt";
String estaciones_src="estaciones.csv";
int nViajes= 0, nEstaciones=0;
viaje[] viajes;
estacion[] estaciones;

int[][] colorEstaciones= {{0,100,0},{0,200,0}};

double fix_lon(double lon) {
  return ((-1)*(lon_centro-lon)*(escala_w))+(scr_w/2);
}
double fix_lat(double lat) {
  return ((lat_centro-lat)*(escala_h))+(scr_h/2);
}

class viaje {
  int dt,hr01,hr02,n;
  double lon01,lat01,lon02,lat02,dur_prom;
  viaje (int _dt,int _hr01,int _hr02,double _lon01,double _lat01,double _lon02,double _lat02,int _n,double _dur_prom) {
   dt=_dt; hr01=_hr01; hr02=_hr02;
   lon01=_lon01; lat01=_lat01; lon02=_lon02; lat02=_lat02;
   n=_n; dur_prom= _dur_prom;
  }
  void printViaje() {
    println(dt,hr01,hr02,n,lon01,lat01,lon02,lat02,dur_prom);
  }
}

class estacion {
  int id;
  String tipo;
  double lon,lat;
  estacion(int _id,double _lon,double _lat,String _tipo) {
    id=_id; lon=_lon; lat=_lat; tipo=_tipo;
  }
  void printEstacion() {
    println(id,tipo,lon,lat);
  }
}

void cargaViajes() {
  Table table= loadTable(file_src,"csv");
  nViajes= table.getRowCount();
  viajes= new viaje[nViajes];
  viaje v;
  int i=0;
  for(TableRow r : table.rows()) {
    v= new viaje(r.getInt(0),r.getInt(1),r.getInt(2),fix_lon(r.getFloat(3)),fix_lat(r.getFloat(4)),fix_lon(r.getFloat(5)),fix_lat(r.getFloat(6)),r.getInt(7),r.getFloat(8));
    //v.printViaje();
    viajes[i]= v;
    i=i+1;
  }
}

void cargaEstaciones() {
  Table table= loadTable(estaciones_src,"header,csv");
  nEstaciones= table.getRowCount();
  estaciones= new estacion[nEstaciones];
  estacion e;
  int i=0;
  for(TableRow r : table.rows()) {
    e= new estacion(r.getInt(0),fix_lon(r.getFloat(1)),fix_lat(r.getFloat(2)),r.getString(3));
    //e.printEstacion();
    estaciones[i]= e;
    i=i+1;
  }
}

void dibujaEstaciones() {
  int i;
  estacion e;
  for(i=0;i<nEstaciones;i++) {
    e= estaciones[i];
    e.printEstacion();
    if(e.tipo=="BIKE") {
      stroke(colorEstaciones[0][0],colorEstaciones[0][1],colorEstaciones[0][2]);
    }
    else {
      stroke(colorEstaciones[1][0],colorEstaciones[1][1],colorEstaciones[1][2]);
    }
    point(round(e.lon),round(e.lat));
  }
}

//*******************************************************************************************************************

void setup() {
  size(scr_w,scr_h);
  cargaViajes();
  cargaEstaciones();
  println(nViajes,nEstaciones);
}

void draw() {
  dibujaEstaciones();
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


