Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45858A57B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Aug 2022 06:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbiHEEhU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Aug 2022 00:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiHEEhT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Aug 2022 00:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 294E170E63
        for <ceph-devel@vger.kernel.org>; Thu,  4 Aug 2022 21:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659674237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zifIoJxFy1aP1LpzVxFYcPp5D3KkfJ3+v8CI2n0Rbns=;
        b=XGAY2Bppvc2ipJUdMvT81QSTkDVaHUAvREGYyXNavt7hToZc8A4FgQgEms9ViH6dj53mdC
        Ueb0BflPcyLz2rzrtOIaVvZFs6ofjrwBJBMlTAdr2YUasLbkEjgjSAn8w1uw7fmF6oTZcB
        0HYTS/BOQAZlpkTxE24Gn2O28REJ4hc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-vuxQJbQ1M4CY7phhpsak9w-1; Fri, 05 Aug 2022 00:37:16 -0400
X-MC-Unique: vuxQJbQ1M4CY7phhpsak9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B02141C04B4C
        for <ceph-devel@vger.kernel.org>; Fri,  5 Aug 2022 04:37:15 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77975C28125;
        Fri,  5 Aug 2022 04:37:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: wake up the waiters if any new caps comes
Date:   Fri,  5 Aug 2022 12:37:11 +0800
Message-Id: <20220805043711.306673-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When new caps comes we need to wake up the waiters and also when
revoking the caps, there also could be new caps comes.

https://tracker.ceph.com/issues/54044
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5a4e7e53015a..139d21b8fb49 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -755,6 +755,7 @@ void ceph_add_cap(struct inode *inode,
 	cap->issue_seq = seq;
 	cap->mseq = mseq;
 	cap->cap_gen = gen;
+	wake_up_all(&ci->i_cap_wq);
 }
 
 /*
@@ -3601,6 +3602,9 @@ static void handle_cap_grant(struct inode *inode,
 			check_caps = 1; /* check auth cap only */
 		else
 			check_caps = 2; /* check all caps */
+		/* If there is new caps, try to wake up the waiters */
+		if (~cap->issued & newcaps)
+			wake = true;
 		cap->issued = newcaps;
 		cap->implemented |= newcaps;
 	} else if (cap->issued == newcaps) {
-- 
2.36.0.rc1

