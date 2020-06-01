Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A0F1EAFDF
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jun 2020 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgFAT6k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 15:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgFAT6j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jun 2020 15:58:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F48C061A0E
        for <ceph-devel@vger.kernel.org>; Mon,  1 Jun 2020 12:58:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u13so697601wml.1
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jun 2020 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mozm5+Qn2jQellCDzvz0rjWbKVUgZJBYwUvfCMCVwo8=;
        b=Sox/sQt7jWe8TvB+6kNxSm3CnNkiDA1h5APAJDt/FEndqsvw1peLbgjm7WP03PlGly
         TWxSA0WJTVv4loeZvVqfpujBTk57ZM7ciTqukf4araO7OQCt655ybyw+F1BTMuFe4LBg
         jPRLtiir+FRLHlEe8aVwx+6dzpYbqeGG/HP9YqTewXBxkFlh86j8vgjOh24jK1nuf1Ym
         z/sxQM/ab9fgIpNnbczBrpjYD2fVzO/BZLMUaCTsjO1wGGEN6KS5GzJ3LF25VjbjRkef
         zORF3dHLBlhTSJ+WyDY19YRl149vpKXt40yX9IQ+jCgwafCo1I6an3OJTO+XrKABWRKn
         /WFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mozm5+Qn2jQellCDzvz0rjWbKVUgZJBYwUvfCMCVwo8=;
        b=SKt6oJFZC8QY7HnGxCUSpI6r4/BT1rBpiIYHMopSjP//xGCbRQQDVOPmfl3SY0biqA
         oicnC72gUDzyNak6LCSe4tGjcTgjCwQdBVIKGgTfoZyiXg2b9JjJnMcI7dRyxoKtS0w7
         imTeo3AF/9FHBmCWOkwMwZkGUOOXX/U2sZacJMoflP1uELzY4uTNAWpatSYmOvfG8sna
         lgkBTkPEs8cziHStlCRHiW6pNKxVe5apWqXVn+mAaeafCF5r3rmSHKt+XmEUoEv9ZHyo
         CdBeO3OXgrJDNG0IUz/OrSgHXqbZC7LvIffsLB/rG3pmzi4aeJQiWxB89UMLgab1FCPA
         l85Q==
X-Gm-Message-State: AOAM530gk8vQNCF7S9MHdWMuvcoNYUWYVNMsLvz8g0/1JJgc6s0dp9gx
        Jic466m3e7R9Nk0V0QJysn/f1K5ovi4=
X-Google-Smtp-Source: ABdhPJyeyKY2u3tvmMtgJDRp8AptOnoFfQZmCPKy3cBYcchKgPBnJPkmaeMSJ/QkL7YOFD04DomSJw==
X-Received: by 2002:a7b:cc71:: with SMTP id n17mr825902wmj.148.1591041517615;
        Mon, 01 Jun 2020 12:58:37 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id t189sm574008wma.4.2020.06.01.12.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 12:58:37 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jason Dillaman <jdillama@redhat.com>
Subject: [PATCH 2/2] rbd: compression_hint option
Date:   Mon,  1 Jun 2020 21:58:26 +0200
Message-Id: <20200601195826.17159-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200601195826.17159-1-idryomov@gmail.com>
References: <20200601195826.17159-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow hinting to bluestore if the data should/should not be compressed.
The default is to not hint (compression_hint=none).

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b1cd41e671d1..e02089d550a4 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -836,6 +836,7 @@ enum {
 	Opt_lock_timeout,
 	/* int args above */
 	Opt_pool_ns,
+	Opt_compression_hint,
 	/* string args above */
 	Opt_read_only,
 	Opt_read_write,
@@ -844,8 +845,23 @@ enum {
 	Opt_notrim,
 };
 
+enum {
+	Opt_compression_hint_none,
+	Opt_compression_hint_compressible,
+	Opt_compression_hint_incompressible,
+};
+
+static const struct constant_table rbd_param_compression_hint[] = {
+	{"none",		Opt_compression_hint_none},
+	{"compressible",	Opt_compression_hint_compressible},
+	{"incompressible",	Opt_compression_hint_incompressible},
+	{}
+};
+
 static const struct fs_parameter_spec rbd_parameters[] = {
 	fsparam_u32	("alloc_size",			Opt_alloc_size),
+	fsparam_enum	("compression_hint",		Opt_compression_hint,
+			 rbd_param_compression_hint),
 	fsparam_flag	("exclusive",			Opt_exclusive),
 	fsparam_flag	("lock_on_read",		Opt_lock_on_read),
 	fsparam_u32	("lock_timeout",		Opt_lock_timeout),
@@ -867,6 +883,8 @@ struct rbd_options {
 	bool	lock_on_read;
 	bool	exclusive;
 	bool	trim;
+
+	u32 alloc_hint_flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
 };
 
 #define RBD_QUEUE_DEPTH_DEFAULT	BLKDEV_MAX_RQ
@@ -2254,7 +2272,7 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
 		osd_req_op_alloc_hint_init(osd_req, which++,
 					   rbd_dev->layout.object_size,
 					   rbd_dev->layout.object_size,
-					   0);
+					   rbd_dev->opts->alloc_hint_flags);
 	}
 
 	if (rbd_obj_is_entire(obj_req))
@@ -6332,6 +6350,29 @@ static int rbd_parse_param(struct fs_parameter *param,
 		pctx->spec->pool_ns = param->string;
 		param->string = NULL;
 		break;
+	case Opt_compression_hint:
+		switch (result.uint_32) {
+		case Opt_compression_hint_none:
+			opt->alloc_hint_flags &=
+			    ~(CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE |
+			      CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE);
+			break;
+		case Opt_compression_hint_compressible:
+			opt->alloc_hint_flags |=
+			    CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE;
+			opt->alloc_hint_flags &=
+			    ~CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE;
+			break;
+		case Opt_compression_hint_incompressible:
+			opt->alloc_hint_flags |=
+			    CEPH_OSD_ALLOC_HINT_FLAG_INCOMPRESSIBLE;
+			opt->alloc_hint_flags &=
+			    ~CEPH_OSD_ALLOC_HINT_FLAG_COMPRESSIBLE;
+			break;
+		default:
+			BUG();
+		}
+		break;
 	case Opt_read_only:
 		opt->read_only = true;
 		break;
-- 
2.19.2

