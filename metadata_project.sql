/* DDL table structures */

/**
  This statement creates the models table which represents the creation of a new relational database model that
  models a real-world dataset. model_name uniquely identifies a given model and thus is designated as a primary
  key of the table.
 */
CREATE TABLE models (
    model_name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    creation_date DATE,
    CONSTRAINT models_pk PRIMARY KEY (model_name)
);

/**
  This statement creates the relation scheme table which represents the creation of a new relation scheme of a
  particular relational database model. The model_name and scheme_name uniquely identify a particular relation scheme
  of a given relational model and thus serves as the primary keys. In addition, the migrating foreign key in this
  case is the model_name.
 */
CREATE TABLE relational_schemes (
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    CONSTRAINT relational_schemes_pk PRIMARY KEY (scheme_name, model_name),
    CONSTRAINT relational_schemes_fk_1 FOREIGN KEY (model_name) REFERENCES models (model_name)
);

/**
  This statement creates the constraints table which represents the creation of a new constraint of a
  particular relational database model. The model_name and the name of the constraint uniquely identify a particular
  constraint of a given relational model and thus serves as the primary keys. In addition, the migrating foreign key
  in this case is the model_name.
 */
CREATE TABLE constraints (
    model_name VARCHAR(50) NOT NULL,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT constraints_pk_01 PRIMARY KEY (model_name, name),
    CONSTRAINT constraints_fk_01 FOREIGN KEY (model_name) REFERENCES models (model_name)
);

/**
  This statement creates the attributes table which represents the creation of a new attribute of a
  particular relational database model. The model_name, scheme_name, and attribute_name uniquely identify a particular
  attribute of a given relational model and thus serves as the primary keys. In addition, the migrating foreign keys
  in this case are the model_name and scheme_name.
 */
CREATE TABLE attributes (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    CONSTRAINT attributes_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT attributes_fk_1 FOREIGN KEY (scheme_name, model_name)
        REFERENCES relational_schemes (scheme_name, model_name)
);

/**
  This statement creates the candidate keys table which represents the creation of a new candidate key of a
  particular relational database model. The model_name and the key_name uniquely identify a particular
  candidate key of a given relational model and thus serves as the primary keys. In addition, the migrating foreign keys
  in this case are model_name and scheme_name.
 */
CREATE TABLE candidate_keys (
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    key_name VARCHAR(50) NOT NULL,
    CONSTRAINT candidate_keys_pk PRIMARY KEY (model_name, key_name),
    CONSTRAINT candidate_keys_fk_1 FOREIGN KEY (model_name) REFERENCES constraints (model_name),
    CONSTRAINT candidate_keys_fk_2 FOREIGN KEY (scheme_name, model_name)
        REFERENCES relational_schemes (scheme_name, model_name)
);

/**
  This statement creates the primary key table which represents the creation of a new primary key of a
  particular relational database model. The model_name and the key_name uniquely identify a particular
  primary key of a given relational model and thus serves as the primary keys. In addition, the migrating foreign keys
  in this case are the model_name and key_name.
 */
CREATE TABLE primary_keys (
    model_name VARCHAR(50) NOT NULL,
    key_name VARCHAR(50) NOT NULL,
    CONSTRAINT primary_keys_pk PRIMARY KEY (model_name, key_name),
    CONSTRAINT primary_keys_fk_1 FOREIGN KEY (model_name, key_name)
        REFERENCES candidate_keys (model_name, key_name)
);

/**
  This statement creates the candidate key members table which represents the creation of candidate key membership of a
  particular relational database model. The model_name, attribute_name, scheme_name, and key_name uniquely identify a particular
  constraint of a given relational model and thus serves as the primary keys. In addition, the migrating foreign keys
  in this case are model_name, scheme_name, attribute_name. Since model_name, key_name, and order_num should be unique,
  a uniqueness constrain on candidate key members has been enforced.
 */
CREATE TABLE candidate_key_members (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    key_name VARCHAR(50) NOT NULL,
    order_num INTEGER DEFAULT 0,
    CONSTRAINT candidate_key_members_pk PRIMARY KEY (attribute_name, scheme_name, model_name, key_name),
    CONSTRAINT candidate_key_members_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name),
    CONSTRAINT candidate_key_members_fk_2 FOREIGN KEY (model_name, key_name)
        REFERENCES candidate_keys (model_name, key_name),
    CONSTRAINT candidate_key_members_uk_1 UNIQUE (model_name, key_name, order_num)
);

/**
  This statement creates the relationship names table which represents the creation of a new relationship name of a
  particular relational database model. The name of the relationship uniquely identifies a particular relationship
  name of a given relational model and thus serves as the primary key.
 */
CREATE TABLE relationship_names (
    name VARCHAR(50) NOT NULL,
    CONSTRAINT relationship_names_pk_1 PRIMARY KEY (name)
);

/**
  This statement creates the cardinalities table which represents the creation of a new cardinality of a
  particular relationship within a given relational database model. The cardinality type uniquely identifies a
  particular relationship of a given relational model and thus serves as the primary key.
 */
CREATE TABLE cardinalities (
    type VARCHAR(50) NOT NULL,
    CONSTRAINT relationship_names_pk_1 PRIMARY KEY (type)
);

/**
  This statement creates the foreign keys table which represents the creation of a new foreign key of a
  particular relational database model. The model_name and the key_name uniquely identify a particular
  primary key of a given relational model and thus serves as the primary keys. In addition, the migrating foreign keys
  in this case are the model_name, key_name, name of the constraint, parent scheme name, child scheme name,
  name of the relationship, cardinality of the parent, and cardinality of the child.
 */
CREATE TABLE foreign_keys (
    model_name VARCHAR(50) NOT NULL,
    key_name VARCHAR(50) NOT NULL,
    parent_scheme VARCHAR(50) NOT NULL,
    child_scheme VARCHAR(50) NOT NULL,
    relationship_name VARCHAR(50) NOT NULL,
    parent_cardinality VARCHAR(50) NOT NULL,
    child_cardinality VARCHAR(50) NOT NULL,
    identifying BOOLEAN,
    CONSTRAINT foreign_keys_pk_1 PRIMARY KEY (model_name, key_name),
    CONSTRAINT foreign_keys_fk_1 FOREIGN KEY (model_name, key_name)
        REFERENCES constraints (model_name, name),
    CONSTRAINT foreign_keys_fk_2 FOREIGN KEY (parent_scheme, model_name)
        REFERENCES relational_schemes (scheme_name, model_name),
    CONSTRAINT foreign_keys_fk_3 FOREIGN KEY (child_scheme, model_name)
        REFERENCES relational_schemes (scheme_name, model_name),
    CONSTRAINT foreign_keys_fk_4 FOREIGN KEY (relationship_name)
        REFERENCES relationship_names (name),
    CONSTRAINT foreign_keys_fk_5 FOREIGN KEY (parent_cardinality)
        REFERENCES cardinalities (type),
    CONSTRAINT foreign_keys_fk_6 FOREIGN KEY (child_cardinality)
        REFERENCES cardinalities (type)
);

