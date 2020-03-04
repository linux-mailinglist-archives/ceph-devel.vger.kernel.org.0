Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93071179132
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 14:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388029AbgCDNWa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 08:22:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45763 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387776AbgCDNWa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 08:22:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583328149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xBgIkbekAZf2bUD0vkYrNyTxqB5YgBS5IIjXSaMUwzI=;
        b=BNrbhvlWtLyNYXYxeQlF66YpJJFLcsdyAzU4+XhrhUFNsqJcni5ElNaeGC1TXrry76W5bR
        BsWcjIOZQ/1CxXk3nM6rYcnrKzj5449JK+Myt1hHA3ME7dgfV93bT2Vi7TFTaU9xtfaZdc
        qJLzpMCW1mQ5YO4+G0DWumHIGG91/RQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-ef5Cf8nGPHe3FuzJxhKFrw-1; Wed, 04 Mar 2020 08:22:26 -0500
X-MC-Unique: ef5Cf8nGPHe3FuzJxhKFrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D8C0800D5B;
        Wed,  4 Mar 2020 13:22:25 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-198.pek2.redhat.com [10.72.12.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C69C2719A;
        Wed,  4 Mar 2020 13:22:22 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] mds: update dentry lease for async create
Date:   Wed,  4 Mar 2020 21:22:20 +0800
Message-Id: <20200304132220.41238-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Otherwise ceph_d_delete() may return 1 for the dentry, which makes
dput() prune the dentry and clear parent dir's complete flag.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 53321bf517c2..671b141aedfe 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -480,6 +480,9 @@ static int try_prep_async_create(struct inode *dir, s=
truct dentry *dentry,
 	if (d_in_lookup(dentry)) {
 		if (!__ceph_dir_is_complete(ci))
 			goto no_async;
+		spin_lock(&dentry->d_lock);
+		di->lease_shared_gen =3D atomic_read(&ci->i_shared_gen);
+		spin_unlock(&dentry->d_lock);
 	} else if (atomic_read(&ci->i_shared_gen) !=3D
 		   READ_ONCE(di->lease_shared_gen)) {
 		goto no_async;
--=20
2.21.1

