Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869F93BF704
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 10:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhGHIpn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 04:45:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231345AbhGHIpm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 04:45:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625733780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S4cU/xx0zjvXuWehqCcQBwCFvuxaw5ZEbgauSSASq8w=;
        b=JjJLQ8Sn3TPnPLiXi9LGk9SkyWWz46PFtSCXqq0havw/pNJG6K2mu21yPWSe2oOSMaehmk
        2WThNTXFO5NlUgqcAkvQh3wQDDgnSAFwlF/ZX3DahO1VABk8RjmYrE4yFh4FuJvDEf7RNL
        Zs8AZZ9SZCWpzBDrjr/uEUSoLG5F/GU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-MEvZJHVHMrqP03_w4NIdtw-1; Thu, 08 Jul 2021 04:42:59 -0400
X-MC-Unique: MEvZJHVHMrqP03_w4NIdtw-1
Received: by mail-pg1-f197.google.com with SMTP id p2-20020a63e6420000b02902271082c631so3832835pgj.5
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jul 2021 01:42:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4cU/xx0zjvXuWehqCcQBwCFvuxaw5ZEbgauSSASq8w=;
        b=dC4/a+uPVcbe+vfLItARuGtB2yPPmTKSu1VQtB26AB7oRHiofiadvrVMBgys5vCgH1
         7k7F2+TZBrVm0wcak3PxS6PbBNqhdBnp+C03hNvNytpHmnqvdFxwUMkzPqTQeHykrhgR
         J2ZeIpJvRc1CrBi17h1NMed5QbJYGpHBam8eD6jT6o0ackeAsxQJUg+teCrZFI3dkgxp
         JsG2oTRv9wwnjT+T1Wlf4kRUJBPC0yxJUro5vOk/w+tII4RTBUmSGO6Qr2BkHURQn9+c
         a7YjPfe28lxoGxlSr+dTHaOr+RUBawQ7bxBh4XUXD5JUQB0kZzJJxlxe3RqanS/OIQWp
         jY0A==
X-Gm-Message-State: AOAM532qxBmYeBf0xXLJtfIO9iTOIGVQts3rSKd5EjIMd8VCPxj9iJ+I
        m03XNrfrZQb+Aobw7Iq/4Vmm3XriLJvujqd2OYPoy91QZ1R+FzW0EYEYC27plIBwO1/0vwld9iQ
        HbCRdywBW2JLbNz3qseiQbg==
X-Received: by 2002:a17:90a:d50f:: with SMTP id t15mr1223043pju.160.1625733778667;
        Thu, 08 Jul 2021 01:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxI+0SBwSpyIfxG3vsqTyLq1RGBvAIZ8Jg5jykD0iMp5keZVKvlu9C6MB6OCM6w92Y9jcEwA==
X-Received: by 2002:a17:90a:d50f:: with SMTP id t15mr1223028pju.160.1625733778513;
        Thu, 08 Jul 2021 01:42:58 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.223.150])
        by smtp.gmail.com with ESMTPSA id r14sm2154588pgm.28.2021.07.08.01.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 01:42:58 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 2/5] ceph: rename parse_fsid() to ceph_parse_fsid() and export
Date:   Thu,  8 Jul 2021 14:12:44 +0530
Message-Id: <20210708084247.182953-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210708084247.182953-1-vshankar@redhat.com>
References: <20210708084247.182953-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

... as it is too generic. also, use __func__ when logging
rather than hardcoding the function name.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 include/linux/ceph/libceph.h | 1 +
 net/ceph/ceph_common.c       | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index e50dba429819..37ab639b5012 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -298,6 +298,7 @@ extern bool libceph_compatible(void *data);
 extern const char *ceph_msg_type_name(int type);
 extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
 extern void *ceph_kvmalloc(size_t size, gfp_t flags);
+extern int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid);
 
 struct fs_parameter;
 struct fc_log;
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 0f74ceeddf48..31cbe671121c 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -217,14 +217,14 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
 	return p;
 }
 
-static int parse_fsid(const char *str, struct ceph_fsid *fsid)
+int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
 	int i = 0;
 	char tmp[3];
 	int err = -EINVAL;
 	int d;
 
-	dout("parse_fsid '%s'\n", str);
+	dout("%s '%s'\n", __func__, str);
 	tmp[2] = 0;
 	while (*str && i < 16) {
 		if (ispunct(*str)) {
@@ -244,9 +244,10 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 
 	if (i == 16)
 		err = 0;
-	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
+	dout("%s ret %d got fsid %pU\n", __func__, err, fsid);
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

