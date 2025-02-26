Return-Path: <ceph-devel+bounces-2815-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88480A46A97
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2025 20:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 155CA188995D
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2025 19:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773C62248B4;
	Wed, 26 Feb 2025 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="j0vkeuR7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FBE221DA6
	for <ceph-devel@vger.kernel.org>; Wed, 26 Feb 2025 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596726; cv=none; b=TEj3RK5NdYQCn///dw8bDvsLNVh79jW7KYZpkVQkTacBbL26JgMY2ErISWyG3ari63sdGkXzFzi9HL+CwPs1S7W65YJrIGkVd16nM9JZpGAxH48YB4CsVE8Ubt6dZAp/kdQADYc8FmgPNd/wtsQ42LVv3vv3KaKKpAuCLykc1Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596726; c=relaxed/simple;
	bh=RnQ9g/Wy6E1VJwrUr9oq9ZQgA54OsfI9toc9NsBjMRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mqPr6zZ9ug/4E/IFtqqsF3hrTuqmy9iIK+U1n/AmkvFfhwX1NVcoaPJmY4V4QFDo4DXx1dpQdgNxTXp6Z/WqbmxB4lnA3BnscpdUUljTY77tjel2a9eSiV0qRlrivNZKdVbTuTk7AEBvaHsI8ZxNu02GzfwlFqdWMdKCcsdGURo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=j0vkeuR7; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2fc20e0f0ceso297339a91.3
        for <ceph-devel@vger.kernel.org>; Wed, 26 Feb 2025 11:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1740596723; x=1741201523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4INREAWwgjraVq6E3VB47jHRo/ztU1ZT9LDQgJ3arv0=;
        b=j0vkeuR7bmBPTMdmoH6617H4ZAEJuoC17Wsm5u7ofwg8A57w052dk5kfMwiKYAs0x5
         vEOA6xNHgXN4uFGhEbt/rG+6oiUa0VeRNRBEdh8IQ+EI/OQLhrf5yTLqRCQ9BG2iiDl8
         cJbm5U7yt07EDFm37LjW0xMxRkJSY7d61WV1dYmmSkduMGkI5F+AXJMrngmth+dN96EQ
         oNd4IJesb0UaX8BE8HDKlpQ4x5/E/WixcwzMrk5tjHvgc3vQ1quwEV3r02GlZ1ngUcwA
         9qwcdYnNfgGM5Wi+Wt3xdfL5+5kpdZaWmZGdZZPFgByL5Cjz3A/4hwkm8M3op56Oj0Te
         d1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740596723; x=1741201523;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4INREAWwgjraVq6E3VB47jHRo/ztU1ZT9LDQgJ3arv0=;
        b=E5BX8wo6FyFbc+Fe7q1/Qcp39ZTe2JF/BDW0PH2apTx1TdZHaRFGskkzz8fmzQpLBd
         wnXhD/DdPRYUx8jcLTE4oIpXni1ngoj4XZkxrJ820gABy7FSV9ACXmfKcaEhkOndbce6
         m8PKctdvllfSnibsYvaCRsUQ/Wn8ed554NYj7f0UrDpFl3qaNwAtwU9R4522borU540G
         hUW8XYU4KDwMYTPOgQPvn9FdPta0VuDTIY+6CS/5RsuNfK0xkUo2C3OEUiNajuVoK8Ko
         /zGlazKi0Uo6Lnb2esBYWoAFadFD7dDEqkQUlibHx4cWktFNd6UymUVAhkdgJXbn6kQs
         t1fQ==
X-Gm-Message-State: AOJu0YzXISvhpS/R77lxmM8JpHWIu9ihBob474DJAi6ATv1G1BU/8aq4
	KkcIHsn8n6oIxR6AXtd94BR9vS+lH7GjQmu7Iqavy3BwydNjTvZlxYK6jM3X/DsbfhcsPnxHXka
	aH70lFg==