/**
  This statement creates the foreign key migrations table which represents the creation of a new foreign key migration of a
  particular relational database model. The model_name, key_name, child_attribute, and child_scheme
  uniquely identify a particular foreign key migration of a given relational model and thus serves as the
  primary keys. In addition, the migrating foreign keys in this case are the model_name, key_name, child_attribute,
  child_scheme, parent_scheme, and parent_attribute.
 */
CREATE TABLE foreign_key_migrations (
    parent_attribute VARCHAR(50) NOT NULL,
    parent_scheme VARCHAR(50) NOT NULL,
    child_attribute VARCHAR(50) NOT NULL,
    child_scheme VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    key_name VARCHAR(50) NOT NULL,
    CONSTRAINT foreign_key_migrations_pk_01 PRIMARY KEY (child_attribute, child_scheme, model_name, key_name),
    CONSTRAINT foreign_key_migrations_fk_01 FOREIGN KEY (parent_attribute, parent_scheme, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name),
    CONSTRAINT foreign_key_migrations_fk_02 FOREIGN KEY (child_attribute, child_scheme, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name),
    CONSTRAINT foreign_key_migrations_fk_03 FOREIGN KEY (model_name, key_name)
        REFERENCES foreign_keys (model_name, key_name)
);

/**
  This statement creates the integers table which represents the creation of a new integer datatype of a
  particular relational database model. The model_name, scheme_name, attribute_name
  uniquely identify a particular integer datatype of a given relational model and thus serves as the
  primary keys and also serve as the foreign keys.
 */
CREATE TABLE integers (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    CONSTRAINT integers_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT integers_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name)
);

/**
  This statement creates the decimals table which represents the creation of a new decimal datatype of a
  particular relational database model. The model_name, scheme_name, attribute_name
  uniquely identify a particular decimal datatype of a given relational model and thus serves as the
  primary keys and also serve as the foreign keys. A check constraint is enforced onto the precision and scale attributes
  to ensure that the datatype is nonnegative and less than a specified maximum value, say 66 as an upper bound.
 */
CREATE TABLE decimals (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    decimal_precision INTEGER NOT NULL,
    scale INTEGER NOT NULL,
    CONSTRAINT precision_chk CHECK (decimal_precision > scale and decimal_precision < 66),
    CONSTRAINT scale_chk CHECK (scale > 0 and scale <= decimal_precision),
    CONSTRAINT decimals_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT decimals_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name)
);

/**
  This statement creates the floats table which represents the creation of a new float datatype of a
  particular relational database model. The model_name, scheme_name, attribute_name
  uniquely identify a particular float datatype of a given relational model and thus serves as the
  primary keys and also serve as the foreign keys.
 */
CREATE TABLE floats (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    CONSTRAINT floats_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT floats_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name)
);

/**
  This statement creates the varchars table which represents the creation of a new varchar datatype of a
  particular relational database model. The model_name, scheme_name, attribute_name
  uniquely identify a particular varchar datatype of a given relational model and thus serves as the
  primary keys and also serve as the foreign keys. A check constraint is enforced onto the length attribute
  to ensure that the datatype is nonnegative and less than an astronomical value, say 65535 as an upper bound.
 */
CREATE TABLE varchars (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    length INTEGER NOT NULL,
    CHECK (length > 0 and length <= 65535),
    CONSTRAINT varchars_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT varchars_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name)
);

/**
  This statement creates the dates table which represents the creation of a new date datatype of a
  particular relational database model. The model_name, scheme_name, attribute_name
  uniquely identify a particular date datatype of a given relational model and thus serves as the
  primary keys and also serve as the foreign keys.
 */
CREATE TABLE dates (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    CONSTRAINT dates_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT dates_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name)
);

/**
  This statement creates the times table which represents the creation of a new time datatype of a
  particular relational database model. The model_name, scheme_name, attribute_name
  uniquely identify a particular time datatype of a given relational model and thus serves as the
  primary keys and also serve as the foreign keys.
 */
CREATE TABLE times (
    attribute_name VARCHAR(50) NOT NULL,
    scheme_name VARCHAR(50) NOT NULL,
    model_name VARCHAR(50) NOT NULL,
    CONSTRAINT times_pk PRIMARY KEY (attribute_name, scheme_name, model_name),
    CONSTRAINT times_fk_1 FOREIGN KEY (attribute_name, scheme_name, model_name)
        REFERENCES attributes (attribute_name, scheme_name, model_name)
);

/* Triggers/Functions */

/*
The following procedure checks if all of a primary key's attributes in a parent relational scheme has migrated into
its child attribute.
@param model                    The name of the model the foreign key belongs to.
@param foreign_key_name         Then name of the foreign key.
*/
/* implements business rule (2a) */
DELIMITER $$
CREATE PROCEDURE foreign_key_check(model VARCHAR(50), foreign_key_name VARCHAR(50)) READS SQL DATA
BEGIN
    /* stores a temporary value that is fetched by the cursor */
    DECLARE temp VARCHAR(50) DEFAULT '';
    /* signals when to stop a loop, after the cursor has finished iterating through a list */
    DECLARE done INTEGER DEFAULT 0;
    /* this cursor fetches a list of all of the primary key attributes that has migrated into its child attribute */
    DECLARE pk_attribute_cur CURSOR FOR
        SELECT m.attribute_name
        FROM candidate_key_members m
            INNER JOIN candidate_keys ck USING (model_name, key_name)
            INNER JOIN primary_keys pk USING (model_name, key_name)
        WHERE m.scheme_name =
              (SELECT DISTINCT parent_scheme
               FROM foreign_keys
               WHERE key_name = foreign_key_name
                 AND model_name = model);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    IF NOT EXISTS(SELECT 1
                  FROM foreign_key_migrations
                  WHERE key_name = foreign_key_name)
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'no foreign key attributes found or foreign key does not exist';
    END IF;

    OPEN pk_attribute_cur;

    check_fk_members: LOOP
        FETCH pk_attribute_cur INTO temp;
        IF done = 1 THEN LEAVE check_fk_members;
        END IF;
        IF NOT EXISTS(SELECT 1
                      FROM foreign_key_migrations
                      WHERE parent_attribute = temp AND key_name = foreign_key_name)
            THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'not all primary keys has been migrated to its child';
        END IF;
    END LOOP;
    CLOSE pk_attribute_cur;
end $$
DELIMITER ;

/*
Checks for redundancies between candidate keys in a relational scheme that is passed in.
@param model                    The name of the relational scheme model.
@param scheme                   The name of the relational scheme.
*/
/* implements business rules (3a) and (3b) */
DELIMITER $$
CREATE PROCEDURE candidate_key_redundancy_check(IN model VARCHAR(50), IN scheme VARCHAR(50)) READS SQL DATA
BEGIN
    /* stores a key name fetched by the cursor */
    DECLARE k_name VARCHAR(50) DEfAULT '';
    /* signals when to stop a loop, after the cursor has finished iterating through a list */
    DECLARE done INTEGER DEFAULT 0;
    /* the following cursor fetches a list of candidate key names */
    DECLARE ck_name_cur CURSOR FOR
        SELECT DISTINCT m.key_name
        FROM candidate_key_members m
        WHERE m.model_name = model AND m.scheme_name = scheme;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    IF NOT EXISTS(SELECT 1
                  FROM candidate_key_members m
                  WHERE m.model_name = model AND m.scheme_name = scheme)
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'no candidate key attributes found in relation scheme';
    END IF;

    OPEN ck_name_cur;

    check_constraint: LOOP
        FETCH ck_name_cur INTO k_name;
        IF done = 1 THEN LEAVE check_constraint;
        END IF;
        /* returns true if all of a candidate key's attributes are shared with another ck */
        IF NOT EXISTS(SELECT m.attribute_name
                  FROM candidate_key_members m
                  WHERE m.key_name = k_name AND scheme_name = scheme AND m.model_name = model
                    AND NOT EXISTS(SELECT m1.key_name
                                   FROM candidate_key_members m1
                                   WHERE m1.scheme_name = scheme AND m.model_name = model
                                     AND m1.key_name <> m.key_name AND m1.attribute_name = m.attribute_name))
            THEN SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'redundant candidate key found in relation scheme: ';
        END IF;
    END LOOP;
    CLOSE ck_name_cur;
