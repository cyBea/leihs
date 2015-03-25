class RefactorContracts < ActiveRecord::Migration
  def change

    change_table :contract_lines do |t|
      t.belongs_to :inventory_pool
      t.belongs_to :user
      t.belongs_to :delegated_user
      t.belongs_to :handed_over_by_user
    end
    execute "ALTER TABLE contract_lines ADD COLUMN status ENUM('#{ContractLine::STATUSES.join("', '")}') NOT NULL;"

    execute %Q(UPDATE contract_lines AS cl
                INNER JOIN contracts AS c ON cl.contract_id = c.id
               SET cl.inventory_pool_id = c.inventory_pool_id,
                    cl.user_id = c.user_id,
                    cl.delegated_user_id = c.delegated_user_id,
                    cl.handed_over_by_user_id = c.handed_over_by_user_id,
                    cl.status = c.status;)

    change_table :contract_lines do |t|
      t.index :status
      t.foreign_key :inventory_pools
      t.foreign_key :users
      t.foreign_key :users, column: 'delegated_user_id'
      t.foreign_key :users, column: 'handed_over_by_user_id'
    end

    execute %Q(UPDATE contract_lines
               SET contract_id = NULL
               WHERE status NOT IN ('#{:signed}', '#{:closed}');)

    # TODO migrate data

    change_table :contracts do |t|
      t.remove_foreign_key :inventory_pools
      t.remove_foreign_key :users
      t.remove_foreign_key column: 'delegated_user_id'
      t.remove_foreign_key column: 'handed_over_by_user_id'
      t.remove :inventory_pool_id
      t.remove :user_id
      t.remove :delegated_user_id
      t.remove :handed_over_by_user_id
      t.remove :status
    end


    ############################################################
    # fixing views

    execute("DROP VIEW IF EXISTS visit_lines")
    execute("DROP VIEW IF EXISTS visits")

    execute %Q(CREATE VIEW contract_lines_bundles AS
                SELECT IFNULL(cl.contract_id, CONCAT_WS('_', cl.status, cl.user_id, cl.inventory_pool_id)) as id,
                       cl.user_id,
                       cl.inventory_pool_id,
                       cl.status,
                       IF((cl.status = '#{:approved}'), cl.start_date, IF(cl.status = '#{:signed}', cl.end_date, NULL)) AS visit_date,
                       SUM(cl.quantity) AS quantity,
                       IF(SUM(groups.is_verification_required) > 0, 1, 0) AS verifiable_user,
                       COUNT(partitions.id) > 0 AS verifiable_user_and_model,
                       MAX(cl.created_at) AS created_at
                FROM contract_lines AS cl
                LEFT JOIN groups_users ON groups_users.user_id = cl.user_id
                LEFT JOIN groups ON groups.id = groups_users.group_id  AND groups.inventory_pool_id = cl.inventory_pool_id
                LEFT JOIN partitions ON partitions.group_id = groups.id AND partitions.model_id = cl.model_id AND groups.is_verification_required = 1
                WHERE cl.status != '#{:closed}'
                GROUP BY
                  IFNULL(cl.contract_id, cl.status), cl.user_id, cl.inventory_pool_id,
                  IF((cl.status = '#{:signed}'), cl.end_date, IF((cl.status = '#{:approved}'), cl.start_date, NULL))
                ORDER BY visit_date;)

  end
end
