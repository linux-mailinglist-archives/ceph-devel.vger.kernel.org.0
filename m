Return-Path: <ceph-devel+bounces-3774-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5284ABB0AFD
	for <lists+ceph-devel@lfdr.de>; Wed, 01 Oct 2025 16:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EECAA3C7F6A
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Oct 2025 14:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55410257AD3;
	Wed,  1 Oct 2025 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XaHMKLG+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FBD25E44E
	for <ceph-devel@vger.kernel.org>; Wed,  1 Oct 2025 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759328551; cv=none; b=H+I8aisBMcAyqeOV5e8Ds6HVBdbUt9Wi8SBit2l2WFqn/BSwKCqEXObVzhuMtG4oYECYyKsmF+Zp9j9l94opOwp+zxcaEVVlsuRPdcifsFXCVZdz++DpRC9E62i27fywcx7vHDTOFK9hp6axwzSSITgrndNGz3uqHnBkQBWzu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759328551; c=relaxed/simple;
	bh=D7mVDGZAz+OQrTd235FOz3Zo7U/7fserTMD3kjcTn5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcxAVma0eSL8TvoD/Uddyhwws5+qLiASwwACKxGJnUQ+VTT5BYBLZn/fBYELQOLruW3E4BFt/i49BsHchbyhJNSOdAxRFPakC1qk/HMsiEJ0d0AoeId5x0COopi6LPzzAYNcXw5L0aSErQZEx1ELIRcE9zpMetA/QfTTs4e/6+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XaHMKLG+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759328548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JoPvLlbCSML6XwkftITPfIg8xOvQBqiE6ulvHio3xoY=;
	b=XaHMKLG+vmNzP9ZV/PwBaF+KoHGe3L2j1/GMfwnV3UxjvxL/iRhwhLDizPHdrNc1gKqJGm
	+VLkTJJ/IkUxSV3xkrV04zArd05P1A3GXgYIBOolrndOnZAr3yvxuwVIIrAT8FfJ4yMyq4
	p67KCuWkutsJXr/0cbaQulAqfN7MDG8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-sm5etZg7N-WMMnYZYMXyMg-1; Wed, 01 Oct 2025 10:22:25 -0400
X-MC-Unique: sm5etZg7N-WMMnYZYMXyMg-1
X-Mimecast-MFC-AGG-ID: sm5etZg7N-WMMnYZYMXyMg_1759328544
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32ec67fcb88so6544619a91.3
        for <ceph-devel@vger.kernel.org>; Wed, 01 Oct 2025 07:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759328544; x=1759933344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JoPvLlbCSML6XwkftITPfIg8xOvQBqiE6ulvHio3xoY=;
        b=IRr0aIaIfP2Tx7Wi/oMCS2dfEOgGrEPb0Uck+GImQRVYwQT4mHNp8qMJB19WHBEHAo
         VRyaVtPRIuXahjTGbsGGh/WReIuoo/UiV6b87sDxlYelDWvcF0P7PMH+XJenBIRgK7qx
         Pzx4cXWms/1drPiRBpxZs98CkrWruuX8oLxrqh0IAgjXVB3K6bawUjccaOIT9HrP+niD
         XPulPPwS6Gudf636GyFyORP/u64e7p8qm7aVw4dprC9HharaKrWmcLdgILrHarqAefXk
         v2g4uzzKEpJ3LLTRWGjjux44qCQ2BXmWSEsMQthh0qVRYCr8FpNpGfMtFDncwbzJpsZ7
         UJ3g==
X-Forwarded-Encrypted: i=1; AJvYcCV/5IDUswdztMIIn+94SfQQtzGMtNsLHLQRKNWr8Q/hue3cAikfHOZ+DdVB2ELigoCc6qfuQ3vmnhyt@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0m77u2UW2N6LsMviCDIshRfDXaAavInWFKTl2wy7aeASUB8xO
	DXH+e+QnuaqnQHv9TWjUk3LVg7saUp+xWYrREbjCnPuC/JNw/zd7WqNwAlkjz5B9y3XD0FmAuh5
	HmLNIbgObyK+P3f7fla5AGB5q4BVsKwAWZhncDXKZOpdiveDGWbvf9ffc4A/3da0=
X-Gm-Gg: ASbGncsOp7JVpN/q0z5YDyG2VY4rVSNZynLgENlMk9Ym1Qs95Mv8m8g6vnQd+Q6nlk/
	R/jkO4Ldr0R8VU+3gXmu8UvnFWPt3gY27W+RNB0ITcD/8FBtn96UqKO5CUU+LvF+MhVzajejV6w
	+9yTsPuy7yqYSb7toHhd1BjLO/7ivBz7Rc1es7MytTVK8ctgBChlFGAjpDwoSU3M3eAVwQtV5in
	78G+n/z/rkgMsbuNG98eim0Lqic0K53fv67+6PJIqatdmwKF2C65xuf6emv/WOelnHx95anZUvf
	zRGxAtGP3pbsR//eL+8R5dZsTVi/QvLfLDkjpmJrsgqECEjDIBUs61wwpBtxAlKUezjX6ll0/Jt
	qgCM34/NjGQ==
