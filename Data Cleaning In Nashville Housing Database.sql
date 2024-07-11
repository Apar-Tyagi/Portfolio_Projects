-- Cleaning data in Sql Queries

select * 
from PortfolioProject..NashvilleHousing


-- Standardizing Date Format
select * 
from PortfolioProject..NashvilleHousing

--Select SaleDate, convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing

--update PortfolioProject..NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

alter table PortfolioProject..NashvilleHousing
add
SaleDateConverted Date; 

update PortfolioProject..NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)

Select SaleDateConverted--, convert(Date, SaleDate)
from PortfolioProject..NashvilleHousing



-- Populate Property Address Data

Select * --PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--Breaking out address into individual columns(Address, city, state)

select propertyAddress
from 
PortfolioProject..NashvilleHousing

select
SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(propertyAddress)) as State
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
add
PropertySplitAddress nvarchar(255); 

update PortfolioProject..NashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

alter table PortfolioProject..NashvilleHousing
add
PropertySplitCity nvarchar(255); 

update PortfolioProject..NashvilleHousing
set PropertySplitCity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(propertyAddress))


select * 
from PortfolioProject..NashvilleHousing


select OwnerAddress 
from PortfolioProject..NashvilleHousing

select 
parsename(replace(OwnerAddress, ',', '.'),3),
parsename(replace(OwnerAddress, ',', '.'),2),
parsename(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
add
OwnerSplitAddress nvarchar(255); 

update PortfolioProject..NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'),3)

alter table PortfolioProject..NashvilleHousing
add
OwnerSplitCity nvarchar(255); 

update PortfolioProject..NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'),2)

alter table PortfolioProject..NashvilleHousing
add
ownerSplitstate nvarchar(255); 

update PortfolioProject..NashvilleHousing
set ownerSplitstate =parsename(replace(OwnerAddress, ',', '.'),1)

select * 
from PortfolioProject..NashvilleHousing






-- Change Y and N to Yes and No in "sold as vacant" field

select distinct(SoldAsVacant), count (soldasvacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject..NashvilleHousing;


update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
	 when soldasvacant = 'N' then 'No'
	 else SoldAsVacant
	 end




--Remove Duplicates


With RollNumCTE as(
Select *,
	ROW_NUMBER() OVER(
	partition by parcelId,
				 propertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from PortfolioProject..NashvilleHousing
--order by ParcelID
)
select *
from RollNumCTE
where row_num > 1
order by PropertyAddress;




select *
from PortfolioProject..NashvilleHousing










-- Remove Unused Data

select *
from PortfolioProject..NashvilleHousing;

Alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleData;