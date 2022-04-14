Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A64E5005A3
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Apr 2022 07:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiDNFqD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Apr 2022 01:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiDNFqD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Apr 2022 01:46:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE38349F0A
        for <ceph-devel@vger.kernel.org>; Wed, 13 Apr 2022 22:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649915018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=adBYNiofK6H6nKjsEB57TrQzmk/JV8QiRaDMMGegPRE=;
        b=LghotsQ2GXULF1IFOEMkRKte+/RlsEDOEV6+Rp1CI8nnlwSggC0aVOLOD9NSO3HLyiEsii
        IMds7NxwcqS16BG12/cakjdkCMD9dRHoUqgsuDMUEYYd7NtY9j7z6sxrDcI1syZUmUaV8P
        gQ7KRhiS9HvE0V6yii9kPKmPfEDsfyU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-Yb6OSukaMUuozt_9wOWsmg-1; Thu, 14 Apr 2022 01:43:34 -0400
X-MC-Unique: Yb6OSukaMUuozt_9wOWsmg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EE6F802803;
        Thu, 14 Apr 2022 05:43:34 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A44640F4940;
        Thu, 14 Apr 2022 05:43:33 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix possible NULL pointer dereference for req->r_session
Date:   Thu, 14 Apr 2022 13:43:24 +0800
Message-Id: <20220414054324.374694-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 fs/ceph/caps.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 69af17df59be..6a9bf58478c8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2333,7 +2333,7 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds >= max_sessions)) {
+				if (unlikely(s && s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
 						s = sessions[i];
@@ -2343,7 +2343,7 @@ static int unsafe_request_wait(struct inode *inode)
 					kfree(sessions);
 					goto retry;
 				}
-				if (!sessions[s->s_mds]) {
+				if (s && !sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
 				}
@@ -2353,7 +2353,7 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds >= max_sessions)) {
+				if (unlikely(s && s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					for (i = 0; i < max_sessions; i++) {
 						s = sessions[i];
@@ -2363,7 +2363,7 @@ static int unsafe_request_wait(struct inode *inode)
 					kfree(sessions);
 					goto retry;
 				}
-				if (!sessions[s->s_mds]) {
+				if (s && !sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
 				}
-- 
2.36.0.rc1

