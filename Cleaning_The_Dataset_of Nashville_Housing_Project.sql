-- Cleaning Data in SQL (by Using  SSMS) 

select* from [Cleaning Dataset Project ]..[Nashville Housing]

--Standardlize Data Format 

select SaleDate,cast(SaleDate as Date) as SaleDateUpdate
from [Cleaning Dataset Project ]..[Nashville Housing]


ALTER TABLE dbo.[Nashville Housing]
add SaleDateUpdate DATE;

UPDATE dbo.[Nashville Housing]
SET SaleDateUpdate = cast(SaleDate as date)

-- Populate Property address data
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress) 
from [Cleaning Dataset Project ]..[Nashville Housing] a 
join [Cleaning Dataset Project ]..[Nashville Housing] b 
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



update a set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)  
from [Cleaning Dataset Project ]..[Nashville Housing] a 
join [Cleaning Dataset Project ]..[Nashville Housing] b 
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into individual columns ( address, city, state)

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, len(PropertyAddress)) as Address 
 from [Cleaning Dataset Project ]..[Nashville Housing]

 --Starting to Braek down the propertyaddress into address and city and update it to the table
ALTER TABLE dbo.[Nashville Housing]
add PropertySplitAddress Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1)




ALTER TABLE dbo.[Nashville Housing]
add PropertySplitCity Nvarchar(255)

UPDATE dbo.[Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, len(PropertyAddress)) 


select* from [Cleaning Dataset Project ]..[Nashville Housing]

 
-- Braek down the OwnerAddress into address,city, and state but in other way with udating to the table

select PARSENAME(replace(OwnerAddress, ',','.'),3),
 PARSENAME(replace(OwnerAddress, ',','.'),2),
 PARSENAME(replace(OwnerAddress, ',','.'),1)
from [Cleaning Dataset Project ]..[Nashville Housing]

ALTER TABLE dbo.[Nashville Housing]
add OwnerSplitAddress Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'),3)


ALTER TABLE dbo.[Nashville Housing]
add OwnerSplitCity Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'),2)

ALTER TABLE dbo.[Nashville Housing]
add OwnerSplitState Nvarchar(255);

UPDATE dbo.[Nashville Housing]
SET OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'),1)


--Change Y and N to 'Yes' and 'No' in Sold As Vacant Field 

-- Query to be sure that there are 'y' and 'n'

select distinct (SoldAsVacant), count(SoldAsVacant)
from [Cleaning Dataset Project ]..[Nashville Housing]
group by SoldAsVacant
order by 2 

-- Changing y and n to yes or no  and updating to the table 

select SoldAsVacant, 
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end
from [Cleaning Dataset Project ]..[Nashville Housing]

update [Cleaning Dataset Project ]..[Nashville Housing] 
set SoldAsVacant =  
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
     else SoldAsVacant
     end

 --Remove dublicates and unused columns in the table 

 with RowNumCte as (
 
 select *, 
    ROW_NUMBER() over ( 
    partition BY 
     ParcelID,
     PropertyAddress, 
     SalePrice,
    LegalReference 
    order by UniqueID )row_nums

from [Cleaning Dataset Project ]..[Nashville Housing]
 )

select * from RowNumCte
where row_nums>1
order by PropertyAddress


--Delete unused columns

 select * from [Cleaning Dataset Project ]..[Nashville Housing]

alter table  [Cleaning Dataset Project ]..[Nashville Housing]
drop column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate 


  