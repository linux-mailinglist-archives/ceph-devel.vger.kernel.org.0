Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B20545B21
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 06:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbiFJEcA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 00:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiFJEb7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 00:31:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C0524B1C7
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 21:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654835515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9KwGWk7CcVXQ1tfcNI+bcg8QZigY72nsZurU5DgWyg=;
        b=HLIRS1Dw8VxSqcQSrH/s8myYDVS5RP55nJ48QBhu00wXq6BuP3ZxTnY/FjBWoEb++p8U4L
        9bseoLlI7CFJOteQ1rH6E2YVRRv7eLZUN14DC8gmTrvozH4oIINULdwHiLSLTBgVpv4Ct5
        FW9jHQDPAK4bNyRXqZehLbXixAanPe4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-UGXzGK8RNbSCFGVoIby2XQ-1; Fri, 10 Jun 2022 00:31:52 -0400
X-MC-Unique: UGXzGK8RNbSCFGVoIby2XQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E548785A580;
        Fri, 10 Jun 2022 04:31:51 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4700E404E4BD;
        Fri, 10 Jun 2022 04:31:50 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: make change_auth_cap_ses a global symbol
Date:   Fri, 10 Jun 2022 12:31:39 +0800
Message-Id: <20220610043140.642501-2-xiubli@redhat.com>
In-Reply-To: <20220610043140.642501-1-xiubli@redhat.com>
References: <20220610043140.642501-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  | 4 ++--
 fs/ceph/super.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5ecfff4b37c9..fb0f0669bdde 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -602,8 +602,8 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
  * @ci: inode to be moved
  * @session: new auth caps session
  */
-static void change_auth_cap_ses(struct ceph_inode_info *ci,
-				struct ceph_mds_session *session)
+void change_auth_cap_ses(struct ceph_inode_info *ci,
+			 struct ceph_mds_session *session)
 {
 	lockdep_assert_held(&ci->i_ceph_lock);
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c5e8665d0586..3bdd60a3e680 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -774,6 +774,8 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
 extern void ceph_reservation_status(struct ceph_fs_client *client,
 				    int *total, int *avail, int *used,
 				    int *reserved, int *min);
+extern void change_auth_cap_ses(struct ceph_inode_info *ci,
+				struct ceph_mds_session *session);
 
 
 
-- 
2.36.0.rc1