end $$
DELIMITER ;

/*
The following procedure checks for any split keys in a relational scheme that is passed in through the parameter.
The relational scheme must contain migrated foreign key attributes that references its parent relational scheme's
primary key attributes.
@param in_model                 The name of the relational scheme model.
@param in_child_scheme          The name of the relational scheme to be checked.
*/
/* implements business rule (4) */
DELIMITER $$
CREATE PROCEDURE split_key_check(IN in_model VARCHAR(50),IN in_child_scheme VARCHAR(50)) READS SQL DATA
BEGIN
    /* signals when to stop a loop, after a cursor has finished iterating through a list */
    DECLARE done INT DEFAULT 0;
    /* stores the name of a candidate key that is fetched by a cursor */
    DECLARE ck_name VARCHAR(50) DEFAULT '';
    /* this cursor fetches a list of all the candidate keys that belongs to the relational scheme passed in
       by the procedure */
    DECLARE ck_cur CURSOR FOR
        SELECT m.key_name
        FROM candidate_key_members m
        WHERE m.model_name = in_model AND m.scheme_name = in_child_scheme;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN ck_cur;

    check_for_split_key: LOOP /* start of split key check */
        FETCH ck_cur INTO ck_name;
        IF done = 1 THEN LEAVE check_for_split_key;
        END IF;
        FK_CHECK_BLOCK: BEGIN
            /* signals when to stop a loop, after the cursor has finished iterating through a list of foreign keys */
            DECLARE fk_done INT DEFAULT 0;
            /* stores the name of a foreign key fetched by the cursor */
            DECLARE fk_name VARCHAR(50) DEFAULT '';
            /* this cursor fetches a list of all the foreign keys that belongs to the relational scheme passed in
               by the procedure */
            DECLARE fk_cur CURSOR FOR
            SELECT key_name
            FROM foreign_keys
            WHERE model_name = in_model AND child_scheme = in_child_scheme;

            DECLARE CONTINUE HANDLER FOR NOT FOUND SET fk_done = 1;
            OPEN fk_cur;

            fk_check_loop: LOOP
                FETCH fk_cur INTO fk_name;
                IF fk_done = 1 THEN LEAVE fk_check_loop;
                END IF;
                IF EXISTS (SELECT m.attribute_name /* for every ck attribute that is in the child relational scheme */
                  FROM candidate_key_members m
                  WHERE m.model_name = in_model AND m.scheme_name = in_child_scheme
                    AND m.key_name = ck_name AND m.attribute_name IN /* check if its attribute is also part of a fk attribute */
                                                 (SELECT fkm.child_attribute
                                                  FROM foreign_key_migrations fkm
                                                  WHERE fkm.model_name = in_model AND fkm.child_scheme = in_child_scheme
                                                    AND fkm.key_name = fk_name))
                THEN /* if true, check if all the following fk attributes are inside the ck */
                    IF EXISTS(SELECT fkm.child_attribute /* returns true if one of the fk attributes is not inside the ck */
                              FROM foreign_key_migrations fkm
                              WHERE fkm.model_name = in_model AND fkm.child_scheme = in_child_scheme AND fkm.key_name = fk_name
                                AND fkm.child_attribute NOT IN
                                    (SELECT m.attribute_name
                                     FROM candidate_key_members m
                                     WHERE m.model_name = in_model AND m.scheme_name = in_child_scheme
                                       AND m.key_name = ck_name))
                    THEN
                        /* if true, check if all the attributes in the following candidate key is a proper subset of a
                           single FK, not including the FK that has attributes outside the candidate key */
                        COLLIDING_FK_CHECK_BLOCK: BEGIN
                            /* stores the name of a candidate key attribute fetched by the cursor */
                            DECLARE ck_attribute VARCHAR(50) DEFAULT '';
                            /* signals when to stop a loop, after a cursor has finished iterating through a list */
                            DECLARE done INT DEFAULT 0;
                            /* this cursor fetches a list of all the ck attributes that belongs to the relational
                               scheme passed in by the procedure */
                            DECLARE attribute_cur CURSOR FOR
                                SELECT m.attribute_name
                                FROM candidate_key_members m
                                WHERE m.model_name = in_model AND m.scheme_name = in_child_scheme
                                  AND m.key_name = ck_name;

                            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
                            OPEN attribute_cur;

                            check_for_colliding_fk: LOOP
                                FETCH attribute_cur INTO ck_attribute;
                                IF done = 1 THEN LEAVE check_for_colliding_fk;
                                END IF;
                                /* finds another FK with a matching CK attribute and checks if all of its
                                   attributes are inside the CK */
                                IF NOT EXISTS (SELECT fkm.key_name
                                           FROM foreign_key_migrations fkm
                                           WHERE fkm.model_name = in_model AND fkm.child_scheme = in_child_scheme
                                             AND fkm.child_attribute = ck_attribute AND fkm.key_name <> fk_name
                                             AND fkm.key_name IN
                                                 (SELECT DISTINCT fkm2.key_name
                                                    FROM foreign_key_migrations fkm2
                                                    WHERE fkm2.model_name = in_model
                                                    AND fkm2.child_scheme = in_child_scheme
                                                    AND fkm2.child_attribute IN
                                                        (SELECT m.attribute_name
                                                         FROM candidate_key_members m
                                                         WHERE m.model_name = in_model
                                                            AND m.scheme_name = in_child_scheme
                                                            AND m.key_name = ck_name)))
                                THEN /* if a FK attribute is not inside the candidate key, signal split key error */
                                    SIGNAL SQLSTATE '45000'
                                    SET MESSAGE_TEXT = 'Split key detected in the relational scheme';
                                END IF;
                            END LOOP;
                            CLOSE attribute_cur;
                        END COLLIDING_FK_CHECK_BLOCK;
                    END IF;
                END IF;
            END LOOP; /* end of FK check loop */
            CLOSE fk_cur;
        END FK_CHECK_BLOCK;
    END LOOP; /* end of split key check loop */
    CLOSE ck_cur;
END $$
DELIMITER ;

/* inserts a new foreign_keys value into the constraints table */
DELIMITER $$
CREATE TRIGGER insert_fk BEFORE INSERT ON foreign_keys FOR EACH ROW
BEGIN
    INSERT INTO constraints (model_name, name)
        VALUES (NEW.model_name, NEW.key_name);
