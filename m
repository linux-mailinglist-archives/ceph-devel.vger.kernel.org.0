Return-Path: <ceph-devel+bounces-4365-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ED0CD15579
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jan 2026 21:59:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EAB13301227A
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jan 2026 20:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086E933F8B3;
	Mon, 12 Jan 2026 20:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="VpM+IqTK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE7330EF65
	for <ceph-devel@vger.kernel.org>; Mon, 12 Jan 2026 20:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768251554; cv=none; b=lLD+ZkbVCrbU5/Ag8t+OFg2r+WRW3GznBrDs2aANZf6mkXnFMO9SlCg+btGnlq8nbW2wrArgOxfQav74InASG2TK1PzHexqUK5cngRw5aES2IM1e22bVMolDH0KDC/BG8HkeUMrPJxyfmzaMv6/9LRoABW4pADpzSlNqBeKzWro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768251554; c=relaxed/simple;
	bh=xKYRLKpuM+sQImj23PBCnkebqVm/eqDdchxej7U9Apw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P6xqsujDhfI4AgHPL1PjmLMGO+iOYzxWhlSpgtDsDp/iiARZm+RmnZ/KYPvyGOwDSeI5WAOKz8unN34G/FTrztW/uFqbD3Svu4twMJGHVzlZ5pYsKWQEP7XqbGCdY12H366gFYGIfILJzl9+xDdq+3MG+kEZ5ERlXjUuAruB1Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=VpM+IqTK; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6468f0d5b1cso6075425d50.1
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1768251552; x=1768856352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dvo6+EsDKRRfc3HTMCn0lfwSOccr6CCC/pevgcIHrpQ=;
        b=VpM+IqTKMl7hGiKphf26TwaoqpRXCtvwNfZaZOcFRFgA5LVXiLxaPgNsHiM42Zq8Yn
         ApiCjKmF6MJAv20k99Fuj72rxJJl96I3sMsXoTgIFekMZzxkoOB06WFWV8k05bNQDlww
         W/lvsLoTXskPBRd/CuHQv/vTAIIiTAm2DOyjZxi5M/7Ux1Wmu72gKUwADE8wJrXVsFr/
         EMQKqH9EX+oOl0xaE5AooYPFgyRkne/yJfIEhwww165C2DDkGOVu4g3r1yZuMRW+tkhi
         hFcu4Wj78HcHXQJk06QYHJetXnXJ5EVmDa2N8R4KD90msqivGmSY/11zJSfLqkJy+yVL
         7mpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768251552; x=1768856352;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvo6+EsDKRRfc3HTMCn0lfwSOccr6CCC/pevgcIHrpQ=;
        b=jNicj8x060f9hfxjlxVk2RVZJ0T4BqL2o1mpxi9JVvMfhFzvSs29rngW9+e5APeS0C
         20PmisehV6vQcdX8K63jlQU/7CFHjlGM9eDKcznmlyxOX/Ygwp9B4d6z2DYFyAK+piUQ
         AE0YxB/TolwDKuDyWjvrXkGfTNh1LneLp4Ohyg1t/haKsJHllE1qUByu1IKZnwby+KNr
         moeoLMvs0wldPqqPNf7HYU8V280iPnGeyiHuAzomROyq1RLb2Tq1UguYLjiAN6A3Ymke
         MbYRRjDnWzzESkQlncOwAs+q3pfx6nWaMJUEha7vgzEIyf8UWqsoGtAQuRa4NW2zgF1W
         UdFA==
X-Gm-Message-State: AOJu0YzGx3hJfEBxILlrcI6k5Hp0rE2Y7/B2I+FBbLohSaLprEmzeQcd
	nzfeRYzqdAlOv4FBcYKnxf6yrOUqbtnpD04ID1sPM+ExSqSZVFnRHS140g2byCqF2c4=
X-Gm-Gg: AY/fxX5JXoR11pVK20E2znHKiWbyZvySg2eTTziG/AL2m7pEiC9JKRfWhjq4g1yoKfL
	/jAW9umiacFPt/9xTQbElenOaX43M9acFkW9eDYVCA31FAnj8rEVgpVSNlxdb4OXr6nptSZArwM
	PhBlqg8Sly2F4WysPN9UJaMYMZkdZG53twMRE3QAtYoACUASnHHlT2P7lbZFRtytFTVbiNjZeJV
	cH97tqB5zaozRYK3rqxVqG7Y/ocVaIVZJbleuw2qUtpjsyKMKWTz2bsuhmxzj+iu0v7scks/CP5
	24TnHlzuvhtywaA7Q0SwYqO+ZIuuo+2eXx7sVdtDjwC0FLp076SfBv/UVoAM+4RXWm7fxA6aeAI
	JAc5njNvzACq6QSv2BGsg4oYvZTAPLBHsFSRE1M5k1u0XhLwVzlcaNXKJ7ZlazG7ZwmP7HZakLi
	zrnDJXlQisXpweBzMqeo/fwHwzWmkIhWZzCjn0PNCCW+qeD2NATXIuo/TzlrbOAFHwajLka4SuN
	ip/88l3Kv9URW1LrAI=
