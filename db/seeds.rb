user = User.create(
  email: 'test@test.com',
  password: 'password',
  first_name: 'Valerie',
  last_name: 'Barela',
)

puts 'Test user created.'
parsed = YAML.load_file('./lib/all_reps_email.yaml')
contact_info_hash = {}
parsed.each do |rep|
  term_with_info = rep["terms"].find { |term| term.has_key?("contact_form") }
  if term_with_info
    contact_form = term_with_info["contact_form"]
    id = rep["id"]["bioguide"]
    contact_info_hash[id.to_sym] = contact_form
  end
end

file = File.read('lib/senate.json')
parsed = JSON.parse(file)
senators = parsed["members"]
senators.each do |rep|
  contact_url = contact_info_hash[rep["id"].to_sym]
  Rep.create(
    first_name: rep["first_name"],
    last_name: rep["last_name"],
    state: rep["state"],
    title: "Senator",
    party: rep["party"],
    phone: rep["phone"],
    url: rep["url"],
    next_election: rep["next_election"],
    twitter_account: rep["twitter_account"],
    profile_url: "https://abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png",
    contact_url: contact_url
  )
end

puts 'Senators created'

file = File.read('lib/house.json')
parsed = JSON.parse(file)
representatives = parsed["members"]
representatives.each do |rep|
  Rep.create(
    first_name: rep["first_name"],
    last_name: rep["last_name"],
    state: rep["state"],
    title: "Representative",
    party: rep["party"],
    phone: rep["phone"],
    url: rep["url"],
    next_election: rep["next_election"],
    twitter_account: rep["twitter_account"],
    district: rep["district"],
    profile_url: "https://abs.twimg.com/sticky/default_profile_images/default_profile_4_normal.png"
  )
end

puts "House Rep Created"

representative = Rep.find_by(district: 2, state: "UT")
senators = Rep.where(state: "UT", title: 'Senator')
reps = [*senators, representative]
user.create_ties(reps)
user.ties.each do |tie|
  tie.update(subscription: true)
end

puts 'Ties created.'
