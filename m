Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3079F445310
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 13:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhKDMec (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 08:34:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46904 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhKDMea (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 08:34:30 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 52EB2218B5;
        Thu,  4 Nov 2021 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636029111; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFu1JsOmKFFLdx4Ihzdr2P27n2Aykyh/NedcJP1JwjM=;
        b=HpXuaPQCNb5O0OpuBujykpA7OX/vUyqJVOFTTQu38ohEFYbXzqUGBiwfeln0X/8eJu2x7p
        OaooeVMTF27gTQSdk8g5tYxGq/F7J7PHXsyKlK3GP+npoZUBRaIDqecprMbAyiPp4L04tS
        fdXhpXVuuizGzuiY4Yl4tyxFAJSy9PM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636029111;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFu1JsOmKFFLdx4Ihzdr2P27n2Aykyh/NedcJP1JwjM=;
        b=Uyw3J5DuwGQu/bhqNakAUlLgAxmIDvIYluwfK+6qO50Qok/bsO5cxEg7XC8iPjppixaWRk
        W1Fv50KdCXJFZ/Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7F9C13BD4;
        Thu,  4 Nov 2021 12:31:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kNXlMbbSg2HLDQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 04 Nov 2021 12:31:50 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id c23833fa;
        Thu, 4 Nov 2021 12:31:49 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 2/2] ceph: add a new metric to keep track of remote object copies
Date:   Thu,  4 Nov 2021 12:31:47 +0000
Message-Id: <20211104123147.1632-3-lhenriques@suse.de>
In-Reply-To: <20211104123147.1632-1-lhenriques@suse.de>
References: <20211104123147.1632-1-lhenriques@suse.de>
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
index 6c77f203e7b5..220a41831b46 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2304,6 +2304,10 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 		else {
 			ceph_osdc_start_request(osdc, req, false);
 			ret = ceph_osdc_wait_request(osdc, req);
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
