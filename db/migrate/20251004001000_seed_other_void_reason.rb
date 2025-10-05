class SeedOtherVoidReason < ActiveRecord::Migration[7.0]
  def up
    say_with_time 'Ensuring default Other void reason exists' do
      execute <<~SQL
        INSERT INTO void_reasons (label, code, active, requires_note, position, created_at, updated_at)
        VALUES ('Other', 'other', TRUE, TRUE, 9999, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        ON CONFLICT (code) DO UPDATE SET
          label = EXCLUDED.label,
          active = EXCLUDED.active,
          requires_note = EXCLUDED.requires_note,
          position = COALESCE(void_reasons.position, EXCLUDED.position),
          updated_at = CURRENT_TIMESTAMP;
      SQL
    end
  end

  def down
    execute <<~SQL
      DELETE FROM void_reasons WHERE code = 'other';
    SQL
  end
end