end $$

/* inserts a new candidate_keys value into the constraints table */
CREATE TRIGGER insert_ck BEFORE INSERT ON candidate_keys FOR EACH ROW
BEGIN
    INSERT INTO constraints (model_name, name)
        VALUES (NEW.model_name, NEW.key_name);
end $$

/* generates a date for creation_date to the current date if null */
DELIMITER $$
CREATE TRIGGER check_date_insert BEFORE INSERT ON models FOR EACH ROW
BEGIN
    IF NEW.creation_date IS NULL THEN SET NEW.creation_date = CURDATE();
    END IF;
END $$
DELIMITER ;

/* generates a date for creation_date to the current date if null */
DELIMITER $$
CREATE TRIGGER check_date_update BEFORE UPDATE ON models FOR EACH ROW
BEGIN
    IF NEW.creation_date IS NULL THEN SET NEW.creation_date = CURDATE();
    END IF;
END $$
DELIMITER ;

/* inserts integer values into attributes table */
DELIMITER $$
CREATE TRIGGER insert_int BEFORE INSERT ON integers FOR EACH ROW
BEGIN
    INSERT INTO attributes (attribute_name, scheme_name, model_name)
        VALUES (NEW.attribute_name, NEW.scheme_name, NEW.model_name);
END $$
DELIMITER ;

/* deletes integer values from the attributes table */
DELIMITER $$
CREATE TRIGGER delete_int AFTER DELETE ON integers FOR EACH ROW
BEGIN
    DELETE FROM attributes a WHERE a.attribute_name = OLD.attribute_name AND
                                   a.scheme_name = OLD.scheme_name AND
                                   a.model_name = OLD.model_name;
end $$
DELIMITER ;

/* inserts decimal values into attributes table */
DELIMITER $$
CREATE TRIGGER insert_decimal BEFORE INSERT ON decimals FOR EACH ROW
BEGIN
    INSERT INTO attributes (attribute_name, scheme_name, model_name)
        VALUES (NEW.attribute_name, NEW.scheme_name, NEW.model_name);
END $$
DELIMITER ;

/* deletes decimal values from the attributes table */
DELIMITER $$
CREATE TRIGGER delete_decimal AFTER DELETE ON decimals FOR EACH ROW
BEGIN
    DELETE FROM attributes a WHERE a.attribute_name = OLD.attribute_name AND
                                   a.scheme_name = OLD.scheme_name AND
                                   a.model_name = OLD.model_name;
end $$
DELIMITER ;

/* inserts float values into attributes table */
DELIMITER $$
CREATE TRIGGER insert_float BEFORE INSERT ON floats FOR EACH ROW
BEGIN
    INSERT INTO attributes (attribute_name, scheme_name, model_name)
        VALUES (NEW.attribute_name, NEW.scheme_name, NEW.model_name);
END $$
DELIMITER ;

/* deletes float values from the attributes table */
DELIMITER $$
CREATE TRIGGER delete_float AFTER DELETE ON floats FOR EACH ROW
BEGIN
    DELETE FROM attributes a WHERE a.attribute_name = OLD.attribute_name AND
                                   a.scheme_name = OLD.scheme_name AND
                                   a.model_name = OLD.model_name;
end $$
DELIMITER ;

/* inserts varchar values into attributes table */
DELIMITER $$
CREATE TRIGGER insert_varchar BEFORE INSERT ON varchars FOR EACH ROW
BEGIN
    INSERT INTO attributes (attribute_name, scheme_name, model_name)
        VALUES (NEW.attribute_name, NEW.scheme_name, NEW.model_name);
END $$
DELIMITER ;

/* deletes the varchar value from the attributes table */
DELIMITER $$
CREATE TRIGGER delete_varchar AFTER DELETE ON varchars FOR EACH ROW
BEGIN
    DELETE FROM attributes a WHERE a.attribute_name = OLD.attribute_name AND
                                   a.scheme_name = OLD.scheme_name AND
                                   a.model_name = OLD.model_name;
end $$
DELIMITER ;

/* inserts date values into attributes table */
DELIMITER $$
CREATE TRIGGER insert_date BEFORE INSERT ON dates FOR EACH ROW
BEGIN
    INSERT INTO attributes (attribute_name, scheme_name, model_name)
        VALUES (NEW.attribute_name, NEW.scheme_name, NEW.model_name);
END $$
DELIMITER ;

/* deletes the date value from the attributes table */
DELIMITER $$
CREATE TRIGGER delete_date AFTER DELETE ON dates FOR EACH ROW
BEGIN
    DELETE FROM attributes a WHERE a.attribute_name = OLD.attribute_name AND
                                   a.scheme_name = OLD.scheme_name AND
                                   a.model_name = OLD.model_name;
end $$
DELIMITER ;

/* inserts time values into attributes table */
DELIMITER $$
CREATE TRIGGER insert_time BEFORE INSERT ON times FOR EACH ROW
BEGIN
    INSERT INTO attributes (attribute_name, scheme_name, model_name)
        VALUES (NEW.attribute_name, NEW.scheme_name, NEW.model_name);
END $$
DELIMITER ;

/* deletes the time value from the attributes table */
DELIMITER $$
CREATE TRIGGER delete_time AFTER DELETE ON times FOR EACH ROW
BEGIN
    DELETE FROM attributes a WHERE a.attribute_name = OLD.attribute_name AND
                                   a.scheme_name = OLD.scheme_name AND
                                   a.model_name = OLD.model_name;
end $$
DELIMITER ;

/* validates a candidate_key_members value that is entered */
DELIMITER $$
CREATE TRIGGER candidate_key_member_check BEFORE INSERT ON candidate_key_members FOR EACH ROW
BEGIN
    DECLARE ck_scheme VARCHAR(50) DEFAULT '';

    IF get_attribute_type(NEW.attribute_name,NEW.scheme_name,NEW.model_name) = 'null'
        THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Undefined primitive data type cannot be used as a key';
    END IF;

    IF get_attribute_type(NEW.attribute_name,NEW.scheme_name,NEW.model_name) = 'float'
        THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot use a float data type attribute in a candidate key';
    END IF;

    SET ck_scheme = (SELECT ck.scheme_name
                     FROM candidate_keys ck
                     WHERE ck.model_name = NEW.model_name
                       AND ck.key_name = NEW.key_name);

    IF NEW.scheme_name <> COALESCE(ck_scheme,'null')
        THEN SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Attribute and candidate key are not from the same relation scheme';
    END IF;
END $$
DELIMITER ;

/* calls the generate_order_number function to input a new value for order_num in the candidate_key_members table */
DELIMITER $$
CREATE TRIGGER add_order_number BEFORE INSERT ON candidate_key_members FOR EACH ROW
BEGIN
    SET NEW.order_num = generate_order_number(NEW.key_name);
END $$
DELIMITER ;

