Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED9122A9E5
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jul 2020 09:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgGWHnk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 03:43:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44611 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725911AbgGWHnj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jul 2020 03:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595490218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=ZPuVZpcafSgfXlzvWDTEtspxGl2wbdXL22YX5r6wNYE=;
        b=VEFXgFxva4iqUjZBsp+v8INS9RfQEdB768ZvQ57s0mddlvWXGvkVOCzOQfewR7A6r3kr0K
        hXgBYUnSOXBQCmUMahqiuIMmPeY/nhMQbmkZAV+mMmul+IVOQS3uKr3rP1MMq/vbGmchzE
        xaoL+28EWhUlB+o9maVflphkNoKkdTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-ryzZ4oRFN8-sKZHyrEeTAw-1; Thu, 23 Jul 2020 03:43:33 -0400
X-MC-Unique: ryzZ4oRFN8-sKZHyrEeTAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E92D28015CE;
        Thu, 23 Jul 2020 07:43:32 +0000 (UTC)
Received: from lxbceph3.gsslab.pek2.redhat.com (unknown [10.72.47.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C056010013C0;
        Thu, 23 Jul 2020 07:43:29 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix use-after-free for fsc->mdsc
Date:   Thu, 23 Jul 2020 15:32:25 +0800
Message-Id: <20200723073225.340115-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the ceph_mdsc_init() fails, it will free the mdsc already.

Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
URL: https://tracker.ceph.com/issues/46684
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index af7221d1c610..590822fab767 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4453,7 +4453,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 		goto err_mdsc;
 	}
 
-	fsc->mdsc = mdsc;
 	init_completion(&mdsc->safe_umount_waiters);
 	init_waitqueue_head(&mdsc->session_close_wq);
 	INIT_LIST_HEAD(&mdsc->waiting_for_map);
@@ -4508,6 +4507,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 
 	strscpy(mdsc->nodename, utsname()->nodename,
 		sizeof(mdsc->nodename));
+
+	fsc->mdsc = mdsc;
 	return 0;
 
 err_mdsmap:
-- 
2.18.4

