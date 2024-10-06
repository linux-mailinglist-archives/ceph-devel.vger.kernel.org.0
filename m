Return-Path: <ceph-devel+bounces-1893-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B46991BBD
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 03:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35F881C21075
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 01:21:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C223B13D53D;
	Sun,  6 Oct 2024 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ONLdQOm0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7578F5A;
	Sun,  6 Oct 2024 01:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177608; cv=none; b=A/dBRUBf3tMMpX+XPEdDLrlJ0HMWAu0L0QMmqI2zDNINmotD4sfMBORhYL919DZ1O4CKxCW4qlLIO0xX4LowjAxkpiGwCK0eEoLpNuw6cheMVezfZ1vfY4OIinZvNbMp9xMMw/T/9sZFPJlEcxJBpiGd5jTPo2UxhmrHF0Fo3XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177608; c=relaxed/simple;
	bh=AMhJWtDJ3DmzilqLovKPEDl9iPQ/8NhBRi8PAwhpUvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufo2gzjjk9+pz7V+S+2Er1rwzPn7JjWuJ0dWZPvqeOHqc+AqRqTVteSOIHwGIDyOD31wp8hrBAvgG/wrOA0QRh0msEYFsxYn3oynQIDNMDj61that4oh3OU2UCcMAJscApbqRwA3IZMP9/rCEAKkABzzvVRGNN8G7Qmbea++KEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ONLdQOm0; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=MBiF799tS1XTKKBb+cgx7wzKHjzYh+/tYFwc8HgQmQg=; b=ONLdQOm0N/tzF3tx
	s1Ij7raGrn0g92/9J3eznWbCx2R+1+t21GzH5abDBTTMN+LoSsDoErcBQpU/UfRM/FMSg9SKLBdrw
	AL33d77AhekdXjL+Z7QG5TqTVAvSpKSKWU6GLyQDkDTblCbGJACnbsXglYDflIOzeomOGOVSEN+c+
	rqrbsmxELV4IjT9E8b5znraK44qnyduck3rdD1C+3/BbqNbZ/VxTjhDyNA+0P/5LLEo8X8y457ka4
	pjZ6FqQWxMg/bEXjc2JpaNuovoAbg4iSekleoljWo2sOtlXs1VYVHLhRGq/fdVzqHj7DV+y4d7fT6
	5CLXQrNnvaQgl19rzA==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxFwG-009DsK-1v;
	Sun, 06 Oct 2024 01:20:00 +0000
From: linux@treblig.org
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 5/5] ceph: Remove fs/ceph deadcode
Date: Sun,  6 Oct 2024 02:19:56 +0100
Message-ID: <20241006011956.373622-6-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
References: <20241006011956.373622-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ceph_caps_revoking() has been unused since 2017's commit
3fb99d483e61 ("ceph: nuke startsync op")

ceph_mdsc_open_export_target_sessions() has been unused since 2013's
commit 11df2dfb610d ("ceph: add imported caps when handling cap export message")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/ceph/caps.c       | 14 --------------
 fs/ceph/mds_client.c |  8 --------
 fs/ceph/mds_client.h |  2 --
 fs/ceph/super.h      |  1 -
 4 files changed, 25 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bed34fc11c91..0d6b2c0269bf 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -978,20 +978,6 @@ int __ceph_caps_revoking_other(struct ceph_inode_info *ci,
 	return 0;
 }
 
-int ceph_caps_revoking(struct ceph_inode_info *ci, int mask)
-{
-	struct inode *inode = &ci->netfs.inode;
-	struct ceph_client *cl = ceph_inode_to_client(inode);
-	int ret;
-
-	spin_lock(&ci->i_ceph_lock);
-	ret = __ceph_caps_revoking_other(ci, NULL, mask);
-	spin_unlock(&ci->i_ceph_lock);
-	doutc(cl, "%p %llx.%llx %s = %d\n", inode, ceph_vinop(inode),
-	      ceph_cap_string(mask), ret);
-	return ret;
-}
-
 int __ceph_caps_used(struct ceph_inode_info *ci)
 {
 	int used = 0;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c4a5fd94bbbb..923635532f03 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1747,14 +1747,6 @@ static void __open_export_target_sessions(struct ceph_mds_client *mdsc,
 	}
 }
 
-void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
-					   struct ceph_mds_session *session)
-{
-	mutex_lock(&mdsc->mutex);
-	__open_export_target_sessions(mdsc, session);
-	mutex_unlock(&mdsc->mutex);
-}
-
 /*
  * session caps
  */
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 3dd54587944a..38bb7e0d2d79 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -634,8 +634,6 @@ extern void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc,
 
 extern struct ceph_mds_session *
 ceph_mdsc_open_export_target_session(struct ceph_mds_client *mdsc, int target);
-extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
-					  struct ceph_mds_session *session);
 
 extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
 			  struct ceph_mds_session *session,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 037eac35a9e0..b0b15e87251d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -796,7 +796,6 @@ extern int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 
 extern int __ceph_caps_revoking_other(struct ceph_inode_info *ci,
 				      struct ceph_cap *ocap, int mask);
-extern int ceph_caps_revoking(struct ceph_inode_info *ci, int mask);
 extern int __ceph_caps_used(struct ceph_inode_info *ci);
 
 static inline bool __ceph_is_file_opened(struct ceph_inode_info *ci)
-- 
2.46.2