/* deletes all foreign key rows associated with a candidate key before being deleted */
DELIMITER $$
CREATE TRIGGER wipe_candidate_key_off_completely BEFORE DELETE ON candidate_keys FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT 1
        FROM candidate_key_members ckm INNER JOIN candidate_keys ck USING (model_name, key_name)
        WHERE ckm.scheme_name = OLD.scheme_name AND ckm.model_name = OLD.model_name
          AND ckm.key_name = OLD.key_name))
    THEN
        DELETE FROM candidate_key_members ckm
               WHERE ckm.scheme_name = OLD.scheme_name AND ckm.model_name = OLD.model_name
                 AND ckm.key_name = OLD.key_name;
    END IF;
    IF (EXISTS(SELECT 1
           FROM primary_keys pk
           WHERE pk.model_name = OLD.model_name AND pk.key_name = OLD.key_name))
    THEN DELETE FROM primary_keys pk
         WHERE pk.model_name = OLD.model_name AND pk.key_name = OLD.key_name;
    END IF;
end $$
DELIMITER ;

/* checks that there is no more than one primary key for every relation scheme */
/*Note: a new primary_keys row has to refer to an existing candidate_keys row */
DELIMITER $$
CREATE TRIGGER primary_key_check BEFORE INSERT ON primary_keys FOR EACH ROW
BEGIN
    IF (EXISTS(SELECT 1
                FROM candidate_keys ck INNER JOIN primary_keys pk USING (model_name, key_name)
                WHERE ck.scheme_name = (SELECT ck2.scheme_name
                                        FROM candidate_keys ck2
                                        WHERE ck2.model_name = NEW.model_name AND ck2.key_name = NEW.key_name)))
        THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'primary key already exists in relation scheme';
    end if;
END $$
DELIMITER ;

/*
generates an order number for each member of a candidate key. Increments by 1 and starts
with the largest order number.
@param k_name               Name of the candidate key.
@return                     The order number for a new candidate key member.
*/
DELIMITER $$
CREATE FUNCTION generate_order_number(k_name VARCHAR(50)) RETURNS INTEGER DETERMINISTIC
BEGIN
    DECLARE largest_order_num INTEGER DEFAULT 0;
    SET largest_order_num = (SELECT DISTINCT order_num
                           FROM candidate_key_members m
                           WHERE m.key_name = k_name AND order_num =
                                                     (SELECT MAX(order_num)
                                                      FROM candidate_key_members
                                                      WHERE key_name = k_name));
    IF (largest_order_num IS NULL)
        THEN RETURN 1;
    END IF;
    RETURN largest_order_num + 1;
end;
DELIMITER ;

/*
Returns the name of the attribute data type. Returns null if the attribute has an unspecified data type.
@param attr_name            The name of the attribute.
@param schm_name            The name of the relational scheme the attribute belongs to.
@param modl_name            The name of the model the attribute belongs to.
@return                     String name of the attribute's data type.
*/
DELIMITER $$
CREATE FUNCTION get_attribute_type(attr_name VARCHAR(50), schm_name VARCHAR(50), modl_name VARCHAR(50))
    RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    IF (EXISTS(SELECT 1
               FROM integers
               WHERE attribute_name = attr_name and scheme_name = schm_name and model_name = modl_name))
        THEN RETURN 'integer';
    END IF;
    IF (EXISTS(SELECT 1
               FROM decimals
               WHERE attribute_name = attr_name and scheme_name = schm_name and model_name = modl_name))
        THEN RETURN 'decimal';
        END IF;
    IF (EXISTS(SELECT 1
               FROM floats
               WHERE attribute_name = attr_name and scheme_name = schm_name and model_name = modl_name))
        THEN RETURN 'float';
        END IF;
    IF (EXISTS(SELECT 1
               FROM varchars
               WHERE attribute_name = attr_name and scheme_name = schm_name and model_name = modl_name))
    THEN RETURN 'varchar';
    END IF;
    IF (EXISTS(SELECT 1
               FROM dates
               WHERE attribute_name = attr_name and scheme_name = schm_name and model_name = modl_name))
    THEN RETURN 'date';
    END IF;
    IF (EXISTS(SELECT 1
               FROM times
               WHERE attribute_name = attr_name and scheme_name = schm_name and model_name = modl_name))
    THEN RETURN 'time';
    END IF;
    RETURN 'null';
END $$
DELIMITER ;

/* DDL GENERATOR */

