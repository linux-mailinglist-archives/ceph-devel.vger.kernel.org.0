Return-Path: <ceph-devel+bounces-2443-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 134D4A11453
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 23:45:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B46323A54CA
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 22:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B311D5142;
	Tue, 14 Jan 2025 22:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b="e+RWWSsg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lesviallon.fr (89-95-58-186.abo.bbox.fr [89.95.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEB22080D9
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.95.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736894729; cv=none; b=Py8d2mhtDtpF6bLJfsHGbnKhpWojlRYn9CmvZFAgwyGCujRmQMoaMXd6fj545sKzEI7thRRmQhZM0slL5N17QCMIvwn0kU0pEYaUGDs//k4TY8BSJOMCug9oe8i4cR6qI+yJH2eoU3dju3laWjuLMYn+h53LFgxKkh+Kilq9t58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736894729; c=relaxed/simple;
	bh=Sv5cNBKbpvJtKcK1A6CBSFaHwmqwQgNxDWHXyIlKUJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzwubDPtWdHx8eM83FMkxP7BYXIcWBDOKU6XZNSm7pLG90gef8Vh7ymF+g0NDqn8G4JGYV94pjDk1LmRXK1r6fn2wEERsw4HFq6YWS7W1snB5HIvxlhSzPF2TUfmFG+YaV9qXMGfRiHm9/wxHBuoLbY6gir3+AYnBtodlwC1jl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr; spf=pass smtp.mailfrom=lesviallon.fr; dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b=e+RWWSsg; arc=none smtp.client-ip=89.95.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lesviallon.fr
From: Antoine Viallon <antoine@lesviallon.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesviallon.fr;
	s=dkim; t=1736894723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oiuobzA3tvRXnHvL3JpEP8DVE3BQH8E+0+QqKk80vcM=;
	b=e+RWWSsgrfEHN/XfKBXyRlk3s9zaeMLrNLgXdgZG0zAhKdpjI83ik9PTn2FIsa0x3Fsd0C
	4zmX4UHzgaBJxGXlUKwNE+KK7FhPjukxd7EHnvHhaqUJSs2/jiw2UKLAApp8VcablxYa+K
	nWkA6GrKNFS6jtCCFzh0TEF1T1iJYR0=
Authentication-Results: lesviallon.fr;
	auth=pass smtp.mailfrom=antoine@lesviallon.fr
To: ceph-devel@vger.kernel.org,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Antoine Viallon <antoine@lesviallon.fr>
Subject: [PATCH v2] ceph: fix memory leak in ceph_mds_auth_match()
Date: Tue, 14 Jan 2025 23:45:14 +0100
Message-ID: <20250114224514.2399813-1-antoine@lesviallon.fr>
In-Reply-To: <20250114123806.2339159-1-antoine@lesviallon.fr>
References: <20250114123806.2339159-1-antoine@lesviallon.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: --

We now free the temporary target path substring allocation on every possible branch, instead of omitting the default branch.
In some cases, a memory leak occured, which could rapidly crash the system (depending on how many file accesses were attempted).

This was detected in production because it caused a continuous memory growth,
eventually triggering kernel OOM and completely hard-locking the kernel.

Relevant kmemleak stacktrace:

    unreferenced object 0xffff888131e69900 (size 128):
      comm "git", pid 66104, jiffies 4295435999
      hex dump (first 32 bytes):
        76 6f 6c 75 6d 65 73 2f 63 6f 6e 74 61 69 6e 65  volumes/containe
        72 73 2f 67 69 74 65 61 2f 67 69 74 65 61 2f 67  rs/gitea/gitea/g
      backtrace (crc 2f3bb450):
        [<ffffffffaa68fb49>] __kmalloc_noprof+0x359/0x510
        [<ffffffffc32bf1df>] ceph_mds_check_access+0x5bf/0x14e0 [ceph]
        [<ffffffffc3235722>] ceph_open+0x312/0xd80 [ceph]
        [<ffffffffaa7dd786>] do_dentry_open+0x456/0x1120
        [<ffffffffaa7e3729>] vfs_open+0x79/0x360
        [<ffffffffaa832875>] path_openat+0x1de5/0x4390
        [<ffffffffaa834fcc>] do_filp_open+0x19c/0x3c0
        [<ffffffffaa7e44a1>] do_sys_openat2+0x141/0x180
        [<ffffffffaa7e4945>] __x64_sys_open+0xe5/0x1a0
        [<ffffffffac2cc2f7>] do_syscall_64+0xb7/0x210
        [<ffffffffac400130>] entry_SYSCALL_64_after_hwframe+0x77/0x7f

It can be triggered by mouting a subdirectory of a CephFS filesystem, and then trying to access files on this subdirectory with an auth token using a path-scoped capability:

    $ ceph auth get client.services
    [client.services]
            key = REDACTED
            caps mds = "allow rw fsname=cephfs path=/volumes/"
            caps mon = "allow r fsname=cephfs"
            caps osd = "allow rw tag cephfs data=cephfs"

    $ cat /proc/self/mounts
    services@00000000-0000-0000-0000-000000000000.cephfs=/volumes/containers /ceph/containers ceph rw,noatime,name=services,secret=<hidden>,ms_mode=prefer-crc,mount_timeout=300,acl,mon_addr=[REDACTED]:3300,recover_session=clean 0 0

    $ seq 1 1000000 | xargs -P32 --replace={} touch /ceph/containers/file-{} && \
    seq 1 1000000 | xargs -P32 --replace={} cat /ceph/containers/file-{}

Signed-off-by: Antoine Viallon <antoine@lesviallon.fr>
---
 fs/ceph/mds_client.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 785fe489ef4b..c3b63243c2dd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5690,18 +5690,21 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 			 *
 			 * All the other cases                       --> mismatch
 			 */
+			int rc = 1;
 			char *first = strstr(_tpath, auth->match.path);
 			if (first != _tpath) {
-				if (free_tpath)
-					kfree(_tpath);
-				return 0;
+				rc = 0;
 			}
 
 			if (tlen > len && _tpath[len] != '/') {
-				if (free_tpath)
-					kfree(_tpath);
-				return 0;
+				rc = 0;
 			}
+
+			if (free_tpath)
+			  kfree(_tpath);
+
+			if (!rc)
+			  return 0;
 		}
 	}
 
-- 
2.47.0


