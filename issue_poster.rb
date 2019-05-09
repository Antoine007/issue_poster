# curl -u "Antoine007:#{ENV['GH_PW']}" -H "Content-Type: application/json" -X POST -d '{"title":"testing","body":"amazingness"}' https://api.github.com/repos/Autorama/Helpdesk/issues
# post an issue on a github repo
# https://developer.github.com/v3/issues/#list-issues-for-a-repository

require 'http'
require 'csv'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = '~/Downloads/GitlabIssues.csv'

sent = 0
max_to_send = 20 #comment out for everything
# position = 1

CSV.foreach(filepath, csv_options) do |row|
  if (sent < max_to_send || 999_999_999)
    issue = row.to_hash
    # p [issue["Name"], issue["Description"]]

    # [ issue['Project'], issue['Entity Type'], issue['Effort'], issue['Feature'], issue['Entity State'] ]
    labels = []
    labels.push("Project: #{issue['Project']}")           if issue['Project'] != ''
    labels.push("Entity Type: #{issue['Entity Type']}")   if issue['Entity Type'] != ''
    labels.push("Effort: #{issue['Effort']}")             if (issue['Effort'] != '') && (issue['Effort'].to_i > 0)
    labels.push("Feature: #{issue['Feature']}")           if issue['Feature'] != ''
    labels.push("Entity State: #{issue['Entity State']}") if issue['Entity State'] != ''
    # Other avail in github issue POST
    # - Milestone: deprecated
    # - Assignees need to be github user name so unused  -> assignees = [issue['Owner'], issue['Assigned Teams']]

    data = {
      title: issue['Name'],
      body: issue['Description'],
      labels: labels
    }
    # p data

    url = URI('https://api.github.com/repos/soenergy/main/issues')
    # response = HTTP.basic_auth(user: 'Antoine007', pass: ENV['GH_PW'])
    response = HTTP.basic_auth(user: 'Antoine007', pass: '')
                   .post(
                     url,
                     json: {
                       title: issue['Name'],
                       body: issue['Description'],
                       labels: labels
                     }
                   )

    if response.code != 201
      p response.code
      p response.body.to_s
    else
      p 'Posted:'
      p data
    end

    sent += 1
  end
end
