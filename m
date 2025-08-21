Return-Path: <ceph-devel+bounces-3468-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B6CDB309A9
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Aug 2025 00:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DD91189AAD5
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Aug 2025 22:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7A02E8E19;
	Thu, 21 Aug 2025 22:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="IuOwLjkX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77513258EFF
	for <ceph-devel@vger.kernel.org>; Thu, 21 Aug 2025 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755816745; cv=none; b=QhFga/mxsVSeScllmODSoZh7RdzzrUoa4sztnh797Y9TpY3glg4bZqH9nfZaQFiTZ655C5jS1tzrL6V9GjCfSmsX9Jl88FhRQPlEs/+WiFgIF/adEP6vyQc44MDLzhbPZNlplnU4rwt0h+TxKvQT6efzFGnhvwN62EatPagO8B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755816745; c=relaxed/simple;
	bh=FgHbn/4w4glcRKRoNUMEsZAWrjY3sF8SMqXaxA3sOsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DO1IfsgtEJSkyD/7zsyEU6YxEjDj2eMys3br3DvWDC82EUgW3SAhnk9Ce8PXLiSFBnTR9IFackzPJI13VpLh+sAB89KuZ0l37PItPy5EEOe/pbffjbYnojdqT+lRQXvBZao2AlxLwf8fPRtApclfN06UX7gjEBUZVQaOMBtZCEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=IuOwLjkX; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-71d6083cc69so13181137b3.2
        for <ceph-devel@vger.kernel.org>; Thu, 21 Aug 2025 15:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1755816741; x=1756421541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tIkIZL8emM/MG0oIXAUNgqVGJAtiIfBA7s4V6/c45lQ=;
        b=IuOwLjkX46ghg42iPut6ImY67PZ4eQN69DpLU0chCuxC2q+8YFfsnSZ9iOPmNlJBjr
         TYy0r68YpqFiszYWJ5IHbJXd2Szk5qKU7fD8k+6ur20+TdOrRyc4XMn4EMnUkA3cCfoX
         FWXBwaQw377Iy2Ydq0DhqtnXFnFE/5q7QxqdSGUmkZDAgIk0bbMrkP288K2MNmWvgOw8
         Tcr2kwZsckYYhbPCO0CaxJ3yTO8DonIcde876cXHu2i+KxIXXa5iwKcwk9REe3wH7MYp
         USpmSEgkQEXyD9oGeN6iKLrLcYfF/dvtNsB6iEk2lbv8aJosEfnwy6gmkNYfhlAenOla
         J2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755816741; x=1756421541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tIkIZL8emM/MG0oIXAUNgqVGJAtiIfBA7s4V6/c45lQ=;
        b=Nc1VHIEVvvhgyXsx7gpnml1dTkoqVaS0e+1bs5cUdH30H0Du2Rnght+OyOIPhaX96w
         t1W92+bAaA60H/rA9XW8aXz3CfHeRyIPcxHqIl110UqEN3/L9ZXlmj2/W7j9WZf7uQoC
         z3u0aR7ky6jRdcuaVE4me2yPK7pUlnao6IethPex7rAE2YLIXeEdar0zobLE4kewIZsI
         tAbX6X+WtLm9Pi9nuABJuOxRLXOxnEa3TAXairDJM0z/pF69GhfVX6SeyJjQSr8Avf/L
         4FEDTmU4PZLHbsNNVId/ZO3q+AJNINnAz2wBLNQo3EIpTZmYM5a+O4YAFZoAg2DbpRwJ
         kS5w==
X-Gm-Message-State: AOJu0YzpjWEowyo20tPhnkiy2FF9Fl3zwX9/bW6cKVSPy+wId7X3tFYk
	4sRy+dyMU5gj18//JyRQQCmoa3s+F0adZAN8QyWeee920rKc+TzWKwA3wZYnq6OgSDVf4TcVUTh
	2zt60DnHxiw==
X-Gm-Gg: ASbGncuM11PEkP2FDtqKr+wlLaEt1alBkzpVhaaDoFjf12ms80NxZmB7CTqqGZxmv9G
	gLG3WFBxIrCwRoRHgQzdZ84ShtiRN1CtuSQ2rUrzg4sdDKFRp2E1SzpdhdwUwNYdkInfxw0K+Di
	QNk/S05oDvVL5MJWLU5SwIty6bBTRjOFBKr8G4EM3/jy27Wi399WEiTaSfPVwfujV10p8xnKWeZ
	qqGbgf1J87SP6nv5z8DXf8rnyBB6FAfSPkd+37KrtQrhKl5Pi1TvAbWxg4XEX7pOcRR3QD542tT
	sZiGiZbVhlj1yVNml6Snqqio1OzwfKIh5inNuk/9oBVeHUUzUfeHQQQMVwqVuGecn9pY4KTu0Hw
	JOpIMtMmq1XgEUmQRZjWcVAzEhCUEWJE5SflRVUhK
