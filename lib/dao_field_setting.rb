require_dependency 'enum_site_setting'

class DaoFieldSetting < EnumSiteSetting

  def self.valid_value?(val)
    UserField.where(id: val).exists?
  end

  def self.values
    UserField.select('id, name').map do |g|
      {name: g.name, value: g.id}
    end
  end

end
