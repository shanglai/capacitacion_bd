
import re
import math

@outputSchema("word:chararray")
def helloworld():
	return 'Hello, World'

@outputSchema("dt2:int")
def parseDt(dt):
	yr= int(dt[0:4])
	mon= int(dt[5:7])
	dy= int(dt[8:10])
	dt2= yr*365+mon*12+dy
	return dt2
	
@outputSchema("hr2:int")
def parseRoundHr(hr):
	#00:13:01.050000
	#00:13:01
	h= int(hr[0:2])
	m= int(hr[3:5])
	s= int(hr[6:8])
	hr2= h*3600+m*60+s
	return hr2
	
@outputSchema("minutos:int")
def roundNmin(seg,divisor):
	return int(seg/60/divisor)
	
@outputSchema("duracion_minutos:int")
def duracionMinutos(hr_ret,hr_arr):
	return int((hr_arr-hr_ret)/60)
	
@outputSchema("distancia:float")
def euclid(lon_ret,lat_ret,lon_arr,lat_arr):
	return round(math.sqrt((lon_arr-lon_ret)*(lon_arr-lon_ret)+(lat_arr-lat_ret)*(lat_arr-lat_ret)),7)

