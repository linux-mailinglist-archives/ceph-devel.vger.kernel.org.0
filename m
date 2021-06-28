Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED1D3B5A29
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhF1H60 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 03:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232222AbhF1H6Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 03:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624866960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdZrPxC1yAJ+Swj56DMBkMu6GFqmDHMg6LUuLZPa3yU=;
        b=NbtQebqmF+U+Xa1z8IHw19NaThYVhKKfS9q5u1+VqNY3WiReNpqntc7IqMd7m+bgB2X3vj
        JxRTXw3WluFZXPriIg9WR9wpP6kHD66k7b/xdaGr7nRshs3446LCpylR4SA80zwEmNV0W8
        eTckvyp846E4uUaXJQ9c1mC056o1CCU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-qSN6wGGiN8S7nfRgoGku5g-1; Mon, 28 Jun 2021 03:55:58 -0400
X-MC-Unique: qSN6wGGiN8S7nfRgoGku5g-1
Received: by mail-pg1-f198.google.com with SMTP id y1-20020a655b410000b02902235977d00cso11630709pgr.21
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 00:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jdZrPxC1yAJ+Swj56DMBkMu6GFqmDHMg6LUuLZPa3yU=;
        b=QRLN7aQxb9/qGsY+HRungKwQYzxwlLB10wL9fP7m5jUCk8vP2KpUin2uKyInN8bpt8
         LlamDEpgM04RE8yKXxbiLuC2Zf9KqbHdCsuDeFVn1x0eCRbOjO2m9GEuS/JVgnoIkCCo
         VXiVEQngpAFgtIoD0N52/6J++G2wT2ocFjxLe4D9Bdh0KsVxNm0XDq8hb/jXUTRlCEEt
         zGqIyf47hJ/fihp78UulXTG8P+gOehClgqslJIU4LkPeS9PL0Pw+eiVcIbyv4yRJKXC5
         2xeWcZt5PvnmcwUyI17wyD/cI4hgN7muYydMkyalc29pw17gilSuLIeTeod3Q9keJIQ/
         35Hg==
X-Gm-Message-State: AOAM532k9L6aFpKqUoDoq5ImkL0exW7//C77Kz9i5hays2V5LXgetzbm
        KR7R/xGlgEXbW0cYteMoxXVvlK2zYtQ6zBSRm2Ob2/zMrHflh8UmVOh8EnOPryGYzbNIgKPULbC
        6clVTYNMMJBlOvleTb7YB9w==
X-Received: by 2002:a63:db43:: with SMTP id x3mr22115724pgi.383.1624866957600;
        Mon, 28 Jun 2021 00:55:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyWAiVegHL+XfFJ2t9T6cab1SiUFnn7dX3UzD6gQZpC65nYvNqaUwXqgkleqP5hLfcFd9TMg==
X-Received: by 2002:a63:db43:: with SMTP id x3mr22115709pgi.383.1624866957398;
        Mon, 28 Jun 2021 00:55:57 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.6])
        by smtp.gmail.com with ESMTPSA id g123sm8304959pfb.187.2021.06.28.00.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 00:55:56 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 2/4] ceph: validate cluster FSID for new device syntax
Date:   Mon, 28 Jun 2021 13:25:43 +0530
Message-Id: <20210628075545.702106-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210628075545.702106-1-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The new device syntax requires the cluster FSID as part
of the device string. Use this FSID to verify if it matches
the cluster FSID we get back from the monitor, failing the
mount on mismatch.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c              | 9 +++++++++
 fs/ceph/super.h              | 1 +
 include/linux/ceph/libceph.h | 1 +
 net/ceph/ceph_common.c       | 3 ++-
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 950a28ad9c59..84bc06e51680 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -266,6 +266,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	if (!fs_name_start)
 		return invalfc(fc, "missing file system name");
 
+	if (parse_fsid(fsid_start, &fsopt->fsid))
+		return invalfc(fc, "invalid fsid format");
+
 	++fs_name_start; /* start of file system name */
 	fsopt->mds_namespace = kstrndup(fs_name_start,
 					dev_name_end - fs_name_start, GFP_KERNEL);
@@ -748,6 +751,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 	}
 	opt = NULL; /* fsc->client now owns this */
 
+	/* help learn fsid */
+	if (fsopt->new_dev_syntax) {
+		ceph_check_fsid(fsc->client, &fsopt->fsid);
+		fsc->client->have_fsid = true;
+	}
+
 	fsc->client->extra_mon_dispatch = extra_mon_dispatch;
 	ceph_set_opt(fsc->client, ABORT_ON_FULL);
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 557348ff3203..cfd8ec25a9a8 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -100,6 +100,7 @@ struct ceph_mount_options {
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 	char *mon_addr;
+	struct ceph_fsid fsid;
 };
 
 struct ceph_fs_client {
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 409d8c29bc4f..24c1f4e9144d 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
 extern void *ceph_kvmalloc(size_t size, gfp_t flags);
+extern int parse_fsid(const char *str, struct ceph_fsid *fsid);
 
 struct fs_parameter;
 struct fc_log;
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 97d6ea763e32..db21734462a4 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
 	return p;
 }
 
-static int parse_fsid(const char *str, struct ceph_fsid *fsid)
+int parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
 	int i = 0;
 	char tmp[3];
@@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
 	return err;
 }
+EXPORT_SYMBOL(parse_fsid);
 
 /*
  * ceph options
-- 
2.27.0

