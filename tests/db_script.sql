CREATE DATABASE `showdb_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE `AuthSession` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `CreatedDate` datetime NOT NULL COMMENT 'The date and time this session was created.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'The date and time this session was last updated, A session expires when the current date and time equals LastModifiedDate + NumSecondsValid.',
  `LoginType` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The type of login, for example, Application.',
  `NumSecondsValid` int(11) DEFAULT NULL COMMENT 'The number of seconds before the session expires, starting from the last update time.',
  `SessionId` char(44) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The session Id stored on a cookie or used to authenticate API requests.',
  `SessionSecurityLevel` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Standard or High, depending upon the authentication method used. (LOW, STANDARD, HIGH_ASSURANCE)',
  `SessionType` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The type of session. Common ones are UI, Content, and API.',
  `SourceIp` varchar(39) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP address of the end user’s device from which the session started. This can be an IPv4 or IPv6 address.',
  `UserId` bigint(20) unsigned NOT NULL COMMENT 'The user’s user ID.',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `AuthSession_SessionId_UNIQUE` (`SessionId`),
  KEY `FK_Auth_UserId_INDEX` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The AuthSession object represents an individual user session in your organization.';

CREATE TABLE `Group` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `CreatedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who created this record. CreatedById fields have Defaulted on create and Filter access.',
  `CreatedDate` datetime NOT NULL COMMENT 'Date and time when this record was created. CreatedDate fields have Defaulted on create and Filter access.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `DeveloperName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your organization. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object’s name in a managed package and the changes are reflected in a subscriber’s organization. Corresponds to Group Name in the user interface.',
  `Name` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Required. Name of the group. Corresponds to Label on the user interface.',
  `OwnerId` bigint(20) unsigned DEFAULT NULL COMMENT 'ID of the user who owns the group.',
  `RelatedId` bigint(20) unsigned DEFAULT NULL COMMENT 'For Groups of type “Role,” the ID of the associated UserRole.',
  `Type` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Group_DeveloperName_UNIQUE` (`DeveloperName`),
  KEY `FK_Group_CreatedById_INDEX` (`CreatedById`),
  KEY `FK_Group_LastModifiedById_INDEX` (`LastModifiedById`),
  KEY `FK_Group_OwnerId` (`OwnerId`),
  KEY `FK_Group_RelatedId` (`RelatedId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a set of Users.';

CREATE TABLE `GroupMember` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `RelatedId` int(11) NOT NULL COMMENT 'Required. ID of the Group.',
  `UserId` int(11) DEFAULT NULL COMMENT 'ID of the User that is a direct member of the group.',
  PRIMARY KEY (`Id`),
  KEY `FK_GroupMember_RelatedId_INDEX` (`RelatedId`),
  KEY `FK_GroupMember_UserId_INDEX` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a User that is a member of a public group.';

CREATE TABLE `LoginHistory` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `ApiType` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Indicates the API type, for example Soap Enterprise. Label is API Type.',
  `ApiVersion` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Displays the API version used by the client. Label is API Version.',
  `Application` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The application used to access the organization. Label is Application.',
  `Browser` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The current browser version. Label is Browser.',
  `LoginTime` datetime NOT NULL COMMENT 'Time zone is based on GMT. Label is Login Time.',
  `LoginType` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The type of login, for example, Application. Label is Login Type.',
  `LoginUrl` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'URL from which the login request is coming. Label is Login URL.',
  `Platform` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Operating system on the login machine. Label is Platform.',
  `SourceIp` varchar(39) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP address of the machine from which the login request is coming. Label is Source IP.',
  `Status` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Displays the status of the attempted login. Status is either success or a reason for failure. Label is Status.',
  `UserId` bigint(20) unsigned NOT NULL COMMENT 'ID of the user logging in. Label is User ID.',
  PRIMARY KEY (`Id`),
  KEY `FK_LoginHistory_UserId_INDEX` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents the login history for all successful and failed login attempts.';

