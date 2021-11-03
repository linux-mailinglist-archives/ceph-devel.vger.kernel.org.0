Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF3A444088
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 12:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhKCL0t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 07:26:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41316 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhKCL0q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 07:26:46 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D48071FD4F;
        Wed,  3 Nov 2021 11:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635938648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4A9LwbWSrS822C4Vswjzc2ote0q6H+7MR5LublF8dA=;
        b=YP4cLlGpiKstukvxrqhyZErxBsYBAlHf3xpMbT/LR1TJ4QdEy/n7Tt6/mxFncVj5hRGctb
        TYpaRDXAWK+4FwYb945qaGuecV77UN2WHvrTenDNfgSgvurGfJYIqEFlnIQx1k+D4haE/T
        FHefFLY2PuKODg8Pkf8HhSioxOR7VK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635938648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E4A9LwbWSrS822C4Vswjzc2ote0q6H+7MR5LublF8dA=;
        b=9cw2Odc4aGglhxaAff4lQFC5iERUnH615q0jCqrmB5sLvzQ5vIBCizv8CYpfpdReyi7RSe
        ZDg9SrbCIuWP0uAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5931914060;
        Wed,  3 Nov 2021 11:24:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qFD5ElhxgmHyMQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 03 Nov 2021 11:24:08 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 3b547176;
        Wed, 3 Nov 2021 11:24:07 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 2/2] ceph: add a new metric to keep track of remote object copies
Date:   Wed,  3 Nov 2021 11:24:05 +0000
Message-Id: <20211103112405.8733-3-lhenriques@suse.de>
In-Reply-To: <20211103112405.8733-1-lhenriques@suse.de>
References: <20211103112405.8733-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patch adds latency and size metrics for remote object copies
operations ("copyfrom").  For now, these metrics will be available on the
client only, they won't be sent to the MDS.

Cc: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/debugfs.c | 3 ++-
 fs/ceph/file.c    | 4 ++++
 fs/ceph/metric.h  | 8 ++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index e04ae1098431..3cf7c9c1085b 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -167,7 +167,8 @@ static int metrics_file_show(struct seq_file *s, void *p)
 static const char * const metric_str[] = {
 	"read",
 	"write",
-	"metadata"
+	"metadata",
+	"copyfrom"
 };
 static int metrics_latency_show(struct seq_file *s, void *p)
 {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a39703b8ef99..c61d71cef55d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2259,6 +2259,10 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 			ret = PTR_ERR(req);
 		else {
 			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+			ceph_update_copyfrom_metrics(&fsc->mdsc->metric,
+						     req->r_start_latency,
+						     req->r_end_latency,
+						     object_size, ret);
 			ceph_osdc_put_request(req);
 		}
 		if (ret) {
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index e67fc997760b..bb45608181e7 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -129,6 +129,7 @@ enum metric_type {
 	METRIC_READ,
 	METRIC_WRITE,
 	METRIC_METADATA,
+	METRIC_COPYFROM,
 	METRIC_MAX
 };
 
@@ -214,4 +215,11 @@ static inline void ceph_update_metadata_metrics(struct ceph_client_metric *m,
 	ceph_update_metrics(&m->metric[METRIC_METADATA],
 			    r_start, r_end, 0, rc);
 }
+static inline void ceph_update_copyfrom_metrics(struct ceph_client_metric *m,
+						ktime_t r_start, ktime_t r_end,
+						unsigned int size, int rc)
+{
+	ceph_update_metrics(&m->metric[METRIC_COPYFROM],
+			    r_start, r_end, size, rc);
+}
 #endif /* _FS_CEPH_MDS_METRIC_H */
