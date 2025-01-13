. "$PSScriptRoot/shared.ps1"

$listname = "Scripts"
DocumentLibrary $listname
CalculatedField $listname "Execute" "Execute" "=0"

<#
You can get the internal name of all field by running the following command:
```powershell
Get-PnPField  -List "Scripts" | Select Title,InternalName
```

Title                                       InternalName
-----                                       ------------
Content Type ID                             ContentTypeId
Approver Comments                           _ModerationComments
Name                                        FileLeafRef
Document Modified By                        Modified_x0020_By
Document Created By                         Created_x0020_By
File Type                                   File_x0020_Type
HTML File Type                              HTML_x0020_File_x0020_Type
Source URL                                  _SourceUrl
Shared File Index                           _SharedFileIndex
Color                                       _ColorHex
Color Tag                                   _ColorTag
Emoji                                       _Emoji
Media Generated Metadata                    MediaGeneratedMetadata
Media User Metadata                         MediaUserMetadata
Compliance Asset Id                         ComplianceAssetId
Title                                       Title
Template Link                               TemplateUrl
HTML File Link                              xd_ProgID
Is Signed                                   xd_Signature
Effective Sensitivity                       _EffectiveIpLabelDisplayName
Shortcut URL                                _ShortcutUrl
Shortcut Site Id                            _ShortcutSiteId
Shortcut Web Id                             _ShortcutWebId
Shortcut Unique Id                          _ShortcutUniqueId
Description                                 _ExtendedDescription
Trigger Flow Info                           TriggerFlowInfo
Execute                                     Execute
ID                                          ID
Content Type                                ContentType
Created                                     Created
Created By                                  Author
Modified                                    Modified
Modified By                                 Editor
Has Copy Destinations                       _HasCopyDestinations
Copy Source                                 _CopySource
Approval Status                             _ModerationStatus
URL Path                                    FileRef
Path                                        FileDirRef
Modified                                    Last_x0020_Modified
Created                                     Created_x0020_Date
File Size                                   File_x0020_Size
Item Type                                   FSObjType
Sort Type                                   SortBehavior
Effective Permissions Mask                  PermMask
Principal Count                             PrincipalCount
ID of the User who has the item Checked Out CheckedOutUserId
Is Checked out to local                     IsCheckedoutToLocal
Checked Out To                              CheckoutUser
Unique Id                                   UniqueId
Document Parent Identifier                  ParentUniqueId
Client Id                                   SyncClientId
ProgId                                      ProgId
ScopeId                                     ScopeId
Virus Status                                VirusStatus
Checked Out To                              CheckedOutTitle
Check In Comment                            _CheckinComment
Checked Out To                              LinkCheckedOutTitle
Edit Menu Table Start                       _EditMenuTableStart
Edit Menu Table Start                       _EditMenuTableStart2
Edit Menu Table End                         _EditMenuTableEnd
Name                                        LinkFilenameNoMenu
Name                                        LinkFilename
Name                                        LinkFilename2
Type                                        DocIcon
Server Relative URL                         ServerUrl
Encoded Absolute URL                        EncodedAbsUrl
Name                                        BaseName
File Size                                   FileSizeDisplay
Property Bag                                MetaInfo
Level                                       _Level
Is Current Version                          _IsCurrentVersion
Item Child Count                            ItemChildCount
Folder Child Count                          FolderChildCount
Restricted                                  Restricted
Originator Id                               OriginatorId
NoExecute                                   NoExecute
Content Version                             ContentVersion
Label setting                               _ComplianceFlags
Retention label                             _ComplianceTag
Retention label Applied                     _ComplianceTagWrittenTime
Label applied by                            _ComplianceTagUserId
Item is a Record                            _IsRecord
BLOB Sequence Number                        BSN
List Schema Version                         _ListSchemaVersion
Dirty                                       _Dirty
Parsable                                    _Parsable
StubFile                                    _StubFile
HasEncryptedContent                         _HasEncryptedContent
HasUserDefinedProtection                    _HasUserDefinedProtection
Access Policy                               AccessPolicy
VirusStatus                                 _VirusStatus
VirusVendorID                               _VirusVendorID
VirusInfo                                   _VirusInfo
RansomwareAnomalyMetaInfo                   _RansomwareAnomalyMetaInfo
Comment settings                            _CommentFlags
Comment count                               _CommentCount
Like count                                  _LikeCount
Rights Management Template Id               _RmsTemplateId
Sensitivity Label Id                        _IpLabelId
Sensitivity                                 _DisplayName
Sensitivity Label Assignment Method         _IpLabelAssignmentMethod
A2OD Mount Count                            A2ODMountCount
Expiration Date                             _ExpirationDate
IpLabelHash                                 _IpLabelHash
IpLabelPromotionCtagVersion                 _IpLabelPromotionCtagVersion
Sensitivity Label Metadata                  _IpLabelMetaInfo
AdditionalStreamSize                        _AdditionalStreamSize
StreamScenarioIds                           _StreamScenarioIds
App Created By                              AppAuthor
App Modified By                             AppEditor
Total Size                                  SMTotalSize
Last Modified Date                          SMLastModifiedDate
Total File Stream Size                      SMTotalFileStreamSize
Total File Count                            SMTotalFileCount
Select                                      SelectTitle
Select                                      SelectFilename
Edit                                        Edit
owshiddenversion                            owshiddenversion
UI Version                                  _UIVersion
Version                                     _UIVersionString
Instance ID                                 InstanceID
Order                                       Order
GUID                                        GUID
Workflow Version                            WorkflowVersion
Workflow Instance ID                        WorkflowInstanceID
Source Version (Converted Document)         ParentVersionString
Source Name (Converted Document)            ParentLeafName
Document Concurrency Number                 DocConcurrencyNumber
Document Stream Hash                        StreamHash
Merge                                       Combine
Relink                                      RepairDocument
Actions Disabled by Policy                  PolicyDisabledUICapabilities

