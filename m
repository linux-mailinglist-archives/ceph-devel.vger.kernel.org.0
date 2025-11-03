Return-Path: <ceph-devel+bounces-3912-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A6554C2E334
	for <lists+ceph-devel@lfdr.de>; Mon, 03 Nov 2025 22:54:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 379D24E9443
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Nov 2025 21:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C14F2D6E6D;
	Mon,  3 Nov 2025 21:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WF/xXWfm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D6D2D5C6C
	for <ceph-devel@vger.kernel.org>; Mon,  3 Nov 2025 21:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762206827; cv=none; b=gtvg+rIWKxux9VKnwXMzHT68cmQtcKRJZufjhQ1Qmk+g1Qiv7A2fI5ffwdWHz5pW7ntYK5ZM48N9AX5LqhvHrEFpQ0yh+UYhGetP3Xsmbgh92biaI2kkYlocYkukHuYtzxpGftTRI382p5Ew8Vmqa0Yh7o6s7FQuL3TqrpEjJMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762206827; c=relaxed/simple;
	bh=NhEN3opQj9LdJgc7ykAt1iYfejYv0EvfPv/KGIGmPew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+0cda2vo468WdvLzttxvpXudxx3kuI1HpOr7HcZVi91YjCWNMbybaE8YJ4vw0bZw0To95SEdlvufKDa12bcrrPCk4pEOUCaU1oKkGkvEBLQ0Q2qLYL/9gSJoAut4B50Zr+PMIsWM/xS/xSN9yLmhel/ibOVwhyUJct3NrRpvLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WF/xXWfm; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42557c5cedcso2915283f8f.0
        for <ceph-devel@vger.kernel.org>; Mon, 03 Nov 2025 13:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762206824; x=1762811624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCkV0HBTpDv4qN+QTM6IPA1y0o1FY4jhg+avyfhH6So=;
        b=WF/xXWfmP+9ZD9hPI+7HpPfJVJR9PpH96OKuuAYEK7w+YoKlA8DiFOfka/XRpUo7JY
         TEZEGLsYD7iJ7HqSXrtvkyhn5IuofgjoZ2gmCkj4LCDrZMmxG5qYWn0QBM5uUsqLDu8t
         i+dJCtotGnHvjc1a62yDaw6utyPQu0n+QQ2H3fGa+aEtXrOyw5Xm7u+eWJQF2gRGNPBp
         PdcPuJeaZ1tb6KK/jT+hZsgshV23DlPSMaueiBIMt/so7y/4Prt/kjz15w0leFtLCKQs
         toIO+Y1DG7Rlt+iTOwdukG9gvqQV0FJVnbphfwfJRvgcMGIuhVZg/QEuq2dKpBuZ8395
         dhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762206824; x=1762811624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCkV0HBTpDv4qN+QTM6IPA1y0o1FY4jhg+avyfhH6So=;
        b=MQ9vYwVBzGnfx1a1TgWFi/qE7I9mT3/RkUuOlkfHf4ucNZiQFvEDhls8x6BUh0Lw8D
         S/v7M1oZR5+VRW+cMuoNYsRtQz0I+5l0Rmx1pjQzveFUWzJHJ4pl0AHgnCRhy/GAQxyq
         FIKBkYh1kYn2yqnUxT7/emcKyBnB0qVyVE8jVVeeTIkV0SKhV4+pxow4M0Iy8rTpvoNj
         E20cd47oPVuMNhML4YWBScV1ZhrsmA3Sq0qZT+I3AOK3te1ej4Ls+soa2YUPH7D1MDbF
         D1IEwSyhBbr6W7A/ROkPqa64wprQOOrYC4sn7QHIWfZwVmuR1dTEWel8phYfp9B5tZNa
         A3jA==
X-Gm-Message-State: AOJu0YyF2nbCbJS+ki7vZQUVDtOas3Ri0dLHkRf4TY8uyptKGctstmk+
	SYjbrsPDpcIlIOV6k1uraP0WjYpDcIFHBsFJyVfKFSJ8MKmwqpnKiGSqAjFsbQ==
