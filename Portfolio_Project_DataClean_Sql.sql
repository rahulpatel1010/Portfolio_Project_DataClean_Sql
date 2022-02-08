--cleaning data in Sql Queries
select * from
PortfolioProject..NashvilleHousing
----------------------------------------------------------------------------
--Standardize Date Format
select SaleDateConverted,CONVERT(date,SaleDate)
from
PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SaleDate=CONVERT(date,SaleDate)

alter table PortfolioProject..NashvilleHousing
add SaleDateConverted date;

update PortfolioProject..NashvilleHousing
set SaleDateConverted=CONVERT(date,SaleDate)

--------------------------------------------------------------------------
--populate Property Address Data
select * from
PortfolioProject..NashvilleHousing
order by parcelid 


select a.PropertyAddress,a.ParcelID,b.ParcelID,b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from
PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on
a.ParcelID=b.ParcelID And
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from
PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on
a.ParcelID=b.ParcelID And
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------------------------------------------------------------
-- Breaking out address into individual columns (addres,city,state)
select propertyaddress
from
PortfolioProject..NashvilleHousing

select 
substring( propertyaddress,1,charindex(',',propertyaddress) -1) as Address,
substring( propertyaddress,charindex(',',propertyaddress) +1,len(propertyaddress)) as Address
from
PortfolioProject..NashvilleHousing

--alter table NashvilleHousing
add propertysplitaddress Nvarchar(255);

--Update NashvilleHousing
set propertysplitaddress= substring( propertyaddress,1,charindex(',',propertyaddress) -1)

--alter table NashvilleHousing
add propertysplitcity Nvarchar(255);

--Update NashvilleHousing
set propertysplitcity= substring( propertyaddress,charindex(',',propertyaddress) +1,len(propertyaddress)) 

select propertyaddress,propertysplitaddress,propertysplitcity from
PortfolioProject..NashvilleHousing

select 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from
PortfolioProject..NashvilleHousing

--alter table NashvilleHousing
add Ownersplitaddress Nvarchar(255);

--Update NashvilleHousing
set Ownersplitaddress= parsename(replace(owneraddress,',','.'),3)


--alter table NashvilleHousing
add Ownersplitcity Nvarchar(255);

--Update NashvilleHousing
set Ownersplitcity= parsename(replace(owneraddress,',','.'),2)

--alter table NashvilleHousing
add Ownersplitstate Nvarchar(255);

--Update NashvilleHousing
set Ownersplitstate= parsename(replace(owneraddress,',','.'),1)


select Ownersplitaddress,Ownersplitcity,Ownersplitstate from
PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------

select distinct(soldasvacant),count(soldasvacant)
from PortfolioProject..NashvilleHousing
group by soldasvacant
order by 2

select soldasvacant,
CASE WHEN soldasvacant='Y' THEN 'Yes'
     WHEN soldasvacant='N' THEN 'No'
	 ELSE soldasvacant
	 End
from 
PortfolioProject..NashvilleHousing


--update PortfolioProject..NashvilleHousing
set soldasvacant=CASE WHEN soldasvacant='Y' THEN 'Yes'
     WHEN soldasvacant='N' THEN 'No'
	 ELSE soldasvacant
	 End

----------------------------------------------------------------------------------------------------------------
-- remove Duplicates
With RowNumCTE As(
select *,
      ROW_NUMBER() OVER (
	  PARTITION BY Parcelid,
	               PropertyAddress,
				   salePrice,
				   SaleDate,
				   Legalreference
				   order by 
				   Uniqueid
				   ) row_num
from 
PortfolioProject..NashvilleHousing
)
select * 
from RowNumCTE where 
row_num >1

--------------------------------------------------------------------------------------------------------------------

-- delete Unused Columns

select *
from 
PortfolioProject..NashvilleHousing

Alter table
PortfolioProject..NashvilleHousing
Drop column owneraddress,taxDistrict,propertyAddress


Alter table
PortfolioProject..NashvilleHousing
Drop column Saledate






