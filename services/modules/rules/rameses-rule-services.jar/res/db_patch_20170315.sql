ALTER TABLE sys_rule_action_param ADD COLUMN rangeoption INT;
UPDATE sys_rule_action_param SET rangeoption=0 where rangeoption is null;
