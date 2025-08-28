Return-Path: <ceph-devel+bounces-3488-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA32AB3AA31
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 20:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D8471713C3
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 18:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7F42D23B6;
	Thu, 28 Aug 2025 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="mWn2IuPG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A51E27934E
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756406708; cv=none; b=nCFm4PY7rry8dHUsmLWmRyBUuPmZ32I9LANoeyS0loB7K4mWa79SmQNiQviH7VPe3eaIiZM+Gt1O+HM9vLMYeeNp724sfHq7XiNXG2J9TPVDqm/IHj3OopmSpN+U62qO+29PzWZ5K3YxfRmnB+Wpq5r1/mIuIh6aO3DlE2KsDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756406708; c=relaxed/simple;
	bh=x8ELUEO4zpbibIvbx2fhkv24vwSibg539brPVKqK0Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SqClZUXmlze1Z86OpPSqkhcLh/GdzWO/WQwRNZz7PbgFtfuJjfN1ddee+dKi7hA94sAP/LqJ7OpNcyGitg0/n+QigHEIqf+3O380ALNtTooLSadkVim9n4b+XDgTSrHyChEiQOKn/PKiboSCeerPHT7/WWFU5PFIbsRD/lwnsg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=mWn2IuPG; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-72019872530so11004637b3.1
        for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1756406705; x=1757011505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NJJoCqafY2R71TzE6L9BGRudxdiRZ8yK2jVs5bHbWUY=;
        b=mWn2IuPGl3/RVh4OAW8wrzLoYwnK+asL5arwy4hrcnSMdGuud1uOOPSI5zgHD2tZcN
         PigPulkEV597Qdd9vSBuBAWogj7WCFSS02CpKFBVq0B0rlYf8OE017nxNZNlunm7pVjn
         ckac6IB0DvS3cR5DedaQV9hbjKFXJjf1hWjoIn/bwN+Tvt6zRyUaBOOlXlDgcJ9gIxdB
         VIQ8ZgoFRsBvpsziwQJg88wjLBUZE2ikoa+U127+NqFnzDMMV/pB510BQOCA94HUXVVw
         Bz8bINWyZ3r3SGV7obzELHBYnBy/hduodKvUTbsDS8hMeZWL/Mz/YtXw5irmQ/weVS3W
         jU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756406705; x=1757011505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJJoCqafY2R71TzE6L9BGRudxdiRZ8yK2jVs5bHbWUY=;
        b=b1OgJNbgOKOMfXxmLQDyFCdqPetCdRevwGs5Fn6/Vz74dTb2oQLH0Wcp1GegCd3fsx
         4K41ecljG3yaxNRh6+/zEFsv+4g77xJS/sZ4vnPT/CNxgc+Sio30kWViqmPbXl44X89u
         qsdOuBEKeWWfEfWcl+ub2LoXbXvpipAEExvlEW1xIHtukLVzJvdADpmu5Z/CPGQOKs+S
         5D7C9ihhn6e7RUU3c30lx1+5BV5uL8GpKqXqXiVDbsEJw9hRq3gv9aT+PqBzMq8PR8ON
         46IrZ0bqKQjUf66B0n+zki76SQPJl5p6JDMlvsraG9FzGT3BAsW0cSeYxPSCN/3g+n6Z
         63Rw==
X-Gm-Message-State: AOJu0YzGBBWSORz0QcBvniCWF1gidkfefDi0K0ENLLzBfHucV6B0Ejma
	AaP76Z3A78G8nkrSRFwt4biSlMaXANu1J/Bqb9pca5lsB0W0gMvuDyvcWpZ6B2f5JlYTmluXkgK
	yJ/L3SZkDpw==
X-Gm-Gg: ASbGnctIWp/D1k99L08xyWrZJN/8lCZPPMM8zNw4mZTzhmyxDHsBn+FzT/ZM0Uo8va0
	sc/i8vZbdPfrN2jdlkzPZg1janZjHT2k5PQBkDccLVMaVg79LUX9eU6/DJul2PTAsZsLQa6SZsX
	TrrLqPQz7nqgmF8nft7CPbUBVpRxj/7W4n9/bw0VTLfZQylJmnEgI21aZXElrwTeNYJQZIwfM+0
	UyRKvbx3/+RydrnqqjYrm0PYizbJuJW2s8Islo7QrVyAdr1dGUAiDfehri8XwRDYGV+lFVBy6r4
	mxpKYSXMdmZl8cmi0Tpfwlx/JcUgYsZpo8l85imG28ZvmbU3CZfLgSe7YhQi7EovuI/897gLOy7
	J60SciZVgPdgPlLzbHjNj9UDdyLdeVOPpereQaIOVbQ6Bbqp7lss=
X-Google-Smtp-Source: AGHT+IG3GoqyBGLBmGPhmOHqb16rK9P6upQaQINamt65amR5WQ/XeYvsof2WnR1hFv8BsS3/5X3Z2w==
X-Received: by 2002:a05:690c:968b:b0:71b:f56a:d116 with SMTP id 00721157ae682-71fdc2d2454mr278404217b3.2.1756406704820;
        Thu, 28 Aug 2025 11:45:04 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:450d:fa44:b650:10d9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721c630cc83sm1339417b3.11.2025.08.28.11.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 11:45:04 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH v2] ceph: fix potential NULL dereferenced issue in ceph_fill_trace()
Date: Thu, 28 Aug 2025 11:44:42 -0700
Message-ID: <20250828184441.83336-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has detected a potential dereference of
an explicit NULL value in ceph_fill_trace() [1].

The variable in is declared in the beggining of
ceph_fill_trace() [2]:

struct inode *in = NULL;

However, the initialization of the variable is happening under
condition [3]:

if (rinfo->head->is_target) {
    <skipped>
    in = req->r_target_inode;
    <skipped>
}

Potentially, if rinfo->head->is_target == FALSE, then
in variable continues to be NULL and later the dereference of
NULL value could happen in ceph_fill_trace() logic [4,5]:

else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
            req->r_op == CEPH_MDS_OP_MKSNAP) &&
            test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
             !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
<skipped>
     ihold(in);
     err = splice_dentry(&req->r_dentry, in);
     if (err < 0)
         goto done;
}

This patch adds the checking of in variable for NULL value
and it returns -EINVAL error code if it has NULL value.

v2
Alex Markuze suggested to add unlikely macro
in the checking condition.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1141197
[2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1522
[3] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1629
[4] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1745
[5] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1777

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 fs/ceph/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index fc543075b827..8ef6b3e561cf 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1739,6 +1739,11 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			goto done;
 		}
 
+		if (unlikely(!in)) {
+			err = -EINVAL;
+			goto done;
+		}
+
 		/* attach proper inode */
 		if (d_really_is_negative(dn)) {
 			ceph_dir_clear_ordered(dir);
@@ -1774,6 +1779,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		doutc(cl, " linking snapped dir %p to dn %p\n", in,
 		      req->r_dentry);
 		ceph_dir_clear_ordered(dir);
+
+		if (unlikely(!in)) {
+			err = -EINVAL;
+			goto done;
+		}
+
 		ihold(in);
 		err = splice_dentry(&req->r_dentry, in);
 		if (err < 0)
-- 
2.51.0


