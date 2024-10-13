Return-Path: <ceph-devel+bounces-1900-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E496999B7DC
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 03:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E1FEB222FF
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 01:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DC74A18;
	Sun, 13 Oct 2024 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="lXSXnZ2o"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F21617C9
	for <ceph-devel@vger.kernel.org>; Sun, 13 Oct 2024 01:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728782211; cv=none; b=mCFaYRQ1J2YEdnPoXb59WZNott+DDopcWkTa0ZlbmlrxCjGiygxN53eggF1WVpGNB1iGb6ioa7djh+WQ40O2bO0BNjeUNvk9vAj5u/abRKqrjypSeDS0sUgUyKjUTVadchj0KisQuux4mpSbtmEN0BkkeWvFxUKrZrlAPrRuj0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728782211; c=relaxed/simple;
	bh=Rs0WhVYlqwQ9GIF9wqpRbWP2+E5Qn796AkiW/OgXwcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mwaQXJ1+8Zz3CX+dpnpoo5cYF6Qh4fa64IbM9IFBRzpKdW1yzq3JCgkUYBN6dnSnVgYJrkWgjytDZ4KVNDK4oug2Q04sFLxgMeuQUfkf4iRtntPyV6LkGGHe/7VpFNbue84zD8TViq3E2PptTQYtR9I8xqx847u584XZYZLJYaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=lXSXnZ2o; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7b11692cbcfso220532185a.0
        for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 18:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728782208; x=1729387008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+sk6LUiLeleXUsSllRpsc5OH3Y6ZTlzg70lgLuDUR68=;
        b=lXSXnZ2oS7w0xrt7652xlz9ebLAnqDITGQe1ymKSSx6HzDMyuITsS6HMdMaHEYoHGr
         usDy6s0nC+LRzSOogPKpn3/aCFRBeFdOjUCtBE3k75JPRpnnowoGWjrRhk5QeTKsOFna
         cUrLeGFrcQ5Ud3weqtZn8ZGAoiWC4CewJvyGyYCp3IiVRxvhFsA4CCO/am5oko+K/b1C
         YI8+PS/0nScNip2+Oj7bC/nCl58fGrD/GTTZVu5vpwvQnbpjdcM8K8W/bIrr5AhPGsZX
         HzGhAqvjKnTQuKsUxNdbrNBd7MLU6nnvgS9wPeVyKa8eS9IzVwixGBIPSyyCFb/aeqRE
         r9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728782208; x=1729387008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sk6LUiLeleXUsSllRpsc5OH3Y6ZTlzg70lgLuDUR68=;
        b=MQ/EkVIF+OD1C++Msb6Ly7bPs4TNH2Ji9XeTNsxoTWKcp6X4fnjiC7dDCoAItETiD1
         FxBzlHgf6rMKYo9d2W1IwYon6oUydZZOQBtZop8y2Y3gz1CSdnCLy7ZlxFYpiKNgZwJn
         BUkkFhdHP02y4lK3l9sgm6jLPCPxwnqDsmDT5ITJiq8w0/JlWChCyW2+zV78i7LYgZGL
         lz/v3q/L7rxiSbeJlRuVpbgkmTMeGG3hFWcVnOJ0t3iqw/AVXfOdZJm0yy8vnIgQHaln
         zoCwfe7oTroOQ82oVWwQL6JKxownuPfIWQ2+Oght3nL0N2e2SZSBQvLRl6EaUKpsY5m7
         erZg==
X-Forwarded-Encrypted: i=1; AJvYcCUV7y5I9KDDkD2arGrltIoczZHHquZEqKwE4+PJOtvM2yK4VlsRQCHRtVI5SIcoI1saSghTeZNZULEk@vger.kernel.org
X-Gm-Message-State: AOJu0YyrOkljR/t+u1TMrGopw/0ME0xth9ITnOpe/K4lJE6mfthN3Wgj
	PHbV48wCWc5OhSRi58MClheU/1Q5dO12mufZKz5vlYzTjjcs0It/8aXzXRMhxw==
X-Google-Smtp-Source: AGHT+IGTmQ1sCNGvxvKC+B7rM8+rg2NN9YCFVlNQ5vOIyaUhlkwDzZptdz/WbPjvm/E9Ssohsb2QKQ==
X-Received: by 2002:a05:620a:2950:b0:7a9:db7d:11f5 with SMTP id af79cd13be357-7b11a36f4d9mr1209601585a.25.1728782208407;
        Sat, 12 Oct 2024 18:16:48 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b11497704dsm273414185a.101.2024.10.12.18.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 18:16:47 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ceph: correct ceph_mds_cap_item field name
Date: Sat, 12 Oct 2024 21:16:36 -0400
Message-ID: <20241013011642.555987-1-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The issue_seq is sent with bulk cap releases, not the current sequence number.

See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_item field name".

See-also: https://tracker.ceph.com/issues/66704
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/mds_client.c         | 2 +-
 include/linux/ceph/ceph_fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c4a5fd94bbbb..0be82de8a6da 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2362,7 +2362,7 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
 		item->ino = cpu_to_le64(cap->cap_ino);
 		item->cap_id = cpu_to_le64(cap->cap_id);
 		item->migrate_seq = cpu_to_le32(cap->mseq);
-		item->seq = cpu_to_le32(cap->issue_seq);
+		item->issue_seq = cpu_to_le32(cap->issue_seq);
 		msg->front.iov_len += sizeof(*item);
 
 		ceph_put_cap(mdsc, cap);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ee1d0e5f9789..4ff3ad5e9210 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -822,7 +822,7 @@ struct ceph_mds_cap_release {
 struct ceph_mds_cap_item {
 	__le64 ino;
 	__le64 cap_id;
-	__le32 migrate_seq, seq;
+	__le32 migrate_seq, issue_seq;
 } __attribute__ ((packed));
 
 #define CEPH_MDS_LEASE_REVOKE           1  /*    mds  -> client */

base-commit: 75b607fab38d149f232f01eae5e6392b394dd659
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


