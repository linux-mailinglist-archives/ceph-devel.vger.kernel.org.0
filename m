Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDAE18F952
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 17:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgCWQHQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 12:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbgCWQHQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 12:07:16 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CE872072E;
        Mon, 23 Mar 2020 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584979636;
        bh=Do2IXVrJnIM5yT/kKD1jy0YvlSBikWNaa6uR3PSF/BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kzwAT62I0hy2Ga/xQlqW4AP5mvGkEEz/fAB5hVBhQMrqHDLR8WsNaXMcK1s5hO++6
         YquYyp3s8FUYL8ELjl6KMHIZmS2tbBTm1hNFTs/4r84X5T/I+ZMtVqIvIDwCnWTRJq
         +a22y8Ga4krw7z+4JvU60OS5/F2D/ipd5VmUAM7Y=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 8/8] ceph: throw a warning if we destroy session with mutex still locked
Date:   Mon, 23 Mar 2020 12:07:08 -0400
Message-Id: <20200323160708.104152-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-1-jlayton@kernel.org>
References: <20200323160708.104152-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index acce04483471..9a8e7013aca1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -659,6 +659,7 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	if (refcount_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
 			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
+		WARN_ON(mutex_is_locked(&s->s_mutex));
 		xa_destroy(&s->s_delegated_inos);
 		kfree(s);
 	}
-- 
2.25.1

