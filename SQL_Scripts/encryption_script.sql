USE RestaurantManagementSystem;
GO


IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.certificates WHERE name = 'RestaurantDataCertificate')
BEGIN
    CREATE CERTIFICATE RestaurantDataCertificate
    WITH SUBJECT = 'Encrypt Restaurant Data';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.symmetric_keys WHERE name = 'RestaurantSymmetricKey')
BEGIN
    CREATE SYMMETRIC KEY RestaurantSymmetricKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE RestaurantDataCertificate;
END
GO

-- Open symmetric key for encryption/decryption
OPEN SYMMETRIC KEY RestaurantSymmetricKey
DECRYPTION BY CERTIFICATE RestaurantDataCertificate;
GO

-- Add encrypted columns to CUSTOMER table 
IF COL_LENGTH('dbo.CUSTOMER', 'encrypted_Email') IS NULL
    ALTER TABLE CUSTOMER ADD encrypted_Email VARBINARY(MAX);
GO
IF COL_LENGTH('dbo.CUSTOMER', 'encrypted_Phone') IS NULL
    ALTER TABLE CUSTOMER ADD encrypted_Phone VARBINARY(MAX);
GO
IF COL_LENGTH('dbo.CUSTOMER', 'encrypted_Street') IS NULL
    ALTER TABLE CUSTOMER ADD encrypted_Street VARBINARY(MAX);
GO

-- Only encrypt if plaintext exists and encrypted column is NULL
UPDATE CUSTOMER
SET encrypted_Email = EncryptByKey(Key_GUID('RestaurantSymmetricKey'),  Email)
WHERE Email IS NOT NULL AND encrypted_Email IS NULL;
GO

UPDATE CUSTOMER
SET encrypted_Phone = EncryptByKey(Key_GUID('RestaurantSymmetricKey'), Phone)
WHERE Phone IS NOT NULL AND encrypted_Phone IS NULL;
GO

UPDATE CUSTOMER
SET encrypted_Street = EncryptByKey(Key_GUID('RestaurantSymmetricKey'), Street)
WHERE Street IS NOT NULL AND encrypted_Street IS NULL;
GO

-- Open symmetric key for encryption/decryption
OPEN SYMMETRIC KEY RestaurantSymmetricKey
DECRYPTION BY CERTIFICATE RestaurantDataCertificate;
GO

SELECT
    CustomerID,
    Email AS plaintext_Email,
    encrypted_Email,
    CONVERT(varchar(4000), DecryptByKey(encrypted_Email)) AS decrypted_Email,
    Phone AS plaintext_Phone,
    CONVERT(varchar(4000), DecryptByKey(encrypted_Phone)) AS decrypted_Phone,
    encrypted_Phone,
    Street AS plaintext_Street,
    CONVERT(varchar(4000), DecryptByKey(encrypted_Street)) AS decrypted_Street,
    encrypted_Street
FROM CUSTOMER
WHERE encrypted_Email IS NOT NULL OR encrypted_Phone IS NOT NULL OR encrypted_Street IS NOT NULL;
GO

-- Close symmetric key when done
CLOSE SYMMETRIC KEY RestaurantSymmetricKey;
GO
