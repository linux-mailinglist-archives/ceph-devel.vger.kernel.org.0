Return-Path: <ceph-devel+bounces-3118-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D01D5AD9484
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jun 2025 20:35:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91F961E084A
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Jun 2025 18:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301E522F74E;
	Fri, 13 Jun 2025 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="Z1d3Phmg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4CA22A1E1
	for <ceph-devel@vger.kernel.org>; Fri, 13 Jun 2025 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749839712; cv=none; b=sWJc5wNvJRnlcxyXg2zsnVIT1W0PLzFQbY4AtK3V5bMbpk38dCLtK8pl6AGIdD2qp0hoVfmwh9k9yMmkaVbbaKL004h+OqmbHeSmiOaPI1HyC5LA+EuusxzEEk34nXBhrHbU+05Qxynth3wmnQJET7a47Q+4dzQjWFMc/0+o6cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749839712; c=relaxed/simple;
	bh=FzYI0Sker9fDBJGCSx1RvHWGeovX+wUmWT8o/1P8AS8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sx5Ft4w1lPXtfBh16lzYF3k1vglJ0/PjHXW5cIeuVSAM+1g9jH++AZhAQ0apNKqkDkcyAUbI3Gu9LM3Kl0bXAZdu5EOr5SB0YMFDUmlTXN8IUontb0cuEj3oQJdEfLqgB6ygqyDQaPjGdZzntLl/iZHH1+NyfSzTMZ8lOlWsaTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=Z1d3Phmg; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-70a57a8ffc3so23437087b3.0
        for <ceph-devel@vger.kernel.org>; Fri, 13 Jun 2025 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1749839709; x=1750444509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3OGn1R/yKE49/2aRgFT6tnkBXQ9m5DSCIwvtHbEVlnM=;
        b=Z1d3PhmgZQI/Sdrk4bUELJ1/i/dBq2R70hcqKwQ45GQ27SH2EaZ+7k0QAjZZjNpgjH
         VFBTFE1tM43gJNtbsOvEA0a2ErLb3l/aIOn5+GP+v7lLHxkTQx8CrATvnK3lVdEjeQWk
         lgDxGLDTN4SGHWWOImt7PYfiUuSxUJTcSLl1pUJdXrrIv2/WxMe+PwXXWAHoFHFyzprw
         NtfrfXJGH67+j4nu5QG1jQvJO65INrO6N85hMKcCL4Xadce7SlxVM1+56rFHqPvKyIu0
         NFhrjzExVC/HdkZSUs03WCSRBxxzEyn7/2XxkgE+ygnMr7Eacnf9QiVxjM8dGCpqRN9c
         5ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749839709; x=1750444509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3OGn1R/yKE49/2aRgFT6tnkBXQ9m5DSCIwvtHbEVlnM=;
        b=rEtxUuEEw5soh+OXzh2dnZUUlg/DN8a5IpvUErgjAw5+7NY4L7+LdooVK1+4yCeMxx
         yFS2WllXgLN7jPZiPVd2Fv3nyLH0h952vJljfncigmch+sbx+IcQRYigXknHizKxuiE2
         OkOuhcJn6BV56G2GVeJszjJAG4iLvJlu9BGPHqofBkRuy9earXCxs3sVq3iiuZVQswUl
         g8nQUzV7lvUOfuXnotUzOF/s73vDgPFlIsxygTlGXP+TuOiUn165XWQfNmLoLsGrMQ/w
         mulDCoYJ8nEoimLA3My2yObBGpFfNP3v8jY/biMc/mzMa29JpZ+QPhRa5lfE89O2GLnE
         fgmw==
X-Gm-Message-State: AOJu0Yzr3vneW2jEZl9PyhCCDfsUBnFF2Dn2yA2lZrJntIjKBErRQt+S
	k9kyyRHk68e2V2Wm3g7th8+xRE1rQgPlGQ/jD0loJaiP/pOsEqfCXLRSpn/8WWydrcAkjLVBBcJ
	YEaJN
