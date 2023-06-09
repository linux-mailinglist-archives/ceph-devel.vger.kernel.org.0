Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80458729589
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 11:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbjFIJjL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 05:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbjFIJix (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 05:38:53 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51C63C24
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:33:28 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 375C73F36A
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303157;
        bh=Qh/WJ81ZpXRyl0gQ4ukcXvtFhi/qxOmZnI5fUrSNycI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=janVrMALn5r213g/rDnEkl1i3iMgdLxMc2L25qsX4ZuKCHX+wqow7EUfftZiks9mX
         iO9f0xKxWXD8HLgoWtQulAzDvGv34CgzQWQkNg9yezNgDcVAJHLip/5FXAo6qxUaTX
         XlVU/LIE9U+tN28eFS0aIl4ybQrR2b1unlShM1105f9yXYXtV0IKABMJJzDQ1O4m9l
         E1w4EJJXiw0TwKr0by3g+UEk74AbPJjwkt8FgSCZLm/gIopm1fPC6nVDTssrJ4I3QJ
         0eAdySVG0gwPpZSQqiFUdm0cliXKfyP76eWKRLYcoqPmdX0hYw8guQyCTZdYOfqqKh
         J5KEGbB/KwW0A==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5153b118ea0so1448937a12.0
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303157; x=1688895157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qh/WJ81ZpXRyl0gQ4ukcXvtFhi/qxOmZnI5fUrSNycI=;
        b=dKlAK8vL5hOcZRp14y80+Zb6c3jZa1tk4SbcqS2ap6EGsG7ZA3RVM4WGxCRmtKJS6H
         8mYa8Ruh0bgH5o+Nbhde0zdYmrpUQXihI1rdllKK1YdRZFTFhpttzt0whHI/J2t9tTXH
         x527vh6125jXGm+OOfTEvlbXocwuyjMBykweROCgMwyCeiGOy0V0VczFC6QYPph16qOB
         wUcj9T1SRAlaSEOJIUv1zLOwbHTm+WWcmgOK2SOVrdOCzrVjo0eROGRdkJk9bik/mdSK
         k5+srmskrjKWlO1rvrVPOT4A/zl9vPQcK/J6meo5y1dDp90uGRE8yPcbSzuELPpvaJ0C
         drCQ==
X-Gm-Message-State: AC+VfDyue5SNWojzQFAEr+0TgQtBhDxQrJ0WEHR9hVXs95bFdc6jdMpv
        zfMBSI7ypIKDvAb4+qobrToXVDjQWagjIWgy+1+tIwH8b6ibk+/yFf9siOJ4BznQ4BoKMTKt5Rm
        1zJGA3S/ptysV6/DCEpP1gNco43RzRD1Ah/TY09Q=
X-Received: by 2002:a17:906:ee83:b0:974:5480:171e with SMTP id wt3-20020a170906ee8300b009745480171emr1462450ejb.32.1686303156920;
        Fri, 09 Jun 2023 02:32:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4VQ7NQSOiIOTdYHqbG/vALAaZAqtr0peZI68CNDA6sXkaWXr8PTJSD5GsVy3Ejtu/h5mXQKw==
X-Received: by 2002:a17:906:ee83:b0:974:5480:171e with SMTP id wt3-20020a170906ee8300b009745480171emr1462432ejb.32.1686303156625;
        Fri, 09 Jun 2023 02:32:36 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:32:36 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/15] ceph: stash idmapping in mdsc request
Date:   Fri,  9 Jun 2023 11:31:13 +0200
Message-Id: <20230609093125.252186-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

When sending a mds request cephfs will send relevant data for the
requested operation. For creation requests the caller's fs{g,u}id is
used to set the ownership of the newly created filesystem object. For
setattr requests the caller can pass in arbitrary {g,u}id values to
which the relevant filesystem object is supposed to be changed.

If the caller is performing the relevant operation via an idmapped mount
cephfs simply needs to take the idmapping into account when it sends the
relevant mds request.

In order to support idmapped mounts for cephfs we stash the idmapping
whenever they are relevant for the operation for the duration of the
request. Since mds requests can be queued and performed asynchronously
we make sure to keep the idmapping around and release it once the
request has finished.

In follow-up patches we will use this to send correct ownership
information over the wire. This patch just adds the basic infrastructure
to keep the idmapping around. The actual conversion patches are all
fairly minimal.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- don't call mnt_idmap_get(..) in __register_request
---
 fs/ceph/mds_client.c | 5 +++++
 fs/ceph/mds_client.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c808270a2f5d..083d0329f62d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/mnt_idmapping.h>
 
 #include "super.h"
 #include "crypto.h"
@@ -1115,6 +1116,8 @@ void ceph_mdsc_release_request(struct kref *kref)
 	kfree(req->r_path1);
 	kfree(req->r_path2);
 	put_cred(req->r_cred);
+	if (req->r_mnt_idmap)
+		mnt_idmap_put(req->r_mnt_idmap);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	kfree(req->r_fscrypt_auth);
@@ -1173,6 +1176,8 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	insert_request(&mdsc->request_tree, req);
 
 	req->r_cred = get_current_cred();
+	if (!req->r_mnt_idmap)
+		req->r_mnt_idmap = &nop_mnt_idmap;
 
 	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
 		mdsc->oldest_tid = req->r_tid;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 351d92f7fc4f..89799becec90 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -298,6 +298,7 @@ struct ceph_mds_request {
 	int r_fmode;        /* file mode, if expecting cap */
 	int r_request_release_offset;
 	const struct cred *r_cred;
+	struct mnt_idmap *r_mnt_idmap;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
-- 
2.34.1

