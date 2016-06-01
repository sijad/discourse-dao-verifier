desc "Update users group"
task "dao:sync" => :environment do
  group = Group.find_by(id: SiteSetting.dao_group)
  break if !group.present?
  # .where("updated_at < ?", 1.hour.ago)
  UserCustomField.where(name: "user_field_#{SiteSetting.dao_field}")
    .pluck(:user_id, :value)
    .each do |user_id, address|
      user = User.find_by(id: user_id)
      balance = JSON.parse(Excon.post('https://rpc.myetherwallet.com/api.php',
        :body => URI.encode_www_form(:balance => address),
        :headers => { "Content-Type" => "application/x-www-form-urlencoded" }, :read_timeout => 5,
        :connect_timeout => 5).body)['data']['balance'].to_f rescue 0
      if balance > 0 && !user.groups.include?(group)
        group.add(user)
      else
        group.remove(user)
      end
  end
end