X-Gm-Gg: ASbGncvk2+cBOMEMCeFmOjBXPd4F7eLPr1JGGHzs4lb4/I9SDZNlDzReb7BT/K/zljf
	SC2XdoEeeHdr6K0g750zZgXIF0z1LLs9mcgjz2lLOLf9abeXHV6SrGvE4beGNnA/Dhi/qGgpTDE
	q9PFtOuEV/+UhbFi4LJW1i6QdYJfjGbULnYNcHKLBTWlFmDLuOZbRhuIerMHh1pg4q9gqqsi6Lp
	hl9Pi1+EvqMAHnGUE9/yRr85sEt+VYrRjE8rmVqix7KRVzlIWiFjjaq7O4zjqZVHHaySEiDWuF4
	rWoMOvhuKwy2Y5Rbb1Lm0uHWkJOBwzS3eM4c4ist878Z
X-Google-Smtp-Source: AGHT+IHZGUYqPanSW+m+4MRsCZLuQOIZDadvIgL1ssW63dHVgkBN7ttr8xTfW5SZuocq/WMre3H8WA==
X-Received: by 2002:a17:90b:384b:b0:2ee:a04b:92ce with SMTP id 98e67ed59e1d1-2fe7e3b2e96mr6131652a91.32.1740596723149;
        Wed, 26 Feb 2025 11:05:23 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:c0d9:dcd1:ac55:69e5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aeda7f7f39bsm3643639a12.27.2025.02.26.11.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 11:05:22 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org,
	dhowells@redhat.com,
	amarkuze@redhat.com
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH v2] ceph: fix slab-use-after-free in have_mon_and_osd_map()
Date: Wed, 26 Feb 2025 11:05:15 -0800
Message-ID: <20250226190515.314845-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The generic/395 and generic/397 is capable of generating
the oops is on line net/ceph/ceph_common.c:794 with
KASAN enabled.

BUG: KASAN: slab-use-after-free in have_mon_and_osd_map+0x56/0x70
Read of size 4 at addr ffff88811012d810 by task mount.ceph/13305

CPU: 2 UID: 0 PID: 13305 Comm: mount.ceph Not tainted 6.14.0-rc2-build2+ #1266
Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
Call Trace:
<TASK>
dump_stack_lvl+0x57/0x80
? have_mon_and_osd_map+0x56/0x70
print_address_description.constprop.0+0x84/0x330
? have_mon_and_osd_map+0x56/0x70
print_report+0xe2/0x1e0
? rcu_read_unlock_sched+0x60/0x80
? kmem_cache_debug_flags+0xc/0x20
? fixup_red_left+0x17/0x30
? have_mon_and_osd_map+0x56/0x70
kasan_report+0x8d/0xc0
? have_mon_and_osd_map+0x56/0x70
have_mon_and_osd_map+0x56/0x70
ceph_open_session+0x182/0x290
? __pfx_ceph_open_session+0x10/0x10
? __init_swait_queue_head+0x8d/0xa0
? __pfx_autoremove_wake_function+0x10/0x10
? shrinker_register+0xdd/0xf0
ceph_get_tree+0x333/0x680
vfs_get_tree+0x49/0x180
do_new_mount+0x1a3/0x2d0
? __pfx_do_new_mount+0x10/0x10
? security_capable+0x39/0x70
path_mount+0x6dd/0x730
? __pfx_path_mount+0x10/0x10
? kmem_cache_free+0x1e5/0x270
? user_path_at+0x48/0x60
do_mount+0x99/0xe0
? __pfx_do_mount+0x10/0x10
? lock_release+0x155/0x190
__do_sys_mount+0x141/0x180
do_syscall_64+0x9f/0x100
entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f01b1b14f3e
Code: 48 8b 0d d5 3e 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a2 3e 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007fffd129fa08 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000564ec01a7850 RCX: 00007f01b1b14f3e
RDX: 0000564ec00f2225 RSI: 00007fffd12a1964 RDI: 0000564ec0147a20
RBP: 00007fffd129fbd0 R08: 0000564ec014da90 R09: 0000000000000080
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffd12a194e
R13: 0000000000000000 R14: 00007fffd129fa50 R15: 00007fffd129fa40
</TASK>

