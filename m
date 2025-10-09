Return-Path: <ceph-devel+bounces-3800-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EC1BC7DFF
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 10:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 185E5351F7B
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 08:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4AD2D7DDB;
	Thu,  9 Oct 2025 08:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XagQkyNV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D18E2D8792
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 07:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996799; cv=none; b=BM5TqnOhx+2Mh55maP8mXIB7oe3ksoGvf3Y5z/Ksh5nrvqRVV15TLTKjy9jCOtCvhxzg1F5P1bXGu36QK+PYnMRbPcolzAv7JHTFJPClalEYvWF6E2PpLixjjyFYDMvV2AYIHs36CMJCyaSOcd3NxWf26wWDOrUmmBJEYGZzesU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996799; c=relaxed/simple;
	bh=CjghRbVJnrrRxsFC/uqUg1E0WT10jkJULO+lABGoVkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiPuW2DCkfM/IKwFNgZXsd+snXO2gFNuc9bxI073pyjTkzwHzoPy9LG8ndXfucs3sm8SoJyDqrp1yC6XSQ7Wgsl/BmBB7QfcT/GhDzLx9E+a9uUSlXZjOl5vI6XcP1ZeuaM8NTJjh+DPeglqEh145tdFpgtRLzlMLORQY+crAJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XagQkyNV; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62ecd3c21d3so1035561a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996793; x=1760601593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qUy8w4oQhAgPl6fOZI4wnlmjsFcl6OG6QfU8CrT8Pk=;
        b=XagQkyNVxo10BmQPyZD+yu//5tUJ2oRbuqYr1gAYVHfL+oBGf2DHyKr5NUSSOpszo9
         XNVfIA7L2ILl3KlexyL25l2DusOVsoonl03HpxhblrhT/dSehwjKS4WCbhIuWCkU1sZz
         +yql5aQB76ryOHiSeI12l1yC8ghJFwdrGCCcfYtPTy91qDr3ksDgSx19jQIBI6I0Qrmb
         6jVvsF6aacudvR7O4N7kmfCLBUsV2jdX+n+evXIeoLGKN1p241aiIXIjDZp/h2cyiiuQ
         uWHjDw9pGWbQjxRdbbUchADmgaYabJOE075a81KPgOTaVMvpTKKn1pw+dy1b0nkFz57T
         rHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996793; x=1760601593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qUy8w4oQhAgPl6fOZI4wnlmjsFcl6OG6QfU8CrT8Pk=;
        b=Zl/CdDjo84D2R9sURCUy1U39ySzAIk9zWqGFHDbwTHIfOiNHTZDz3zKVidXUR4zA2/
         ZL7NzdqO3s2NxKtBzkQU+Gfo5MPW15zRmyt4pk1sW9pyyXOVYgdDiXIzW0orBnZ1uRlv
         CQkqUZsqUJpsCNccM4HEzVZ1ly9zc/uXZlSWSrfO9onsvvtRoNw6e2qwJI7D5zd/SpPH
         bR2l/dx/abN0ixIyjtL0bwzazeQAYOaxq8FBcwt12SF5f5Q3VWaFfWOIgAx3zkUM103m
         jENs9cUII91SqZy6crAVR9FvQojoeThFT5hNHbPdEOmhFzHTFe5cXzooIn4BDin3nfH2
         qfoA==
X-Forwarded-Encrypted: i=1; AJvYcCV8LYgS6dlNkxXjIKNRx51ZUNJrzcTvV667DjDI7H+iv9IsjCAc/iNKemBPckyVscI1PnU1rGE3aQt1@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb6/bTKnpzPZzCW0ZAUaHzbJfNCrIBN5IYRXXgYu4T/TxsPKdq
	LrkN55x9bOpMlptyfIxk2BmfyZAdUjxbvBOY0i43GRwTDZk/I1tcD+sx
X-Gm-Gg: ASbGnctGbynZHtR8V4pCEq0MjsD9ZQvGHCTJIoRPUUOS3G75QT2V58do1IryO/LJGkS
	IGEt9wjwDmCILhBfr4lZAKZ4W/pDzVwq412vI4ds6VvOhEOdvTQ2arPxoIrx+6Y3csHIRiGdSjF
	b7f6uLx2oqlwbneTivBHmYK82v50RccLZRIPbp4v+lJg5hxblj0zleSo90REatvruEVdezSgm4q
	YrP0CH9SDqjNCYkmlmdX0qogWeJXkEc/HDgNiuw3S97xm5C/AsgUGzKQE2AOyTwcAs+i8gkk9ht
	hnuruHLcILSwsFCtc6qNqWXzhWYjPdWEdlspT6B+IiYtA0dUlxyRZ6QT0euhbm/whBeQx/kxeXx
	DHZPeH1LcrLIeOo8ux51k3bYIfQky7rNlbApgkIdzMLZmqVsGrYr5NbEOo9jun+66tYWvSfYjfJ
	wxyiWRAYilTkXxEzfhXORW3w==
