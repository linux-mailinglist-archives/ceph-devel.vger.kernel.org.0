Return-Path: <ceph-devel+bounces-3455-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CCD6B27011
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 22:14:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 963133BF7FE
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Aug 2025 20:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE48242D65;
	Thu, 14 Aug 2025 20:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KbuUlJj4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1BD2472B7
	for <ceph-devel@vger.kernel.org>; Thu, 14 Aug 2025 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755202410; cv=none; b=styW6XlpHePKw5ULys08gnTpjnJrHqz7HRx5O05gqUC3DrBkakZahCy13rDkhMBBUUUElo72KQQUt9CmcTsbV2nn18/Eq5q6pivzEVf50PskPXmuqXJ2QWW0xAebEkJSh5m5RoImk4OzKmWooSw4MnhfJDSDhhTXT5xAzbexs1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755202410; c=relaxed/simple;
	bh=/3la84wwr3qkhdKa/bO3fSOE1EppUgPRLRiBJxppEyE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rBswB/xbgckdUNy+9j7m0bnZiBwEYTt4639bLvK/EI9sBtqJ+nO9CJ/VIC6sPRHbS6MEha9XClnqKAAC50NVDtvSCDmbZbTZy0avq27PVZq3QIO6eL7utlhKCHLu5FVUgzVIyvSwZOENotwWf2BwDRz7B5Hry33pDrczEi7COic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KbuUlJj4; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755202408; x=1786738408;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/3la84wwr3qkhdKa/bO3fSOE1EppUgPRLRiBJxppEyE=;
  b=KbuUlJj423sGZpdSMiO1s5GZTF5WsEN5iOTSZ0u3N+/x/vV7Z4axdCoO
   VCVaq2tDLDH3U6YdI4/lmEWENGtYUouhhrfyZJ4F5THjvPNLHSfadRGhz
   xD5zQOlSvuWCcr4kHhcdoV4D0a82lpdnfHPQa8Mcwsn9wAPek5j1X1tMS
   T5BGvKsVNrDXhec97jUKYXzixDDHaapwaykJXVbHu5lwD9E/55KblHaWt
   ffy2JSqoAwDG44jhyFr8erURyNmltjZ/gbCnsMl0IqmgVNmvqOGiH4zek
   kMlNZrpq0jW7LxWJDr8dnAUSAyZX8vKG6hXgGDoLzDaCzkJDh9y5OpUuI
   A==;
X-CSE-ConnectionGUID: QYG3TrseQ8ClvRMvLx+aHA==
X-CSE-MsgGUID: QEH79nWoSsS8wDJjBMp7zA==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57245753"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57245753"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 13:13:28 -0700
X-CSE-ConnectionGUID: 4MoHWDghQbOIe72XoLIX9A==
X-CSE-MsgGUID: bDVS21eBRLWhaf5yzHx8hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="204030130"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 14 Aug 2025 13:13:27 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umeKC-000BIm-00;
	Thu, 14 Aug 2025 20:13:24 +0000
Date: Fri, 15 Aug 2025 04:12:44 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls-tracing-only 10/10] fs/ceph/blog_debugfs.c:26:
 warning: Function parameter or struct member 's' not described in
 'blog_entries_show'
Message-ID: <202508150401.905dissE-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls-tracing-only
head:   6b738aa5f6bb2343f8277d318ff1e9ea9289212c
commit: 6b738aa5f6bb2343f8277d318ff1e9ea9289212c [10/10] proper isolation
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20250815/202508150401.905dissE-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250815/202508150401.905dissE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508150401.905dissE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/ceph/blog_debugfs.c:26: warning: Function parameter or struct member 's' not described in 'blog_entries_show'
>> fs/ceph/blog_debugfs.c:26: warning: Function parameter or struct member 'p' not described in 'blog_entries_show'
>> fs/ceph/blog_debugfs.c:100: warning: Function parameter or struct member 's' not described in 'blog_stats_show'
>> fs/ceph/blog_debugfs.c:100: warning: Function parameter or struct member 'p' not described in 'blog_stats_show'
>> fs/ceph/blog_debugfs.c:138: warning: Function parameter or struct member 's' not described in 'blog_sources_show'
>> fs/ceph/blog_debugfs.c:138: warning: Function parameter or struct member 'p' not described in 'blog_sources_show'
>> fs/ceph/blog_debugfs.c:189: warning: Function parameter or struct member 's' not described in 'blog_clients_show'
>> fs/ceph/blog_debugfs.c:189: warning: Function parameter or struct member 'p' not described in 'blog_clients_show'
>> fs/ceph/blog_debugfs.c:232: warning: Function parameter or struct member 'file' not described in 'blog_clear_write'
>> fs/ceph/blog_debugfs.c:232: warning: Function parameter or struct member 'buf' not described in 'blog_clear_write'
>> fs/ceph/blog_debugfs.c:232: warning: Function parameter or struct member 'count' not described in 'blog_clear_write'
>> fs/ceph/blog_debugfs.c:232: warning: Function parameter or struct member 'ppos' not described in 'blog_clear_write'