DELIMITER $$
CREATE FUNCTION generate_model(in_model_name VARCHAR(64)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
   /*
    This function generates the prototype DDL for an entire model.
    @param in_model_name        The name of the model that you want to generate the DDL for.
    @return                      The DDL for every relaton scheme in this model.
    */
   DECLARE results TEXT default '';
   DECLARE next_relation_scheme VARCHAR(64);
    DECLARE first BOOLEAN default true;
    DECLARE done int default 0;
    DECLARE model_cur CURSOR FOR
      SELECT scheme_name
        FROM   relational_schemes
        WHERE  model_name = in_model_name
        ORDER BY scheme_name;
   -- This handler will flip the done flag after we read the last row from the cursor.
   DECLARE continue handler for not found set done = 1;
   IF NOT EXISTS (
      SELECT 'X'
        FROM   models
        WHERE  model_name = in_model_name) THEN
        SET results = CONCAT('Error, model: ', in_model_name, ' does not exist!');
   ELSE
      OPEN model_cur;
        REPEAT
         FETCH model_cur into next_relation_scheme;
            -- SET results = CONCAT(results, next_relation_scheme, ' ');
            IF ! done THEN /* 0 if false, 1 if true */
            IF first THEN
               SET first = false;
                    SET results = CONCAT (results, '
', generate_relation_scheme (in_model_name, next_relation_scheme));
            ELSE
               SET results = CONCAT (results, '

', generate_relation_scheme (in_model_name, next_relation_scheme));
            END IF;
         END IF;
        UNTIL done
        END REPEAT;
        CLOSE model_cur;
    END IF;
   RETURN results;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION generate_relation_scheme(in_model_name VARCHAR(64), in_relation_scheme_name VARCHAR(64)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
   /*
    This generates the prototype DDL for a single relation scheme.
    @param in_model_name        The name of the model that you want to generate the DDL for.
    @param in_relation_scheme_name    The relaton scheme within that model that owns the attribute.
    @return                      The DDL for this one relation scheme.
    */
   DECLARE results text default '';
    DECLARE next_attribute VARCHAR(64);
    -- Flag to tell us whether this is the first column in the output
    DECLARE first BOOLEAN default true;
    DECLARE done int default 0;                   -- Flag to get us out of the cursor
    DECLARE    relation_cur CURSOR FOR
      SELECT a.attribute_name
        FROM   attributes a
        WHERE  model_name = in_model_name AND
            a.scheme_name = in_relation_scheme_name;
   -- This handler will flip the done flag after we read the last row from the cursor.
   DECLARE continue handler for not found set done = 1;
    IF NOT EXISTS (
      SELECT 'X'
        FROM   relational_schemes
        WHERE  model_name = in_model_name AND
            scheme_name = in_relation_scheme_name) THEN
      SET results = concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relation_scheme_name,
                        ' does not exist!');
   ELSE
      SET results = concat ('CREATE TABLE    ', in_relation_scheme_name, ' (');
        OPEN relation_cur;
        REPEAT
         FETCH relation_cur into next_attribute;
            IF ! done THEN
            IF first THEN
               SET first = false;          -- Not the first attribute anymore.
                    -- This is the only way that I've been able to insert a CR/LF
                    SET results = CONCAT(results, '
', generate_attribute (in_model_name, in_relation_scheme_name, next_attribute));
            ELSE
               SET results = CONCAT(results, ',
', generate_attribute (in_model_name, in_relation_scheme_name, next_attribute));
            END IF;
            END IF;
      UNTIL done
        END REPEAT;
        CLOSE relation_cur;
        SET results = CONCAT(results, ');');
      /** the following block will generate the alter table DDL code with a list of all key constraints that the
        relation scheme has **/
        GENERATE_KEYS_BLOCK: BEGIN
            /* signals first entry from a list of values fetched by the cursor */
            DECLARE first BOOLEAN DEFAULT TRUE;
            /* signals the end of a list fetched by the cursor */
            DECLARE done INTEGER DEFAULT 0;
            /* stores the key name that is fetched by the cursor */
            DECLARE next_key VARCHAR(50) DEFAULT '';
            /* stores the key type of the key that is fetched by the cursor */
            DECLARE key_type VARCHAR(50) DEFAULT '';
            /* this cursor gets a list of all the keys that belongs to the relational scheme passed in
               through the parameter */
            DECLARE key_cur CURSOR FOR
                SELECT key_name
                FROM candidate_keys
                WHERE model_name = in_model_name AND scheme_name = in_relation_scheme_name
                UNION
                SELECT key_name
                FROM foreign_keys
                WHERE model_name = in_model_name AND child_scheme = in_relation_scheme_name;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

            IF NOT EXISTS (
                SELECT 'X'
                FROM candidate_key_members
                WHERE model_name = in_model_name AND scheme_name = in_relation_scheme_name)
                AND NOT EXISTS (
                    SELECT 'X'
                    FROM foreign_key_migrations
                    WHERE model_name = in_model_name AND child_scheme = in_relation_scheme_name) THEN
                SET results = CONCAT('No key members found in relation scheme: ', in_relation_scheme_name);
            ELSE
                SET results = CONCAT(results,'

ALTER TABLE ', in_relation_scheme_name);
                OPEN key_cur;
                REPEAT
                    FETCH key_cur INTO next_key;
                    IF !done THEN
                        /* get key type */
                        IF EXISTS (
                            SELECT 'X'
                            FROM candidate_keys ck
                            WHERE ck.model_name = in_model_name
                              AND ck.scheme_name = in_relation_scheme_name AND ck.key_name = next_key) THEN
                            IF EXISTS (
                                SELECT 'X'
                                FROM primary_keys pk
                                WHERE pk.model_name = in_model_name AND pk.key_name = next_key) THEN
                                SET key_type = 'PRIMARY KEY';
                            ELSE
                                SET key_type = 'UNIQUE';
                            END IF;
                        ELSEIF EXISTS (
                                SELECT 'X'
                                FROM foreign_key_migrations m
                                WHERE m.model_name = in_model_name AND m.child_scheme = in_relation_scheme_name
                                  AND m.key_name = next_key) THEN
                                SET key_type = 'FOREIGN KEY';
                        END IF;
                        IF first then
                            SET first = FALSE;
                            SET results = CONCAT(results,'
', generate_key(in_model_name,in_relation_scheme_name, next_key, key_type));
                        ELSE
                            SET results = CONCAT(results,',
', generate_key(in_model_name,in_relation_scheme_name, next_key, key_type));
                        end if;
                    end if;
                UNTIL done
                END REPEAT;
                CLOSE key_cur;
                SET results = CONCAT(results,';');
            END IF;
        END GENERATE_KEYS_BLOCK;
   END IF;
   RETURN results;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION generate_attribute(in_model_name VARCHAR(64), in_relation_scheme_name VARCHAR(64),
            in_attribute_name VARCHAR(64)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
BEGIN
   /*
    This function generates a single DDL line for an attribute.
    @param in_model_name        The name of the model that you want to generate the DDL for.
    @param in_relation_scheme_name    The relaton scheme within that model that owns the attribute.
    @param in_attribute_name     The name of the attribute to generate DDL for.
    @return                      The one line of DDL for this particular attribute.
    */
   /* used for varchar data type DDL output */
   DECLARE length INTEGER DEFAULT 0;
   /* used for decimal data type DDL output */
   DECLARE dec_precision INTEGER DEFAULT 0;
   /* used for decimal data type DDL output */
   DECLARE dec_scale INTEGER DEFAULT 0;
   DECLARE    results text default '';         -- The output string.
    IF NOT EXISTS (
      SELECT 'X'
        FROM   attributes
        WHERE  model_name = in_model_name AND
            scheme_name = in_relation_scheme_name AND
                attribute_name = in_attribute_name) THEN
      SET results = concat ('Error, model: ', in_model_name, ' relation scheme name: ', in_relation_scheme_name,
                     ' attribute: ', in_attribute_name, ' not found!');
   ELSE
       IF get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'null'
       THEN
            SET results = CONCAT('Error, attribute: ', in_attribute_name, ' has an undefined data type');
        END IF;
       IF get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'varchar'
        THEN
            SET length = (SELECT v.length
                          FROM varchars v
                          WHERE v.attribute_name = in_attribute_name
                            AND v.scheme_name = in_relation_scheme_name
                            AND v.model_name = in_model_name);
            IF length > 16280 THEN
                SET results = CONCAT(in_attribute_name, ' TEXT NOT NULL');
            ELSE
                SET results = CONCAT(in_attribute_name, ' VARCHAR(', length, ') NOT NULL');
            END IF;
       ELSEIF  get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'integer'
        THEN
            SET results = CONCAT(in_attribute_name, ' INT NOT NULL');
       ELSEIF get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'decimal'
        THEN
            SET
                dec_precision = (SELECT d.decimal_precision
                                 FROM decimals d
                                 WHERE d.attribute_name = in_attribute_name
                                   AND d.scheme_name = in_relation_scheme_name
                                   AND d.model_name = in_model_name),
                dec_scale = (SELECT d.scale
                                 FROM decimals d
                                 WHERE d.attribute_name = in_attribute_name
                                   AND d.scheme_name = in_relation_scheme_name
                                   AND d.model_name = in_model_name);
            SET results = CONCAT(in_attribute_name, ' DECIMAL(', dec_precision, ',', dec_scale, ') NOT NULL');
        ELSEIF get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'float'
        THEN
            SET results = CONCAT(in_attribute_name, ' FLOAT NOT NULL');
        ELSEIF get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'date'
        THEN
            SET results = CONCAT(in_attribute_name, ' DATE NOT NULL');
        ELSEIF get_attribute_type(in_attribute_name,in_relation_scheme_name,in_model_name) = 'time'
       THEN
           SET results = CONCAT(in_attribute_name, ' TIME NOT NULL');
       END IF;
   END IF;
   RETURN results;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION generate_key(in_model_name VARCHAR(64), in_scheme_name VARCHAR(64),
    in_key_name VARCHAR(50), in_key_type VARCHAR(20)) RETURNS TEXT CHARSET UTF8MB4 READS SQL DATA
BEGIN
    /*
    The following function generates a DDL code for a single key constraint.
    @param in_model_name            The name of the model.
    @param in_scheme_name           The relation scheme that is within the model.
    @param in_key_name              The name of the key to generate a DDL output for.
    @param  in_key_type             The name of the type of key. It can be either a PK, a KC, or a FK.
    @return                         The one line of DDL for this particular key.
    */
    /* Stores a list of attributes ordered in ascending alphabetical order, or a list of child attributes in
       FK ordered by the parent attribute in ascending alphabetical order */
    DECLARE attribute_list TEXT DEFAULT '';
    /* Stores a list of primary key attribute that is referenced by the child attribute, in ascending alphabetical
       order */
    DECLARE reference_attribute_list TEXT DEFAULT '';
    /* stores the name of the parent scheme */
    DECLARE parent_scheme_name VARCHAR(50) DEFAULT '';
    /* stores the DDL code for the function to return */
    DECLARE results TEXT DEFAULT '';

    SET results = CONCAT('ADD CONSTRAINT ', in_key_name, ' ');
    IF UPPER(in_key_type) = 'PRIMARY KEY' OR UPPER(in_key_type) = 'UNIQUE' THEN
        SET results = CONCAT(results, in_key_type, ' (');
        SET attribute_list = (SELECT GROUP_CONCAT(attribute_name ORDER BY order_num SEPARATOR ', ')
                              FROM candidate_key_members
                              WHERE model_name = in_model_name AND key_name = in_key_name);
        SET results = CONCAT(results, attribute_list, ')');
    ELSEIF UPPER(in_key_type) = 'FOREIGN KEY' THEN
        SET parent_scheme_name = (SELECT DISTINCT parent_scheme
                                  FROM foreign_key_migrations
                                  WHERE model_name = in_model_name AND child_scheme = in_scheme_name
                                    AND key_name = in_key_name);
        SET results = CONCAT(results, in_key_type, ' (');
        SET attribute_list = (SELECT GROUP_CONCAT(DISTINCT child_attribute ORDER BY order_num SEPARATOR ', ')
                              FROM foreign_key_migrations fkm INNER JOIN candidate_key_members m ON parent_attribute = attribute_name
                              WHERE fkm.model_name = in_model_name
                                AND fkm.parent_scheme = m.scheme_name
                                AND fkm.key_name = in_key_name);
        SET reference_attribute_list = (SELECT GROUP_CONCAT(DISTINCT parent_attribute ORDER BY order_num SEPARATOR ', ')
                              FROM foreign_key_migrations fkm INNER JOIN candidate_key_members m ON parent_attribute = attribute_name
                              WHERE fkm.model_name = in_model_name
                                AND fkm.parent_scheme = m.scheme_name
                                AND fkm.key_name = in_key_name);
        SET results = CONCAT(results, attribute_list, ') REFERENCES ', parent_scheme_name, ' (', reference_attribute_list, ')');
    END IF;
    RETURN results;
end $$
DELIMITER ;

/* EXTRA */

/*
The following function determines if a foreign key that is passed in is either identifying or non-identifying in
the relational scheme that it belongs to. Checks if the foreign key is a proper subset of the relational scheme's
primary key. Returns true if it is identifying, false if it's non-identifying.
@param in_model_name                    The name of the model that the foreign key belongs to.
@param in_fk_name                       The name of the foreign key.
@return                                 Returns true or false.
*/
DELIMITER $$
CREATE FUNCTION get_identifying_value(in_model_name VARCHAR(50), in_fk_name VARCHAR(50)) RETURNS BOOLEAN READS SQL DATA
BEGIN
    /*signals the end of a cursor list */
    DECLARE done INTEGER DEFAULT 0;
    /* stores the next candidate key that is fetched by the cursor */
    DECLARE next_ck VARCHAR(50) DEFAULT 0;
    /* fetches a list of primary keys that is in the same relational scheme as the foreign key that is passed in
       by the procedure */
    DECLARE ck_cur CURSOR FOR
        SELECT key_name
        FROM candidate_keys INNER JOIN primary_keys USING (model_name, key_name)
        WHERE model_name = in_model_name AND scheme_name =
                                             (SELECT DISTINCT child_scheme
                                              FROM foreign_keys
                                              WHERE key_name = in_fk_name AND model_name = in_model_name);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN ck_cur;

    check_each_ck: LOOP
        FETCH ck_cur INTO next_ck;
        IF done = 1 THEN LEAVE check_each_ck;
        END IF;
        IF NOT EXISTS ( /* returns true if the following FK is a proper subset of a CK in the same relation scheme */
            SELECT child_attribute
            FROM foreign_key_migrations
            WHERE model_name = in_model_name AND key_name = in_fk_name
              AND child_attribute NOT IN
                  (SELECT attribute_name
                   FROM candidate_key_members m
                   WHERE m.model_name = in_model_name AND m.key_name = next_ck)) THEN
            CLOSE ck_cur;
            RETURN TRUE;
        END IF;
    END LOOP;
CLOSE ck_cur;
RETURN FALSE;
END $$
DELIMITER ;

/*
The following procedure updates all of the identifying values of each foreign key in the model.
@param in_model_name                        The name of the model.
*/
DELIMITER $$
CREATE PROCEDURE update_identifying_fk_values(IN in_model_name VARCHAR(50))
BEGIN
    DECLARE done INTEGER DEFAULT 0;
    DECLARE next_fk VARCHAR(50) DEFAULT '';
    DECLARE fk_cur CURSOR FOR
        SELECT key_name
        FROM foreign_keys
        WHERE model_name = in_model_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN fk_cur;

    update_fk_identifying_values: LOOP
        FETCH fk_cur INTO next_fk;
        IF done = 1 THEN LEAVE update_fk_identifying_values;
        END IF;
        UPDATE foreign_keys
            SET identifying = get_identifying_value(in_model_name,next_fk)
            WHERE key_name = next_fk AND model_name = in_model_name;
    end loop;
CLOSE fk_cur;
end $$
DELIMITER ;

/*DML Code*/

INSERT INTO models(model_name, description) VALUES
('transcripts','metadata project model sample');

INSERT INTO relational_schemes(scheme_name, model_name, description)
VALUES
/* transcripts */
('departments', 'transcripts',''), ('days','transcripts',''), ('instructors','transcripts',''),
('courses','transcripts',''), ('semesters','transcripts',''), ('sections','transcripts',''),
('students','transcripts',''), ('grades','transcripts',''), ('enrollments','transcripts',''),
('transcript_entries','transcripts','');

INSERT INTO varchars(attribute_name, scheme_name, model_name, length)
VALUES
/* departments */
('name','departments','transcripts',50),

/* courses */
('name','courses','transcripts',50), ('description','courses','transcripts', 65535),/* TEXT data type */
('title','courses','transcripts',50),

/* semesters */
('name','semesters','transcripts',50),

/* instructors */
('instructor_name','instructors','transcripts',50),

/* days */
('weekday_combinations','days','transcripts',50),

/* students */
('last_name','students','transcripts',50), ('first_name','students','transcripts',50),

/* sections */
('department_name','sections','transcripts',50), ('semester','sections','transcripts',50),
('instructor','sections','transcripts',50), ('days','sections','transcripts',50),

/* enrollments */
('department_name','enrollments','transcripts',50), ('semester','enrollments','transcripts',50),
('grade','enrollments','transcripts',5),

/* grades */
('grade_letter','grades','transcripts',5),

/* transcript_entries */
('department_name','transcript_entries','transcripts',50), ('semester','transcript_entries','transcripts',50);
;

INSERT INTO integers(attribute_name, scheme_name, model_name)
VALUES
('number','courses','transcripts'), ('units','courses','transcripts'),

('course_number','sections','transcripts'), ('number','sections','transcripts'),

('student_id','students','transcripts'),

('student_id','enrollments','transcripts'), ('course_number','enrollments','transcripts'),
('section_number','enrollments','transcripts'),

('student_id','transcript_entries','transcripts'), ('course_number','transcript_entries','transcripts'),
('section_number','transcript_entries','transcripts')
;

INSERT INTO dates(attribute_name, scheme_name, model_name)
VALUES
('year','sections','transcripts'),

('year','enrollments','transcripts'),

('year','transcript_entries','transcripts')
;

INSERT INTO times(attribute_name, scheme_name, model_name)
VALUES
('start_time','sections','transcripts');


INSERT INTO candidate_keys(scheme_name, model_name, key_name)
VALUES
('departments','transcripts','departments_pk_01'),

('courses','transcripts','courses_pk_01'), ('courses','transcripts','courses_uk_01'),
('courses','transcripts','courses_uk_02'),

('semesters','transcripts','semesters_pk_01'),

('instructors','transcripts','instructors_pk_01'),

('days','transcripts','days_pk_01'),

('sections','transcripts','sections_pk_01'),

('students','transcripts','students_pk_01'),

('grades','transcripts','grades_pk_01'),

('enrollments','transcripts','enrollments_pk_01'),

('transcript_entries','transcripts','transcript_entries_pk_01')
;

INSERT INTO primary_keys(model_name, key_name)
VALUES

('transcripts', 'departments_pk_01'),

('transcripts', 'courses_pk_01'),

('transcripts','semesters_pk_01'),

('transcripts', 'instructors_pk_01'),

('transcripts','days_pk_01'),

('transcripts','sections_pk_01'),

('transcripts','students_pk_01'),

('transcripts','grades_pk_01'),

('transcripts','enrollments_pk_01'),

('transcripts','transcript_entries_pk_01')
;

INSERT INTO candidate_key_members(attribute_name, scheme_name, model_name, key_name)
VALUES

/* departments */
('name','departments','transcripts','departments_pk_01'),

/* courses */
('name','courses','transcripts','courses_pk_01'), ('number','courses','transcripts','courses_pk_01'),
('name','courses','transcripts','courses_uk_01'), ('title','courses','transcripts','courses_uk_02'),

/*instructors*/
('instructor_name','instructors','transcripts','instructors_pk_01'),

/*semesters*/
('name','semesters','transcripts','semesters_pk_01'),

/*days*/
('weekday_combinations','days','transcripts','days_pk_01'),

/*sections*/
('department_name','sections','transcripts','sections_pk_01'),
('course_number','sections','transcripts','sections_pk_01'),
('number','sections','transcripts','sections_pk_01'),
('year','sections','transcripts','sections_pk_01'),
('semester','sections','transcripts','sections_pk_01'),

/*students*/
('student_id','students','transcripts','students_pk_01'),

/*grades (missed entering this one!) */
('grade_letter','grades','transcripts','grades_pk_01'),

/*enrollments*/
('student_id','enrollments','transcripts','enrollments_pk_01'),
('department_name','enrollments','transcripts','enrollments_pk_01'),
('course_number','enrollments','transcripts','enrollments_pk_01'),
('section_number','enrollments','transcripts','enrollments_pk_01'),
('year','enrollments','transcripts','enrollments_pk_01'),
('semester','enrollments','transcripts','enrollments_pk_01'),

/*transcript_entries*/
('student_id','transcript_entries','transcripts','transcript_entries_pk_01'),
('department_name','transcript_entries','transcripts','transcript_entries_pk_01'),
('course_number','transcript_entries','transcripts','transcript_entries_pk_01')
;

INSERT INTO relationship_names(name)
VALUES
('one to many'),('categorization'),('aggregation'),('composition'),('one to one'), ('zero to one');

INSERT INTO cardinalities(type)
VALUES
('1..*'),('0..*'),('1..1'),('0..1');

INSERT INTO foreign_keys(model_name, key_name, parent_scheme, child_scheme, relationship_name,
                         parent_cardinality, child_cardinality)
VALUES
('transcripts','courses_departments_fk_01','departments','courses','one to many','1..1','1..*'),

('transcripts','sections_courses_fk_01','courses','sections','one to many','1..1','0..*'),
('transcripts','sections_semesters_fk_02','semesters','sections','one to many','1..1','0..*'),
('transcripts','sections_instructors_fk_03','instructors','sections','one to many','1..1','0..*'),
('transcripts','sections_days_fk_04','days','sections','one to many','1..1','0..*'),

('transcripts','enrollments_students_fk_01','students','enrollments','one to many','1..1','0..*'),
('transcripts','enrollments_sections_fk_02','sections','enrollments','one to many','1..1','0..*'),
('transcripts','enrollments_grades_fk_03','grades','enrollments','one to many','1..1','0..*'),

('transcripts','transcript_entries_enrollments_fk_01','enrollments','transcript_entries','zero to one','1..1','0..1')
;

INSERT INTO foreign_key_migrations(parent_attribute, parent_scheme, child_attribute, child_scheme, model_name, key_name)
VALUES

/* courses */
('name','departments','name','courses','transcripts','courses_departments_fk_01'),

/* sections */
('name','courses','department_name','sections','transcripts','sections_courses_fk_01'),
('number','courses','course_number','sections','transcripts','sections_courses_fk_01'),
('name','semesters','semester','sections','transcripts','sections_semesters_fk_02'),
('weekday_combinations','days','days','sections','transcripts','sections_days_fk_04'),
('instructor_name','instructors','instructor','sections','transcripts','sections_instructors_fk_03'),

/* enrollments */
('student_id','students','student_id','enrollments','transcripts','enrollments_students_fk_01'),
('department_name','sections','department_name','enrollments','transcripts','enrollments_sections_fk_02'),
('course_number','sections','course_number','enrollments','transcripts','enrollments_sections_fk_02'),
('number','sections','section_number','enrollments','transcripts','enrollments_sections_fk_02'),
('year','sections','year','enrollments','transcripts','enrollments_sections_fk_02'),
('semester','sections','semester','enrollments','transcripts','enrollments_sections_fk_02'),
('grade_letter','grades','grade','enrollments','transcripts','enrollments_grades_fk_03'),

/* transcript_entries */
('student_id','enrollments','student_id','transcript_entries','transcripts','transcript_entries_enrollments_fk_01'),
('department_name','enrollments','department_name','transcript_entries','transcripts','transcript_entries_enrollments_fk_01'),
('course_number','enrollments','course_number','transcript_entries','transcripts','transcript_entries_enrollments_fk_01'),
('section_number','enrollments','section_number','transcript_entries','transcripts','transcript_entries_enrollments_fk_01'),
('year','enrollments','year','transcript_entries','transcripts','transcript_entries_enrollments_fk_01'),
('semester','enrollments','semester','transcript_entries','transcripts','transcript_entries_enrollments_fk_01')
;