Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD97C4B6BF6
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 13:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbiBOMXs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 07:23:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236233AbiBOMXr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 07:23:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21750107AAB
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644927816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HQ+xivxB43tXo4RERtGauY3YUoCYvZW5H6WAxoSHvXU=;
        b=crcu2mjoengkWMk2Kg5bvq+veu2cKBWpQ8OL+g9bOdUxcnPVvqEi71eL0s/tZrVMh+WFC2
        dBedGb828j3kMGVBMhAQdf+4V9TBlMRbxglaicARCZK2OOv9N07iFJOwNxTcK2fxg60zEO
        yvae8hvX1BnEXc3SV+N1eJGQD3ZhRbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-5J2XDh1oPDSiS2Xy13hrwQ-1; Tue, 15 Feb 2022 07:23:35 -0500
X-MC-Unique: 5J2XDh1oPDSiS2Xy13hrwQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0666B2F26;
        Tue, 15 Feb 2022 12:23:34 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FF01101F6CF;
        Tue, 15 Feb 2022 12:23:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/3] ceph: do no update snapshot context when there is no new snapshot
Date:   Tue, 15 Feb 2022 20:23:16 +0800
Message-Id: <20220215122316.7625-4-xiubli@redhat.com>
In-Reply-To: <20220215122316.7625-1-xiubli@redhat.com>
References: <20220215122316.7625-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

No need to update snapshot context when any of the following two
cases happens:
1: if my context seq matches realm's seq and realm has no parent.
2: if my context seq equals or is larger than my parent's, this
   works because we rebuild_snap_realms() works _downward_ in
   hierarchy after each update.

This fix will avoid those inodes which accidently calling
ceph_queue_cap_snap() and make no sense, for exmaple:

There have 6 directories like:

/dir_X1/dir_X2/dir_X3/
/dir_Y1/dir_Y2/dir_Y3/

Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then
make a root snapshot under /.snap/root_snap. And every time when
we make snapshots under /dir_Y1/..., the kclient will always try
to rebuild the snap context for snap_X2 realm and finally will
always try to queue cap snaps for dir_Y2 and dir_Y3, which makes
no sense.

That's because the snap_X2's seq is 2 and root_snap's seq is 3.
So when creating a new snapshot under /dir_Y1/... the new seq
will be 4, and then the mds will send kclient a snapshot backtrace
in _downward_ in hierarchy: seqs 4, 3. Then in ceph_update_snap_trace()
it will always rebuild the from the last realm, that's the root_snap.
So later when rebuilding the snap context it will always rebuild
the snap_X2 realm and then try to queue cap snaps for all the inodes
related in snap_X2 realm, and we are seeing the logs like:

"ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"

URL: https://tracker.ceph.com/issues/44100
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index d075d3ce5f6d..1f24a5de81e7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -341,14 +341,16 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 		num += parent->cached_context->num_snaps;
 	}
 
-	/* do i actually need to update?  not if my context seq
-	   matches realm seq, and my parents' does to.  (this works
-	   because we rebuild_snap_realms() works _downward_ in
-	   hierarchy after each update.) */
+	/* do i actually need to update? No need when any of the following
+	 * two cases:
+	 * #1: if my context seq matches realm's seq and realm has no parent.
+	 * #2: if my context seq equals or is larger than my parent's, this
+	 *     works because we rebuild_snap_realms() works _downward_ in
+	 *     hierarchy after each update.
+	 */
 	if (realm->cached_context &&
-	    realm->cached_context->seq == realm->seq &&
-	    (!parent ||
-	     realm->cached_context->seq >= parent->cached_context->seq)) {
+	    ((realm->cached_context->seq == realm->seq && !parent) ||
+	     (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
 		dout("build_snap_context %llx %p: %p seq %lld (%u snaps)"
 		     " (unchanged)\n",
 		     realm->ino, realm, realm->cached_context,
-- 
2.27.0