X-Gm-Gg: ASbGncuozg2HAot9IqR9uyOh2+iC4N70d/eP6K2sGaj2Hxp0gFWCJ4kt1c1Rxdh4FAb
	2fvoyULXnFzQtp9jH5jP2pNq5nGDyMGz840i7jkId1jnhxXjwmsTbrtLDg8SvNfYovX2/Cvicbt
	GRFV39Dh6O+odkWxUgUAwHSSxi71GPMhbgIG0NrUHh5xqfuJYp1Ys3m2mwbsMAYRRQWqsLxDJIh
	BGJgFF0EfQG/3Rn/GxcPUGWbpOX+HDJfXqt8NBh8xWZowZgNMGONWy+bNGy4ILTPZP06BM+D2Pr
	py1Y6nfQM7yVAfLhtK2EUwaCsdU46aDebVlwgU3ZIp04jBHrgpuNSN8ftDVx3ktxKLzaTVfIz04
	/SXrB
X-Google-Smtp-Source: AGHT+IEYQFcJLX8r6gHZUenmje7qRbAY6mp/2ab2kp/Vqwv3zjm9WKy1xxuOGiPIbEVuaCMSoe95cg==
X-Received: by 2002:a05:690c:3688:b0:70c:a854:8384 with SMTP id 00721157ae682-7117545cafemr8261317b3.11.1749839709594;
        Fri, 13 Jun 2025 11:35:09 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:a998:6e10:dab4:a72e])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71152059c22sm7407097b3.4.2025.06.13.11.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:35:08 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: fix potential race condition in ceph_ioctl_lazyio()
Date: Fri, 13 Jun 2025 11:34:53 -0700
Message-ID: <20250613183453.596900-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has detected potential
race condition in ceph_ioctl_lazyio() [1].

The CID 1591046 contains explanation: "Check of thread-shared
field evades lock acquisition (LOCK_EVASION). Thread1 sets
fmode to a new value. Now the two threads have an inconsistent
view of fmode and updates to fields correlated with fmode
may be lost. The data guarded by this critical section may
be read while in an inconsistent state or modified by multiple
racing threads. In ceph_ioctl_lazyio: Checking the value of
a thread-shared field outside of a locked region to determine
if a locked operation involving that thread shared field
has completed. (CWE-543)".

The patch places fi->fmode field access under ci->i_ceph_lock
protection. Also, it introduces the is_file_already_lazy
variable that is set under the lock and it is checked later
out of scope of critical section.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1591046

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/ioctl.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index e861de3c79b9..60410cf27a34 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -246,21 +246,27 @@ static long ceph_ioctl_lazyio(struct file *file)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_client *mdsc = ceph_inode_to_fs_client(inode)->mdsc;
 	struct ceph_client *cl = mdsc->fsc->client;
+	bool is_file_already_lazy = false;
 
+	spin_lock(&ci->i_ceph_lock);
 	if ((fi->fmode & CEPH_FILE_MODE_LAZY) == 0) {
-		spin_lock(&ci->i_ceph_lock);
 		fi->fmode |= CEPH_FILE_MODE_LAZY;
 		ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)]++;
 		__ceph_touch_fmode(ci, mdsc, fi->fmode);
-		spin_unlock(&ci->i_ceph_lock);
+	} else
+		is_file_already_lazy = true;
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (is_file_already_lazy) {
+		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
+		      ceph_vinop(inode));
+	} else {
 		doutc(cl, "file %p %p %llx.%llx marked lazy\n", file, inode,
 		      ceph_vinop(inode));
 
 		ceph_check_caps(ci, 0);
-	} else {
-		doutc(cl, "file %p %p %llx.%llx already lazy\n", file, inode,
-		      ceph_vinop(inode));
 	}
+
 	return 0;
 }
 
-- 
2.49.0