X-Received: by 2002:a17:90b:1c86:b0:32e:b87e:a961 with SMTP id 98e67ed59e1d1-339a6e28253mr4100166a91.5.1759328544111;
        Wed, 01 Oct 2025 07:22:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiE8E8JpUc+mHC5geLw3ziv7M/Gy1hwfOav0RRD8KAg2+oypacVIJZ920PB0HXVVKODZBYBg==
X-Received: by 2002:a17:90b:1c86:b0:32e:b87e:a961 with SMTP id 98e67ed59e1d1-339a6e28253mr4100113a91.5.1759328543484;
        Wed, 01 Oct 2025 07:22:23 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6ff0d4esm2543782a91.17.2025.10.01.07.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 07:22:23 -0700 (PDT)
Date: Wed, 1 Oct 2025 22:22:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: ethanwu <ethanwu@synology.com>
Cc: fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com, ethan198912@gmail.com
Subject: Re: [PATCH] ceph/006: test snapshot data integrity after punch hole
 operations
Message-ID: <20251001142218.zjhquaouttns7yxx@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250930075743.2404523-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930075743.2404523-1-ethanwu@synology.com>

On Tue, Sep 30, 2025 at 03:57:42PM +0800, ethanwu wrote:
> Add test to verify that Ceph snapshots preserve original file data
> when the live file is modified with punch hole operations. The test
> creates a file, takes a snapshot, punches multiple holes in the
> original file, then verifies the snapshot data remains unchanged.
> 
> Signed-off-by: ethanwu <ethanwu@synology.com>
> ---

Thanks for the new test case from ceph list :) I have two questions
about this patch (see below...)

>  tests/ceph/006     | 58 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/006.out |  2 ++
>  2 files changed, 60 insertions(+)
>  create mode 100755 tests/ceph/006
>  create mode 100644 tests/ceph/006.out
> 
> diff --git a/tests/ceph/006 b/tests/ceph/006
> new file mode 100755
> index 00000000..3f4b4547
> --- /dev/null
> +++ b/tests/ceph/006
> @@ -0,0 +1,58 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Synology All Rights Reserved.
> +#
> +# FS QA Test No. ceph/006
> +#
> +# Test that snapshot data remains intact after punch hole operations
> +# on the original file.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick snapshot
> +
> +. common/filter

I didn't see you use any filter helpers, this might not needed :)

> +
> +_require_test
> +_require_xfs_io_command "pwrite"
> +_require_xfs_io_command "fpunch"
> +_exclude_test_mount_option "test_dummy_encryption"
> +
> +# TODO: Update with final commit SHA when merged
> +_fixed_by_kernel_commit 1b7b474b3a78 \
> +	"ceph: fix snapshot context missing in ceph_zero_partial_object"

This test case uncovers a ceph known issue, but I didn't find any ceph
specific test steps in this case, so how about move this case to be a
generic test case (in tests/generic/ directory) ?

> +
> +workdir=$TEST_DIR/test-$seq
> +snapdir=$workdir/.snap/snap1
> +rmdir $snapdir 2>/dev/null
> +rm -rf $workdir
> +mkdir $workdir
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
> +
> +mkdir $snapdir
> +
> +original_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
> +
> +# Punch several holes of various sizes at different offsets
> +$XFS_IO_PROG -c "fpunch 0 4096" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 16384 8192" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 65536 16384" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 262144 32768" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 1024000 4096" $workdir/foo

We're used to 4k block size by default, but now the LBS(large block size) is
more and more popularizes, so if you can reproduce this bug after replace
above 4k with 64k, how about using bigger hole size.

> +
> +# Make sure we don't read from cache
> +echo 3 > /proc/sys/vm/drop_caches
> +
> +snapshot_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
> +
> +if [ "$original_md5" != "$snapshot_md5" ]; then
> +    echo "FAIL: Snapshot data changed after punch hole operations"
> +    echo "Original md5sum: $original_md5"
> +    echo "Snapshot md5sum: $snapshot_md5"
> +fi
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/ceph/006.out b/tests/ceph/006.out
> new file mode 100644
> index 00000000..675c1b7c
> --- /dev/null
> +++ b/tests/ceph/006.out
> @@ -0,0 +1,2 @@
> +QA output created by 006
> +Silence is golden
> -- 
> 2.43.0
> 
> 
> Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
> 


