Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5705D3BD9DC
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 17:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhGFPR3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 11:17:29 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33716 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbhGFPR2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 11:17:28 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5A0791FF81;
        Tue,  6 Jul 2021 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625579564; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2OyEQ2NjpZQXif7OzBbQKABUSVbIXRvJoMQ9p8XetM=;
        b=vdQMyIREkOOz7ms/RwsWo5wGnIow/IxbhLmeP9yRtZ5oV6JJDf3B6tDbrcHpoPeJ6Hw0lm
        aCX8Fxady6vp3KkRp1NwSJrS4K17EEnzT3zBeUoqBnznn1lhz7e1M7BtrnTfaCrVZYuK8/
        yZJHMqdLa+rwzd+JPMj6YiuCdw+feuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625579564;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2OyEQ2NjpZQXif7OzBbQKABUSVbIXRvJoMQ9p8XetM=;
        b=lCCXhzffDA8aeMVYB+Rzr6SR7IIh+AIvoPZOWKzjLryndmuff8gqy1OFlfo2nn9bJv5B26
        unvM/pNT3IxOFOCA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id EFFA5133D0;
        Tue,  6 Jul 2021 13:52:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id OBhfNytg5GCPKAAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Tue, 06 Jul 2021 13:52:43 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id fca8c589;
        Tue, 6 Jul 2021 13:52:42 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH v3 1/2] ceph: allow schedule_delayed() callers to set delay for workqueue
Date:   Tue,  6 Jul 2021 14:52:41 +0100
Message-Id: <20210706135242.9978-2-lhenriques@suse.de>
In-Reply-To: <20210706135242.9978-1-lhenriques@suse.de>
References: <20210706135242.9978-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow schedule_delayed() callers to explicitly set the delay value instead
of defaulting to a 5 secs value.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/mds_client.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e5af591d3bd4..f5dc58a05f9f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4502,13 +4502,19 @@ void inc_session_sequence(struct ceph_mds_session *s)
 }
 
 /*
- * delayed work -- periodically trim expired leases, renew caps with mds
+ * delayed work -- periodically trim expired leases, renew caps with mds.  If
+ * the @delay parameter is set to 0 or if it's more than 5 secs, the default
+ * workqueue delay value of 5 secs will be used.
  */
-static void schedule_delayed(struct ceph_mds_client *mdsc)
+static void schedule_delayed(struct ceph_mds_client *mdsc, unsigned long delay)
 {
-	int delay = 5;
-	unsigned hz = round_jiffies_relative(HZ * delay);
-	schedule_delayed_work(&mdsc->delayed_work, hz);
+	unsigned long max_delay = HZ * 5;
+
+	/* 5 secs default delay */
+	if (!delay || (delay > max_delay))
+		delay = max_delay;
+	schedule_delayed_work(&mdsc->delayed_work,
+			      round_jiffies_relative(delay));
 }
 
 static void delayed_work(struct work_struct *work)
@@ -4565,7 +4571,7 @@ static void delayed_work(struct work_struct *work)
 
 	maybe_recover_session(mdsc);
 
-	schedule_delayed(mdsc);
+	schedule_delayed(mdsc, 0);
 }
 
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
@@ -5042,7 +5048,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 			  mdsc->mdsmap->m_epoch);
 
 	mutex_unlock(&mdsc->mutex);
-	schedule_delayed(mdsc);
+	schedule_delayed(mdsc, 0);
 	return;
 
 bad_unlock:
