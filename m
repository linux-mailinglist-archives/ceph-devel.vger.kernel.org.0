Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DB43FF3E9
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 21:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243515AbhIBTOW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 15:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347294AbhIBTOT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 15:14:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827FC610CF;
        Thu,  2 Sep 2021 19:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630610000;
        bh=X0EpprjCgVTbJnj25ysZWuzuDlt+CWao1B2tFFuR7mc=;
        h=From:To:Cc:Subject:Date:From;
        b=WP4UtzKkafxHYKOgT+zGAHDY81K4xnOlHFsZSn972bq0PW8EiYP/TC2PK9ggoqw0F
         P1BvJDk5D0qHFPQQ+tx+rUKIPRVYXHMi9GBdvksppxXUTet3ih8WZj4xyv9Dfn2e2K
         D9HMUJGQ4hH7L166nP5YBVtDP1qaoaCOoraiycJWUGYVKER+2+HiueDeifGYsnHKuK
         FjqOpcZuvOGFBK9XyqVdyPwsk0+teoo2/ltCQBnWccv1n8dqXMs7Tse/UCrUl5tVMB
         /AHATXJ2RderSUu0AUHFArzSeH+8m/HNqqUetOmWhxRjKoTsvkg+i1Jl0g3deIErb5
         FsUkbYIv9Dmqg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: drop the mdsc_get_session/put_session dout() messages
Date:   Thu,  2 Sep 2021 15:13:19 -0400
Message-Id: <20210902191319.47145-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

These are very chatty, racy, and not terribly useful. Just remove them.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8d5bffb4e84f..9ff3c7ade509 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -653,14 +653,9 @@ const char *ceph_session_state_name(int s)
 
 struct ceph_mds_session *ceph_get_mds_session(struct ceph_mds_session *s)
 {
-	if (refcount_inc_not_zero(&s->s_ref)) {
-		dout("mdsc get_session %p %d -> %d\n", s,
-		     refcount_read(&s->s_ref)-1, refcount_read(&s->s_ref));
+	if (refcount_inc_not_zero(&s->s_ref))
 		return s;
-	} else {
-		dout("mdsc get_session %p 0 -- FAIL\n", s);
-		return NULL;
-	}
+	return NULL;
 }
 
 void ceph_put_mds_session(struct ceph_mds_session *s)
@@ -668,8 +663,6 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	if (IS_ERR_OR_NULL(s))
 		return;
 
-	dout("mdsc put_session %p %d -> %d\n", s,
-	     refcount_read(&s->s_ref), refcount_read(&s->s_ref)-1);
 	if (refcount_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
 			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
-- 
2.31.1

