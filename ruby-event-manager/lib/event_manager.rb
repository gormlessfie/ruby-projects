# frozen_string_literal: true

require 'csv'
require 'erb'
require 'google/apis/civicinfo_v2'


def clean_zipcode(zip_code)
  zip_code.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue
    'You can find your representative through Google.'
  end
end

def clean_homephone(phone_number)
  temp_number = phone_number
                .to_s
                .delete('-').delete('(').delete(')').delete('.')
                .tr(' ', '')
  if temp_number.length < 10
    'Bad number'
  elsif temp_number.length >= 11
    if temp_number[0] == 1
      temp_number[1, 10]
    else
      'Bad number'
    end
  else
    temp_number
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')
  filename = "output/thanks#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end
week_day_count = Hash.new(0)
def count_days_of_week(date, week_day_count)
  week_day = Date.new(date[2].rjust(4, '20').to_i, date[0].to_i, date[1].to_i).wday
  case week_day
  when 0
    week_day_count[:sunday] += 1
  when 1
    week_day_count[:monday] += 1
  when 2
    week_day_count[:tuesday] += 1
  when 3
    week_day_count[:wednesday] += 1
  when 4
    week_day_count[:thursday] += 1
  when 5
    week_day_count[:friday] += 1
  when 6
    week_day_count[:saturday] += 1
  end

  week_day_count
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

hour_count = Hash.new(0)


contents.each do |row|
  id = row[0]
  hour = row[:regdate].split(' ')[1].split(':')[0].to_i
  hour_count["Hour: #{hour}"] += 1
  name = row[:first_name]

  date = row[:regdate].to_s.split(' ')[0].split('/')


  zip_code = clean_zipcode(row[:zipcode])
  phone_number = clean_homephone(row[:homephone])
  legislators = legislators_by_zipcode(zip_code)
  count_days_of_week(date, week_day_count)
  # form_letter = erb_template.result(binding)
  # save_thank_you_letter(id, form_letter)
end

p week_day_count
