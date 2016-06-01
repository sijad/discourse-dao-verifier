require_dependency 'enum_site_setting'

class DaoGroupSetting < EnumSiteSetting

  def self.valid_value?(val)
    Group.where(id: val).exists?
  end

  def self.values
    Group.select('id, name').where(automatic: false).map do |g|
      {name: g.name, value: g.id}
    end
  end

end
