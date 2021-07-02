Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B797C3B9C53
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 08:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhGBGvJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 02:51:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230064AbhGBGvJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 02:51:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0pBBfVLTrUAdeKDvmfdX/JCgV0KwE4CE4VePsI1zjs0=;
        b=h8AFXKHeu9z/FbvnrMDSWX7EcnhbhulVMHmTeJyNJN2aYW1Vh1Dp37wxiLNLqTjfiB6JMT
        0F8ANQ3Sn/jsRfgL2REvvmrYLRpXz2ztlk0dcZyuJ4iZnIZb90eF5M/np4HQtFgayN8Ib/
        jChniY1ryKVnYdRi+4DLumRBKIHTks4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-NOSK2IXuN7-sRUnnMGfZnw-1; Fri, 02 Jul 2021 02:48:36 -0400
X-MC-Unique: NOSK2IXuN7-sRUnnMGfZnw-1
Received: by mail-pl1-f199.google.com with SMTP id g9-20020a1709029349b0290128bcba6be7so4132785plp.18
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 23:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0pBBfVLTrUAdeKDvmfdX/JCgV0KwE4CE4VePsI1zjs0=;
        b=W6QO9ftqAtgZSX0lR/c/oAUdVbubGCXN0jT5yIEziiy6LwVFG4oklJGc9MZQY37zJ4
         UzgufumhfDUvNna6DXyyfvXTpp33/rxOVmWrUE5/CYi6Gr6szM7lj6hkfJWiubRSk4h5
         BtlGbU8X47ADfzZUeT/iQmPLw4Lq2NwIA85gLGS6yPbooN7c7OY624BUES5Oz+7HmNH2
         0IDGhQBhl1IEgsXzaxs98qNpQZ1eINuuDPhYzF7pZm6QeCsLs6CdwQLVINfjUddfhAD/
         P5l7bVqmPcGf0SasiAlpwY/oN3vVfgW6PZycF6wz2cNxr3XCt18GwbpWPOWSGfAfgfwW
         R2hw==
X-Gm-Message-State: AOAM532eVkbyrozejEtSP8JUHNqkepjk3L2Gwc+pzCRZphiHoMIURBpO
        wQWSdv3CGPW/7fTUhZUgnLaVW2uqY4UAKdhzl7j9krxU029dIF1hb9hb94/3c9GLKqzYlCsVFkV
        OInyPC3rbPLN+CA/cY36/9A==
X-Received: by 2002:a17:90a:ea8b:: with SMTP id h11mr14228321pjz.122.1625208515109;
        Thu, 01 Jul 2021 23:48:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEFLoxRDaHfCVkt4BBlaOYTLOaibLMIzpVS1GHrtVBUOdPyn4fkiJb1IBj2EYtewyEVsOyFQ==
X-Received: by 2002:a17:90a:ea8b:: with SMTP id h11mr14228307pjz.122.1625208514945;
        Thu, 01 Jul 2021 23:48:34 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id o34sm2394364pgm.6.2021.07.01.23.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 23:48:34 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 2/4] ceph: validate cluster FSID for new device syntax
Date:   Fri,  2 Jul 2021 12:18:19 +0530
Message-Id: <20210702064821.148063-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702064821.148063-1-vshankar@redhat.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The new device syntax requires the cluster FSID as part
of the device string. Use this FSID to verify if it matches
the cluster FSID we get back from the monitor, failing the
mount on mismatch.

Also, rename parse_fsid() to ceph_parse_fsid() as it is too
generic.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c              | 9 +++++++++
 fs/ceph/super.h              | 1 +
 include/linux/ceph/libceph.h | 1 +
 net/ceph/ceph_common.c       | 5 +++--
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 0b324e43c9f4..03e5f4bb2b6f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -268,6 +268,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	if (!fs_name_start)
 		return invalfc(fc, "missing file system name");
 
+	if (ceph_parse_fsid(fsid_start, &fsopt->fsid))
+		return invalfc(fc, "invalid fsid format");
+
 	++fs_name_start; /* start of file system name */
 	fsopt->mds_namespace = kstrndup(fs_name_start,
 					dev_name_end - fs_name_start, GFP_KERNEL);
@@ -750,6 +753,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
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
index 8f71184b7c85..ce5fb90a01a4 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -99,6 +99,7 @@ struct ceph_mount_options {
 	char *server_path;    /* default NULL (means "/") */
 	char *fscache_uniq;   /* default NULL */
 	char *mon_addr;
+	struct ceph_fsid fsid;
 };
 
 struct ceph_fs_client {
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 409d8c29bc4f..75d059b79d90 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
 extern void *ceph_kvmalloc(size_t size, gfp_t flags);
+extern int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid);
 
 struct fs_parameter;
 struct fc_log;
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 97d6ea763e32..da480757fcca 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
 	return p;
 }
 
-static int parse_fsid(const char *str, struct ceph_fsid *fsid)
+int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
 	int i = 0;
 	char tmp[3];
@@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
 	return err;
 }
+EXPORT_SYMBOL(ceph_parse_fsid);
 
 /*
  * ceph options
@@ -465,7 +466,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		break;
 
 	case Opt_fsid:
-		err = parse_fsid(param->string, &opt->fsid);
+		err = ceph_parse_fsid(param->string, &opt->fsid);
 		if (err) {
 			error_plog(&log, "Failed to parse fsid: %d", err);
 			return err;
-- 
2.27.0

