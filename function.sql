CREATE FUNCTION find_health_points_by_shinobi_id (x bigint)
    RETURNS integer AS $find_health_points_by_shinobi_id$
BEGIN
    RETURN (SELECT health_points FROM shinobi WHERE id = $1);
END
$find_health_points_by_shinobi_id$ LANGUAGE plpgsql;

CREATE FUNCTION update_village() RETURNS trigger AS $update_village$
BEGIN

    IF NEW.country_id != OLD.country_id THEN
        RAISE EXCEPTION 'country_id should not be different from the previous one';
    END IF;

    IF find_health_points_by_shinobi_id(NEW.kage_id) = 0 THEN
        RAISE EXCEPTION 'kage health points cannot be 0';
    END IF;

    RETURN NEW;
END;
$update_village$ LANGUAGE plpgsql;

CREATE TRIGGER update_village BEFORE INSERT OR UPDATE ON villages
    FOR EACH ROW EXECUTE PROCEDURE update_village();


CREATE FUNCTION update_clans() RETURNS trigger AS
$update_clans$
BEGIN

    IF find_health_points_by_shinobi_id(NEW.leader_id) = 0 THEN
        RAISE EXCEPTION 'leader health points cannot be 0';
    END IF;

    RETURN NEW;
END;
$update_clans$ LANGUAGE plpgsql;

CREATE TRIGGER update_clans
    BEFORE INSERT OR UPDATE
    ON clans
    FOR EACH ROW
EXECUTE PROCEDURE update_clans();

CREATE FUNCTION update_organization() RETURNS trigger AS
$update_organization$
BEGIN

    IF find_health_points_by_shinobi_id(NEW.leader_id) = 0 THEN
        RAISE EXCEPTION 'leader health points cannot be 0';
    END IF;

    RETURN NEW;
END;
$update_organization$ LANGUAGE plpgsql;

CREATE TRIGGER update_organization
    BEFORE INSERT OR UPDATE
    ON organizations
    FOR EACH ROW
EXECUTE PROCEDURE update_organization();

CREATE FUNCTION update_countries() RETURNS trigger AS
$update_countries$
BEGIN

    IF find_health_points_by_shinobi_id(NEW.daimyo_id) = 0 THEN
        RAISE EXCEPTION 'daimyo health points cannot be 0';
    END IF;

    RETURN NEW;
END;
$update_countries$ LANGUAGE plpgsql;

CREATE TRIGGER update_countries
    BEFORE INSERT OR UPDATE
    ON countries
    FOR EACH ROW
EXECUTE PROCEDURE update_countries();

CREATE FUNCTION update_team() RETURNS trigger AS
$update_team$
BEGIN

    IF find_health_points_by_shinobi_id(NEW.leader_id) = 0 THEN
        RAISE EXCEPTION 'leader health points cannot be 0';
    END IF;

    RETURN NEW;
END;
$update_team$ LANGUAGE plpgsql;

CREATE TRIGGER update_team
    BEFORE INSERT OR UPDATE
    ON teams
    FOR EACH ROW
EXECUTE PROCEDURE update_team();
