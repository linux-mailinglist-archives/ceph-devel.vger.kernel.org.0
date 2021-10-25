Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2000439982
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Oct 2021 17:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhJYPDT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 11:03:19 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44100 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbhJYPDJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Oct 2021 11:03:09 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4B1B61FD3A;
        Mon, 25 Oct 2021 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635174046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Em7EGGqG6o35wKmiax01QEikuwAkO36IkSznNVbOrlc=;
        b=jIahhHxFdvhSnQYxu0IBU28NRIRCzOOJrmFrset/zDMiZ7xfEq1BN9mZzJHvCKOHHJfCCX
        S8085s18u/fWaQ/C9Djhh9Ak8fX8tL/KcURPxIKTnUGLt9n8GwtYDciaZma8CYY5sviWFb
        i5x8fpIWp0c40NjlZRLsHpgUm7POKHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635174046;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Em7EGGqG6o35wKmiax01QEikuwAkO36IkSznNVbOrlc=;
        b=EzpQlzC437+htL/7LNxRfvm4yG04LClGFMDBNi0+MIMs/PBqGghZtfRguuxQfp/nBUh4q9
        rewS9GLRZ/qQPWCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94A9513C0B;
        Mon, 25 Oct 2021 15:00:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cCmUIZ3GdmHSDQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 25 Oct 2021 15:00:45 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 03806f0b;
        Mon, 25 Oct 2021 15:00:44 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [RFC PATCH v2] ceph: add remote object copy counter to fs client metrics
Date:   Mon, 25 Oct 2021 16:00:42 +0100
Message-Id: <20211025150042.1677-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This counter will keep track of the number of remote object copies done on
copy_file_range syscalls.  This counter will be kept using the metrics
infrastructure and thus accessible through debugfs.  For now, this counter
won't be sent to the MDS.

Cc: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
Hi!

So, here's v2 of this RFC.  Now, I guess that Patrick's idea of adding
this counter was to validate the test results, isn't that right?  If so,
this has to be done from within the fstest code and not from teuthology
test.  The reason is that fstests mount and unmount the filesystems under
test, which effectively wipe the metrics on the client.

So, the follow-up to this patch would be changes to the corresponding
fstests so that they would access this debugfs file and check the counter
is set to the expected value.

Cheers,
-- 
Luís

 fs/ceph/debugfs.c | 6 ++++++
 fs/ceph/file.c    | 1 +
 fs/ceph/metric.c  | 2 ++
 fs/ceph/metric.h  | 2 ++
 4 files changed, 11 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 38b78b45811f..9f1a09816541 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -235,6 +235,12 @@ static int metric_show(struct seq_file *s, void *p)
 		   percpu_counter_sum(&m->i_caps_mis),
 		   percpu_counter_sum(&m->i_caps_hit));
 
+	seq_printf(s, "\n");
+	seq_printf(s, "item          total\n");
+	seq_printf(s, "-------------------\n");
+	seq_printf(s, "%-14s%-16lld\n", "copy-from",
+		   atomic64_read(&m->total_copyfrom));
+
 	return 0;
 }
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e61018d9764e..b36a7b9c1ab8 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2253,6 +2253,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 				bytes = ret;
 			goto out;
 		}
+		atomic64_inc(&fsc->mdsc->metric.total_copyfrom);
 		len -= object_size;
 		bytes += object_size;
 		*src_off += object_size;
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 04d5df29bbbf..a8a9f96c56a8 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -278,6 +278,8 @@ int ceph_metric_init(struct ceph_client_metric *m)
 	if (ret)
 		goto err_total_inodes;
 
+	atomic64_set(&m->total_copyfrom, 0);
+
 	m->session = NULL;
 	INIT_DELAYED_WORK(&m->delayed_work, metric_delayed_work);
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 0133955a3c6a..a1e2cd46de6b 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -169,6 +169,8 @@ struct ceph_client_metric {
 	struct percpu_counter opened_inodes;
 	struct percpu_counter total_inodes;
 
+	atomic64_t total_copyfrom;
+
 	struct ceph_mds_session *session;
 	struct delayed_work delayed_work;  /* delayed work */
 };
