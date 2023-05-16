select count(*)
from summary_of_weather_v1 sowv 
select count(*) 
from weather_station_locations wsl 
/*Jaka była i w jakim kraju miała miejsce najwyższa dzienna amplituda
temperatury?*/

select wsl."NAME",  max(sowv.maxtemp -sowv.mintemp) as amplituda
from summary_of_weather_v1 sowv 
join weather_station_locations wsl 
on sowv.sta=wsl.wban 
group by wsl."NAME"
order by amplituda desc 

/*Z czym silniej skorelowana jest średnia dzienna temperatura dla stacji
– szerokością (lattitude) czy długością (longtitude) geograficzną?*/

select
corr (sowv.meantemp,wsl.longitude) as kor_dł,
corr (sowv.meantemp,wsl.latitude)as kor_szer
from summary_of_weather_v1 sowv 
join weather_station_locations wsl 
on sowv.sta=wsl.wban

/*Pokaż obserwacje, w których suma opadów atmosferycznych
(precipitation) przekroczyła sumę opadów z ostatnich 5 obserwacji na
danej stacji.*/

select *
from summary_of_weather_v1 sowv

update summary_of_weather_v1  set precip = case 
	when precip='T' then '0'
	else precip
end 
where precip in ('T')

 create view V_ranking_obserwacji_dla_Stacji3 as
		select sowv.sta, cast(sowv.precip as float4), sowv."Date",
		row_number () over (partition by sowv.sta order by sowv."Date" ) numer_obserwacji
		from summary_of_weather_v1 sowv 
		
select
sta, sum(precip)
from v_ranking_obserwacji_dla_stacji3 
where numer_obserwacji <=5
group by sta


