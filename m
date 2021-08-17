Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9B3EEE0A
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbhHQOFQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 10:05:16 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37536 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhHQOFQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Aug 2021 10:05:16 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 11B151FF45;
        Tue, 17 Aug 2021 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629209082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fdViEVKbc9ON3uLVVeKYrw2KvM6hRER7Fj1dCegvK+4=;
        b=H8r/BPzeMbPQmJo8v8j3wBJ8Y1FkO5FG1l3JEE3ih49KGnhrQkX5qYOtg3neVb+y0kpePL
        jAGt8loI70fHOh0w07PhPTLiWMtVgAR8STzOvwXCTdHQoeuS9zCvpcRRArLZqqFZ0D0Z//
        GMAM8SCTgRKFeUnoi33fgdG239qn2EU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629209082;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=fdViEVKbc9ON3uLVVeKYrw2KvM6hRER7Fj1dCegvK+4=;
        b=kqdkxbWhD053liyIQgwGMFrxeg6W3z5D25ztHx6h8WEfrpl7ort2ymbh3cKx7SccS+P1cb
        15jW8l7I4C6QjtCg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id B6AEA132AB;
        Tue, 17 Aug 2021 14:04:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 7rmSKfnBG2EuSgAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Tue, 17 Aug 2021 14:04:41 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id ba6867a0;
        Tue, 17 Aug 2021 14:04:41 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [fscrypt][RFC PATCH v2] ceph: don't allow changing layout on encrypted files/directories
Date:   Tue, 17 Aug 2021 15:04:39 +0100
Message-Id: <20210817140439.1442-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Encryption is currently only supported on files/directories with layouts
where stripe_count=1.  Forbid changing layouts when encryption is involved.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Changes since v1:
- dropped changes to ceph_sync_setxattr(), MDS shall be responsible for
  preventing layout changes on encrypted dirs/files

 fs/ceph/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 477ecc667aee..480d18bb2ff0 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	/* encrypted directories can't have striped layout */
+	if (ci->i_layout.stripe_count > 1)
+		return -EINVAL;
+
 	ret = vet_mds_for_fscrypt(file);
 	if (ret)
 		return ret;