CREATE TABLE `Organization` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `CreatedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who created this record. CreatedById fields have Defaulted on create and Filter access.',
  `CreatedDate` datetime NOT NULL COMMENT 'Date and time when this record was created. CreatedDate fields have Defaulted on create and Filter access.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `InstanceName` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The name of the instance.',
  `IsSandbox` bit(1) DEFAULT b'1' COMMENT 'Indicates whether the current organization is a sandbox (true) or production (false) instance.',
  `InMaintenanceMode` bit(1) DEFAULT b'1' COMMENT 'Indicates whether the current organization is in maintenance mode (true) or not (false).',
  `LanguageLocaleKey` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT 'en_US' COMMENT 'The same as Language, the two-to-five character code which represents the language and locale ISO code. This controls the language for labels displayed in an application.',
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The name of the organization.',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Organization_InstanceName_UNIQUE` (`InstanceName`),
  KEY `FK_Organization_CreatedById_INDEX` (`CreatedById`),
  KEY `FK_Organization_LastModifiedById_INDEX` (`LastModifiedById`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='This object represents key configuration information for an organization.';

CREATE TABLE `Permission` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `DeveloperName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The unique name of the object in the API. This name can contain only underscores and alphanumeric characters. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores.',
  `Name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Required. Name of the permission. Corresponds to Label on the user interface.',
  `Description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description of the permission.',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Permission_DeveloperName_UNIQUE` (`DeveloperName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a permission.';

CREATE TABLE `PermissionAssignment` (
  `PermissionSetId` bigint(20) unsigned NOT NULL COMMENT 'ID of the PermissionSet to assign to the permission specified in PermissionId.',
  `PermissionId` bigint(20) unsigned NOT NULL COMMENT 'ID of the Permission to assign the permission set specified in PermissionSetId.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  PRIMARY KEY (`PermissionSetId`,`PermissionId`),
  KEY `FK_PermissionAssignment_PermissionId_INDEX` (`PermissionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents the association between a Permission and a PermissionSet.';

CREATE TABLE `PermissionSet` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `CreatedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who created this record. CreatedById fields have Defaulted on create and Filter access.',
  `CreatedDate` datetime NOT NULL COMMENT 'Date and time when this record was created. CreatedDate fields have Defaulted on create and Filter access.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `Name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your organization. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Label corresponds to API Name in the user interface.',
  `Description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'A description of the permission set.',
  `IsOwnedByProfile` bit(1) NOT NULL DEFAULT b'1' COMMENT 'If true, the permission set is owned by a profile.',
  `Label` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The permission set label, which corresponds to Label in the user interface.',
  `UserLicenseId` bigint(20) unsigned DEFAULT NULL COMMENT 'ID of the UserLicense associated with this permission set.',
  `ProfileId` bigint(20) unsigned DEFAULT NULL COMMENT 'If the permission set is owned by a profile, this field returns the ID of the Profile. If the permission set isn’t owned by a profile, this field returns a null value.',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `PermissionSet_Name_UNIQUE` (`Name`),
  KEY `FK_PermissionSet_CreatedById_INDEX` (`CreatedById`),
  KEY `FK_PermissionSet_LastModifiedById_INDEX` (`LastModifiedById`),
  KEY `FK_PermissionSet_UserLicenseId_INDEX` (`UserLicenseId`),
  KEY `FK_PermissionSet_ProfileId_INDEX` (`ProfileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a set of permissions that’s used to grant additional access to one or more users without changing their profile or reassigning profiles. You can use permission sets to grant access, but not to deny access.';

CREATE TABLE `PermissionSetAssignment` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `AssigneeId` bigint(20) unsigned NOT NULL COMMENT 'ID of the User to assign the permission set specified in PermissionSetId.',
  `PermissionSetId` bigint(20) unsigned NOT NULL COMMENT 'ID of the PermissionSet to assign to the user specified in AssigneeId.',
  PRIMARY KEY (`Id`),
  KEY `FK_PermissionSetAssignment_AssigneeId_INDEX` (`AssigneeId`),
  KEY `FK_PermissionSetAssignment_PermissionSetId_INDEX` (`PermissionSetId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents the association between a User and a PermissionSet.';

CREATE TABLE `Profile` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `CreatedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who created this record. CreatedById fields have Defaulted on create and Filter access.',
  `CreatedDate` datetime NOT NULL COMMENT 'Date and time when this record was created. CreatedDate fields have Defaulted on create and Filter access.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `Name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The name of the profile.',
  `Description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Profile_Name_UNIQUE` (`Name`),
  KEY `FK_Profile_CreatedById_INDEX` (`CreatedById`),
  KEY `FK_Profile_LastModifiedById_INDEX` (`LastModifiedById`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a profile, which defines a set of permissions to perform different operations, such as querying, adding, updating, or deleting information.';

CREATE TABLE `User` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Indicates whether the record has been moved to the Recycle Bin (true) or not (false).',
  `CreatedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who created this record. CreatedById fields have Defaulted on create and Filter access.',
  `CreatedDate` datetime NOT NULL COMMENT 'Date and time when this record was created. CreatedDate fields have Defaulted on create and Filter access.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `Email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The user’s email address.',
  `Username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Required. Contains the name that a user enters to log into the API or the user interface. The value for this field must be in the form of an email address. It must also be unique across all instances. If you try to Create() or Update() a User with a duplicate value for this field, the operation is rejected.',
  `Alias` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Required. The user’s alias. For example, "jsmith."',
  `FirstName` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The user’s first name.',
  `LastName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The user’s last name.',
  `IsActive` bit(1) NOT NULL DEFAULT b'1' COMMENT 'Indicates whether the user has access to log in (true) or not (false).',
  `LastLoginDate` datetime DEFAULT NULL COMMENT 'Date and time when the user last logged in.',
  `MobilePhone` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'The user’s mobile or cellular phone number.',
  `UserRoleId` bigint(20) unsigned NOT NULL COMMENT 'ID of the user’s UserRole.',
  `ProfileId` bigint(20) unsigned NOT NULL COMMENT 'ID of the user’s Profile.',
  `LanguageLocaleKey` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en_US' COMMENT 'Required. The user’s language, such as "French" or "Chinese (Traditional)." Label is Language.',
  `LocaleSidKey` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en_US' COMMENT 'Required. This field is a restricted picklist field. The value of the field affects formatting and parsing of values, especially numeric values, in the user interface. It does not affect the API.',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `User_Username_UNIQUE` (`Username`),
  UNIQUE KEY `User_Alias_UNIQUE` (`Alias`),
  KEY `FK_User_CreatedById_INDEX` (`CreatedById`),
  KEY `FK_User_LastModifiedById_INDEX` (`LastModifiedById`),
  KEY `FK_User_UserRoleId_INDEX` (`UserRoleId`),
  KEY `FK_User_ProfileId_INDEX` (`ProfileId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a user in the system.';

CREATE TABLE `UserLogin` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `IsFrozen` bit(1) DEFAULT b'0' COMMENT 'If true, the user account associated with this object is frozen.',
  `IsPasswordLocked` bit(1) DEFAULT b'0' COMMENT 'If true, the user account associated with this object is locked because of too many login failures. From the API, you can set this field to false, but not true.',
  `UserId` bigint(20) unsigned NOT NULL COMMENT 'ID of the associated user account. This field can’t be updated.',
  PRIMARY KEY (`Id`),
  KEY `FK_UserLogin_LastModifiedById_INDEX` (`LastModifiedById`),
  KEY `FK_UserLogin_UserId_INDEX` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents the settings that affect a user’s ability to log into an organization. To access this object, you need the UserPermissions.ManageUsers permission.';

CREATE TABLE `UserRole` (
  `Id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID that identifies a record.',
  `IsDeleted` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Indicates whether the record has been moved to the Recycle Bin (true) or not (false).',
  `CreatedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who created this record. CreatedById fields have Defaulted on create and Filter access.',
  `CreatedDate` datetime NOT NULL COMMENT 'Date and time when this record was created. CreatedDate fields have Defaulted on create and Filter access.',
  `LastModifiedById` bigint(20) unsigned NOT NULL COMMENT 'ID of the User who last updated this record. LastModifiedById fields have Defaulted on create and Filter access.',
  `LastModifiedDate` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user. LastModifiedDate fields have Defaulted on create and Filter access.',
  `SystemModstamp` datetime NOT NULL COMMENT 'Date and time when this record was last modified by a user or by a workflow process (such as a trigger). SystemModstamp fields have Defaulted on create and Filter access.',
  `DeveloperName` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your organization. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object’s name in a managed package and the changes are reflected in a subscriber’s organization. Corresponds to Role Name in the user interface.',
  `Name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Required. Name of the role. Corresponds to Label on the user interface.',
  `ParentRoleId` bigint(20) unsigned DEFAULT NULL COMMENT 'The ID of the parent role.',
  `Description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Description of the role.',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `UserRole_DeveloperName_UNIQUE` (`DeveloperName`),
  KEY `FK_UserRole_CreatedById_INDEX` (`CreatedById`),
  KEY `FK_UserRole_LastModifiedById_INDEX` (`LastModifiedById`),
  KEY `FK_UserRole_ParentRoleId_INDEX` (`ParentRoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Represents a user role in your organization.';
