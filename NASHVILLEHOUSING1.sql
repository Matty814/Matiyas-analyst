-------THIS IS A WALK THROUGH FOR FILTRING THE DATA AND CLEANING------

----STANDARDIZE DATE FORMAT UNDER SALEDATE-----

SELECT SALEDATE, CONVERT(DATE,SALEDATE)
FROM NASHVILLEHOUSING

UPDATE NASHVILLEHOUSING 
SET SALEDATE = CONVERT (DATE,SALEDATE)
---ADDING A TABLE HERE---

ALTER TABLE NASHVILLEHOUSING
ADD SALEDATECONVERTED DATE;


SELECT

---TOOK THE SALEDATECOLMN AND ADDED TO THE SALEDATECONVERTED---

UPDATE NASHVILLEHOUSING
SET SALEDATECONVERTED = CONVERT (DATE, SALEDATE)

SELECT SALEDATECONVERTED   -----VERIFY---
FROM NASHVILLEHOUSING

/* POPULATING ADDRESS DATA BECAUSE ITS MISSING DATA WITHIN IT LOOKING FOR DUPLICATES UNDER THE PROPERTYADDRESS */

SELECT * 
FROM NASHVILLEHOUSING
ORDER BY ParcelID

SELECT A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL (A.PROPERTYADDRESS,B.PropertyAddress)
FROM NASHVILLEHOUSING A
JOIN NASHVILLEHOUSING B
ON A.ParcelID = B.ParcelID AND
A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A 
SET PropertyAddress = ISNULL (A.PropertyAddress,B.PropertyAddress)
FROM NASHVILLEHOUSING A
JOIN NASHVILLEHOUSING B
ON A.ParcelID = B.ParcelID AND
A.[UniqueID ] <> B.[UniqueID ]

/* WE ARE GOING TO START BY BREAKING DOWN THE ADDESSES TO INDVIDUAL COLUMN CITY BY SUBSTRINGS */





SELECT 
PARSENAME (REPLACE (OWNERADDRESS, ',','.'),3),
PARSENAME (REPLACE (OWNERADDRESS, ',','.'),2),
PARSENAME (REPLACE (OWNERADDRESS, ',','.'),1)

FROM NASHVILLEHOUSING

ALTER TABLE NASHVILLEHOUSING
ADD OWNERHOMEADDRESS NVARCHAR (255);

UPDATE NASHVILLEHOUSING 
SET OWNERHOMEADDRESS = PARSENAME (REPLACE (OWNERADDRESS, ',','.'),3)

ALTER TABLE NASHVILLEHOUSING
ADD OWNERCITYADDRESS NVARCHAR (255)

UPDATE NASHVILLEHOUSING 
SET OWNERCITYADDRESS = PARSENAME (REPLACE (OWNERADDRESS, ',','.'),2)

ALTER TABLE NASHVILLEHOUSING
ADD OWNERSTATEADDRESS NVARCHAR (255);

UPDATE NASHVILLEHOUSING 
SET OWNERSTATEADDRESS = PARSENAME (REPLACE (OWNERADDRESS, ',','.'),1)


-change Y and N to Yes and No so we can make the data accurate=

SELECT DISTINCT (SOLDASVACANT) ,
COUNT (SOLDASVACANT)
FROM NASHVILLEHOUSING
GROUP BY SOLDASVACANT
ORDER BY 2

SELECT SOLDASVACANT,
CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
     WHEN SOLDASVACANT = 'N' THEN 'NO'
	 ELSE SOLDASVACANT
	 END
FROM NASHVILLEHOUSING


UPDATE NASHVILLEHOUSING
SET SOLDASVACANT = CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
     WHEN SOLDASVACANT = 'N' THEN 'NO'
	 ELSE SOLDASVACANT
	 END


	 /* REMOVING DUPLICATES AND UNUSED COLUMNS NOT A STANDARD PRACTICE UISNG IN DATABASE */
WITH ROWNUMCTE AS(
	 SELECT *,
	 ROW_NUMBER() OVER (
	 PARTITION BY PARCELID,
	 PROPERTYADDRESS,
	 SALEPRICE,
	 SALEDATE,
	 LEGALREFERENCE
	 ORDER BY 
	 UNIQUEID
	 ) ROW_NUM
FROM Nashvillehousing
)
SELECT*
FROM ROWNUMCTE 
WHERE ROW_NUM > 1
--ORDER BY PROPERTYADDRESS 


---DELETE UNUSED COLUMNS--

SELECT *
FROM Nashvillehousing

ALTER TABLE NASHVILLEHOUSING 
DROP COLUMN OWNERADDRESS,PROPERYADDRESS 

ALTER TABLE NASHVILLEHOUSING
DROP COLUMN TAXDISTRICT

