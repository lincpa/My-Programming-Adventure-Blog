require '.\libs\Microsoft.TeamFoundation.dll'
require '.\libs\Microsoft.TeamFoundation.Client.dll'
require '.\libs\Microsoft.TeamFoundation.WorkItemTracking.Client.dll'

def find_item(arr, val) 
  arr.each do |a|
    return a unless a.Name != val
  end
end

def create_work_item(wi_type, title, desc, area, iter)
  work_item = Microsoft::TeamFoundation::WorkItemTracking::Client::WorkItem.new wi_type
  work_item.Title         = title
  work_item.Description   = desc
  work_item.AreaPath      = area
  work_item.IterationPath = iter
  work_item
end

def add_attachment(wi, path, desc)
  attachment = Microsoft::TeamFoundation::WorkItemTracking::Client::Attachment.new path, desc
  wi.Attachments.Add attachment
end

def main
  tfs       = Microsoft::TeamFoundation::Client::TeamFoundationServerFactory.GetServer "phw-ptrak"
  wi_store  = Microsoft::TeamFoundation::WorkItemTracking::Client::WorkItemStore.new tfs
  project   = find_item wi_store.Projects, "RnD"
  bug_type  = find_item project.WorkItemTypes, "Bug"
  work_item = create_work_item(bug_type, "IronRuby bug creation (#{Time.now.ToString})", 
                               "This bug was created from my IronRuby script!!!",
                               "RnD\\Clojure-clr Testing",
                               "RnD\\Testing")

  add_attachment work_item, "IronRuby-tfs-bug.PNG", "Example image for showing how to add an attachment"

  work_item.Save
  puts "I just created Bug # #{work_item.Id} with an attachment!"

end

main