vim +26 fs/ceph/blog_debugfs.c

    18	
    19	/**
    20	 * blog_entries_show - Show all BLOG entries for Ceph
    21	 * 
    22	 * Iterates through all contexts and their pagefrags, deserializing entries
    23	 * using BLOG's deserialization with Ceph's client callback
    24	 */
    25	static int blog_entries_show(struct seq_file *s, void *p)
  > 26	{
    27		struct blog_tls_ctx *ctx;
    28		struct blog_log_iter iter;
    29		struct blog_log_entry *entry;
    30		char output_buf[1024];
    31		int ret;
    32		int entry_count = 0;
    33		int ctx_count = 0;
    34	
    35		seq_printf(s, "Ceph BLOG Entries\n");
    36		seq_printf(s, "=================\n\n");
    37	
    38		/* Access the global logger - need to be careful here */
    39		spin_lock(&g_blog_logger.lock);
    40		
    41		list_for_each_entry(ctx, &g_blog_logger.contexts, list) {
    42			ctx_count++;
    43			seq_printf(s, "Context %d (ID: %llu, PID: %d, Comm: %s)\n",
    44			          ctx_count, ctx->id, ctx->pid, ctx->comm);
    45			seq_printf(s, "  Base jiffies: %lu, Refcount: %d\n",
    46			          ctx->base_jiffies, atomic_read(&ctx->refcount));
    47			
    48			/* Initialize iterator for this context's pagefrag */
    49			blog_log_iter_init(&iter, &ctx->pf);
    50			
    51			/* Iterate through all entries in this context */
    52			while ((entry = blog_log_iter_next(&iter)) != NULL) {
    53				entry_count++;
    54				
    55				/* Clear output buffer */
    56				memset(output_buf, 0, sizeof(output_buf));
    57				
    58				/* Use blog_des_entry with Ceph's client callback */
    59				ret = blog_des_entry(entry, output_buf, sizeof(output_buf),
    60				                    ceph_blog_client_des_callback);
    61				
    62				if (ret < 0) {
    63					seq_printf(s, "  Entry %d: [Error deserializing: %d]\n",
    64					          entry_count, ret);
    65				} else {
    66					/* Show entry details */
    67					seq_printf(s, "  Entry %d (ts_delta=%u, src=%u, client=%u, len=%u):\n",
    68					          entry_count, entry->ts_delta, entry->source_id, 
    69					          entry->client_id, entry->len);
    70					seq_printf(s, "    %s\n", output_buf);
    71				}
    72			}
    73			seq_printf(s, "\n");
    74		}
    75		
    76		spin_unlock(&g_blog_logger.lock);
    77		
    78		seq_printf(s, "Total contexts: %d\n", ctx_count);
    79		seq_printf(s, "Total entries: %d\n", entry_count);
    80		
    81		return 0;
    82	}
    83	
    84	static int blog_entries_open(struct inode *inode, struct file *file)
    85	{
    86		return single_open(file, blog_entries_show, inode->i_private);
    87	}
    88	
    89	static const struct file_operations blog_entries_fops = {
    90		.open = blog_entries_open,
    91		.read = seq_read,
    92		.llseek = seq_lseek,
    93		.release = single_release,
    94	};
    95	
    96	/**
    97	 * blog_stats_show - Show BLOG statistics
    98	 */
    99	static int blog_stats_show(struct seq_file *s, void *p)
 > 100	{
   101		seq_printf(s, "Ceph BLOG Statistics\n");
   102		seq_printf(s, "====================\n\n");
   103		
   104		seq_printf(s, "Global Logger State:\n");
   105		seq_printf(s, "  Total contexts allocated: %lu\n", 
   106		          g_blog_logger.total_contexts_allocated);
   107		seq_printf(s, "  Next context ID: %llu\n", g_blog_logger.next_ctx_id);
   108		seq_printf(s, "  Next source ID: %u\n", 
   109		          atomic_read(&g_blog_logger.next_source_id));
   110		
   111		seq_printf(s, "\nAllocation Batch:\n");
   112		seq_printf(s, "  Full magazines: %u\n", g_blog_logger.alloc_batch.nr_full);
   113		seq_printf(s, "  Empty magazines: %u\n", g_blog_logger.alloc_batch.nr_empty);
   114		
   115		seq_printf(s, "\nLog Batch:\n");
   116		seq_printf(s, "  Full magazines: %u\n", g_blog_logger.log_batch.nr_full);
   117		seq_printf(s, "  Empty magazines: %u\n", g_blog_logger.log_batch.nr_empty);
   118		
   119		return 0;
   120	}
   121	
   122	static int blog_stats_open(struct inode *inode, struct file *file)
   123	{
   124		return single_open(file, blog_stats_show, inode->i_private);
   125	}
   126	
   127	static const struct file_operations blog_stats_fops = {
   128		.open = blog_stats_open,
   129		.read = seq_read,
   130		.llseek = seq_lseek,
   131		.release = single_release,
   132	};
   133	
   134	/**
   135	 * blog_sources_show - Show all registered source locations
   136	 */
   137	static int blog_sources_show(struct seq_file *s, void *p)
 > 138	{
   139		struct blog_source_info *source;
   140		u32 id;
   141		int count = 0;
   142		
   143		seq_printf(s, "Ceph BLOG Source Locations\n");
   144		seq_printf(s, "===========================\n\n");
   145		
   146		for (id = 1; id < BLOG_MAX_SOURCE_IDS; id++) {
   147			source = blog_get_source_info(id);
   148			if (!source || !source->file)
   149				continue;
   150			
   151			count++;
   152			seq_printf(s, "ID %u: %s:%s:%u\n", id, 
   153			          source->file, source->func, source->line);
   154			seq_printf(s, "  Format: %s\n", source->fmt ? source->fmt : "(null)");
   155			seq_printf(s, "  Warnings: %d\n", source->warn_count);
   156			
   157	#if BLOG_TRACK_USAGE
   158			seq_printf(s, "  NAPI usage: %d calls, %d bytes\n",
   159			          atomic_read(&source->napi_usage),
   160			          atomic_read(&source->napi_bytes));
   161			seq_printf(s, "  Task usage: %d calls, %d bytes\n",
   162			          atomic_read(&source->task_usage),
   163			          atomic_read(&source->task_bytes));
   164	#endif
   165			seq_printf(s, "\n");
   166		}
   167		
   168		seq_printf(s, "Total registered sources: %d\n", count);
   169		
   170		return 0;
   171	}
   172	
   173	static int blog_sources_open(struct inode *inode, struct file *file)
   174	{
   175		return single_open(file, blog_sources_show, inode->i_private);
   176	}
   177	
   178	static const struct file_operations blog_sources_fops = {
   179		.open = blog_sources_open,
   180		.read = seq_read,
   181		.llseek = seq_lseek,
   182		.release = single_release,
   183	};
   184	
   185	/**
   186	 * blog_clients_show - Show all registered Ceph clients
   187	 */
   188	static int blog_clients_show(struct seq_file *s, void *p)
 > 189	{
   190		u32 id;
   191		int count = 0;
   192		const struct ceph_blog_client_info *info;
   193		
   194		seq_printf(s, "Ceph BLOG Registered Clients\n");
   195		seq_printf(s, "=============================\n\n");
   196		
   197		for (id = 1; id < CEPH_BLOG_MAX_CLIENTS; id++) {
   198			info = ceph_blog_get_client_info(id);
   199			if (!info || info->global_id == 0)
   200				continue;
   201			
   202			count++;
   203			
   204			seq_printf(s, "Client ID %u:\n", id);
   205			seq_printf(s, "  FSID: %pU\n", info->fsid);
   206			seq_printf(s, "  Global ID: %llu\n", info->global_id);
   207			seq_printf(s, "\n");
   208		}
   209		
   210		seq_printf(s, "Total registered clients: %d\n", count);
   211		
   212		return 0;
   213	}
   214	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

