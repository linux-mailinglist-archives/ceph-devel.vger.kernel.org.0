Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C94727584
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 05:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbjFHDRQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 23:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFHDRO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 23:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1822688
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 20:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686194186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oyN0DeILEOGvXC3ICtsug4LB95yYZDRF5H5VFo7WTh8=;
        b=Sm0x0qG6KLcqw6/LNyzJx2lCMHCx3XNqP27qJ2+OstVrC+xirelS/sANawAgLHMFOBjKYV
        ydQg1GADrXWGfInQ6PeMsD32kOg+6lxwOCptS2qts3wo05bpj26Lz2XApbJlwvfY9HPiZq
        BI9V4ZoMl1aImbYVJa5hGjYlO+2w9no=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-WqQOQ_z7NFi3iiXMhIk0ug-1; Wed, 07 Jun 2023 23:16:23 -0400
X-MC-Unique: WqQOQ_z7NFi3iiXMhIk0ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 140141C0513E;
        Thu,  8 Jun 2023 03:16:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-135.pek2.redhat.com [10.72.13.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 624E12166B26;
        Thu,  8 Jun 2023 03:16:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: print the client global id when blocklisting the sessions
Date:   Thu,  8 Jun 2023 11:13:59 +0800
Message-Id: <20230608031359.48134-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Multiple cephfs mounts on a host is increasingly common so disambiguating
messages like this is necessary and will make it easier to debug
issues.

URL: https://tracker.ceph.com/issues/61590
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0a70a2438cb2..c808270a2f5d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3978,7 +3978,9 @@ static void handle_session(struct ceph_mds_session *session,
 		/* version >= 5, flags   */
 		ceph_decode_32_safe(&p, end, flags, bad);
 		if (flags & CEPH_SESSION_BLOCKLISTED) {
-			pr_warn("mds%d session blocklisted\n", session->s_mds);
+			pr_warn("client.%lld mds%d session blocklisted\n",
+				mdsc->fsc->client->monc.auth->global_id,
+				session->s_mds);
 			blocklisted = true;
 		}
 	}
-- 
2.40.1

