Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06AF4842F5
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiADOEf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiADOEd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24EE61462
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87738C36AEF;
        Tue,  4 Jan 2022 14:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305072;
        bh=TqhxcjSSsz5BG2JsZaDV65AFz/oNyLOr2Fc3EaW/w3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPQJzD29kLiHfavjqwxdK5SGptNHJm1kT4G+F8Jq6bpxJt6suQdLWtHO7Y78w4kzj
         aQLrv2Ze47VMaFAlpGthA+XO9SZGjNi/EXTT7K22Q709mImdeVD90SBIoskmdhGW9H
         bNJBN5iZ097DaMubbrY3QGgKTflSo9bci6Fmt4ziNfuZ58KI9obXG6Z+FDEZUkw/So
         55RFyEPkGFDFZwD1vmwvHYgCQq7L4WP+OUvtdWkjlCLj3wbgefUFbQfMLyyT61FRpV
         aQrk9ckB7ovsCT75oHg4DRq0YCzkz5BlmkeSXgF+mnpBs/fNpg5W+jySLeRM1Mu/rL
         SFZnaWRgZs0zw==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 01/12] ceph: stash idmapping in mdsc request
Date:   Tue,  4 Jan 2022 15:04:03 +0100
Message-Id: <20220104140414.155198-2-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104140414.155198-1-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2814; h=from:subject; bh=lUre2FF+bMPoTNWEitmuyN6zfiumvjQNh9FhgakhqbU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCd7AsvLLo2tTUxz2sx8qMJjX+e3szvz5Zyvm7XnQ1Hfe Q/C2bUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEfNwY/pf8X5gVvEmiRy5mX+XT/4 lBE44r/BHTkoypvPxDQ12oJICR4Z205hTmXU3C+wxPsStNeqi7rPF9Qcr/A1um51jtnV+xiRsA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

When sending a mds request cephfs will send relevant data for the
requested operation. For creation requests the caller's fs{g,u}id is
used to set the ownership of the newly created filesystem object. For
setattr requests the caller can pass in arbitrary {g,u}id values to
which the relevant filesystem object is supposed to be changed.

If the caller is performing the relevant operation via an idmapped mount
cephfs simply needs to take the idmapping into account when it sends the
relevant mds request.

In order to support idmapped mounts for cephfs we stash the idmapping
whenever they are relevant for the operation for the duration of the
request. Since mds requests can be queued and performed asynchronously
we make sure to keep the idmapping around and release it once the
request has finished.

In follow-up patches we will use this to send correct ownership
information over the wire. This patch just adds the basic infrastructure
to keep the idmapping around. The actual conversion patches are all
fairly minimal.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/ceph/mds_client.c | 7 +++++++
 fs/ceph/mds_client.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c30eefc0ac19..ae2cc4ce1d48 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/mnt_idmapping.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -862,6 +863,8 @@ void ceph_mdsc_release_request(struct kref *kref)
 	kfree(req->r_path1);
 	kfree(req->r_path2);
 	put_cred(req->r_cred);
+	if (!initial_idmapping(req->mnt_userns))
+		put_user_ns(req->mnt_userns);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	put_request_session(req);
@@ -918,6 +921,10 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	insert_request(&mdsc->request_tree, req);
 
 	req->r_cred = get_current_cred();
+	if (!req->mnt_userns)
+		req->mnt_userns = &init_user_ns;
+	else
+		get_user_ns(req->mnt_userns);
 
 	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
 		mdsc->oldest_tid = req->r_tid;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 97c7f7bfa55f..1b648645e340 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -275,6 +275,7 @@ struct ceph_mds_request {
 	union ceph_mds_request_args r_args;
 	int r_fmode;        /* file mode, if expecting cap */
 	const struct cred *r_cred;
+	struct user_namespace *mnt_userns;
 	int r_request_release_offset;
 	struct timespec64 r_stamp;
 
-- 
2.32.0