Allocated by task 13305:
stack_trace_save+0x8c/0xc0
kasan_save_stack+0x1e/0x40
kasan_save_track+0x10/0x30
__kasan_kmalloc+0x3a/0x50
__kmalloc_noprof+0x247/0x290
ceph_osdmap_alloc+0x16/0x130
ceph_osdc_init+0x27a/0x4c0
ceph_create_client+0x153/0x190
create_fs_client+0x50/0x2a0
ceph_get_tree+0xff/0x680
vfs_get_tree+0x49/0x180
do_new_mount+0x1a3/0x2d0
path_mount+0x6dd/0x730
do_mount+0x99/0xe0
__do_sys_mount+0x141/0x180
do_syscall_64+0x9f/0x100
entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 9475:
stack_trace_save+0x8c/0xc0
kasan_save_stack+0x1e/0x40
kasan_save_track+0x10/0x30
kasan_save_free_info+0x3b/0x50
__kasan_slab_free+0x18/0x30
kfree+0x212/0x290
handle_one_map+0x23c/0x3b0
ceph_osdc_handle_map+0x3c9/0x590
mon_dispatch+0x655/0x6f0
ceph_con_process_message+0xc3/0xe0
ceph_con_v1_try_read+0x614/0x760
ceph_con_workfn+0x2de/0x650
process_one_work+0x486/0x7c0
process_scheduled_works+0x73/0x90
worker_thread+0x1c8/0x2a0
kthread+0x2ec/0x300
ret_from_fork+0x24/0x40
ret_from_fork_asm+0x1a/0x30

