--DDL : Data Definition Language
--CREATE, DROP, ALTER

USE [master]

GO
IF EXISTS (SELECT TOP(1) 1 FROM sys.databases AS t0 WHERE t0.name = 'AddressBook')
BEGIN
	--SINGLE_USER : On passe la base en mode mono-utilisateur (une seule session possible)
	--WITH ROLLBACK IMMEDIATE : Permet d'annuler les transactions incomplètes en cours
	--le mode mono-utilisateur déconnecte automatiquement les autres sessions
	ALTER DATABASE [AddressBook] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  DROP DATABASE [AddressBook]
END

GO
CREATE DATABASE [AddressBook]

GO
USE [AddressBook]






