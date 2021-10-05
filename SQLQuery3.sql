
-- Question 1

select L.State from [dbo].[FACT_TRANSACTIONS] T
inner join [dbo].[DIM_LOCATION] L on T.IDLocation = L.IDLocation
where year(T.[Date]) >= 2005
group by L.State
having sum([Quantity])>0

-- Question 2

select top 1 L.State from [dbo].[FACT_TRANSACTIONS] T 
inner join [dbo].[DIM_LOCATION] L on T.[IDLocation] = L.[IDLocation]
inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
where [Country] = 'US' and [Manufacturer_Name] = 'Samsung'
group by [State]
order by sum([Quantity]) desc

-- Question 3

select [State] , [ZipCode] , [Model_Name] , count(MO.[IDModel])[no. of transactions] from [dbo].[FACT_TRANSACTIONS] T
inner join [dbo].[DIM_MODEL] MO on MO.[IDModel] = T.[IDModel]
inner join [dbo].[DIM_LOCATION] L on L.[IDLocation] = T.[IDLocation]
group by [State] , [ZipCode] , [Model_Name]

--Question 4

select top 1 MA.Manufacturer_Name , MO.Model_Name , MO.Unit_price from [dbo].[FACT_TRANSACTIONS] T
inner join [dbo].[DIM_MODEL] MO on T.IDModel=MO.IDModel
inner join [dbo].[DIM_MANUFACTURER] MA on MA.IDManufacturer=MO.IDManufacturer
order by [Unit_price]

-- Question 5

select MO.Model_Name , AVG([Unit_price])[avg_price] from [dbo].[FACT_TRANSACTIONS] T
inner join [dbo].[DIM_MODEL] MO on T.IDModel=MO.IDModel
inner join [dbo].[DIM_MANUFACTURER] MA on MA.IDManufacturer=MO.IDManufacturer
where MA.[Manufacturer_Name] in 
           (select top 5 MA.[Manufacturer_Name] from [dbo].[FACT_TRANSACTIONS] T
              inner join [dbo].[DIM_MODEL] MO on T.IDModel=MO.IDModel
              inner join [dbo].[DIM_MANUFACTURER] MA on MA.IDManufacturer=MO.IDManufacturer
              group by MA.[Manufacturer_Name]
              order by sum(T.[Quantity]) desc)
group by MO.Model_Name
order by AVG([Unit_price])

-- Question 6

select C.Customer_Name , avg(T.[TotalPrice])[average] from [dbo].[DIM_CUSTOMER] C
inner join [dbo].[FACT_TRANSACTIONS] T on C.IDCustomer=T.IDCustomer
where year(T.[Date]) = 2009
group by C.Customer_Name
having avg(T.[TotalPrice]) > 500

-- Question 7

select [Model_Name] from [dbo].[DIM_MODEL]
where [Model_Name] in (
                       select top 5 MO.Model_Name from [dbo].[FACT_TRANSACTIONS] T
                       inner join [dbo].[DIM_MODEL] MO on T.IDModel=MO.IDModel
                       where year(T.[Date]) = 2008
                       group by MO.Model_Name
                       order by sum(T.[Quantity]) desc) and [Model_Name] in (
                                                                          select top 5 MO.Model_Name from [dbo].[FACT_TRANSACTIONS] T
                                                                          inner join [dbo].[DIM_MODEL] MO on T.IDModel=MO.IDModel
                                                                          where year(T.[Date]) = 2009
                                                                          group by MO.Model_Name
                                                                          order by sum(T.[Quantity]) desc) and [Model_Name] in (
                                                                                                                               select top 5 MO.Model_Name from [dbo].[FACT_TRANSACTIONS] T
                                                                                                                               inner join [dbo].[DIM_MODEL] MO on T.IDModel=MO.IDModel
                                                                                                                               where year(T.[Date]) = 2010
                                                                                                                               group by MO.Model_Name
                                                                                                                               order by sum(T.[Quantity]) desc)


-- Question 8

