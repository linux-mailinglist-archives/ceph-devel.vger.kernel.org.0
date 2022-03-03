Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CA44CB570
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 04:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiCCD15 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 22:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCCD1u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 22:27:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7887E11D784
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 19:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646278024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I5DlEHKjH984caIa16P08GW6K0nsTFnTjffRToq2y/U=;
        b=Rz2x/t/2MI3jdqG5xBXeZYwY00J+/OAdHe+tmMNnrwK0AxVBnzUD7jGoHOkaxIBKW+UVX6
        cXBrpEszmchesjDPpWF6xS13wwIhOoi13GeSItx8vZlpyz3KL/jo5ZqD0qyb/svYRYtfes
        EKXc2ovEQ6pQdEmCAYDI+SwVWwHQ6Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-9YWB9mLmNdG1kpz_c3heCg-1; Wed, 02 Mar 2022 22:27:01 -0500
X-MC-Unique: 9YWB9mLmNdG1kpz_c3heCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 737F5180FD71;
        Thu,  3 Mar 2022 03:27:00 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66546305B5;
        Thu,  3 Mar 2022 03:26:58 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 1/2] ceph: fail the request when failing to decode dentry names
Date:   Thu,  3 Mar 2022 11:26:39 +0800
Message-Id: <20220303032640.521999-2-xiubli@redhat.com>
In-Reply-To: <20220303032640.521999-1-xiubli@redhat.com>
References: <20220303032640.521999-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If we just skip the corrupt dentry names without setting the rde's
offset it will crash in ceph_readdir():

------------[ cut here ]------------
kernel BUG at fs/ceph/dir.c:537!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 16 PID: 21641 Comm: ls Tainted: G            E     5.17.0-rc2+ #92
Hardware name: Red Hat RHEV Hypervisor, BIOS 1.11.0-2.el7 04/01/2014

The corresponding code in ceph_readdir() is:

	BUG_ON(rde->offset < ctx->pos);

For now let's just fail the readdir request since it's nasty to
handle it and will do better error handling later in future.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c        | 13 +++++++------
 fs/ceph/inode.c      |  5 +++--
 fs/ceph/mds_client.c |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index bdd757690a11..4da59810b036 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -537,6 +537,13 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					    .ctext_len	= rde->altname_len };
 		u32 olen = oname.len;
 
+		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
+		if (err) {
+			pr_err("%s unable to decode %.*s, got %d\n", __func__,
+			       rde->name_len, rde->name, err);
+			goto out;
+		}
+
 		BUG_ON(rde->offset < ctx->pos);
 		BUG_ON(!rde->inode.in);
 
@@ -545,12 +552,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		     i, rinfo->dir_nr, ctx->pos,
 		     rde->name_len, rde->name, &rde->inode.in);
 
-		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
-		if (err) {
-			dout("Unable to decode %.*s. Skipping it.\n", rde->name_len, rde->name);
-			continue;
-		}
-
 		if (!dir_emit(ctx, oname.name, oname.len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d842ccb15667..e5a9838981ba 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1897,8 +1897,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 
 		err = ceph_fname_to_usr(&fname, &tname, &oname, &is_nokey);
 		if (err) {
-			dout("Unable to decode %.*s. Skipping it.", rde->name_len, rde->name);
-			continue;
+			pr_err("%s unable to decode %.*s, got %d\n", __func__,
+			       rde->name_len, rde->name, err);
+			goto out;
 		}
 
 		dname.name = oname.name;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 34fc7c226b0d..f0d2442187a3 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3449,7 +3449,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	if (err == 0) {
 		if (result == 0 && (req->r_op == CEPH_MDS_OP_READDIR ||
 				    req->r_op == CEPH_MDS_OP_LSSNAP))
-			ceph_readdir_prepopulate(req, req->r_session);
+			err = ceph_readdir_prepopulate(req, req->r_session);
 	}
 	current->journal_info = NULL;
 	mutex_unlock(&req->r_fill_mutex);
-- 
2.27.0

