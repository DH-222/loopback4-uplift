SET search_path TO todolist,public;

CREATE TABLE user_credentials (
  id integer NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  user_id integer NOT NULL ,
  auth_provider varchar(50) NOT NULL ,
  auth_id varchar(100) ,
  auth_token varchar(100) ,
  created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	deleted              bool DEFAULT false NOT NULL ,
  CONSTRAINT pk_user_credentials_id PRIMARY KEY ( id ),
  CONSTRAINT idx_user_credentials_user_id UNIQUE ( user_id )
);
CREATE INDEX idx_user_credentials ON user_credentials ( auth_provider );
ALTER TABLE user_credentials ADD CONSTRAINT fk_user_credentials_users FOREIGN KEY ( user_id ) REFERENCES users( id );

ALTER TABLE user_credentials ADD "password" varchar(60);
insert into user_credentials (user_id, auth_provider, "password") select id, 'internal', password from users;
ALTER TABLE users DROP COLUMN "password";

update auth_clients set redirect_url='http://localhost:4200/login/success' where client_id='webapp';
