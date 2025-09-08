Return-Path: <ceph-devel+bounces-3560-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DE5DB49873
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 20:38:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05F7B7ACD6E
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 18:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75DD931B809;
	Mon,  8 Sep 2025 18:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="DhdMIUn6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFE30F93D
	for <ceph-devel@vger.kernel.org>; Mon,  8 Sep 2025 18:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356667; cv=none; b=AS6nNNYXjjnorJU+eV/4BQB7Y52ItYgHuhXYA7JX0rFTIuN3hTDrhExURhSaD7Mw3yp5WMyjnJoOyPLpiIZ60FNakG6JUlOSLsWHBHphgfv47LVbzQXp3/EpZVtl7bbUnHiaT+Co8Yizg/yCnKfsc/F1eUbJQIWNjpfE5EPOqRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356667; c=relaxed/simple;
	bh=naqO89vSOyeXTBBgns+p5M5J7Oz56gjzzJXfxlrHQ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W5MphmeQZP0BtTw9rlpmyVGqRW+RXccjddDxtbdyeTeHlQzqlsRcdMShGmh1rrEX/kKUEp7bjc2qgcbXzo3K6EEVTtgse4C2taEdz++E6oni0/43C+6Xsnlho6LE/r9c4RuD4fH6LeU8VgeBvO/hP6K4aX3PzAWW10FRpMQUf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=DhdMIUn6; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d6014810fso42772507b3.0
        for <ceph-devel@vger.kernel.org>; Mon, 08 Sep 2025 11:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1757356663; x=1757961463; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YgGQycmClIa+ShcSNbH+2BUvPBs54QxzARtkevxCKcA=;
        b=DhdMIUn67ckVRX/8i1WXVq4zmxf6wJpqkVRHHdyexMVuTjMpsjPLi2cDqdZ4TddQ75
         iIJfa0tAUoahsC74EXBEmvJ4VwebpuqtIpWkf+UjF25btSZpGsA4U0tVdGyr/keXnifo
         AjMYRFOsYSVWHUsxvE8oCXJqVPLoHpHivnTW6KPt9shbShaqchiSiLuy7S8bcLibFAnh
         EgaM3XrLni2SpspcnJBgR4+8i+a7XSR06b6rdYUnhVZZtH3EsVYwfKGR1Yoa2Fe3s9Q7
         RboVrzyv0J4B2q7AxJRsu+BR6bTdLlE7MwX0NZ+OrvUL9rAkcPcNcWmo7PR29ufvEkE0
         jpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757356663; x=1757961463;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YgGQycmClIa+ShcSNbH+2BUvPBs54QxzARtkevxCKcA=;
        b=cT3IWa6vZdFPLwHH4xZaTR/hyQzWAd8jIqPGS8bhfvvRbCTUgSlYe3Xx6+IM7RjO1U
         6qiF9+LibZoCcFC5TMrB/PSEhR6kWtkzE6E3QJ/jWmfi03pnEPcSqy2ihCUwgTpgdhzp
         7sh0s5Mdw2TqSjMwifIbJ/ZU0/MoXRWST+5MnxP+aWXQhv/q+c9x8py49rylZ/F9/wLr
         Vjt+7c4+uLhcSSBdn3cA+4KFEUaHKK/xJCyAl/pBes3lI2lDPusInOG+sBLPi2sQwI/Y
         BYgw4eMP4oggDEbBxJ3A8faKheM9e+ttqdIo8Vi0j3XbmpSYBF1otbSGWV038IJUXIf3
         LUQg==
X-Gm-Message-State: AOJu0YwDFpbPGc4+JS1wO3Nj0mnSD6mqc0LmLEZQ/0r4KTgCaCXesA1b
	vlEjGXtchb5DuNpeqe3k+px2hmrFMdF/ggkGDIX0AlXjsc1J7JIE8Vtoo3sK1SBXBM855l25xUC
	lMZpoD/c=
X-Gm-Gg: ASbGncs1JON/fzIAoboJPFWb3zeWa7o+4WCNmjjFTcx29qTyPdsuclqSHm7KtvCNug/
	Vg87sNVfz3eb891ml27TKVcnt5lJvcU7QewZJxZ6oBpJMXTBY1jRYhaa1IuhqPIuzu3Wq6wFC1I
	8KKZSOGFtwjLkKwsa7EhcCShRO36/9IBwC0o/acZ7yfjautc89SlhG5x9ws8iwDZ5CHb6h6DpFu
	zSTvVr9ZEXUI1KDq4OL5chj3ykzA5ReQAhKmT/ovB+EkJ55sbz7kNdmUQQaHaxYD8iUTUz6aNeS
	RAhpZkPs0duJNc+KgMYGOvTkTizza1kTtog1ozGnqnQhbVOH6iIOksX7Tbq3sRbKsOgaNJSPq1c
	9+2JhxPyP5VVE44l3ybzND81L0241hphYq+kDsJ14
X-Google-Smtp-Source: AGHT+IHJwOEaYNEwhDFYKpOG5zDF1keBM7TigRfJxMnjrTs21qRd/6AmYj8DmXH8zmiqUMQlztaQdw==
X-Received: by 2002:a05:690c:4b0b:b0:722:6ab7:f652 with SMTP id 00721157ae682-727f5a344aemr72652107b3.51.1757356663183;
        Mon, 08 Sep 2025 11:37:43 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:5d01:275f:7660:c6ef])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a859ff2fsm55140397b3.65.2025.09.08.11.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 11:37:42 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com
Subject: [PATCH v2] ceph: add in MAINTAINERS bug tracking system info
Date: Mon,  8 Sep 2025 11:37:18 -0700
Message-ID: <20250908183717.218437-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

CephFS kernel client depends on declaractions in
include/linux/ceph/. So, this folder with Ceph
declarations should be mentioned for CephFS kernel
client. Also, this patch adds information about
Ceph bug tracking system.

v2
Ilya Dryomov suggested to add bug tracking system info
for RADOS BLOCK DEVICE (RBD) entry and to correct
CephFS and libceph maintainers info.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 MAINTAINERS | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cd7ff55b5d32..787365f2ef26 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5622,23 +5622,28 @@ F:	drivers/power/supply/cw2015_battery.c
 
 CEPH COMMON CODE (LIBCEPH)
 M:	Ilya Dryomov <idryomov@gmail.com>
-M:	Xiubo Li <xiubli@redhat.com>
+M:	Alex Markuze <amarkuze@redhat.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
+B:	https://tracker.ceph.com/
 T:	git https://github.com/ceph/ceph-client.git
 F:	include/linux/ceph/
 F:	include/linux/crush/
 F:	net/ceph/
 
 CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
-M:	Xiubo Li <xiubli@redhat.com>
 M:	Ilya Dryomov <idryomov@gmail.com>
+M:	Alex Markuze <amarkuze@redhat.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
+B:	https://tracker.ceph.com/
 T:	git https://github.com/ceph/ceph-client.git
 F:	Documentation/filesystems/ceph.rst
+F:	include/linux/ceph/
 F:	fs/ceph/
 
 CERTIFICATE HANDLING
@@ -20980,6 +20985,7 @@ R:	Dongsheng Yang <dongsheng.yang@easystack.cn>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
+B:	https://tracker.ceph.com/
 T:	git https://github.com/ceph/ceph-client.git
 F:	Documentation/ABI/testing/sysfs-bus-rbd
 F:	drivers/block/rbd.c
-- 
2.51.0


