Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFD649BDB4
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 22:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiAYVIz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 16:08:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbiAYVIp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jan 2022 16:08:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 425586179E
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 21:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B48C340E0;
        Tue, 25 Jan 2022 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643144924;
        bh=w0vq4YB7f61GzVNjElzWuB/3sOthPw9ChMLjfNajtdE=;
        h=From:To:Cc:Subject:Date:From;
        b=hW8hzx5Sct5mn6uV/VR8pxh7r5HQ+Iy78OjG/d7kNOh9aoZLXZ2J8py4qAh9/nKAi
         9bpuTQX0OHoHEOzIJxWVHVOD7sFDglHAprEfVHpMHZ9Zxv1X4zMloZqgLBSAJUbx/J
         AC9c+1WUmzaTlxS4BjlwtEnuBhsJwvr4/DjhO9n1QskS3s4RsanAwXGH6j48WeH5QH
         v6AuuXyYmZTbEmmbNjFCC1csvqebm1HCB0mkrGuCLueMPNxfW4AYH6II2AxMl9vcFs
         AgbpK9qCoPKzidT3T8lvODRCFRSfOupch0x+DmlMaaCgQO6jfNDSwmUQ5dCMSlj+9Q
         jmUdfjng86uog==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: properly put ceph_string reference after async create attempt
Date:   Tue, 25 Jan 2022 16:08:42 -0500
Message-Id: <20220125210842.114067-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The reference acquired by try_prep_async_create is currently leaked.
Ensure we put it.

Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ea1e9ac6c465..cbe4d5a5cde5 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -766,8 +766,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 				restore_deleg_ino(dir, req->r_deleg_ino);
 				ceph_mdsc_put_request(req);
 				try_async = false;
+				ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 				goto retry;
 			}
+			ceph_put_string(rcu_dereference_raw(lo.pool_ns));
 			goto out_req;
 		}
 	}
-- 
2.34.1