X-Gm-Gg: ASbGncu+9gPTQYmc1cTlOekr+0GQJWCobCcBPZ/7BDmhyqHXeqjvd9NB4k06ZkZ6uS5
	k+OkynkmUECtpBBVFpeaRU9ZsSpa7qqsmTCxOQqmEldkEwhLZboCFdXt+JgFvZC25Xl/m7Sxctp
	XbN1rEFHrAGxjRskJ72W7fcxHRnBQjnu91dAX85Qpdxd/1N3KlgT6p1soLEefqVJA6vtFJZMweb
	l2xAsp6vgzfShl+ZpNuVZSyFoOW0dcUIPGoBpJGW4hdfmZmtci/txfoipDb6XWxNF4T0Zh0GGd+
	/2s6raKcznwsDnzBKaAyeTaF/9Ee/GXXwf0NEBXPiiSCOtDZexHlb3LJcOvTFHtGU5ba9fyMjFC
	UoeeHVimLm1/uX0A6HYgWKY/8Wu8ZbME+sXkyREw8jDeYwyBCYD0+HumXFsf9oeECxP0Q1QqDtW
	NSeC67mKkV90EfoW8jkAbUqZNluJH0YkATaB96OOqy3nAAPzhzkDDyJI5nDTHk
X-Google-Smtp-Source: AGHT+IEkwtOMBPFgHZ04ROGPApNldMDmMdFuCkB6Pl2LSp8yVgprUB/kWGAtLxK6LKZoQchJpr1svw==
X-Received: by 2002:a05:6000:1846:b0:426:d80c:2759 with SMTP id ffacd0b85a97d-429bd696c7fmr13699798f8f.25.1762206823361;
        Mon, 03 Nov 2025 13:53:43 -0800 (PST)
Received: from zambezi.redhat.com (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18efd3sm986521f8f.5.2025.11.03.13.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 13:53:42 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH 1/2] libceph: fix potential use-after-free in have_mon_and_osd_map()
Date: Mon,  3 Nov 2025 22:53:26 +0100
Message-ID: <20251103215329.1856726-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251103215329.1856726-1-idryomov@gmail.com>
References: <20251103215329.1856726-1-idryomov@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wait loop in __ceph_open_session() can race with the client
receiving a new monmap or osdmap shortly after the initial map is
received.  Both ceph_monc_handle_map() and handle_one_map() install
a new map immediately after freeing the old one

    kfree(monc->monmap);
    monc->monmap = monmap;

    ceph_osdmap_destroy(osdc->osdmap);
    osdc->osdmap = newmap;

under client->monc.mutex and client->osdc.lock respectively, but
because neither is taken in have_mon_and_osd_map() it's possible for
client->monc.monmap->epoch and client->osdc.osdmap->epoch arms in

    client->monc.monmap && client->monc.monmap->epoch &&
        client->osdc.osdmap && client->osdc.osdmap->epoch;

condition to dereference an already freed map.  This happens to be
reproducible with generic/395 and generic/397 with KASAN enabled:

    BUG: KASAN: slab-use-after-free in have_mon_and_osd_map+0x56/0x70
    Read of size 4 at addr ffff88811012d810 by task mount.ceph/13305
    CPU: 2 UID: 0 PID: 13305 Comm: mount.ceph Not tainted 6.14.0-rc2-build2+ #1266
    ...
    Call Trace:
    <TASK>
    have_mon_and_osd_map+0x56/0x70
    ceph_open_session+0x182/0x290
    ceph_get_tree+0x333/0x680
    vfs_get_tree+0x49/0x180
    do_new_mount+0x1a3/0x2d0
    path_mount+0x6dd/0x730
    do_mount+0x99/0xe0
    __do_sys_mount+0x141/0x180
    do_syscall_64+0x9f/0x100
    entry_SYSCALL_64_after_hwframe+0x76/0x7e
    </TASK>

    Allocated by task 13305:
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

Rewrite the wait loop to check the above condition directly with
client->monc.mutex and client->osdc.lock taken as appropriate.  While
at it, improve the timeout handling (previously mount_timeout could be
exceeded in case wait_event_interruptible_timeout() slept more than
once) and access client->auth_err under client->monc.mutex to match
how it's set in finish_auth().

monmap_show() and osdmap_show() now take the respective lock before
accessing the map as well.

