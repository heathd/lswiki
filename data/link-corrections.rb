replacements = {
'AppreciativeInterview' => 'AppreciativeInterviews',
'DesignStoryboard' => 'DesignStoryBoards',
'Discovery &amp; Action Dialogues' => 'DiscoveryAndActionDialogue',
'Ecocycle' => 'EcocyclePlanning',
'GenerativeRelationships' => 'GenerativeRelationshipsStar',
'Heard, Seen, Respected (HSR)' => 'HeardSeenRespected',
'Integrated~Autonomy' => 'IntegratedAutonomy',
'Purpose-To-Practice' => 'PurposeToPractice',
'W³ (What, So What, Now What?)' => 'WhatSoWhatNowWhat',
'W³ (What? So What? Now What?)' => 'WhatSoWhatNowWhat'
}

Dir['*.md'].each do |file|
  data = File.read(file)
  File.write("#{file}.bak", data)
  replacements.each do |from, to|
    data.gsub!("[[#{from}]]", "[[#{to}]]")
  end

  File.write("#{file}", data)
end
