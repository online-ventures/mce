# In August 2019 many features were soft-deleted and replaced with renamed
# copies, but the vehicle features page kept offering the deleted ones, so
# most vehicles still use them. This moves vehicles off deleted features
# that have a live replacement, and restores deleted features that have no
# replacement but are still in use, then fixes two badly named replacements.
#
# Feature ids are production ids. The migration checks each id still has the
# expected name and aborts if any differ; databases without these features
# (e.g. a fresh dev database) are skipped.
class MergeDeletedFeatures < ActiveRecord::Migration[6.1]
  # deleted feature id => [expected name, live replacement id, expected name]
  MERGES = {
    122 => ['Power Door Locks', 186, 'Power Locks'],
    113 => ['Sat Radio (XM or Sirius)', 193, 'Satellite Radio'],
    162 => ['Back-up Camera', 197, 'Back Up Camera'],
    177 => ['AM/FM Stereo', 192, 'AM/FM Stereo'],
    107 => ['AM / FM CD Radio', 192, 'AM/FM Stereo'],
    115 => ['Automatic Climate Controls', 182, 'auto climate controls'],
    111 => ['Leather Seating', 184, 'Leather Seats'],
    112 => ['Navigation System', 196, 'Navigation'],
    169 => ['All Wheel Drive', 198, 'AWD (All Wheel Drive)'],
    119 => ['Power Seat Driver', 185, 'Drivers Power Seat'],
    120 => ['Power Sunroof', 187, 'Power Suroof'],
    128 => ['Driver Memory Setting', 189, 'Driver Memory Settings'],
    116 => ['Rear A/ C Heat Vents', 183, 'Rear Heat/AC Vents'],
    175 => ['Heads Up Display(HUD)', 191, 'HUD (Heads Up Display)'],
    194 => ['DVD PLayer', 195, 'DVD Player'],
    109 => ['DVD Entertainment Package', 195, 'DVD Player'],
    152 => ['Side Airbags (seat)', 200, 'Seat Airbags'],
    153 => ['Side Curtain Airbags', 199, 'Curtain Airbags'],
    180 => ['18 in Alloy wheels', 148, '18 Inch Alloy Wheels'],
    181 => ['18 inch alloy wheels', 148, '18 Inch Alloy Wheels'],
    179 => ['19 inch alloy wheels', 136, '19 Inch Alloy Wheels'],
    178 => ['20 inch alloy wheels', 149, '20 Inch Alloy Wheels'],
    139 => ['Back up Sensors', 190, 'Park Assist'],
    188 => ['Power Mirros', 123, 'Power Mirrors'] # 123 is restored below
  }.freeze

  # deleted features with no replacement that are still on vehicles
  RESTORES = {
    114 => 'Air Conditioning',
    123 => 'Power Mirrors',
    124 => 'Power Windows',
    125 => 'Adjustable Foot Pedals',
    126 => 'Auto Dimming Rear View Mirror',
    127 => 'Automatic Wipers',
    130 => 'Keyless Entry',
    117 => 'Rear Wiper',
    118 => 'Dual Power Seats',
    121 => 'Third Row Seating',
    138 => 'Automatic Headlamps',
    140 => 'Cruise Control',
    145 => '16 Inch Steel Wheels',
    147 => '17 inch Steel Wheels',
    159 => '15 Inch Steel Wheels',
    164 => 'Rear Power Sliding Window',
    165 => '22 inch Alloy Wheels',
    167 => 'Hands-free Bluetooth',
    171 => '18 Inch Steel Wheels'
  }.freeze

  # live replacements with bad names, fixed once vehicles are merged into them
  RENAMES = {
    187 => ['Power Suroof', 'Power Sunroof'],
    182 => ['auto climate controls', 'Automatic Climate Controls']
  }.freeze

  def up
    expected = RESTORES.dup
    MERGES.each do |old_id, (old_name, new_id, new_name)|
      expected[old_id] = old_name
      expected[new_id] = new_name
    end

    actual = select_rows(
      "SELECT id, name FROM features WHERE id IN (#{expected.keys.join(',')})"
    ).to_h { |id, name| [id.to_i, name.to_s.strip] }

    if actual.empty?
      say 'None of the expected features exist; skipping.'
      return
    end

    mismatched = expected.reject { |id, name| actual[id] == name }
    if mismatched.any?
      details = mismatched.map { |id, name| "#{id}: expected #{name.inspect}, found #{actual[id].inspect}" }
      raise "Feature ids don't match production, aborting:\n#{details.join("\n")}"
    end

    # Restore first so Power Mirros can merge into a live Power Mirrors.
    execute <<~SQL
      UPDATE features SET deleted_at = NULL, updated_at = NOW()
      WHERE id IN (#{RESTORES.keys.join(',')})
    SQL

    MERGES.each do |old_id, (_, new_id, _)|
      # Give vehicles the replacement unless they already have it...
      execute <<~SQL
        INSERT INTO vehicles_features (vehicle_id, feature_id)
        SELECT DISTINCT vehicle_id, #{new_id} FROM vehicles_features old
        WHERE old.feature_id = #{old_id}
          AND NOT EXISTS (
            SELECT 1 FROM vehicles_features vf
            WHERE vf.vehicle_id = old.vehicle_id AND vf.feature_id = #{new_id}
          )
      SQL
      # ...then drop the deleted feature from every vehicle.
      execute "DELETE FROM vehicles_features WHERE feature_id = #{old_id}"
    end

    RENAMES.each do |id, (_, new_name)|
      execute "UPDATE features SET name = #{connection.quote(new_name)}, updated_at = NOW() WHERE id = #{id}"
    end
    # Vehicle updated_at is left alone on purpose: the public page shows
    # "Updated X ago". The vehicle page cache is busted by bumping its version.
  end

  def down
    # Which vehicles had the old feature, the new one or both is not recorded.
    raise ActiveRecord::IrreversibleMigration, 'Restore vehicles_features and features from a backup'
  end
end
