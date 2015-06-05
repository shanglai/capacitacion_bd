

register 'test.py' using jython as myfuncs;

est= load 'est' using PigStorage(',') as (id:int,district:charArray,lon:float,lat:float);
x= limit est 15;
--dump x;

dat= load 'dat' using PigStorage(',') as 
	(est_ret:int,dt_ret:charArray,hr_ret:charArray,
	est_arr:int,dt_arr:charArray,hr_arr:charArray);
--x= limit dat 15;
--dump x;

dat2= foreach dat generate 
	est_ret,est_arr,
	dt_ret as dt_orig,
	myfuncs.parseDt(dt_ret) as dt_ret,
	myfuncs.parseDt(dt_arr) as dt_arr,
	myfuncs.parseRoundHr(hr_ret) as hr_ret,
	myfuncs.parseRoundHr(hr_arr) as hr_arr;
--dump dat;

est_ret_= foreach est generate 
	id as est_ret, district as district_ret, lon as lon_ret, lat as lat_ret;
est_arr_= foreach est generate
	id as est_arr, district as district_arr, lon as lon_arr, lat as lat_arr;

dat_ret= join dat2 by est_ret, est_ret_ by est_ret;
dat_arr= join dat_ret by est_arr, est_arr_ by est_arr;

--describe dat;
--describe dat2;
--describe est_ret_;
--describe est_arr_;
--describe dat_ret;
--describe dat_arr;


dat3= foreach dat_arr generate
	dat_ret::dat2::est_ret as est_ret,dat_ret::dat2::est_arr as est_arr,
	dt_orig,dt_ret,dt_arr,
	myfuncs.roundNmin(hr_ret,10) as hr_ret,
	myfuncs.roundNmin(hr_arr,10) as hr_arr,
	myfuncs.duracionMinutos(hr_ret,hr_arr) as duracion_minutos,
	district_ret,lon_ret,lat_ret,district_arr,lon_arr,lat_arr,
	myfuncs.euclid(lon_ret,lat_ret,lon_arr,lat_arr) as distancia;

--x= limit dat3 20;
--dump x;

store dat3 into 'datos01' using PigStorage(',');


dat3r= load 'datos01/part-r-00000' using PigStorage(',') as
	(est_ret:int,est_arr:int,
	dt_orig:chararray,dt_ret:int,dt_arr:int,
	hr_ret:int,hr_arr:int,duracion_minutos:int,
	district_ret:chararray,
	lon_ret:double,lat_ret:double,
	district_arr:chararray,
	lon_arr:double,lat_arr:double,
	distancia:double);

agg0= foreach dat3r generate 
	dt_ret as dt,dt_orig,hr_ret as hr01,hr_arr as hr02,
	duracion_minutos as dur,distancia as dist,
	lon_ret as lon01, lat_ret as lat01,
	lon_arr as lon02, lat_arr as lat02;

agg1= group agg0 by (dt,dt_orig,hr01,hr02,lon01,lat01,lon02,lat02);

--x= limit agg1 200;
--describe agg1
--illustrate agg1

--dump x;

agg2= foreach agg1 {
	n= COUNT(agg0);
	d=AVG(agg0.dur);
	generate FLATTEN(group),n as n,d as dur_prom;
}

--x= limit agg2 100;
--dump x;

store agg2 into 'datos02' using PigStorage(',');


agg3= filter agg2 by dur_prom>0.0;

--x= limit agg3 100;
--dump x;

store agg3 into 'datos03' using PigStorage(',');






	



















