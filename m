Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B376EB7D
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Aug 2023 16:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbjHCOBC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Aug 2023 10:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbjHCOAm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Aug 2023 10:00:42 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042181707
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:00:20 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id B9F8B413E8
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691071216;
        bh=StxqveXF5moq9iJU4D0IjENKfN6jaIfCw60woBc2a1E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=hUAwZ/oiS9GHVg2erBTvteYPCpHdUDA5uHRI7kYGHflwdOFk4uV8EzHDrzCka3LC/
         58T+e4/eqLYdtvcnzqIoKAb5iALD9mQQTYafzoMgAzVsrFR/s5i536evBRcj1A9Wv8
         KGQPvVOKXi1dcaOGcWqiLliT1L4v42Xai4QF59SOm/Dus+ZbzYlpN4d8WPqMstukqS
         q8Ze1c5BBwsMR7HNp66DcFMG3u5ypodARZc93ebm82RzDjjSSqrr/Z3/hhzDKPmBSb
         9kaxVTNJxAi9Lz/S7bAO+zSUigHp8LseDYB3M+/H2OfCdGC8WzIj4cLuN2aZZUR+8Q
         UWDb0Ksh/fOVA==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-52291e49dbcso696191a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 03 Aug 2023 07:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071215; x=1691676015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=StxqveXF5moq9iJU4D0IjENKfN6jaIfCw60woBc2a1E=;
        b=FjYMTAfU5uEmCSMoo9vLEc2VJIOjrVk6OAFSIxTnC3oqiwAO0I76HRzY3AfT/pOC/v
         6yBVMRDJqTwjpTchclvzOLQ/NAOew2lF7Zs86ShMZnMIm3P/pUESDTLLvJ09MOSbS03V
         Dw5HpfTEHcUfuIOYmhIlQWGkXYKd9sOGyewvvrcJaSCMl/DEd3nMevyJInTrg5KJoPwY
         s78/EQ0wO8RQ3OcYF7bU6WJlGkPzeP7NMapR9jBNDR2C78zBxL5Emi0kEndCfVi9EfCL
         zzb3JTZPTPqklJGbsrzJ8QNAW8h3wNvUyIFBaPQ5ZufepfybWWNnuXwylfm2CAqtOTsq
         pI4Q==
X-Gm-Message-State: ABy/qLawDwoyzVYjx1suKePteD844jePU2NrN9chdA7FcfBWdVXLvqV7
        bucA8VOHiX5UkIKCrne21hiW/GajNvgfujlZLrsY4scsn4/EoDfjYAFX/+OAvnYNJNWklxNYotW
        CaRUpnrYF7oVlhsffHQvCQ7NfunIz8L2Lj634Kmg=
X-Received: by 2002:aa7:de14:0:b0:519:6a6a:7659 with SMTP id h20-20020aa7de14000000b005196a6a7659mr8931906edv.18.1691071214979;
        Thu, 03 Aug 2023 07:00:14 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG5paflJLz4JBRbHPhL+2+ULYp98vUnpGsRBpJboWm8CHBV4DSIx5ONfbc9tYUeWfPNtNGOIA==
X-Received: by 2002:aa7:de14:0:b0:519:6a6a:7659 with SMTP id h20-20020aa7de14000000b005196a6a7659mr8931880edv.18.1691071214671;
        Thu, 03 Aug 2023 07:00:14 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id bc21-20020a056402205500b0052229882fb0sm10114822edb.71.2023.08.03.07.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:14 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 02/12] ceph: stash idmapping in mdsc request
Date:   Thu,  3 Aug 2023 15:59:45 +0200
Message-Id: <20230803135955.230449-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

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
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- don't call mnt_idmap_get(..) in __register_request
---
 fs/ceph/mds_client.c | 5 +++++
 fs/ceph/mds_client.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9aae39289b43..8829f55103da 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/mnt_idmapping.h>
 
 #include "super.h"
 #include "crypto.h"
@@ -1121,6 +1122,8 @@ void ceph_mdsc_release_request(struct kref *kref)
 	kfree(req->r_path1);
 	kfree(req->r_path2);
 	put_cred(req->r_cred);
+	if (req->r_mnt_idmap)
+		mnt_idmap_put(req->r_mnt_idmap);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	kfree(req->r_fscrypt_auth);
@@ -1180,6 +1183,8 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	insert_request(&mdsc->request_tree, req);
 
 	req->r_cred = get_current_cred();
+	if (!req->r_mnt_idmap)
+		req->r_mnt_idmap = &nop_mnt_idmap;
 
 	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
 		mdsc->oldest_tid = req->r_tid;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 717a7399bacb..e3bbf3ba8ee8 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -300,6 +300,7 @@ struct ceph_mds_request {
 	int r_fmode;        /* file mode, if expecting cap */
 	int r_request_release_offset;
 	const struct cred *r_cred;
+	struct mnt_idmap *r_mnt_idmap;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
-- 
2.34.1

