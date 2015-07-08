if Rails.env.development?
  begin
    puts "Adding seed data..."
    puts "seed chapters..."
    chapters = [Fabricate(:chapter_with_groups, name: "London"),
                Fabricate(:chapter_with_groups, name: "Brighton"),
                Fabricate(:chapter_with_groups, name: "Cambridge")]

    puts "seed seessions..."
    sessions = 10.times.map { |n| Fabricate(:sessions, chapter: chapters.sample, date_and_time: DateTime.now+14.days-n.weeks) }

    puts "seed courses..."
    courses = 5.times.map { |n| Fabricate(:course, chapter: chapters.sample, date_and_time: DateTime.now+14.days-n.weeks) }
    puts "seed coaches..."
    coaches = 20.times.map { |n| Fabricate(:coach, groups: Group.coaches.order("RANDOM()").limit(2)) }
    puts "seed tutorials..."
    tutorials = 10.times.map { |n| Fabricate(:tutorial, sessions: sessions.sample) }
    puts "seed feedback_requests..."
    feedback_requests = 5.times.map { Fabricate(:feedback_request) }
    puts "seed feedbacks..."
    feedbacks = 5.times.map { Fabricate(:feedback, tutorial: tutorials.sample, coach: coaches.sample) }

    puts "seed Coach attendenences..."
    40.times do |n|
      coach = coaches.sample
      Fabricate(:attended_session_invitation, role: "Coach", member: coach, sessions: sessions.sample )  rescue "Coach already attended"
    end

    puts "seed a meeting..."
    meeting = Meeting.create(venue: Sponsor.all.shuffle.first,
                             date_and_time: DateTime.now+1.year-11.months,
                             duration: 120,
                             lanyrd_url: "http://lanyrd.com/2013/by-codebar/")
    puts "seed meeting talks..."
    meeting.meeting_talks << MeetingTalk.create(title: "Becoming a Software Engineer",
                                                description: "Inspiring a New Generation of Developers",
                                                speaker_id: Member.first.id,
                                                abstract: Faker::Lorem.paragraph)

    meeting.meeting_talks << MeetingTalk.create(title: "Kickstart your development career",
                                                speaker_id: Member.last.id,
                                                abstract: Faker::Lorem.paragraph)
    puts "..done!"
  rescue Exception => e
    puts e.inspect
    puts "Something went wrong. Try running `bundle exec rake db:drop db:create db:migrate` first"
  end
end
