Return-Path: <ceph-devel+bounces-3623-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D62B598B8
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 16:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0B991C0298A
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Sep 2025 14:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9577A35208A;
	Tue, 16 Sep 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHs4mrtt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF231350851
	for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031197; cv=none; b=Jsupq7zuZZt+iP5gQkZyboUD0Lrbtqg9Sk5aLcRlzhHOAdyowPYyhWbxizG08+/QRrLJQMkMamrnWS4xzKogh9ynAzkgg9ShtUGa2wufTRY3AI+9nQBpL6TSSYiDFyM2H9BslitwNRpW1f+CVJpx2mjipsC0HlRryaQ8CKHlp0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031197; c=relaxed/simple;
	bh=zZiNEsc0ou9dLfivP9Aqc6NzCGoV3keb+6tsUnteUdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grvFJ/bEGErVsXkUgY2r8QyL9a2F9mDSbaG2lHpk9fpZLk9vQZ5vV19j9RVdPnThmGUZI2RW8Q2o2rPt8nvgQRW0UihGbVxgaGaTqBreUn2imvS+LkoMo7IJQfL4BHT80RCB+T/gWkI4nE9Yg0w0jlmMe4BKEbh48j8Z8L6LZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RHs4mrtt; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45f2b062b86so17473395e9.1
        for <ceph-devel@vger.kernel.org>; Tue, 16 Sep 2025 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758031193; x=1758635993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BH7uZiHjx4atLUKz523xg3qFPyZEu5cyZb0AVULMuO0=;
        b=RHs4mrttSYB9GRGRbp9KqwYnMiUEDNugTDAhLFQoZojDS0ZgoU0Va7b9gY3Cc6pZ5b
         O3vJ1KheImXyWj+71MZD2sM8nrtiHieuI7KAcKS+ocl/x1fgN72+vwL1gpGT3q7S0xUj
         kihoI5B07V5J9Jv920/X4pxFRd3zyvaFMV1k2nejn9ujA6hCbYP3rzyKP+UScJ3SsA08
         62/eowIVfhzLFP90sKACmqejcwZKcgViHQKCLqXMu9ZQkEjN9VvDOySElFYfZqqBuwXT
         +Cw2ILPMdQe4+tCLLSzTQ+VIZxbC+TvQxRp9meBAcR3quDq8MTBlcazdBJuOZcJoPJ/i
         lkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758031193; x=1758635993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BH7uZiHjx4atLUKz523xg3qFPyZEu5cyZb0AVULMuO0=;
        b=m7wH8JKBXRx42uMpoEBoY4WrZPxWPR1DBKu/IXJ/NSvMF49fv7rELZOBNeqjxFg8hH
         i+EK036Swqfj7kxvtvpCXXyZmjLvktSBTETZHFLc04wM+/XDEkGauY8rWu28eKMkM82V
         U/NHwsF9sgyDe6w0SffKHsBUhBjOPvVsYRUbL/R8qiD/8R6T3+6d34WNlFd1ufYKAT+i
         APLFJEJzD7yeQXrWJkVhxZRZBBXhD4dmJnnugRbqMWosznEUMoZ2Vs+Hke1xe0QrCzGl
         s7S0koJhMSLCui5NTZ63/svOZByacPP0SWrHXxdz93XHbvYPjkl8e1aHfeI12cZ4cC5U
         MgkA==
X-Forwarded-Encrypted: i=1; AJvYcCWeY4U2e7dfR6IIxO6QLplMqliBWMy+atMwly7GEOsok6/2er1F8UefmxsCKdAKSpEqGI/YWhEOALFV@vger.kernel.org
X-Gm-Message-State: AOJu0YxlZQHQICOdUyhpeOIvumd1SMAH5pf+bYkKd/wvkoNU3wV+RcKU
	zLdNbgwvRMdhzAcfu5a6sg7N2uExcsHbHCciOSxuXGHnHQStY3czb/D7
X-Gm-Gg: ASbGncs7ETe6SGuG7TaUNkdeZzTpyB30vGnAbJHbq2dOyhGfFRmTsrXo5WNQOTmxVX8
	YRL3lIG2pHl8fHG1ZEFUzxwye9rjii9yXgYoHKk4N5hbGiopTJ+w6HLgMgwITzRQ4/1+xPIUE1N
	MVHjgcek7Snc2B+VZnVSS1+fe2my0/2DQjUMzU+qcAcucMyfV87n16VrmBwtYHsgj22evXWi1OW
	EYoPbEZAznmFPBMyToPz1hxWDHE5nHaKqaKVU7d+MeEY5CLM/776FHlb9+1hFe7t53MuPsFaK7q
	KfqBuZDxeQsbhlV2NT79kB3H2zYSTkdIJCUtEzrR7ajopm5DUn9Gskz8t7gS77NTs7T6ldqDki7
	mHxPkVOG3z1acuyueW4n+ty6U6+tV1ktXY/PXny/HtbVRpUYCc/7B8xR41SytbdILHO1m3buO
