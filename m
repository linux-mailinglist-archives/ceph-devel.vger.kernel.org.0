Return-Path: <ceph-devel+bounces-2994-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D1744A74350
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Mar 2025 06:26:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D192E189CEDF
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Mar 2025 05:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4DE20DD49;
	Fri, 28 Mar 2025 05:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S4POHn4H"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7698528373
	for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 05:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743139614; cv=none; b=oZhRIUoNxXm/9e2NOC8q1/KuFFLLv2fa2NJx61EKFtGC7HmciayhMh4fxJ1LJLgiL3ktLhJzNycVPU+MEi9p4BpkEnSwna2aqz/FDHv6grO4sFIeyDmaUwXsZMT6+Lp2jJgrGkEtRdYgrUFrjVndByQqcDcVd+I9cwZ1hgueMIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743139614; c=relaxed/simple;
	bh=1zzZ3hAoQgiQKDwuWs4Af8NLyALwZLGxcTpksqLDoW4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FV5/eQIZB25q8yKpBCnJzRY8W4qBx3wTQ1OmvfWeUCeJ6xBRvD7uAwQdjHm511UZk6SznMOLftogjKHP7tjPMvHeuCthqE1wR1IabUrERaiqN8GKvJo+HTTmT8+vkCxK8ycqZC0Xh+nDXJl2yzdG0L1CduAPT1GzHXozmFHHQ6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S4POHn4H; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf628cb14so19283415e9.1
        for <ceph-devel@vger.kernel.org>; Thu, 27 Mar 2025 22:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743139611; x=1743744411; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fmoyoSA2Dy8iFsEnEBLlb/cn6Ozp+HwWcLRRzXUA8II=;
        b=S4POHn4HyZ4MNcQTPKU29K14WlYq+CSRIgvz3WfIrFsrhS3RCNbTIeP4gvHWWjB2qK
         b7vSkg1lD7EYGv4kPcD58gTH7SGb1//vx/5RpLwPQ5Y6gdx95gEXHeV9kfs2PmIxdOmj
         EpnxNrPv1PAMmb2ffSYxuIyPBk/4z4x/f5MWyMCbzh+zS7AyJ+qfKbvqeAL+9djRKW4J
         xLlRDc3NNnwePkYxFuwcinxDfmfax/vzuhUYQL4H283zwirwzH0jwRZ4cZciq4XVkIgs
         nzCBxxrgrp5WzblIUIseZZCSWU9/UE39BgJM4+BQ4yyAuhxnVas8eeyyGqtcaTDiBFsb
         R1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743139611; x=1743744411;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fmoyoSA2Dy8iFsEnEBLlb/cn6Ozp+HwWcLRRzXUA8II=;
        b=oWpy9xJf4Ok1XoliKHYU7Uz8doyNpcFtWuuMzq3Shc5bSxxco32sC3tdXUzs0F+fQK
         hhXTKKTAki0CZWHZw9Df7+G+P8llgXWwt29+g+uhhEcDwB6lEMmqPF0g3LGv775kqMJt
         PW5r4JptjXcEVBLSencB3GO83YqOIAjSpjTIfm17ZA97Ymb/UrUf2hc8WvNbUIo0dLDC
         bvP/Hth4brqCLF50fb3Neio+mMpOO3CykPSpHJkj0JoPxbH+GYRBZjtx357GlglA2zqK
         VB3lcATAR+5VvwgoHs/7LCMIKJFISlpf3Ah1/Ki5Ewn8eO08zxAV49mTrUtsxkhP5iz3
         PHeA==
X-Forwarded-Encrypted: i=1; AJvYcCU8cQ7edm48WUZ9yJWNBu9Jxyxdt12ihwERmeiPBgR0F88Ux/14g3mrvwE24hSzsuYyWPDSMNbISo3t@vger.kernel.org
X-Gm-Message-State: AOJu0YzePMk6LlNh3y17P/vfFvzGy3TYrp1wJXN7I+U+X/QY18MDLFui
	R0sGXu1CfpLXYoRw2s7F5G+ndIYFq4fvfPta+xLiVHyG+3MSJZQW84AdF6guMwI=
X-Gm-Gg: ASbGncvH+sOjFS+Ksr8DA5zDCobT9/brkmfrEgfhXjgRZl+YFCGK++Pg3A2vOYJ5zHA
	2H6Po5CcdGhbGw/ZzBkKubecKtxkIOq03UeHH6RmvZbBAJiyroTKj+tBbVHB1aJ4vNCKzP+c2Ge
	jXNsBCx44Q0VYrUcUjEiQ8gTKvX3O5HSFGDRs9scsfsW05i6xV+WO3cF8ZhRQxetHIvznViaxH4
	iccD+5T+lKesoWWa7MlX5cfZhtTovAhTkW1yMhciNFf/OGnk/uGMKAHsXulY4WEfHkhd4pqClcy
	kPPKAj9H65HIDAvQIT4nyQ0boqhQleRjlrLM12oiMNu/yVoXeg==
X-Google-Smtp-Source: AGHT+IH6wIHQave/ijbn3USkRE6+YMPxCQbHROwx5BiESapOlb24WCKhxVJv8KMRLhDAEGMVaztxUg==
X-Received: by 2002:a05:600c:6c4f:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-43d9105c99fmr12009115e9.9.1743139610634;
        Thu, 27 Mar 2025 22:26:50 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d82efe678sm58772765e9.20.2025.03.27.22.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 22:26:50 -0700 (PDT)
Date: Fri, 28 Mar 2025 08:26:47 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Alex Markuze <amarkuze@redhat.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 19/40] fs/ceph/super.c:1042
 ceph_umount_begin() warn: variable dereferenced before check 'fsc' (see line
 1041)
Message-ID: <7ffc0531-0240-4a83-8062-e77c7710d93d@stanley.mountain>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   3d957afa4285ed4deaaf42d200ba7ee1f3092f8d
commit: 75b56e556ea415e29a13a8b7e98d302fbbec4c01 [19/40] cephsan new logger
config: x86_64-randconfig-r071-20250328 (https://download.01.org/0day-ci/archive/20250328/202503280852.YDB3pxUY-lkp@intel.com/config)
compiler: clang version 20.1.1 (https://github.com/llvm/llvm-project 424c2d9b7e4de40d0804dd374721e6411c27d1d1)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202503280852.YDB3pxUY-lkp@intel.com/

smatch warnings:
fs/ceph/super.c:1042 ceph_umount_begin() warn: variable dereferenced before check 'fsc' (see line 1041)

vim +/fsc +1042 fs/ceph/super.c

631ed4b0828727 Jeff Layton  2021-10-14  1037  void ceph_umount_begin(struct super_block *sb)
16725b9d2a2e3d Sage Weil    2009-10-06  1038  {
5995d90d2d19f3 Xiubo Li     2023-06-12  1039  	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
3d14c5d2b6e15c Yehuda Sadeh 2010-04-06  1040  
38d46409c4639a Xiubo Li     2023-06-12 @1041  	doutc(fsc->client, "starting forced umount\n");
                                                      ^^^^^^^^^^^
Dereferenced

3d14c5d2b6e15c Yehuda Sadeh 2010-04-06 @1042  	if (!fsc)
                                                    ^^^^
Checked too late.

3d14c5d2b6e15c Yehuda Sadeh 2010-04-06  1043  		return;
3d14c5d2b6e15c Yehuda Sadeh 2010-04-06  1044  	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
50c9132ddfb202 Jeff Layton  2020-09-25  1045  	__ceph_umount_begin(fsc);
16725b9d2a2e3d Sage Weil    2009-10-06  1046  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


