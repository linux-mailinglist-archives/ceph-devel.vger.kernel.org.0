Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89783EB5ED
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Aug 2021 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbhHMNDd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Aug 2021 09:03:33 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59900 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbhHMNDd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 13 Aug 2021 09:03:33 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 79E942232A;
        Fri, 13 Aug 2021 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628859785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0RpkuLKebk6EffdzQFe8t2/+G3/0hy/tufBIMMJPcCc=;
        b=uLbXROHJXvBIRn8N6wOxyJuWtaUscIi8GdDZQfbDFQE9u03QwF4AqlXxMnrmdVNV81iggW
        HLFHAnj/VWOAci190PBaxGjU2csM7wVX7xbl7sYyKqO+QCpx8/dhC+Ol/hNhiMwfZP6raT
        9/2hS0IX6hPuPUCeWq+mE3X2i61dy+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628859785;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0RpkuLKebk6EffdzQFe8t2/+G3/0hy/tufBIMMJPcCc=;
        b=E96NVvDZpMgYBf1Q+z2rklIodRZBMPkMdBK83Ct9aVol0BM8PdLPtz858SWJO5injNVQDy
        wdptOwUmWsKUqUDA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 36960137DE;
        Fri, 13 Aug 2021 13:03:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id WaZHColtFmFhegAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Fri, 13 Aug 2021 13:03:05 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 577537d7;
        Fri, 13 Aug 2021 13:03:04 +0000 (UTC)
Date:   Fri, 13 Aug 2021 14:03:04 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [fscrypt][RFC PATCH] ceph: don't allow changing layout on encrypted
 files/directories
Message-ID: <YRZtiL+qo95vK0Nf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Encryption is currently only supported on files/directories with layouts
where stripe_count=1.  Forbid changing layouts when encryption is involved.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Hi!

While continuing looking into fscrypt, I realized we're not yet forbidding
different layouts on encrypted files.  This patch tries to do just that.

Regarding the setxattr, I've also made a change [1] to the MDS code so that it
also prevents layouts to be changed.  This should make the changes to
ceph_sync_setxattr() redundant, but in practice it doesn't because if we encrypt
a directory and immediately after that we change that directory layout, the MDS
wouldn't yet have received the fscrypt_auth for that inode.  So... yeah, an
alternative would be to propagate the fscrypt context immediately after
encrypting a directory.

[1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10

Cheers,
--
Luis

 fs/ceph/ioctl.c | 4 ++++
 fs/ceph/xattr.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 477ecc667aee..42abfc564301 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	/* encrypted directories can't have striped layout */
+	if (ci->i_layout.stripe_count > 1)
+		return -EOPNOTSUPP;
+
 	ret = vet_mds_for_fscrypt(file);
 	if (ret)
 		return ret;
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index b175b3029dc0..7921cb34900c 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1051,6 +1051,12 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 	int op = CEPH_MDS_OP_SETXATTR;
 	int err;
 
+	/* encrypted directories/files can't have their layout changed */
+	if (IS_ENCRYPTED(inode) &&
+	    (!strncmp(name, "ceph.file.layout", 16) ||
+	     !strncmp(name, "ceph.dir.layout", 15)))
+		return -EOPNOTSUPP;
+
 	if (size > 0) {
 		/* copy value into pagelist */
 		pagelist = ceph_pagelist_alloc(GFP_NOFS);

Cheers,
--
Luís
