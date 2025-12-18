Return-Path: <ceph-devel+bounces-4193-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B23CCABD7
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 08:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E9E09300D66F
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 07:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DD32E36F3;
	Thu, 18 Dec 2025 07:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtqz4OTf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9393822FF22
	for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 07:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766044581; cv=none; b=rco38NYd5Qb2JEGHWq0VJPNti6nAbhiRiefpYZv/U8nlRgu5cnI0P9C63sqyrI20V8p1/cPIoNiGP8QdQ1UplXcCO+pEHajdGLbpqcOJ8reVr1HYB4Qf89QqJmp/3kp7Eb4MuKgvN3i59KJ6BIzvrl4aN9+7dURx/YUJX1lf03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766044581; c=relaxed/simple;
	bh=qUhv/WVO97iNaIQ1FzvXmfWz4JvCFSI9eW4uzD8Ds20=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nRr0eZl44WiC+f3WUwziNTdRcY65Gqs/dGmxcmVc/39Ip1TJdFzod9GGUOFeEy4OfJXu7lBQfy0LTcvxld49x4ES/8jnV/EWw6E8Kbj7Oah48mAvY9T3Vg69sbHT+gsAAe7f6AE2pqIKoUWExSlobdxYn45RiKSRzT1y4j6LNkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtqz4OTf; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34c27d14559so281966a91.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Dec 2025 23:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766044579; x=1766649379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MMkuXW4b3ShoHrgyNV0wgRq15Ymd9snXpguC9jssOUE=;
        b=dtqz4OTfhzikNX39QKYuDK17ftqgNkcnb81CzxYrZK/XSVmk8x74agt8uOC0BNAmMw
         IX2Amb4I+q5mXi0iexqr3uj19AnqKEUU557+CJZ930wqDoW+/w8o6a7F9NRehu4cUgmn
         Q0iDQDP/YGA5llvQdONosgVD2hspVnZtTTXgoCFjosvA6T/4XmuKjWxC1R3lCzg++uIZ
         Qzjl/8BjHYjTWKvjEX/qwFq7htYjYKvvWMnrvYMOk6g4tzjzMefB+kE1PctO3w0haLNK
         /N+RGJPa5AYh6aeNl/+0UZ4MDylu58SuNOJYg9DXTNr73XZsSCEn65zjqPKz1vZ+fJIZ
         i3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766044579; x=1766649379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMkuXW4b3ShoHrgyNV0wgRq15Ymd9snXpguC9jssOUE=;
        b=xOhSycPuKwwjRoIEOhvlMsWRMtTIuH0i0MkSqlv+NfCqNAblSfeUyKdKuha+Tkk6p/
         2bRbu5sUY0Yu2xoKIhNHnfHIMtO7jR9g3WcBZbt7SdQCw3jLTRw3DLVW5scSAU21KbND
         7vf3gUwWC6gND0DfjunHCUQJREnSCz6Oo1MpMXuRpN5CyPBwcN0QsqorTGv8KYPLrq2L
         pqktHC3XRdPiTwZQZTYt5WN8UBwRnkEtIY27xgJW526uWs6wH5LXA1+Txn0IXowSXd75
         x8eEOfeZ/lftT4YGele13cwuTcP+IBWZGqOQjZsZP5XyH6HM6FYSUJAM44KfZYIrCq/N
         24bQ==
X-Gm-Message-State: AOJu0YwMqMlKQ3PcCspQQd1d16n3UZ4QxOIG2DRFKisGNO5wMSn1gt+T
	rZ1Z6qvcfhEZCqWljl2ttpfLBuUStfIfD53kwvlKbYPlubtM1fLzX7Ep
X-Gm-Gg: AY/fxX6qkws1lx1p32J+3z5tn01c4UczKfVSe0QQfjEaB5ZbqXU4BukuUhtfJC/+loi
	rmAM1sSi61Fd4uc2oDhx+UvGq+Tg6No2m+7OGZI2Em/cB2a3kziIqtOr0YbAy4j75CmFRjQS85/
	zvbaagBqkBjfBMTX8diQ/6QyuzywkCEllqAb/JYkSXGDxykoxG2wb+Zamupe18X3szJmDswi8p/
	s68pNPYY9XsnMjWY0Q5CBfcFsOHfthzrwAO6axQ5Irsm4opMkZs/70IQX3YJ9YHZJuiqRlyDcQ8
	ARap0HgFkAnndE5RkK7xn5Zzgh5LA7x/UsjBe2gh6o5rVnwUXpM02LJx121V3aiRKnWyQzqr2ch
	0GSGVy9FtwsTdcu3pi+VvTPn/yUqKZX0nFjNECgm/S7N79GOrJyyfcX+oyHqCGGmKL98Yby0jk/
	SgF/5Muvlj6UChvPuYehM/pqRvVkIHqTIfyWP+tiSNQ0AdxNzBx08p/WnxvlWgQr7JCCXkvhQUa
	69FT3hhLs0=
X-Google-Smtp-Source: AGHT+IFRXXg2xmw/l/+q3DDAOesT1rj27CThyNJNgghkwc7rlSQV1reOiXw4zSJ44hj4CFuxeU5JDg==
X-Received: by 2002:a17:90b:35c9:b0:33f:f22c:8602 with SMTP id 98e67ed59e1d1-34abd858b3cmr18258188a91.26.1766044578847;
        Wed, 17 Dec 2025 23:56:18 -0800 (PST)
Received: from oslab.mshome.net (n058152022071.netvigator.com. [58.152.22.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d4f7d3sm1664430a91.4.2025.12.17.23.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 23:56:18 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: idryomov@gmail.com,
	xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH] net: ceph: Fix a possible null-pointer dereference in decode_choose_args()
Date: Thu, 18 Dec 2025 15:56:03 +0800
Message-ID: <20251218075603.8797-1-islituo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In decode_choose_args(), arg_map->size is updated before memory is
allocated for arg_map->args using kcalloc(). If kcalloc() fails, execution
jumps to the fail label, where free_choose_arg_map() is called to release
resources. However, free_choose_arg_map() unconditionally iterates over
arg_map->args using arg_map->size, which can lead to a NULL pointer
dereference when arg_map->args is NULL:

  for (i = 0; i < arg_map->size; i++) {
    struct crush_choose_arg *arg = &arg_map->args[i];

	for (j = 0; j < arg->weight_set_size; j++)
	  kfree(arg->weight_set[j].weights);
    kfree(arg->weight_set);
	kfree(arg->ids);
  }

To prevent this potential NULL pointer dereference, move the assignment to
arg_map->size to after successful allocation of arg_map->args. This ensures
that when allocation fails, arg_map->size remains zero and the loop in 
free_choose_arg_map() is not executed.

Signed-off-by: Tuo Li <islituo@gmail.com>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index d245fa508e1c..f67a87b3a7c8 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -363,13 +363,13 @@ static int decode_choose_args(void **p, void *end, struct crush_map *c)
 
 		ceph_decode_64_safe(p, end, arg_map->choose_args_index,
 				    e_inval);
-		arg_map->size = c->max_buckets;
 		arg_map->args = kcalloc(arg_map->size, sizeof(*arg_map->args),
 					GFP_NOIO);
 		if (!arg_map->args) {
 			ret = -ENOMEM;
 			goto fail;
 		}
+		arg_map->size = c->max_buckets;
 
 		ceph_decode_32_safe(p, end, num_buckets, e_inval);
 		while (num_buckets--) {
-- 
2.43.0