Cc: stable@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/ceph_common.c | 53 +++++++++++++++++++++++++-----------------
 net/ceph/debugfs.c     | 14 +++++++----
 2 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55..285e981730e5 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -785,42 +785,53 @@ void ceph_reset_client_addr(struct ceph_client *client)
 }
 EXPORT_SYMBOL(ceph_reset_client_addr);
 
-/*
- * true if we have the mon map (and have thus joined the cluster)
- */
-static bool have_mon_and_osd_map(struct ceph_client *client)
-{
-	return client->monc.monmap && client->monc.monmap->epoch &&
-	       client->osdc.osdmap && client->osdc.osdmap->epoch;
-}
-
 /*
  * mount: join the ceph cluster, and open root directory.
  */
 int __ceph_open_session(struct ceph_client *client, unsigned long started)
 {
-	unsigned long timeout = client->options->mount_timeout;
-	long err;
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	long timeout = ceph_timeout_jiffies(client->options->mount_timeout);
+	bool have_monmap, have_osdmap;
+	int err;
 
 	/* open session, and wait for mon and osd maps */
 	err = ceph_monc_open_session(&client->monc);
 	if (err < 0)
 		return err;
 
-	while (!have_mon_and_osd_map(client)) {
-		if (timeout && time_after_eq(jiffies, started + timeout))
-			return -ETIMEDOUT;
+	add_wait_queue(&client->auth_wq, &wait);
+	for (;;) {
+		mutex_lock(&client->monc.mutex);
+		err = client->auth_err;
+		have_monmap = client->monc.monmap && client->monc.monmap->epoch;
+		mutex_unlock(&client->monc.mutex);
+
+		down_read(&client->osdc.lock);
+		have_osdmap = client->osdc.osdmap && client->osdc.osdmap->epoch;
+		up_read(&client->osdc.lock);
+
+		if (err || (have_monmap && have_osdmap))
+			break;
+
+		if (signal_pending(current)) {
+			err = -ERESTARTSYS;
+			break;
+		}
+
+		if (!timeout) {
+			err = -ETIMEDOUT;
+			break;
+		}
 
 		/* wait */
 		dout("mount waiting for mon_map\n");
-		err = wait_event_interruptible_timeout(client->auth_wq,
-			have_mon_and_osd_map(client) || (client->auth_err < 0),
-			ceph_timeout_jiffies(timeout));
-		if (err < 0)
-			return err;
-		if (client->auth_err < 0)
-			return client->auth_err;
+		timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
 	}
+	remove_wait_queue(&client->auth_wq, &wait);
+
+	if (err)
+		return err;
 
 	pr_info("client%llu fsid %pU\n", ceph_client_gid(client),
 		&client->fsid);
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..83c270bce63c 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -36,8 +36,9 @@ static int monmap_show(struct seq_file *s, void *p)
 	int i;
 	struct ceph_client *client = s->private;
 
+	mutex_lock(&client->monc.mutex);
 	if (client->monc.monmap == NULL)
-		return 0;
+		goto out_unlock;
 
 	seq_printf(s, "epoch %d\n", client->monc.monmap->epoch);
 	for (i = 0; i < client->monc.monmap->num_mon; i++) {
@@ -48,6 +49,9 @@ static int monmap_show(struct seq_file *s, void *p)
 			   ENTITY_NAME(inst->name),
 			   ceph_pr_addr(&inst->addr));
 	}
+
+out_unlock:
+	mutex_unlock(&client->monc.mutex);
 	return 0;
 }
 
@@ -56,13 +60,14 @@ static int osdmap_show(struct seq_file *s, void *p)
 	int i;
 	struct ceph_client *client = s->private;
 	struct ceph_osd_client *osdc = &client->osdc;
-	struct ceph_osdmap *map = osdc->osdmap;
+	struct ceph_osdmap *map;
 	struct rb_node *n;
 
+	down_read(&osdc->lock);
+	map = osdc->osdmap;
 	if (map == NULL)
-		return 0;
+		goto out_unlock;
 
-	down_read(&osdc->lock);
 	seq_printf(s, "epoch %u barrier %u flags 0x%x\n", map->epoch,
 			osdc->epoch_barrier, map->flags);
 
@@ -131,6 +136,7 @@ static int osdmap_show(struct seq_file *s, void *p)
 		seq_printf(s, "]\n");
 	}
 
+out_unlock:
 	up_read(&osdc->lock);
 	return 0;
 }
-- 
2.49.0


