
# Get-CsTeamsMeetingPolicy | ft
$tag = "Tag:StreamingMedia"
#New-CsTeamsMeetingPolicy -Identity $tag
Set-CsTeamsMeetingPolicy -Identity $tag -AllowedStreamingMediaInput "RTMP"