select year(T.[Date]) , MA.[Manufacturer_Name] , sum([TotalPrice])from [dbo].[FACT_TRANSACTIONS] T 
inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
where (year(T.[Date]) = 2009 and 
       
	   MA.[Manufacturer_Name] <> (select top 1 MA.[Manufacturer_Name] from [dbo].[FACT_TRANSACTIONS] T 
                                  inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
                                  inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
							      where year(T.[Date]) = 2009 
							      group by MA.[Manufacturer_Name]
							      order by sum([TotalPrice]) desc)  and 

		MA.[Manufacturer_Name] in (select top 2 MA.[Manufacturer_Name] from [dbo].[FACT_TRANSACTIONS] T 
                                  inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
                                  inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
							      where year(T.[Date]) = 2009 
							      group by MA.[Manufacturer_Name]
							      order by sum([TotalPrice]) desc))		or
	  
	  (year(T.[Date]) = 2010 and						 
	   
	   MA.[Manufacturer_Name] <> (select top 1 MA.[Manufacturer_Name] from [dbo].[FACT_TRANSACTIONS] T 
                                  inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
                                  inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
							      where year(T.[Date]) = 2010 
							      group by MA.[Manufacturer_Name]
							      order by sum([TotalPrice]) desc) and 

      MA.[Manufacturer_Name] in (select top 2 MA.[Manufacturer_Name] from [dbo].[FACT_TRANSACTIONS] T 
                                  inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
                                  inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
							      where year(T.[Date]) = 2010 
							      group by MA.[Manufacturer_Name]
							      order by sum([TotalPrice]) desc))

group by year(T.[Date]) , MA.[Manufacturer_Name]
order by year(T.[Date]) , sum([TotalPrice]) desc

-- Question 9

select distinct(MA.Manufacturer_Name) from [dbo].[FACT_TRANSACTIONS] T 
inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
where MA.Manufacturer_Name not in 

(select distinct(MA.Manufacturer_Name) from [dbo].[FACT_TRANSACTIONS] T 
inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
where year([Date]) = 2009) and MA.Manufacturer_Name in 

(select distinct(MA.Manufacturer_Name) from [dbo].[FACT_TRANSACTIONS] T 
inner join [dbo].[DIM_MODEL] MO on T.[IDModel] = MO.[IDModel]
inner join [dbo].[DIM_MANUFACTURER] MA on MO.[IDManufacturer] = MA.[IDManufacturer]
where year([Date]) = 2010)

-- Question 10

SELECT T1.Customer_Name, T1.Year, T1.Avg_Price,T1.Avg_Qty,
    CASE
        WHEN T2.Year IS NOT NULL
        THEN FORMAT(CONVERT(DECIMAL(8,2),(T1.Avg_Price-T2.Avg_Price))/CONVERT(DECIMAL(8,2),T2.Avg_Price),'p') ELSE NULL 
        END AS '% Change_year'
    FROM
        (SELECT C.Customer_Name, YEAR(T.DATE) AS YEAR, AVG(T.TotalPrice) AS Avg_Price, AVG(T.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS T 
        inner join DIM_CUSTOMER as C ON T.IDCustomer=C.IDCustomer
        where T.IDCustomer in (select top 100 IDCustomer 
		                       from FACT_TRANSACTIONS 
							   group by IDCustomer 
							   order by SUM(TotalPrice) desc)
        
		group by C.Customer_Name, YEAR(T.Date)
        )T1
    left join
        (SELECT C.Customer_Name, YEAR(T.DATE) AS YEAR, AVG(T.TotalPrice) AS Avg_Price, AVG(T.Quantity) AS Avg_Qty FROM FACT_TRANSACTIONS AS T 
        inner join DIM_CUSTOMER as C ON T.IDCustomer=C.IDCustomer
        where T.IDCustomer in (select top 100 IDCustomer 
		                       from FACT_TRANSACTIONS 
							   group by IDCustomer 
							   order by SUM(TotalPrice) desc)

        group by C.Customer_Name, YEAR(T.Date)
        )T2
        on T1.Customer_Name=T2.Customer_Name and T2.YEAR=T1.YEAR-1 
