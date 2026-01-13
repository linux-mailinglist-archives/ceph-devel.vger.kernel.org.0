Return-Path: <ceph-devel+bounces-4382-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C36BD1B2B8
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 21:17:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 91451301EC58
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 20:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBDD30F95F;
	Tue, 13 Jan 2026 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="Hwam6yh+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7D62D6611
	for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768335412; cv=none; b=gOI4WkNlOIjGDJDHDj3av8xW1WX57/DVrEXAq3LI6cEbaoXDCN8fuYl4e2fNWJaSgP6i4SaHJarINNmm9UDon6JRVR5ag7w2CpBqsDGfN4dyGGlZlmIGkxOizLVJj54JNBWLwpfOlhpcbi9f4EOnMl9xTTPwEttnjJbNioENhGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768335412; c=relaxed/simple;
	bh=i7Q0cppGHnXoJlzKDTPAA4Ox8F1xyo7tsBiGT/yZWUc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NwH5LWCEVxeIkpevAtcY204mI/7p0G9JH63DG0ocdJlqabuWYLYXxRmrroR0OsaWfAMDGq6BEgacZtDKgSLf1GqA0PjbIuRZ1J6hhurXoUkZxdz4FH4DbNQo9cuZUly+UCs2VM+n6MYUld5Yw9y4epZG+Cu7ih0XYQmzeyj7Dlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=Hwam6yh+; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64669a2ecb5so226247d50.1
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 12:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1768335410; x=1768940210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PxakD1KmYQa92a3vZ7/OlBVuBUSn3nQs6Us3iV3sL6Y=;
        b=Hwam6yh+pF05hqzfKu0TuhGJGLYhBSjVPC6FWINo7k0J/IPSg3/lgBQEAPSnyMukeB
         sgFz0HM5E89y13JPankrblWGAWXyE9ycWQif9EIJEWLoevFfssnMcIFKQsvrp1CG++uK
         6Lry/CRqNthQR73KNRXeNLBgn+oA+dNgbMojghyqwIeNWN+1MgxFKpxCtnZ6LOAYwWvM
         mmMfv6wt96ebEGUGckz/7jrWz4s5G8EbkM9xPftCEfZWvR6aDy67Kl10vlG9kE4aosZw
         ehZkeUctbmwMU42oM2R1ANwpdBR525/2rAuKujlJJPJ8AefJ9bHNHurWTzJmZ5A6esKC
         2S2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768335410; x=1768940210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxakD1KmYQa92a3vZ7/OlBVuBUSn3nQs6Us3iV3sL6Y=;
        b=VebaWv3Cr6kPDGsKauOXVrpaRloH3NtFjpnQRgKXBL3OoJ97e9cGBKb6k8CRWnAoD5
         fFUd6DR7UbMABfsgnXcwyIXskT2ats0kt3jsz9vN30gSA6rBvA6+1NUZ5gULbbIzSwkM
         0CaNFU6LXZbGaBazPQjOdcE5dWqTKl6OByr6BRV01/P53sdtlE9VWUZJCFPtaQ7vA++p
         AxW0k/YPqxvk/unOdP7grlTBVQ6so8iB2QWyx9VUU/GeehkljwCKS8hg2rp8H6fzi690
         rx5Cyit0oJupodJ1/pCafW8lqNC6q4zaYw9CLVItMfpGifRTtislta4lEielXocl6i0+
         HI8A==
X-Gm-Message-State: AOJu0YwZfj9sZoPKqjSq0klBl5/68xpxjmxukWKWxk5TALg5VtSyOHHK
	nz4U0cmP+ft8TI229FmuoINS+tHWpnRGIZuXJvs2MqdDMVNYmpGEkmy1xRdxoPvZyAA=
X-Gm-Gg: AY/fxX4gQmThXcjzYXhIzrXOAuf2QpWVQ6jnWNFowxP62wh3sbtYnYPsTpFJYQdML3C
	OAMCBOoFaIX8/jALc3gsw1gkMErAeC/5ahXeIf3nnr8eGhzsgX4BWhuxfM0eOjNDXFBbDiMgRAm
	v9Cr/Y0QVTFzl6oeijSR2BGs/BUCVJZeYOuXmU48Gb7H3+LPMV2idHwQoTYHhbPjXqrZclK/KKM
	n0IGk8cqzc9tPmRBwj9TzhbFdcty9fXn28c6/6Goypd0Ayptz0EB/w0G9WvJKXLyX2/oD4qrAQt
	kaTs/w8vb6aGEno39LW+bPVERyWT8xf/sspWHsOvsPG8OJ/Lau6GUVjOIY3ojevtFBESlJfwXMD
	F4ekIF2WmbZyBLS4mZtDNHnppa+gcjuEIWo+QotmptFqqOmSd64byVFSia461z38AEg6QtTEWK6
	V2p3C51NvYWQJ/2DNy9IHRkajUBf15fzM65NNs2ovWeXBTbHTgohu9tDLHMVBemEMolItg0f9oI
	ap3UO34ELY/3aMn0Sk=
X-Received: by 2002:a53:8543:0:b0:645:5297:3e5d with SMTP id 956f58d0204a3-648f638c88cmr2981073d50.46.1768335410350;
        Tue, 13 Jan 2026 12:16:50 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:cf4e:ea8f:19ac:63a0])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d80be64sm9666151d50.6.2026.01.13.12.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 12:16:49 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: util-linux@vger.kernel.org,
	kzak@redhat.com
Cc: ceph-devel@vger.kernel.org,
	idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com,
	Pavan.Rallabhandi@ibm.com
Subject: [PATCH v2] mount: (manpage) add CephFS filesystem-specific manual page
Date: Tue, 13 Jan 2026 12:16:37 -0800
Message-ID: <20260113201636.993219-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Currently, manpage for generic mount tool doesn't contain
mentioning of CephFS kernel client filesystem-specific
manual page. This patch adds the mount.ceph(8) mentioning into
file system specific mount options section.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 sys-utils/mount.8.adoc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sys-utils/mount.8.adoc b/sys-utils/mount.8.adoc
index 4571bd2bfd16..43d2ef9a58a4 100644
--- a/sys-utils/mount.8.adoc
+++ b/sys-utils/mount.8.adoc
@@ -853,6 +853,7 @@ This section lists options that are specific to particular filesystems. Where po
 |===
 |*Filesystem(s)* |*Manual page*
 |btrfs |*btrfs*(5)
+|cephfs |*mount.ceph*(8)
 |cifs |*mount.cifs*(8)
 |ext2, ext3, ext4 |*ext4*(5)
 |fuse |*fuse*(8)
-- 
2.52.0


