Return-Path: <ceph-devel+bounces-3275-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85FF2AFBC43
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 22:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C55C561426
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 20:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4921421A445;
	Mon,  7 Jul 2025 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="tmf/p/XE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1E52153D3
	for <ceph-devel@vger.kernel.org>; Mon,  7 Jul 2025 20:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751918621; cv=none; b=u/Pr22o7KTGFlKpIChnmhoFzQGA3Pe7en0FjU/AdRDdo6cJi4CntjNCmXjzaSCUBiCSB2uUTqt9I0f/9X5br/56OiVUDkXDpKlxMj4zgMdkQ9aLNyKn9Xowz1KlrNIks9Itqber3OV6MDyCGGUwvGpWDXGflyB7dvJs+H6WYJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751918621; c=relaxed/simple;
	bh=+IdW9IQoph/y/mp6ERLotvI2aGvwZg9qbaIgK75LH0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EzobnYpAoPYsceg3ONCA49k7I3dQxLqVRkoZ4yk3fUMYeI2mopsvt2WfLONTirFIGfhc0ZTue9XmVS6lSszoJrs+yC3Ch+H7oHw2YpH++usfnMQYsA47DkHsk+sqWjmBg7c86spasY3s8S2Z5kXiMorptgpKHv0mAiuNagAS0u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=tmf/p/XE; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-70f94fe1e40so49061977b3.1
        for <ceph-devel@vger.kernel.org>; Mon, 07 Jul 2025 13:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1751918618; x=1752523418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e0nNP1ej16t8D67FbAmnKcWyH7dm/S6OQwG69pUEMbM=;
        b=tmf/p/XE2W98jTmjF+jRQCHSeJC7rU8SiHByIDaXrHTnBrHRBkVGFd9a5q3w2vKCee
         S8TxPtelRA0wvCXsCfKBNhsxlW2rsWm82uIhJaXq3o5JjGxRlHSRJyx3sbEKvzBnsoEi
         xEoNXxafFx5e0q1nyst9qfsYSZ7wde47GxHlwKVPuhvqMZwHxntggg3TeYNvwDIN7NWH
         12O3pfXeQoK78OGr8N6JY4qx9cnlx9THkuER+uhnYKCjgHs2ELVgeiNCzOHhgm82MRZ4
         PaMaWXNBaGbAOP/HV/yhrHwNWw6EP9zpvCj/EyxUItWYIuxIzue9WhYegrAmByK6ihlp
         a6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751918618; x=1752523418;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e0nNP1ej16t8D67FbAmnKcWyH7dm/S6OQwG69pUEMbM=;
        b=WY63rMs7w88N6wi7+/7L0D7o5GnKumPDtsVSZJLAKFdW4mt8JqqkLMEeNQqnH/xwDG
         SfjhbElmvg+AWa5bXNPelDpWSdvkXJdu5ZJlKY8XQamazazoq0KkhHb1D4gV3cX7guuR
         zsZyEmWta3BAhxfkWCqk39OFMAE9pIEmm/fn70sJSKwKZBoGjAsIjVWRk+s2QSUuSiL4
         E72FJtIm3fLhenCg44c5MenxZIrcfiO45QFeJ78PTMKDYU9Y37B/++NoX88saWrZiDWp
         +pTBjH3OrlzgSR+HYMD3MELubL+9FPzfWCpn8eyZSGBUMQCWzJSlxld2Gvvq2k7LZBJL
         MS+A==
X-Gm-Message-State: AOJu0YxTojEJXEPa3h7QV31Rt9vGA4jRLQI6yH/cOYbvNQKA2XRjwIh+
	DxmenAodwGHeZeWxzSCuxc4cyETxom+Fzo1On3O9srCh9b9VZc9DY01gm8ianXnhbzmg2UiISh2
	GZKI5EXQ=
X-Gm-Gg: ASbGncsfsBqVPdoYc8aeZhFSO1Fe0P3zVcNd4mzI7af6Mq0Abd1VHZwXY/1VPuZBT5e
	rL3Q6n/jvJ8nI+rS23TFlZIdtEor5LuiY/9F+R+M2rOcVUsfE/8tjWc/BN1YM0dTKzekgaqfp3i
	NX7u9cBXcZAkBg40520ZCeY+XIXmgK9DKKeUvypfdm0Qz+Tlz1Y35Vfr34lpmBScvBpirGCRES4
	oBq97Kh7wAHsnfp6Yl2/JP6AoNcgZVwgQuCoWLwiDQZsef7xy6bIVdpG8yBT11vtbDVrNqL55my
	SQRHL24ZV3i0IZzhbqXM4UnZiFO4Gkx5UuzJDnOLT28U4Dd1hdrZuSdYyztWf5iFrhC33O2zDgc
	moMrJ
X-Google-Smtp-Source: AGHT+IH1bdcT8Op1UQcJ7y7fuoZa4AobduFgm4XgERU7WTlUpV6uKyPuVHgAEULfklW/n+LzIP5s+w==
X-Received: by 2002:a05:690c:b9b:b0:712:c295:d01f with SMTP id 00721157ae682-717a0306c58mr558077b3.3.1751918617460;
        Mon, 07 Jul 2025 13:03:37 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:4607:c111:d285:761d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71665ae1fb3sm17818227b3.65.2025.07.07.13.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 13:03:36 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: refactor wake_up_bit() pattern of calling
Date: Mon,  7 Jul 2025 13:03:22 -0700
Message-ID: <20250707200322.533945-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The wake_up_bit() is called in ceph_async_unlink_cb(),
wake_async_create_waiters(), and ceph_finish_async_create().
It makes sense to switch on clear_bit() function, because
it makes the code much cleaner and easier to understand.
More important rework is the adding of smp_mb__after_atomic()
memory barrier after the bit modification and before
wake_up_bit() call. It can prevent potential race condition
of accessing the modified bit in other threads.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/dir.c  | 4 +++-
 fs/ceph/file.c | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a321aa6d0ed2..7f4d1874a84f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1261,7 +1261,9 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	spin_unlock(&fsc->async_unlink_conflict_lock);
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_UNLINK;
+	clear_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags);
+	/* ensure modified bit is visible */
+	smp_mb__after_atomic();
 	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
 	spin_unlock(&dentry->d_lock);
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a7254cab44cc..b114b939cdc0 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -580,7 +580,9 @@ static void wake_async_create_waiters(struct inode *inode,
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
-		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
+		clear_bit(CEPH_ASYNC_CREATE_BIT, &ci->i_ceph_flags);
+		/* ensure modified bit is visible */
+		smp_mb__after_atomic();
 		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
 
 		if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
@@ -765,7 +767,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	}
 
 	spin_lock(&dentry->d_lock);
-	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
+	clear_bit(CEPH_DENTRY_ASYNC_CREATE_BIT, &di->flags);
+	/* ensure modified bit is visible */
+	smp_mb__after_atomic();
 	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
 	spin_unlock(&dentry->d_lock);
 
-- 
2.49.0


