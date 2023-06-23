SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
      ,[SaleDateConverted]
  FROM [NashvilleHousing].[dbo].[NashVilleHousing]


   Select *
  From NashvilleHousing.dbo.NashVilleHousing

  Select SaleDate, CONVERT(Date,SaleDate)
  From NashvilleHousing.dbo.NashVilleHousing

  Update NashVilleHousing
  SET SaleDate = CONVERT(Date, SaleDate)

  ALTER TABLE NashVilleHousing
  Add SaleDateConverted Date;

  Update NashVilleHousing
  SET SaleDateConverted = CONVERT(Date, SaleDate)

  Select SaleDateConverted, CONVERT(Date,SaleDate)
  From NashvilleHousing.dbo.NashVilleHousing

  -- Populate Property Address Data

  Select PropertyAddress
  From NashvilleHousing.dbo.NashVilleHousing
  Where PropertyAddress is NULL

  Select *
  From NashvilleHousing.dbo.NashVilleHousing
  -- Where PropertyAddress is NULL
  Order by ParcelID


  Update a
  SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  From NashvilleHousing.dbo.NashVilleHousing a
  JOIN NashvilleHousing.dbo.NashVilleHousing b
      on a.ParcelID = b.ParcelID
	  AND a.[UniqueID ]<> b.[UniqueID ]  
  Where a.PropertyAddress is NULL

  -- Breaking out Address into individual Column, Address, City, State)

  Select PropertyAddress
  From NashvilleHousing.dbo.NashVilleHousing
  --Where PropertyAddress is NULL
  --Order by ParcelID

  Select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
   CHARINDEX(',', PropertyAddress)

  From NashvilleHousing.dbo.NashVilleHousing

  Select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
  , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

  From NashvilleHousing.dbo.NashVilleHousing
   

  ALTER TABLE NashVilleHousing
  Add PropertySplitAddress Nvarchar(255);

  Update NashVilleHousing
  SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

  ALTER TABLE NashVilleHousing
  Add PropertySplitCity Nvarchar(255);

  Update NashVilleHousing
  SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

  -- Populate Property Address Data
   
  Select *
  From NashvilleHousing.dbo.NashVilleHousing

  Select OwnerAddress
  From NashvilleHousing.dbo.NashVilleHousing

  Select
  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
  , PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
  , PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
  From NashvilleHousing.dbo.NashVilleHousing 

  ALTER TABLE NashVilleHousing
  Add OwnerSplitAddress Nvarchar(255);

  Update NashVilleHousing
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

  ALTER TABLE NashVilleHousing
  Add OwnerSplitCity Nvarchar(255);

  Update NashVilleHousing
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

  ALTER TABLE NashVilleHousing
  Add OwnerSplitState Nvarchar(255);

  Update NashVilleHousing
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

  Select *
  From NashvilleHousing.dbo.NashVilleHousing

  -- Change Y and N to Yes and No in 'old as Vacant' field

  Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  From NashvilleHousing.dbo.NashVilleHousing
  Group by SoldAsVacant
  Order by 2

  Select SoldAsVacant
  , CASE When SoldAsVacant = 'Y' THEN 'Yes'
         When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
  From NashvilleHousing.dbo.NashVilleHousing

  Update NashVilleHousing
  SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
         When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
  From NashvilleHousing.dbo.NashVilleHousing
  Group by SoldAsVacant
  Order by 2


-- Remove Duplicate

WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					)Row_num

From NashvilleHousing.dbo.NashVilleHousing
--Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					)Row_num

From NashvilleHousing.dbo.NashVilleHousing
--Order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


-- Delete unused Colums

Select *
From NashvilleHousing.dbo.NashVilleHousing

ALTER TABLE NashvilleHousing.dbo.NashVilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing.dbo.NashVilleHousing
DROP COLUMN SaleDate, OwnwerSiltCity, OwnwerSpiltCity, OwnwerSplitCity


