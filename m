Return-Path: <ceph-devel+bounces-3546-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FE1AB4643B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 22:04:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77FA7BA04EE
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Sep 2025 20:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BAA303A29;
	Fri,  5 Sep 2025 20:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="EAguRtY2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70912303A16
	for <ceph-devel@vger.kernel.org>; Fri,  5 Sep 2025 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757102540; cv=none; b=TGWtB+ztPv7AW/4aCd37KElgwodNZOclx5OoI7ARnq4FJHsmdYjJE+84CYRAO6Ee9As473Qt8nmTODfxhXZwx5eDBngEJK3dqeYdgnz5W4bUd8g4J6+V6KR1iEIP0uttsXNdotXx4+rvJNgQrs1PTOuA2sMxpg6XgzKF+0JygAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757102540; c=relaxed/simple;
	bh=R5VY6nFTVfGSebVpZ1YPlT3if9W4sV3LuVBesg1T6wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8d8VcsACojYEEY9ViHtTHZCrXCrzhQFY1Z8L5+POHgFpZTcdbzWl62dg8CkmMwTQyj0EUeuhJ9lXWbfp48Iy3xe2dDwSDXrOLRIEOYsHnojjFSQKnLJxGdEuUUK0CojZfkdvv+XuVbjIl4k36XKwvtlFOqki0MBE3f77ZNKLC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=EAguRtY2; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e98b7071cc9so2497554276.3
        for <ceph-devel@vger.kernel.org>; Fri, 05 Sep 2025 13:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757102538; x=1757707338; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9c8qg6RGu3lrcJVE2kpke88dH1EB0WDBNOTCGY50nk=;
        b=EAguRtY2xoj7qgmBZNf2xyPmiHBPAczR/exy70ezYUdUcBMiXcgO0PoUOispRpbyCe
         N3cvtQcwyYe5F5D924HQW3Urb/CX3fRaVhy81dlZA6tfJSOudbNOAR23oyY5bdkXDNBq
         KKKf9oekq6xjF5Aoc/pjId6B5kIyvJ1wK7T4ljRR/oSVXzV18U22XgF68ZApXmvcgjlN
         /S0cBsLuXl208OcX55cETHf+6AzOxmhVt5f4eDamUtjU2hjjXdJKoO4MxZ1eMYx11WmT
         vNwrw9V19vJyICkJ0a5qI2K8gNA9XsJ08xAhUE2O/Yz3wRDpGKG79o5ucYSF0AmY/PLy
         +UWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102538; x=1757707338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b9c8qg6RGu3lrcJVE2kpke88dH1EB0WDBNOTCGY50nk=;
        b=bS6Ae+Xnof8F9py5fk7S++HsBD9/FzjIsIGfUm9FjS0vUtv4TXoVjVmnGyvFqgOMug
         /ARkwIruZlY58YK2FAhmvVmjk2jsgxpTk58dRWu2pNMUwqhzdn59sH+PbWvKsde9E2I0
         VsuSwzWTp02NnUsSs5kkvYzQMSVcRBU9kdwP4NHnWk4E/yea95IOyhJ3JOYna/L0L7eH
         AdgKgMEix84OinrWjJVpflyy82lm9rvQbBzJMvhGczRVtRB/LGsxjCxLw5ZjBHaF52JR
         528jIp8tZlV62MIb9dwyRUJ/3u8s1x5mWhWBS6AzNoeLZjhwcq1qKxvNCsesi/lRyAGX
         pRHQ==
X-Gm-Message-State: AOJu0YyTRA7y0mfade7DSpv3w7Jngfe3Jjv1+OUX2f8moOTrdhhL0ZdR
	EuOHq7Q6+wltKdSJoWkUBb7tt/ndyogP+QoQu8+FaE1Md+Zbri1Xul/Zx9sACEJlkmu8Sxh+Iqc
	p/X3V3Rk=
X-Gm-Gg: ASbGnctVPuohKXo3wK52VAe604WR8q4ss52Lg6bL1OlMteLqwbIqIBVf/+F5opqzhd4
	MlcafbUSvHo5umTXbMHYeBFCotL8PZEN45QAgy/82z2Q3PN2gK6NsL6yKpmQCzIquqC7lTK2WJV
	gMA1NIDeqyHCVszVvXzwFrFyRQQoKiHnRgFvgIB+8XAW8PPvJla0Yc+4OgPAEXG1yeAZH6nqwhe
	RdklFcaMzhw3PIZmO5OfzL8d6MfQsSerzJIcWw8uADLfv6z0xPJPUxPzl5KwNJ/xFW+AwYImIFw
	3U07bs3qH6r5YJjNIjx7Z3Fi8y7hb1ghBu3B+wVttHIjxZRYccLZp+K9EPaLtXuB5ExCaTwmiqV
	t9Lz4PfJzc5H1AOtlu7iQn9CcSFOdyWxqFKlyIObY
X-Google-Smtp-Source: AGHT+IFcxWYqAKX+hUU+AFqPHwKOHFWMyhWr1zxuaiGXI7/57avRymGDJ7wfeVMUuArXeoWG6IudLw==
X-Received: by 2002:a05:690e:d58:b0:600:df43:1eab with SMTP id 956f58d0204a3-61031b96a0bmr196087d50.19.1757102537672;
        Fri, 05 Sep 2025 13:02:17 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:2479:21e9:a32d:d3ee])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm32360857b3.28.2025.09.05.13.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 13:02:16 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [RFC PATCH 18/20] ceph: add comments to metadata structures in string_table.h
Date: Fri,  5 Sep 2025 13:01:06 -0700
Message-ID: <20250905200108.151563-19-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250905200108.151563-1-slava@dubeyko.com>
References: <20250905200108.151563-1-slava@dubeyko.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

We have a lot of declarations and not enough good
comments on it.

Claude AI generated comments for CephFS metadata structure
declarations in include/linux/ceph/*.h. These comments
have been reviewed, checked, and corrected.

This patch adds comments for struct ceph_string
in /include/linux/ceph/string_table.h.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 include/linux/ceph/string_table.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/ceph/string_table.h b/include/linux/ceph/string_table.h
index a4a9962d1e14..ac75feb58007 100644
--- a/include/linux/ceph/string_table.h
+++ b/include/linux/ceph/string_table.h
@@ -7,13 +7,24 @@
 #include <linux/rbtree.h>
 #include <linux/rcupdate.h>
 
+/*
+ * Reference-counted string metadata: Interned string with automatic memory
+ * management and deduplication. Uses red-black tree for efficient lookup and
+ * RCU for safe concurrent access. Strings are immutable and shared across
+ * multiple users to reduce memory usage.
+ */
 struct ceph_string {
+	/* Reference counting for automatic cleanup */
 	struct kref kref;
 	union {
+		/* Red-black tree node for string table lookup */
 		struct rb_node node;
+		/* RCU head for safe deferred cleanup */
 		struct rcu_head rcu;
 	};
+	/* Length of the string in bytes */
 	size_t len;
+	/* Variable-length string data (NUL-terminated) */
 	char str[];
 };
 
-- 
2.51.0


