Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7433B7049
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 11:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhF2JuU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 05:50:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:56214 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbhF2JuS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 05:50:18 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F0B53203C4;
        Tue, 29 Jun 2021 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624960070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZM+fOeCAiwb/5MiJvXfZkLNNXxQowttqgx4sNRJ6uo=;
        b=x4xa7OqIXJsOrGoMimG1X4Ij8F4yd3aOIi15dPxK3m813rFUxv5mE/MmUzwNquCm4gINTa
        kfBWNoz2AfCNWQZA5lO5QiRzwhlhbeLEWnIPQcULEaeF1QFIf8snn5mlcT3at9hd1MUx70
        GwJY156KFehqNf2fLfqWZc+lFn4N8Cs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624960070;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZM+fOeCAiwb/5MiJvXfZkLNNXxQowttqgx4sNRJ6uo=;
        b=isy0exJJvzAAPcaHoyjN2Y7RTkPRjQDjeR9Y1+MWjdPgS95T75KruvGAlr0aYeVP0MjHK5
        2rp+kghDubQtrbCQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8BFC511906;
        Tue, 29 Jun 2021 09:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624960070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZM+fOeCAiwb/5MiJvXfZkLNNXxQowttqgx4sNRJ6uo=;
        b=x4xa7OqIXJsOrGoMimG1X4Ij8F4yd3aOIi15dPxK3m813rFUxv5mE/MmUzwNquCm4gINTa
        kfBWNoz2AfCNWQZA5lO5QiRzwhlhbeLEWnIPQcULEaeF1QFIf8snn5mlcT3at9hd1MUx70
        GwJY156KFehqNf2fLfqWZc+lFn4N8Cs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624960070;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZM+fOeCAiwb/5MiJvXfZkLNNXxQowttqgx4sNRJ6uo=;
        b=isy0exJJvzAAPcaHoyjN2Y7RTkPRjQDjeR9Y1+MWjdPgS95T75KruvGAlr0aYeVP0MjHK5
        2rp+kghDubQtrbCQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id kFlCH0bs2mBqawAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 09:47:50 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 62952341;
        Tue, 29 Jun 2021 09:47:49 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [RFC PATCH v2 1/2] ceph: allow schedule_delayed() callers to set delay for workqueue
Date:   Tue, 29 Jun 2021 10:47:48 +0100
Message-Id: <20210629094749.25253-2-lhenriques@suse.de>
In-Reply-To: <20210629094749.25253-1-lhenriques@suse.de>
References: <20210629094749.25253-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow schedule_delayed() callers to explicitly set the delay value instead
of defaulting to a 5 secs value.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/mds_client.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e5af591d3bd4..08c76bf57fb1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4502,13 +4502,18 @@ void inc_session_sequence(struct ceph_mds_session *s)
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
+	unsigned long max_delay = round_jiffies_relative(HZ * 5);
+
+	/* 5 secs default delay */
+	if (!delay || (delay > max_delay))
+		delay = max_delay;
+	schedule_delayed_work(&mdsc->delayed_work, delay);
 }
 
 static void delayed_work(struct work_struct *work)
@@ -4565,7 +4570,7 @@ static void delayed_work(struct work_struct *work)
 
 	maybe_recover_session(mdsc);
 
-	schedule_delayed(mdsc);
+	schedule_delayed(mdsc, 0);
 }
 
 int ceph_mdsc_init(struct ceph_fs_client *fsc)
@@ -5042,7 +5047,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 			  mdsc->mdsmap->m_epoch);
 
 	mutex_unlock(&mdsc->mutex);
-	schedule_delayed(mdsc);
+	schedule_delayed(mdsc, 0);
 	return;
 
 bad_unlock:
