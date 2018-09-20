-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE users
ADD COLUMN receive_email_notifications BOOLEAN NOT NULL DEFAULT true;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE users
DROP COLUMN receive_email_notifications;
