Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758CC1796C6
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 18:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgCDRdV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 12:33:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25615 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729892AbgCDRdV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 12:33:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583343200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dB7fJoLO4GLGYW7Um4Bj76xNgiwQ3zAPCB1w20ltfh4=;
        b=Eq0DT6ZQ/cezWuMs2OsnQInpND2iFCbwqeUNdlkFqYFe7MPuM2Wc3LpltTD9M+gT7KT/2K
        HvxP8BbhILoWugtKSgDxvxvAPKi2JefA0iWZ+VdSZY5161IQvSwtSlg+85AUlKUZ070qT3
        sKgGyQ0Aa6109a+nUhiSbHo6Q/7yduc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-3ziffFGvNtmwHTxoAh12IQ-1; Wed, 04 Mar 2020 12:33:18 -0500
X-MC-Unique: 3ziffFGvNtmwHTxoAh12IQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF398109AED1;
        Wed,  4 Mar 2020 17:33:17 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-198.pek2.redhat.com [10.72.12.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6F015C1D4;
        Wed,  4 Mar 2020 17:33:15 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v4 6/6] ceph: check all mds' caps after page writeback
Date:   Thu,  5 Mar 2020 01:32:58 +0800
Message-Id: <20200304173258.48377-7-zyan@redhat.com>
In-Reply-To: <20200304173258.48377-1-zyan@redhat.com>
References: <20200304173258.48377-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If an inode has caps from multiple mds's, the following can happen:

- non-auth mds revokes Fsc. Fcb is used, so page writeback is queued.
- when writeback finishes, ceph_check_caps() is called with auth only
  flag. ceph_check_caps() invalidates pagecache, but skips checking any
  non-auth caps.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 0408749ced2d..5e9aecfa2f52 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3052,7 +3052,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_i=
nfo *ci, int nr,
 	spin_unlock(&ci->i_ceph_lock);
=20
 	if (last) {
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
+		ceph_check_caps(ci, 0, NULL);
 	} else if (flush_snaps) {
 		ceph_flush_snaps(ci, NULL);
 	}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c7ff9f7067f6..ee40ba7e0e77 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1984,7 +1984,7 @@ void __ceph_do_pending_vmtruncate(struct inode *ino=
de)
 	mutex_unlock(&ci->i_truncate_mutex);
=20
 	if (wrbuffer_refs =3D=3D 0)
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
+		ceph_check_caps(ci, 0, NULL);
=20
 	wake_up_all(&ci->i_cap_wq);
 }
--=20
2.21.1

