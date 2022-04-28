Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F44513360
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 14:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346041AbiD1MQn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 08:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345829AbiD1MQm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 08:16:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEA90AD11B
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 05:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651148006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=isJuH/WI47gnd/etwCaBE0Ldyl+QLrcjljcx3/2JO2Q=;
        b=cRD5DWq/DlSBn3AuB39lN0KknyzkHUMl1iLBzUFik5x5UWVXD80NprcyX2eB7f7+r5i4Pz
        LnvUTIti0IamTpBG5wmdWp0kvcLEwYvG6LpNuFJQjdkiZH2VsfctxZXb7yLF2QLjvbYRhu
        CHsWA5tfnAIHhdsF40GloR14HqD5pdE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-6ePrdlZjMxOAd-GOkSSoxQ-1; Thu, 28 Apr 2022 08:13:23 -0400
X-MC-Unique: 6ePrdlZjMxOAd-GOkSSoxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC45F185A79C;
        Thu, 28 Apr 2022 12:13:22 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40557414A7EA;
        Thu, 28 Apr 2022 12:13:21 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: don't retain the caps if they're being revoked and not used
Date:   Thu, 28 Apr 2022 20:13:18 +0800
Message-Id: <20220428121318.43125-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For example if the Frwcb caps are being revoked, but only the Fr
caps is still being used then the kclient will skip releasing them
all. But in next turn if the Fr caps is ready to be released the
Fw caps maybe just being used again. So in corner case, such as
heavy load IOs, the revocation maybe stuck for a long time.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 0c0c8f5ae3b3..7eb5238941fc 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 
 	/* The ones we currently want to retain (may be adjusted below) */
 	retain = file_wanted | used | CEPH_CAP_PIN;
+
+	/*
+	 * Do not retain the capabilities if they are under revoking
+	 * but not used, this could help speed up the revoking.
+	 */
+	retain &= ~((revoking & retain) & ~used);
+
 	if (!mdsc->stopping && inode->i_nlink > 0) {
 		if (file_wanted) {
 			retain |= CEPH_CAP_ANY;       /* be greedy */
-- 
2.36.0.rc1

