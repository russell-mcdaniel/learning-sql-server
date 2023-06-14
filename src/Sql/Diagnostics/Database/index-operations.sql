USE Learning;
GO

SELECT
	OBJECT_SCHEMA_NAME(i.object_id)									AS schema_name,
	OBJECT_NAME(i.object_id)										AS table_name,
	i.name															AS idx_name,
	ops.partition_number											AS part_no,

	-- Data operations.
	ops.leaf_insert_count											AS lf_ins_cnt,
	ops.leaf_delete_count											AS lf_del_cnt,
	ops.leaf_update_count											AS lf_upd_cnt,
	ops.leaf_allocation_count										AS lf_alloc_cnt,
	ops.leaf_page_merge_count										AS lf_pg_mrg_cnt,
	ops.leaf_ghost_count											AS lf_ghst_cnt,

	ops.nonleaf_insert_count										AS nlf_ins_cnt,
	ops.nonleaf_delete_count										AS nlf_del_cnt,
	ops.nonleaf_update_count										AS nlf_upd_cnt,
	ops.nonleaf_allocation_count									AS nlf_alloc_cnt,
	ops.nonleaf_page_merge_count									AS nlf_pg_mrg_cnt,

	ops.singleton_lookup_count										AS sng_lkup_cnt,
	ops.range_scan_count											AS rng_scan_cnt,
--	ops.forwarded_fetch_count										AS fwd_fch_cnt,				-- For heaps.

	ops.row_overflow_fetch_in_pages									AS row_ovf_fch_pg,
	ops.row_overflow_fetch_in_bytes									AS row_ovf_fch_b,

	ops.lob_fetch_in_pages											AS lob_fch_in_pgs,
	ops.lob_fetch_in_bytes											AS lob_fch_in_b,
--	ops.lob_orphan_create_count										AS lob_orph_cre_cnt,		-- For bulk import.
--	ops.lob_orphan_insert_count										AS lob_orph_ins_cnt,		-- For bulk import.

	ops.column_value_push_off_row_count								AS col_push_row_cnt,
	ops.column_value_pull_in_row_count								AS col_pull_row_cnt,

	ops.page_compression_attempt_count								AS pg_comp_atmpt_cnt,
	ops.page_compression_success_count								AS pg_comp_succ_cnt,

	-- Lock/latch operations.
	ops.row_lock_count												AS row_lk_cnt,
	ops.row_lock_wait_count											AS row_lk_wt_cnt,
	ops.row_lock_wait_in_ms											AS row_lk_wt_ms,

	ops.page_lock_count												AS pg_lk_cnt,
	ops.page_lock_wait_count										AS pg_lk_wt_cnt,
	ops.page_lock_wait_in_ms										AS pg_lk_wt_ms,

	ops.index_lock_promotion_attempt_count							AS ix_lk_pro_atm_cnt,
	ops.index_lock_promotion_count									AS ix_lk_pro_cnt,

	ops.page_latch_wait_count										AS pg_lch_wt_cnt,
	ops.page_latch_wait_in_ms										AS pg_lch_wt_ms,
	ops.page_io_latch_wait_count									AS pg_io_lch_wt_cnt,
	ops.page_io_latch_wait_in_ms									AS pg_io_lch_wt_ms,

	ops.tree_page_latch_wait_count									AS tpg_lch_wait_cnt,
	ops.tree_page_latch_wait_in_ms									AS tpg_lch_wait_ms,
	ops.tree_page_io_latch_wait_count								AS tpg_io_lch_wt_cnt,
	ops.tree_page_io_latch_wait_in_ms								AS tpg_io_lch_wt_ms
FROM
	-- Use this join to restrict to indexes on user-created tables.
	sys.tables t
INNER JOIN
	sys.indexes i
ON
	i.object_id = t.object_id
CROSS APPLY
	sys.dm_db_index_operational_stats(DB_ID(), i.object_id, i.index_id, 0) ops
ORDER BY
	OBJECT_SCHEMA_NAME(i.object_id),
	OBJECT_NAME(i.object_id),
	i.name;
GO