X-Google-Smtp-Source: AGHT+IHChUM15w8rTVndIAcblUfNQKZjE5Ckd1Ezw+ggkuImQMYHH2MYJMg1j8qo3nE46VliCumLGA==
X-Received: by 2002:a05:600c:584d:b0:45d:e110:e690 with SMTP id 5b1f17b1804b1-45f211d55aamr122328095e9.14.1758031192933;
        Tue, 16 Sep 2025 06:59:52 -0700 (PDT)
Received: from f.. (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7cde81491sm16557991f8f.42.2025.09.16.06.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 06:59:52 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v4 08/12] ext4: use the new ->i_state accessors
Date: Tue, 16 Sep 2025 15:58:56 +0200
Message-ID: <20250916135900.2170346-9-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916135900.2170346-1-mjguzik@gmail.com>
References: <20250916135900.2170346-1-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change generated with coccinelle and fixed up by hand as appropriate.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---

cheat sheet:
Suppose flags I_A and I_B are to be handled, then if ->i_lock is held:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_add(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_del(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_set(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally, add "_once"
suffix for the read routine or "_raw" for the rest:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_add_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_del_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_set_raw(inode, I_A | I_B)

 fs/ext4/inode.c  | 10 +++++-----
 fs/ext4/orphan.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ed54c4d0f2f9..f5b652613f2e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -425,7 +425,7 @@ void ext4_check_map_extents_env(struct inode *inode)
 	if (!S_ISREG(inode->i_mode) ||
 	    IS_NOQUOTA(inode) || IS_VERITY(inode) ||
 	    is_special_ino(inode->i_sb, inode->i_ino) ||
-	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) ||
+	    (inode_state_read_once(inode) & (I_FREEING | I_WILL_FREE | I_NEW)) ||
 	    ext4_test_inode_flag(inode, EXT4_INODE_EA_INODE) ||
 	    ext4_verity_in_progress(inode))
 		return;
@@ -3473,7 +3473,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	/* Any metadata buffers to write? */
 	if (!list_empty(&inode->i_mapping->i_private_list))
 		return true;
-	return inode->i_state & I_DIRTY_DATASYNC;
+	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
 
 static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
@@ -4581,7 +4581,7 @@ int ext4_truncate(struct inode *inode)
 	 * or it's a completely new inode. In those cases we might not
 	 * have i_rwsem locked because it's not necessary.
 	 */
-	if (!(inode->i_state & (I_NEW|I_FREEING)))
+	if (!(inode_state_read_once(inode) & (I_NEW | I_FREEING)))
 		WARN_ON(!inode_is_locked(inode));
 	trace_ext4_truncate_enter(inode);
 
@@ -5239,7 +5239,7 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	if (!(inode->i_state & I_NEW)) {
+	if (!(inode_state_read_once(inode) & I_NEW)) {
 		ret = check_igot_inode(inode, flags, function, line);
 		if (ret) {
 			iput(inode);
@@ -5570,7 +5570,7 @@ static void __ext4_update_other_inode_time(struct super_block *sb,
 	if (inode_is_dirtytime_only(inode)) {
 		struct ext4_inode_info	*ei = EXT4_I(inode);
 
-		inode->i_state &= ~I_DIRTY_TIME;
+		inode_state_del(inode, I_DIRTY_TIME);
 		spin_unlock(&inode->i_lock);
 
 		spin_lock(&ei->i_raw_lock);
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 7c7f792ad6ab..10eeb025380f 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -107,7 +107,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal || is_bad_inode(inode))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode_state_read_once(inode) & (I_NEW | I_FREEING)) &&
 		     !inode_is_locked(inode));
 	/*
 	 * Inode orphaned in orphan file or in orphan list?
@@ -236,7 +236,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	if (!sbi->s_journal && !(sbi->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
-	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
+	WARN_ON_ONCE(!(inode_state_read_once(inode) & (I_NEW | I_FREEING)) &&
 		     !inode_is_locked(inode));
 	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE))
 		return ext4_orphan_file_del(handle, inode);
-- 
2.43.0


