class AddPgSearchDmetaphoneSupportFunctions < ActiveRecord::Migration[7.0]
  def up
    say_with_time("Adding support functions for pg_search :dmetaphone") do
      # execute <<~'SQL'.squish
      #   CREATE OR REPLACE FUNCTION pg_search_dmetaphone(text) RETURNS text LANGUAGE SQL IMMUTABLE STRICT AS $function$
      #     SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
      #   $function$;
      # SQL

      create_function :pg_search_dmetaphone, "text text", <<~'SQL'.squish
        RETURNS text LANGUAGE SQL IMMUTABLE STRICT AS $function$
          SELECT array_to_string(ARRAY(SELECT dmetaphone(unnest(regexp_split_to_array($1, E'\\s+')))), ' ')
        $function$;
      SQL

    end
  end

  def down
    say_with_time("Dropping support functions for pg_search :dmetaphone") do
      drop_function :pg_search_dmetaphone, "text text"
    end
  end
end
