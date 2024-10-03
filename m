Return-Path: <ceph-devel+bounces-1873-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BB9A98E7FE
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Oct 2024 03:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D28C1B24ABA
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Oct 2024 01:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484CC13FFC;
	Thu,  3 Oct 2024 01:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="QZdyDH+Y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9362DCA64
	for <ceph-devel@vger.kernel.org>; Thu,  3 Oct 2024 01:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727917525; cv=none; b=dszB1t6mt/Sac6ty9JRrJXpHVdROc3Pn9LDf4NdujPDFJo11gRJZxG4EYBRlfNU/xcJKReXoixScvLYnfWCtTdkiPTzSPec6hmYKUcNA2lu58T9rgk4jeFx+eDS9hl4kgTQvUlz32nps2XNGCwXFvLOiDaItbnGQiJfptCcK2nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727917525; c=relaxed/simple;
	bh=8m0LTNxY8OvkDg1Sq4Qwbt1zzAxA2+w9iBXhwVsgBnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mEf2npApPV2EaDKY0xTJWHh/VGBtnYKQy+EpiSDt3KoDdbNXM4P9L/BJ8eoW/BZdGRk6+hPCuTpi3aI+OX7a+Hti7pOFLllpQ4YEZcWvq2vamaUZEiZxgRm9ZmUXISsnBI758eLXdHaA9KPTuWew6mXW+qERC+bI21mTPADWvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=QZdyDH+Y; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a99fd4ea26so35831485a.1
        for <ceph-devel@vger.kernel.org>; Wed, 02 Oct 2024 18:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1727917521; x=1728522321; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QzuPQdSMxP55/NS7Cyi/Z68z6m9/+JyCS/Py90nZCwo=;
        b=QZdyDH+YPUfHhfzN3+10kZbC1/IWpArqNswUwmaCwZhcbVaYU0153Zssn0s10ulX+L
         /cb44IYj88wK2uaxxEt4cRB9Bfxzmmq9uJKLZdbT8atsR9VJiwc+2j0+VKeuVttG9sNe
         he/IQlb+du7OerKQ+JA286ANeSWtq9PPuN/34QjbyrI2XP6/0HpgUnS8thi3nlGHkg6Y
         6XEhZUdBsxEVzH2zk5zWzLB9Sh+2eYTFguwmkFG9Lk8BoXbmZYjUrI1bqaezWRTE0tqg
         uCzzVuqzXDVaforoSGZyl4IfOE+nFFnu2rhEQs2/T4x2WzVci3dNsJNinkUmfSAL9Inr
         Ihcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727917521; x=1728522321;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QzuPQdSMxP55/NS7Cyi/Z68z6m9/+JyCS/Py90nZCwo=;
        b=obp/YflOOimYU9OvxDQ5QDAmulUg9NX0eDq3zL8gfP+ZQjBeOJHPqncNR7qqdFNIcb
         7clOsOFOirCzjGmvVbAgygwWTB9JyVCEh3GC4N5/NdeFA29Aigl5272LKm7JpfMCBOPb
         TkmZWmiozrBpqA4aezT+VMAhfQb1QMNZnacBYMjNQX6XG0ezqoGb9mpU/5UNVn8k/SDl
         JT6NU0izT/udU/WlVCPEqI55QSGqDkyOPPXrRxUV9s6VB0S6mPvyrZ+ky3+y06VDEYng
         ofGrFS4DiULeyDk7qi2C2k6+ypaEAi/zyOb1GLPSKgI/uDl9SpaTBdB934kR5oEIQDDk
         IIIg==
X-Forwarded-Encrypted: i=1; AJvYcCWWDU7p9MuqcP2HU5CrkXJ/eyJwO1h9CnusLRfTznRxRYUL7Z7H7vU1meMqVCA9N6/jPgl/MznGWW+y@vger.kernel.org
X-Gm-Message-State: AOJu0YwVXdO0Et+JJ8CVWARoy26wiwj584/exkkzXIIvH7J4HrUWUpq+
	ixJ0YCw+icmG3adga0xudFOx2RlUXDgVs6NRz7AtosX9VCDZSPcYM7ns2csjfQ==
X-Google-Smtp-Source: AGHT+IEsoNF2uAO82nL0/Xt/GYIxP2Odx0PPROHsghTNIyVjiLKqEKD6E0G2RbxTjvG7xMtEpDm7Hw==
X-Received: by 2002:a05:620a:28c9:b0:79e:f9c8:a22a with SMTP id af79cd13be357-7ae626b1a87mr661471685a.12.1727917521357;
        Wed, 02 Oct 2024 18:05:21 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae6b04473asm774585a.53.2024.10.02.18.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 18:05:20 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	stable@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: fix cap ref leak via netfs init_request
Date: Wed,  2 Oct 2024 21:05:12 -0400
Message-ID: <20241003010512.58559-1-batrick@batbytes.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

Log recovered from a user's cluster:

    <7>[ 5413.970692] ceph:  get_cap_refs 00000000958c114b ret 1 got Fr
    <7>[ 5413.970695] ceph:  start_read 00000000958c114b, no cache cap
    ...
    <7>[ 5473.934609] ceph:   my wanted = Fr, used = Fr, dirty -
    <7>[ 5473.934616] ceph:  revocation: pAsLsXsFr -> pAsLsXs (revoking Fr)
    <7>[ 5473.934632] ceph:  __ceph_caps_issued 00000000958c114b cap 00000000f7784259 issued pAsLsXs
    <7>[ 5473.934638] ceph:  check_caps 10000000e68.fffffffffffffffe file_want - used Fr dirty - flushing - issued pAsLsXs revoking Fr retain pAsLsXsFsr  AUTHONLY NOINVAL FLUSH_FORCE

The MDS subsequently complains that the kernel client is late releasing caps.

Approximately, a series of changes to this code by the three commits cited
below resulted in subtle resource cleanup to be missed. The main culprit is the
change in error handling in 2d31604 which meant that a failure in init_request
would no longer cause cleanup to be called. That would prevent the
ceph_put_cap_refs which would cleanup the leaked cap ref.

Closes: https://tracker.ceph.com/issues/67008
Fixes: 49870056005ca9387e5ee31451991491f99cc45f ("ceph: convert ceph_readpages to ceph_readahead")
Fixes: 2de160417315b8d64455fe03e9bb7d3308ac3281 ("netfs: Change ->init_request() to return an error code")
Fixes: a5c9dc4451394b2854493944dcc0ff71af9705a3 ("ceph: Make ceph_init_request() check caps on readahead")
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
Cc: stable@vger.kernel.org
---
 fs/ceph/addr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 53fef258c2bc..702c6a730b70 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -489,8 +489,11 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
 	rreq->io_streams[0].sreq_max_len = fsc->mount_options->rsize;
 
 out:
-	if (ret < 0)
+	if (ret < 0) {
+		if (got)
+			ceph_put_cap_refs(ceph_inode(inode), got);
 		kfree(priv);
+	}
 
 	return ret;
 }

base-commit: e32cde8d2bd7d251a8f9b434143977ddf13dcec6
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