X-Google-Smtp-Source: AGHT+IGbrd08TTcAFiqwbpW9BDTUl/1zMbIp8ia/BbOIaKggRHixcVaV3Fgadc1Z9T3iA/deAE80rw==
X-Received: by 2002:a17:907:9702:b0:b3c:6093:679b with SMTP id a640c23a62f3a-b50ac2d58b3mr707002766b.36.1759996793003;
        Thu, 09 Oct 2025 00:59:53 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:52 -0700 (PDT)
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
Subject: [PATCH v7 08/14] smb: use the new ->i_state accessors
Date: Thu,  9 Oct 2025 09:59:22 +0200
Message-ID: <20251009075929.1203950-9-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009075929.1203950-1-mjguzik@gmail.com>
References: <20251009075929.1203950-1-mjguzik@gmail.com>
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

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

 fs/smb/client/cifsfs.c |  2 +-
 fs/smb/client/inode.c  | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 1775c2b7528f..103289451bd7 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -484,7 +484,7 @@ cifs_evict_inode(struct inode *inode)
 {
 	netfs_wait_for_outstanding_io(inode);
 	truncate_inode_pages_final(&inode->i_data);
-	if (inode->i_state & I_PINNING_NETFS_WB)
+	if (inode_state_read_once(inode) & I_PINNING_NETFS_WB)
 		cifs_fscache_unuse_inode_cookie(inode, true);
 	cifs_fscache_release_inode_cookie(inode);
 	clear_inode(inode);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 8bb544be401e..32d9054a77fc 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -101,7 +101,7 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 	cifs_dbg(FYI, "%s: revalidating inode %llu\n",
 		 __func__, cifs_i->uniqueid);
 
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		cifs_dbg(FYI, "%s: inode %llu is new\n",
 			 __func__, cifs_i->uniqueid);
 		return;
@@ -146,7 +146,7 @@ cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 	 */
 	if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) {
 		/* only provide fake values on a new inode */
-		if (inode->i_state & I_NEW) {
+		if (inode_state_read_once(inode) & I_NEW) {
 			if (fattr->cf_cifsattrs & ATTR_DIRECTORY)
 				set_nlink(inode, 2);
 			else
@@ -167,12 +167,12 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (!(inode->i_state & I_NEW) &&
+	if (!(inode_state_read_once(inode) & I_NEW) &&
 	    unlikely(inode_wrong_type(inode, fattr->cf_mode))) {
 		CIFS_I(inode)->time = 0; /* force reval */
 		return -ESTALE;
 	}
-	if (inode->i_state & I_NEW)
+	if (inode_state_read_once(inode) & I_NEW)
 		CIFS_I(inode)->netfs.zero_point = fattr->cf_eof;
 
 	cifs_revalidate_cache(inode, fattr);
@@ -194,7 +194,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	inode->i_gid = fattr->cf_gid;
 
 	/* if dynperm is set, don't clobber existing mode */
-	if (inode->i_state & I_NEW ||
+	if (inode_state_read(inode) & I_NEW ||
 	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM))
 		inode->i_mode = fattr->cf_mode;
 
@@ -236,7 +236,7 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 
 	if (fattr->cf_flags & CIFS_FATTR_JUNCTION)
 		inode->i_flags |= S_AUTOMOUNT;
-	if (inode->i_state & I_NEW) {
+	if (inode_state_read_once(inode) & I_NEW) {
 		cifs_set_netfs_context(inode);
 		cifs_set_ops(inode);
 	}
@@ -1638,7 +1638,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 		cifs_fattr_to_inode(inode, fattr, false);
 		if (sb->s_flags & SB_NOATIME)
 			inode->i_flags |= S_NOATIME | S_NOCMTIME;
-		if (inode->i_state & I_NEW) {
+		if (inode_state_read_once(inode) & I_NEW) {
 			inode->i_ino = hash;
 			cifs_fscache_get_inode_cookie(inode);
 			unlock_new_inode(inode);
-- 
2.34.1


