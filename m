Return-Path: <ceph-devel+bounces-1553-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F0593ACA4
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 08:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0752EB20DD6
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2024 06:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A91861FF0;
	Wed, 24 Jul 2024 06:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zr4NifKx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769054670
	for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2024 06:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721802581; cv=none; b=ccskicys6Vl+UuwTcQb7pqCmuRKxSPDJF+Hf7eczmq2updCQEfImk3e8cJPTQ2ffC80D7+s8AcHUhGEqampnS6iRkV1tXehNkBXYzi8ORozLeZr6mmF5KI0UQGNNct3xx/nYM7QGDN18b+GLzWcDHQHYpK/gZZhpO98KmfaDfr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721802581; c=relaxed/simple;
	bh=g6C0XvR83OIysdY7Xlzkn0d1IuJVfuvyx7o14YIZcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyHzWSKmXe7gsFv6UjFFwCsChYaLNnB8Hzl+rswg36GVoI5YgUKLcPv9vD9w8eZcgrxVUTuDAweo3NqzG6HtgFyRDlyZ00SD0qYxVqqvt6s70Pp9jJrH5bHlShIDQKiKTBIFVS0QyWgXv4TKBE1az/JGeprZxcOhEg5lWPUM7VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zr4NifKx; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4257d5fc9b7so55534585e9.2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2024 23:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721802578; x=1722407378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXgRJ3BoCz2zxEcveCDlnOETA3pLSI/q6a5Q+E7vtI0=;
        b=Zr4NifKx68mP2DNW4jELZ07g/w1DPrULo4t45VAF1Ni2qhquLTxB2RNCTb8LqdsuEc
         8fQLs9KIdWOCj/arQ03lMkRiXzlKtT1MHPqDr1XD1nPAQkx6ez7HvsnEWZa6GJ43sgM3
         YmssCUsPvGnZIlGCW5p1Dq+yHBeA5VhTBSemr7sNmRNHfq2EObi4O/s1dLJXaQftAL58
         e3nSfyCPtv5/h2gGUZFZDKdUV0FX+Y8IC8neX+PN0RFIW6HkukvQezEj4kaY63Bth+sz
         X/utgy40Dtp8F15FwZc/pRLQbIhPFUKYsQZtrkVE5jrPWlvB2OwFZ61wb5LvNAiZ6TsV
         nXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721802578; x=1722407378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XXgRJ3BoCz2zxEcveCDlnOETA3pLSI/q6a5Q+E7vtI0=;
        b=JLo2MwF7STytcaLSj1fyTseATNX5sMYJCWRiXnq6PUD4M0UXsC76lPKI3zPuGg2HEJ
         LHPK9gxoyoh+8s+/6mi2MKcgewsj/nHoXU6WwAEcydMcACKTigPhPan1xO5GbkxlW0G/
         xDBRQiEjnUnub3WYNb83ry5/OK8WgdPAzYWPTcYAjsYmOgYmGUu1QrxSGpf+iZwMqNY9
         StWsZlPbsNxqBtbPvQLZZwHIi9sPa1Stw4XGCpFmI5Yv1dYbzFW8JBmeTs1F9zI6JTkq
         XhRAVubQ8C4GyhPQEm4EE6Q9kNlBjoxHbnnftX4w1pUaBESJhZkqLlGjat83vOvPFdYb
         3Nsw==
X-Gm-Message-State: AOJu0YyW60TW5GFu46hzkDuW8yiLPRP9HTyWS76BZqW+9MUwENp/dZsm
	oIoW8X+h5Gs2VTIhJh9s6hjIIEQyfBKYO6OKUWA5Fg2IYGesby3hEPzrpQ==
X-Google-Smtp-Source: AGHT+IEP3DUVzSfneHtoEo6lHlXRFrFIqN+X+Lt2b0S6zCAQBQi8/4YxaeeZmgVn5fGVC0UJBvdNtw==
X-Received: by 2002:a05:600c:4713:b0:426:6714:5415 with SMTP id 5b1f17b1804b1-427f7ad5432mr13332235e9.30.1721802577918;
        Tue, 23 Jul 2024 23:29:37 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427f9359516sm14160325e9.2.2024.07.23.23.29.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 23:29:37 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 3/3] rbd: don't assume rbd_is_lock_owner() for exclusive mappings
Date: Wed, 24 Jul 2024 08:29:11 +0200
Message-ID: <20240724062914.667734-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240724062914.667734-1-idryomov@gmail.com>
References: <20240724062914.667734-1-idryomov@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expanding on the previous commit, assuming that rbd_is_lock_owner()
always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too.
In case ceph_cls_set_cookie() fails, the lock would be temporarily
released even if the mapping is exclusive, meaning that we can end up
even in RBD_LOCK_STATE_UNLOCKED.

IOW, exclusive mappings are really "just" about disabling automatic
lock transitions (as documented in the man page), not about grabbing
the lock and holding on to it whatever it takes.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index dc4ddae4f7eb..b8e6700d65f8 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6589,11 +6589,6 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
 	if (ret)
 		return ret;
 
-	/*
-	 * The lock may have been released by now, unless automatic lock
-	 * transitions are disabled.
-	 */
-	rbd_assert(!rbd_dev->opts->exclusive || rbd_is_lock_owner(rbd_dev));
 	return 0;
 }
 
-- 
2.45.1