PS /Users/nielsgregersjohansen/kitchens/koksmat-captain> 
PS /Users/nielsgregersjohansen/kitchens/koksmat-captain> . '/Users/nielsgregersjohansen/kitchens/koksmat-captain/provision-sharepointsite-koksmat/sharepoint-script-library.ps1'
Checking list Scripts
Updating field Execute

Title                                       InternalName
-----                                       ------------
Content Type ID                             ContentTypeId
Approver Comments                           _ModerationComments
Name                                        FileLeafRef
Document Modified By                        Modified_x0020_By
Document Created By                         Created_x0020_By
File Type                                   File_x0020_Type
HTML File Type                              HTML_x0020_File_x0020_Type
Source URL                                  _SourceUrl
Shared File Index                           _SharedFileIndex
Color                                       _ColorHex
Color Tag                                   _ColorTag
Emoji                                       _Emoji
Media Generated Metadata                    MediaGeneratedMetadata
Media User Metadata                         MediaUserMetadata
Compliance Asset Id                         ComplianceAssetId
Title                                       Title
Template Link                               TemplateUrl
HTML File Link                              xd_ProgID
Is Signed                                   xd_Signature
Effective Sensitivity                       _EffectiveIpLabelDisplayName
Shortcut URL                                _ShortcutUrl
Shortcut Site Id                            _ShortcutSiteId
Shortcut Web Id                             _ShortcutWebId
Shortcut Unique Id                          _ShortcutUniqueId
Description                                 _ExtendedDescription
Trigger Flow Info                           TriggerFlowInfo
Execute                                     Execute
ID                                          ID
Content Type                                ContentType
Created                                     Created
Created By                                  Author
Modified                                    Modified
Modified By                                 Editor
Has Copy Destinations                       _HasCopyDestinations
Copy Source                                 _CopySource
Approval Status                             _ModerationStatus
URL Path                                    FileRef
Path                                        FileDirRef
Modified                                    Last_x0020_Modified
Created                                     Created_x0020_Date
File Size                                   File_x0020_Size
Item Type                                   FSObjType
Sort Type                                   SortBehavior
Effective Permissions Mask                  PermMask
Principal Count                             PrincipalCount
ID of the User who has the item Checked Out CheckedOutUserId
Is Checked out to local                     IsCheckedoutToLocal
Checked Out To                              CheckoutUser
Unique Id                                   UniqueId
Document Parent Identifier                  ParentUniqueId
Client Id                                   SyncClientId
ProgId                                      ProgId
ScopeId                                     ScopeId
Virus Status                                VirusStatus
Checked Out To                              CheckedOutTitle
Check In Comment                            _CheckinComment
Checked Out To                              LinkCheckedOutTitle
Edit Menu Table Start                       _EditMenuTableStart
Edit Menu Table Start                       _EditMenuTableStart2
Edit Menu Table End                         _EditMenuTableEnd
Name                                        LinkFilenameNoMenu
Name                                        LinkFilename
Name                                        LinkFilename2
Type                                        DocIcon
Server Relative URL                         ServerUrl
Encoded Absolute URL                        EncodedAbsUrl
Name                                        BaseName
File Size                                   FileSizeDisplay
Property Bag                                MetaInfo
Level                                       _Level
Is Current Version                          _IsCurrentVersion
Item Child Count                            ItemChildCount
Folder Child Count                          FolderChildCount
Restricted                                  Restricted
Originator Id                               OriginatorId
NoExecute                                   NoExecute
Content Version                             ContentVersion
Label setting                               _ComplianceFlags
Retention label                             _ComplianceTag
Retention label Applied                     _ComplianceTagWrittenTime
Label applied by                            _ComplianceTagUserId
Item is a Record                            _IsRecord
BLOB Sequence Number                        BSN
List Schema Version                         _ListSchemaVersion
Dirty                                       _Dirty
Parsable                                    _Parsable
StubFile                                    _StubFile
HasEncryptedContent                         _HasEncryptedContent
HasUserDefinedProtection                    _HasUserDefinedProtection
Access Policy                               AccessPolicy
VirusStatus                                 _VirusStatus
VirusVendorID                               _VirusVendorID
VirusInfo                                   _VirusInfo
RansomwareAnomalyMetaInfo                   _RansomwareAnomalyMetaInfo
Comment settings                            _CommentFlags
Comment count                               _CommentCount
Like count                                  _LikeCount
Rights Management Template Id               _RmsTemplateId
Sensitivity Label Id                        _IpLabelId
Sensitivity                                 _DisplayName
Sensitivity Label Assignment Method         _IpLabelAssignmentMethod
A2OD Mount Count                            A2ODMountCount
Expiration Date                             _ExpirationDate
IpLabelHash                                 _IpLabelHash
IpLabelPromotionCtagVersion                 _IpLabelPromotionCtagVersion
Sensitivity Label Metadata                  _IpLabelMetaInfo
AdditionalStreamSize                        _AdditionalStreamSize
StreamScenarioIds                           _StreamScenarioIds
App Created By                              AppAuthor
App Modified By                             AppEditor
Total Size                                  SMTotalSize
Last Modified Date                          SMLastModifiedDate
Total File Stream Size                      SMTotalFileStreamSize
Total File Count                            SMTotalFileCount
Select                                      SelectTitle
Select                                      SelectFilename
Edit                                        Edit
owshiddenversion                            owshiddenversion
UI Version                                  _UIVersion
Version                                     _UIVersionString
Instance ID                                 InstanceID
Order                                       Order
GUID                                        GUID
Workflow Version                            WorkflowVersion
Workflow Instance ID                        WorkflowInstanceID
Source Version (Converted Document)         ParentVersionString
Source Name (Converted Document)            ParentLeafName
Document Concurrency Number                 DocConcurrencyNumber
Document Stream Hash                        StreamHash
Merge                                       Combine
Relink                                      RepairDocument
Actions Disabled by Policy                  PolicyDisabledUICapabilities

#>
$json = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "txtContent": "[$LinkFilename]"
}

'@


Set-PnPField -List $listname -Identity "Execute" -Values @{ CustomFormatter = $json }
