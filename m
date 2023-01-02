Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFD65AD99
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Jan 2023 08:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjABHLT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Jan 2023 02:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABHLR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Jan 2023 02:11:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E686F10F7
        for <ceph-devel@vger.kernel.org>; Sun,  1 Jan 2023 23:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672643429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+fYEj+jP4J5JrYmWfFoIs4oOdA28qx7XWxrFfLZJ9q4=;
        b=f4CgwjzFigYXtqHLrD7KTrcqcMB6eKns3d7OWWLbrD3n+AIB17F+jzSLL8sCPQeCqbTxGX
        BAhEqbVV3ygHCzmtlzd5+lSUaVeJU4y6GTMQsb052xe7K3tqRVBldO5RgRnH5p9y4bJvS/
        DiBcDXNrN3DYRLkqLW6ABQFtP5Uw6mY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-D2z5DyVhN7W0h7U7QT8E1g-1; Mon, 02 Jan 2023 02:10:26 -0500
X-MC-Unique: D2z5DyVhN7W0h7U7QT8E1g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 104731C068C1;
        Mon,  2 Jan 2023 07:10:26 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B9FB2026D4B;
        Mon,  2 Jan 2023 07:10:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: dump the msg when receiving a corrupt snap trace
Date:   Mon,  2 Jan 2023 15:10:01 +0800
Message-Id: <20230102071001.590386-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It's strange that we can see this when mounting, so we need to know
how the corrupted msg looks like.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1ad85af49b45..43a9a17ed9eb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3724,6 +3724,8 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 		if (err) {
 			up_write(&mdsc->snap_rwsem);
 			close_sessions = true;
+			if (err == -EIO)
+				ceph_msg_dump(msg);
 			goto out_err;
 		}
 		downgrade_write(&mdsc->snap_rwsem);
-- 
2.31.1

