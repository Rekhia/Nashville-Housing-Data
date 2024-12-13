

--#cleaning data

SELECT *
FROM [Nashville Housing Data]

--populate property addres date 

SELECT a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress) as address
FROM [Nashville Housing Data] a
join [Nashville Housing Data] b
on a.ParcelID =b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress) 
FROM [Nashville Housing Data] as a
join [Nashville Housing Data] as b
on a.ParcelID =b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

select ParcelID, PropertyAddress
from [Nashville Housing Data]
where PropertyAddress is null


--Breking out address into individual columns (Address , city , state)

select  PropertyAddress
from [Nashville Housing Data]

SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(' ', PropertyAddress) - 1) AS [street_number],
    LTRIM(SUBSTRING(
        PropertyAddress, 
        CHARINDEX(' ', PropertyAddress) + 1, 
        CHARINDEX(',', PropertyAddress) - CHARINDEX(' ', PropertyAddress) - 1
    )) AS [street_name]
FROM [Nashville Housing Data];


SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(', ', PropertyAddress) ) AS Address,
  SUBSTRING( PropertyAddress,  CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress)) AS CITY
FROM [Nashville Housing Data];


Alter table  [Nashville Housing Data]
Add PropertysplitAddress nvarchar(255);

update [Nashville Housing Data]
set PropertysplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) )


Alter table  [Nashville Housing Data]
Add Propertysplit_city nvarchar(255);

update [Nashville Housing Data]
set Propertysplit_city = SUBSTRING( PropertyAddress,  CHARINDEX(',', PropertyAddress)+1 ,LEN(PropertyAddress))


select  PropertysplitAddress , Propertysplit_city
from [Nashville Housing Data]


select PARSENAME(replace(OwnerAddress,',','.'),3) as address  ,
PARSENAME(replace(OwnerAddress,',','.'),2) city,
PARSENAME(replace(OwnerAddress,',','.'),1) state
from [Nashville Housing Data]


update [Nashville Housing Data]
set PropertysplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)


update [Nashville Housing Data]
set Propertysplit_city = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table  [Nashville Housing Data]
Add Propertysplit_state nvarchar(255);

update  [Nashville Housing Data]
set Propertysplit_state = PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from [Nashville Housing Data]

Alter table  [Nashville Housing Data]
DROP COLUMN  Propertysplitcity



-- change 0 and 1 to 'yes' and 'no' in "Sold as vecant" feild 
select   SoldAsVacant , count(SoldAsVacant)
from [Nashville Housing Data]
group by SoldAsVacant 
order by 2
update [Nashville Housing Data]
set SoldAsVacant = CONVERT( nvarchar(20),SoldAsVacant)


select convert(nvarchar(50),SoldAsVacant) ,
case when SoldAsVacant = '1' then 'YES'
	when SoldAsVacant = '0' then 'NO'
	else SoldAsVacant end
from [Nashville Housing Data]



Alter TABLE [Nashville Housing Data]
ADD SoldAsVacant2 nvarchar(50);

update [Nashville Housing Data]
set SoldAsVacant2 = convert(nvarchar(50),SoldAsVacant)



select SoldAsVacant ,
case when SoldAsVacant2 = '1' then 'YES'
	when SoldAsVacant2 = '0' then 'NO'
	else SoldAsVacant2 end
from [Nashville Housing Data]

update [Nashville Housing Data]
set SoldAsVacant2 = 
case when SoldAsVacant2 = '1' then 'YES'
	when SoldAsVacant2 = '0' then 'NO'
	else SoldAsVacant2 end
from [Nashville Housing Data]

select SoldAsVacant2 , COUNT(SoldAsVacant2)
from [Nashville Housing Data]
group by SoldAsVacant2
order by 2


alter table [Nashville Housing Data]
drop column SoldAsVacant


--Remove Duplicates 

with rownum_dup as (
select *,
ROW_NUMBER() over (partition by SalePrice,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					ORDER BY UniqueID) as row_num
from [Nashville Housing Data] )

select *
from rownum_dup

delete
from rownum_dup
where row_num >1
--order by PropertyAddress



-- delete unused columns
alter table [Nashville Housing Data]
drop column PropertyAddress,TaxDistrict