X-Google-Smtp-Source: AGHT+IENxy+5x2i2xgYMrz0SKExm/H8Y6u2iabD+v8jPA4ysG46WOfa8D8B0YhZSz4/3C2jKDn1FJQ==
X-Received: by 2002:a05:690e:400a:b0:646:e68a:c886 with SMTP id 956f58d0204a3-64716b34ac7mr16215312d50.19.1768251551980;
        Mon, 12 Jan 2026 12:59:11 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:5da1:5daf:bcea:9f2c])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d7f7c04sm8475793d50.2.2026.01.12.12.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 12:59:11 -0800 (PST)
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
Subject: [PATCH] mount: (manpage) add CephFS kernel client mount options
Date: Mon, 12 Jan 2026 12:58:38 -0800
Message-ID: <20260112205837.975869-2-slava@dubeyko.com>
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
explanation of CephFS kernel client mount options. This patch
adds the description of CephFS mount options into
file system specific mount options section.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 sys-utils/mount.8.adoc | 86 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/sys-utils/mount.8.adoc b/sys-utils/mount.8.adoc
index 4571bd2bfd16..191a3fabf501 100644
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
@@ -913,6 +914,91 @@ Give blocksize. Allowed values are 512, 1024, 2048, 4096.
 **grpquota**|**noquota**|**quota**|*usrquota*::
 These options are accepted but ignored. (However, quota utilities may react to such strings in _/etc/fstab_.)
 
+=== Mount options for ceph
+
+CephFS is a POSIX-compliant distributed filesystem provided by Ceph. For more information, see the Linux kernel documentation at _Documentation/filesystems/ceph.rst_ or the Ceph documentation at _https://docs.ceph.com/_.
+
+**mon_addr=**__ip_address__[**:**__port__][**/**__ip_address__[**:**__port__]]::
+Monitor address(es) to bootstrap the connection to the Ceph cluster. Multiple monitor addresses can be specified, separated by forward slashes. If a port is not specified, the default port 6789 is used.
+
+**fsid=**__cluster-id__::
+The cluster FSID (unique identifier). This can be obtained via the *ceph fsid* command.
+
+**ip=**__A.B.C.D__[**:**__N__]::
+Specifies the local IP address and optionally the port that the client should bind to.
+
+**conf=**__path__::
+Path to a _ceph.conf_ configuration file. This can be used for auto-discovery of monitor addresses and authentication secrets.
+
+**secret=**__key__::
+The CephX secret key for authentication. This option is insecure because it exposes the secret on the command line. Use *secretfile* instead when possible.
+
+**secretfile=**__path__::
+Path to a file containing the CephX secret key. This is the preferred method for providing authentication credentials.
+
+**fs=**__name__ or **mds_namespace=**__name__::
+Specify a non-default Ceph filesystem to mount. The *mds_namespace* option is the older syntax.
+
+**mount_timeout=**__seconds__::
+Timeout value for mount operations in seconds. Default is 60 seconds.
+
+**wsize=**__bytes__::
+Maximum write size in bytes. Default is 67108864 (64 MB).
+
+**rsize=**__bytes__::
+Maximum read size in bytes. Default is 67108864 (64 MB).
+
+**rasize=**__bytes__::
+Maximum readahead size in bytes. Default is 8388608 (8 MB).
+
+**caps_max=**__number__::
+Maximum number of capabilities (caps) to retain. When this limit is exceeded, unused caps are released. Default is 0 (no limit).
+
+*rbytes*::
+When *stat*(2) is called on a directory, set the *st_size* field to 'rbytes', the summation of file sizes over all files nested beneath that directory. This is the default behavior.
+
+*norbytes*::
+When *stat*(2) is called on a directory, set the *st_size* field to the number of entries in that directory instead of the recursive byte count.
+
+*dcache*::
+Enable directory entry cache (dcache) for negative lookup caching and readdir operations. This is the default behavior.
+
+*nodcache*::
+Disable directory entry cache usage. This disables negative lookup caching and dcache-assisted readdir operations.
+
+*noasyncreaddir*::
+Disable asynchronous readdir operations that use the dcache.
+
+*nocrc*::
+Disable CRC32C calculation for data writes. If set, the storage nodes must rely on TCP's error correction to detect data corruption in the data payload.
+
+**snapdirname=**__name__::
+Sets the name of the hidden snapshots directory. Default is _.snap_.
+
+*dirstat*::
+Enable reading of directory stats via *cat* on the directory.
+
+*nodirstat*::
+Disable reading of directory stats via *cat* on the directory.
+
+*noquotadf*::
+Report overall filesystem usage in statfs instead of the quota for the root directory.
+
+*nocopyfrom*::
+Disable the use of RADOS copy-from operations in *copy_file_range*(2). The RADOS copy-from operation allows the copy to be performed server-side, which can be more efficient.
+
+**recover_session=**{**no**|*clean*}::
+Control the auto-reconnect behavior when the client has been blocklisted. The default is *no*, which prevents reconnection. The *clean* option (available since Linux kernel 5.4) reconnects automatically when blocklisted, but discards any dirty data and invalidates all caches. This can result in data loss.
+
+**ms_mode=**{**legacy**|**crc**|**secure**|**prefer-crc**|*prefer-secure*}::
+Select the connection transport protocol. *legacy* uses the v1 protocol. *crc* uses the v2 protocol without encryption. *secure* uses the v2 protocol with encryption. *prefer-crc* and *prefer-secure* indicate a preference but will fall back if the preferred mode is not available.
+
+*wsync*::
+Execute namespace operations (file/directory creations, deletions, etc.) synchronously.
+
+*nowsync*::
+Execute namespace operations asynchronously. This is the default behavior since Linux kernel 5.7.
+
 === Mount options for debugfs
 
 The debugfs filesystem is a pseudo filesystem, traditionally mounted on _/sys/kernel/debug_. As of kernel version 3.4, debugfs has the following options:
-- 
2.52.0


