/*Wykonaj zapytania, które odpowiedzą na te pytania:
● 1. Jakie są miasta, w których mieszka więcej niż 3 pracowników?*/

select count(employee_id), e.city,
case 
	when count(employee_id) >3 then 'Miasto w którym mieszka wiecej niż 3 pracowników'
end komentarz
from employees e 
group by e.city
			
/* 2. Zakładając, że produkty, które kosztują (UnitPrice) mniej niż 10$
możemy uznać za tanie, te między 10$ a 50$ za średnie, a te powyżej
50$ za drogie, ile produktów należy do poszczególnych przedziałów?*/

create view przedział_kwalifikacja1 as
select od.unit_price, od.product_id,
case 
	when od.unit_price>50 then 'drogie'
	when od.unit_price between 10 and 50 then 'srednie'
	else 'tanie'
end przedział
from order_details od 


select count(product_id),przedział
from przedział_kwalifikacja1 
group by przedział
			
/* 4. Ile kosztuje najtańszy, najdroższy i ile średnio kosztuje produkt od
każdego z dostawców? UWAGA – te dane powinny być przedstawione
z nazwami dostawców, nie ich identyfikatorami suppliers*/
		
			select s.company_name,
			avg(p.unit_price) as średnia_cena,
			max(p.unit_price) as maksymalna_cena,
			min(p.unit_price) as minimalna_cena
			from suppliers s 
			join products p 
			on s.supplier_id =p.supplier_id
			group by s.company_name 
			order by średnia_cena
		
		
/* 3.  Czy najdroższy produkt z kategorii z największą średnią ceną to
najdroższy produkt ogólnie?*/
		select c.category_name, 
		avg(p.unit_price) as średnia_cena_produktu_w_kategorii, 
		max(p.unit_price) as maksym_cena_produktu
		from products p 
			join categories c 
			on p.category_id =c.category_id
			group by c.category_name 
			order by średnia_cena_produktu_w_kategorii desc 
			
			
			
/*5. Jak się nazywają i jakie mają numery kontaktowe wszyscy dostawcy 
 * (suppliers) i customers klienci (ContactName) z Londynu? Jeśli nie ma numeru telefonu,
wyświetl faks.*/
		select c.contact_name,
case
    when c.phone is null then c.fax
    else c.phone
end phone_or_fax
from customers c
where c.city='London'
union
select s.contact_name,
case
    when s.phone is null then s.fax
    else s.phone
end phone_or_fax
from suppliers s
where s.city='London' 
		
		
		
/*6. Które miejsce cenowo (od najtańszego) zajmują w swojej kategorii
(CategoryID) wszystkie produkty?*/
		
		select p.category_id, p.unit_price, p.product_name,
		rank () over (order by p.unit_price asc)
		from products p 
		