The buggy address belongs to the object at ffff88811012d800
which belongs to the cache kmalloc-512 of size 512
The buggy address is located 16 bytes inside of
freed 512-byte region [ffff88811012d800, ffff88811012da00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11012c
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x200000000000040(head|node=0|zone=2)
page_type: f5(slab)
raw: 0200000000000040 ffff888100042c80 dead000000000100 dead000000000122
raw: 0000000000000000 0000000080100010 00000000f5000000 0000000000000000
head: 0200000000000040 ffff888100042c80 dead000000000100 dead000000000122
head: 0000000000000000 0000000080100010 00000000f5000000 0000000000000000
head: 0200000000000002 ffffea0004404b01 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff88811012d700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff88811012d780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc

    ffff88811012d800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

^
ffff88811012d880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
ffff88811012d900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb ==================================================================
Disabling lock debugging due to kernel taint
libceph: client274326 fsid 8598140e-35c2-11ee-b97c-001517c545cc
libceph: mon0 (1)90.155.74.19:6789 session established
libceph: client274327 fsid 8598140e-35c2-11ee-b97c-001517c545cc

We have such scenario:

Thread 1:
void ceph_osdmap_destroy(...) {
    <skipped>
    kfree(map);
}
Thread 1 sleep...

Thread 2:
static bool have_mon_and_osd_map(struct ceph_client *client) {
    return client->monc.monmap && client->monc.monmap->epoch &&
        client->osdc.osdmap && client->osdc.osdmap->epoch;
}
Thread 2 has oops...

Thread 1 wake up:
static int handle_one_map(...) {
    <skipped>
    osdc->osdmap = newmap;
    <skipped>
}

This patch fixes the issue by means of locking
client->osdc.lock and client->monc.mutex before
the checking client->osdc.osdmap and
client->monc.monmap.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 net/ceph/ceph_common.c | 14 ++++++++++++--
 net/ceph/debugfs.c     | 33 +++++++++++++++++++--------------
 net/ceph/mon_client.c  |  2 ++
 net/ceph/osd_client.c  |  3 +++
 4 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55..5c8fd78d6bd5 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -790,8 +790,18 @@ EXPORT_SYMBOL(ceph_reset_client_addr);
  */
 static bool have_mon_and_osd_map(struct ceph_client *client)
 {
-	return client->monc.monmap && client->monc.monmap->epoch &&
-	       client->osdc.osdmap && client->osdc.osdmap->epoch;
+	bool have_mon_map = false;
+	bool have_osd_map = false;
+
+	mutex_lock(&client->monc.mutex);
+	have_mon_map = client->monc.monmap && client->monc.monmap->epoch;
+	mutex_unlock(&client->monc.mutex);
+
+	down_read(&client->osdc.lock);
+	have_osd_map = client->osdc.osdmap && client->osdc.osdmap->epoch;
+	up_read(&client->osdc.lock);
+
+	return have_mon_map && have_osd_map;
 }
 
 /*
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..6e2014c813ca 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -36,18 +36,20 @@ static int monmap_show(struct seq_file *s, void *p)
 	int i;
 	struct ceph_client *client = s->private;
 
-	if (client->monc.monmap == NULL)
-		return 0;
-
-	seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
-	for (i = 0; i < client->monc.monmap->num_mon; i++) {
-		struct ceph_entity_inst *inst =
-			&client->monc.monmap->mon_inst[i];
-
-		seq_printf(s, "\t%s%lld\t%s\n",
-			   ENTITY_NAME(inst->name),
-			   ceph_pr_addr(&inst->addr));
+	mutex_lock(&client->monc.mutex);
+	if (client->monc.monmap) {
+		seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
+		for (i = 0; i < client->monc.monmap->num_mon; i++) {
+			struct ceph_entity_inst *inst =
+				&client->monc.monmap->mon_inst[i];
+
+			seq_printf(s, "\t%s%lld\t%s\n",
+				   ENTITY_NAME(inst->name),
+				   ceph_pr_addr(&inst->addr));
+		}
 	}
+	mutex_unlock(&client->monc.mutex);
+
 	return 0;
 }
 
@@ -56,13 +58,15 @@ static int osdmap_show(struct seq_file *s, void *p)
 	int i;
 	struct ceph_client *client = s->private;
 	struct ceph_osd_client *osdc = &client->osdc;
-	struct ceph_osdmap *map = osdc->osdmap;
+	struct ceph_osdmap *map = NULL;
 	struct rb_node *n;
 
+	down_read(&osdc->lock);
+
+	map = osdc->osdmap;
 	if (map == NULL)
-		return 0;
+		goto finish_osdmap_show;
 
-	down_read(&osdc->lock);
 	seq_printf(s, "epoch %u barrier %u flags 0x%x\n", map->epoch,
 			osdc->epoch_barrier, map->flags);
 
@@ -131,6 +135,7 @@ static int osdmap_show(struct seq_file *s, void *p)
 		seq_printf(s, "]\n");
 	}
 
+finish_osdmap_show:
 	up_read(&osdc->lock);
 	return 0;
 }
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index ab66b599ac47..2d67ed4aec8b 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1232,6 +1232,7 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 	ceph_auth_destroy(monc->auth);
 out_monmap:
 	kfree(monc->monmap);
+	monc->monmap = NULL;
 out:
 	return err;
 }
@@ -1267,6 +1268,7 @@ void ceph_monc_stop(struct ceph_mon_client *monc)
 	ceph_msg_put(monc->m_subscribe_ack);
 
 	kfree(monc->monmap);
+	monc->monmap = NULL;
 }
 EXPORT_SYMBOL(ceph_monc_stop);
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b24afec24138..3262ea7e5f56 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5278,6 +5278,7 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 	mempool_destroy(osdc->req_mempool);
 out_map:
 	ceph_osdmap_destroy(osdc->osdmap);
+	osdc->osdmap = NULL;
 out:
 	return err;
 }
@@ -5307,6 +5308,8 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 	WARN_ON(atomic_read(&osdc->num_homeless));
 
 	ceph_osdmap_destroy(osdc->osdmap);
+	osdc->osdmap = NULL;
+
 	mempool_destroy(osdc->req_mempool);
 	ceph_msgpool_destroy(&osdc->msgpool_op);
 	ceph_msgpool_destroy(&osdc->msgpool_op_reply);
-- 
2.48.0