X-Google-Smtp-Source: AGHT+IGlORo2TtZPtBfdCpsFipWgayGqjRKkKY+msN/uYah7uZ/X5MxfUz5J6DkgnoqcJmBw3kpF2A==
X-Received: by 2002:a05:690c:2504:b0:71a:2d5f:49bd with SMTP id 00721157ae682-71fdc3155d0mr12431717b3.22.1755816740951;
        Thu, 21 Aug 2025 15:52:20 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:213d:fd37:8ddc:61e4])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-5f52b9fdedbsm136653d50.5.2025.08.21.15.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 15:52:20 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	dhowells@redhat.com
Subject: [PATCH v8] ceph: fix slab-use-after-free in have_mon_and_osd_map()
Date: Thu, 21 Aug 2025 15:51:48 -0700
Message-ID: <20250821225147.37125-2-slava@dubeyko.com>
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
client->monc.monmap in have_mon_and_osd_map() function.
The monmap_show() and osdmap_show() methods were reworked
to prevent the potential race condition during
the methods call.

v8
Ilya Dryomov has pointed out that __ceph_open_session()
has incorrect logic of two nested loops and checking of
client->auth_err could be missed because of it.
The logic of __ceph_open_session() has been reworked.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 net/ceph/ceph_common.c | 43 +++++++++++++++++++++++++++++++++++-------
 net/ceph/debugfs.c     | 17 +++++++++++++----
 net/ceph/mon_client.c  |  2 ++
 net/ceph/osd_client.c  |  2 ++
 4 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55..2a7ca942bc2f 100644
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
@@ -800,6 +810,7 @@ static bool have_mon_and_osd_map(struct ceph_client *client)
 int __ceph_open_session(struct ceph_client *client, unsigned long started)
 {
 	unsigned long timeout = client->options->mount_timeout;
+	int auth_err = 0;
 	long err;
 
 	/* open session, and wait for mon and osd maps */
@@ -813,13 +824,31 @@ int __ceph_open_session(struct ceph_client *client, unsigned long started)
 
 		/* wait */
 		dout("mount waiting for mon_map\n");
-		err = wait_event_interruptible_timeout(client->auth_wq,
-			have_mon_and_osd_map(client) || (client->auth_err < 0),
-			ceph_timeout_jiffies(timeout));
+
+		DEFINE_WAIT_FUNC(wait, woken_wake_function);
+
+		add_wait_queue(&client->auth_wq, &wait);
+
+		if (!have_mon_and_osd_map(client)) {
+			if (signal_pending(current)) {
+				err = -ERESTARTSYS;
+				break;
+			}
+			wait_woken(&wait, TASK_INTERRUPTIBLE,
+				   ceph_timeout_jiffies(timeout));
+		}
+
+		remove_wait_queue(&client->auth_wq, &wait);
+
 		if (err < 0)
 			return err;
-		if (client->auth_err < 0)
-			return client->auth_err;
+
+		mutex_lock(&client->monc.mutex);
+		auth_err = client->auth_err;
+		mutex_unlock(&client->monc.mutex);
+
+		if (auth_err < 0)
+			return auth_err;
 	}
 
 	pr_info("client%llu fsid %pU\n", ceph_client_gid(client),
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..7b45c169a859 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -36,8 +36,10 @@ static int monmap_show(struct seq_file *s, void *p)
 	int i;
 	struct ceph_client *client = s->private;
 
+	mutex_lock(&client->monc.mutex);
+
 	if (client->monc.monmap == NULL)
-		return 0;
+		goto out_unlock;
 
 	seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
 	for (i = 0; i < client->monc.monmap->num_mon; i++) {
@@ -48,6 +50,10 @@ static int monmap_show(struct seq_file *s, void *p)
 			   ENTITY_NAME(inst->name),
 			   ceph_pr_addr(&inst->addr));
 	}
+
+out_unlock:
+	mutex_unlock(&client->monc.mutex);
+
 	return 0;
 }
 
@@ -56,13 +62,15 @@ static int osdmap_show(struct seq_file *s, void *p)
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
+		goto out_unlock;
 
-	down_read(&osdc->lock);
 	seq_printf(s, "epoch %u barrier %u flags 0x%x\n", map->epoch,
 			osdc->epoch_barrier, map->flags);
 
@@ -131,6 +139,7 @@ static int osdmap_show(struct seq_file *s, void *p)
 		seq_printf(s, "]\n");
 	}
 
+out_unlock:
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
index 6664ea73ccf8..5f1e358bdfff 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5255,6 +5255,7 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
 	mempool_destroy(osdc->req_mempool);
 out_map:
 	ceph_osdmap_destroy(osdc->osdmap);
+	osdc->osdmap = NULL;
 out:
 	return err;
 }
@@ -5284,6 +5285,7 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 	WARN_ON(atomic_read(&osdc->num_homeless));
 
 	ceph_osdmap_destroy(osdc->osdmap);
+	osdc->osdmap = NULL;
 	mempool_destroy(osdc->req_mempool);
 	ceph_msgpool_destroy(&osdc->msgpool_op);
 	ceph_msgpool_destroy(&osdc->msgpool_op_reply);
-- 
2.50.1


