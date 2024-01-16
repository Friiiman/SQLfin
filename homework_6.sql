DROP FUNCTION IF EXISTS vk.deletes_all_information_for_user;

CREATE FUNCTION vk.deletes_all_information_for_user(delete_user BIGINT UNSIGNED)

RETURNS INT DETERMINISTIC

BEGIN
	
	DELETE FROM vk.messages 
	WHERE from_user_id = delete_user OR to_user_id = delete_user;
	
	DELETE FROM vk.profiles
	WHERE user_id = delete_user;
	
	DELETE FROM vk.friend_requests 
	WHERE initiator_user_id = delete_user OR target_user_id = delete_user;
	
	DELETE FROM vk.media 
	WHERE user_id = delete_user;
	
	DELETE FROM vk.users_communities
	WHERE user_id = delete_user;
	
	DELETE FROM vk.likes 
	WHERE user_id = delete_user;
	
	DELETE FROM vk.users
	WHERE id = delete_user;
	
	RETURN delete_user;
	
END



DROP PROCEDURE IF EXISTS vk.deletes_all_information_for_user;

CREATE PROCEDURE vk.deletes_all_information_for_user(delete_user BIGINT UNSIGNED)
BEGIN
	
	DECLARE `_rollback` BOOL DEFAULT 0;
	
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	
	BEGIN
    	SET `_rollback` = 1;
    END;
	
	START TRANSACTION;
		DELETE FROM vk.messages 
		WHERE from_user_id = delete_user OR to_user_id = delete_user;
	
		DELETE FROM vk.profiles
		WHERE user_id = delete_user;
		
		DELETE FROM vk.friend_requests 
		WHERE initiator_user_id = delete_user OR target_user_id = delete_user;
		
		DELETE FROM vk.media 
		WHERE user_id = delete_user;
		
		DELETE FROM vk.users_communities
		WHERE user_id = delete_user;
		
		DELETE FROM vk.likes 
		WHERE user_id = delete_user;
		
		DELETE FROM vk.users
		WHERE id = delete_user;
	
		IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
	       COMMIT;
	    END IF;
END



DROP TRIGGER IF EXISTS vk.name_longer_than_five_characters;

CREATE TRIGGER name_longer_than_five_characters
BEFORE INSERT
ON communities FOR EACH ROW
BEGIN 
	IF (SELECT length (NEW.name)) < 5 THEN 
		SIGNAL SQLSTATE '45000'; 
		SET MESSAGE_TEXT = 'Название сообщества должно быть более 4 символов';
	END IF;
END	
