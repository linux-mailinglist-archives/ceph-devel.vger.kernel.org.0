Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB888504AAC
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 03:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbiDRBrs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 17 Apr 2022 21:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiDRBrr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 17 Apr 2022 21:47:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78B93767D
        for <ceph-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650246296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=48hs6o008ph38TQgPNQ2Qkbh1a9M5Powes8oc0MF0jU=;
        b=Bp6dPcTQPTPkX1xrAPKVZOP7hzzBQQM5ObW2olCU5oaer4eNOIWeWlsC7DfSlpfRONK9r1
        F+QWdIjVCX0r/PdeIxayJz5CPLfux3co6oNiPKe4xWsNlhlBWsTdn3p606mSPBwGoxgBKz
        BjXeFlKzi6l7yH4wefpsbvO+1zX/89I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-VGqMG8xtMY-xl2_cNFG4Eg-1; Sun, 17 Apr 2022 21:44:53 -0400
X-MC-Unique: VGqMG8xtMY-xl2_cNFG4Eg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DBB63C01D80;
        Mon, 18 Apr 2022 01:44:53 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 736F0111C4A1;
        Mon, 18 Apr 2022 01:44:52 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fix possible NULL pointer dereference for req->r_session
Date:   Mon, 18 Apr 2022 09:44:40 +0800
Message-Id: <20220418014440.573533-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The request will be inserted into the ci->i_unsafe_dirops before
assigning the req->r_session, so it's possible that we will hit
NULL pointer dereference bug here.

URL: https://tracker.ceph.com/issues/55327
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 69af17df59be..c70fd747c914 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2333,6 +2333,8 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
@@ -2353,6 +2355,8 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
+				if (!s)
+					continue;
 				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
-- 
2.36.0.rc1

