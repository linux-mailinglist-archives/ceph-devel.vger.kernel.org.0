Return-Path: <ceph-devel+bounces-3846-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 25FFABEBA2E
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Oct 2025 22:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BBA4C4FFEAE
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Oct 2025 20:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535E7333728;
	Fri, 17 Oct 2025 20:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DleTbjr3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA97433343A
	for <ceph-devel@vger.kernel.org>; Fri, 17 Oct 2025 20:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760732756; cv=none; b=eTcKqNXoT2Mai2HpW0H26bG1FkPNBISxr19UjE2onsUXnDQbOFlw/QCzJf8WStBoolQr2fphXbySyrPr4EiBLMddD8Rht2Uot4TES7MbFyL5hHVoACs70re9gC9WnUL0KZyhJBMkTg90RXn+k8PMzI0gO4sSm8ngJxrv0tCYrK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760732756; c=relaxed/simple;
	bh=jM5A3TelHkeicjfx+wxJIKYR3jCvvcb2IvEl8LyEalw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9xL+e0V+B+6PJbpKi93n0uNPw5DUuWsy/yMx8iakQwZZ/hDHp4Y6Yw/dYFvB5I265Qq7QgMzIDVi1PciRhDG2pzTabPC4Uxax7Ki3xiRQQnt6fZZJZwYM/ww/szxx+IwLHJDdkoiyoKcaiPILNKviXrcZc1jueCHsFcaUbOU1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DleTbjr3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760732752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SC+5NC1S5pdFEKz3wHqgv0vTb+teR0zOymxzWocp7FQ=;
	b=DleTbjr3bCAMSwUKTFDzVPm4DRG4Ks5bf7Sjcmr4e9CgfXClhjzPy4Ss5aYac+ikiQaEwS
	gucG4J0snGwaAX2IGJBZL4oT7ndsgKuFUqBOcl1fihTI/00xZ+wxZ5DV4sU9hSSInJuz9A
	fLIMfv2Bor69xmVcujXcRlbbeFgIb2c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-SkCnlwk5MFuhkztGB6CPtA-1; Fri, 17 Oct 2025 16:25:51 -0400
X-MC-Unique: SkCnlwk5MFuhkztGB6CPtA-1
X-Mimecast-MFC-AGG-ID: SkCnlwk5MFuhkztGB6CPtA_1760732751
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-27ee41e062cso31398925ad.1
        for <ceph-devel@vger.kernel.org>; Fri, 17 Oct 2025 13:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732750; x=1761337550;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SC+5NC1S5pdFEKz3wHqgv0vTb+teR0zOymxzWocp7FQ=;
        b=Hivj3gGpFkfvahcMZcOiby8drvEfYwO7Oz6GFuYlhyF2JWxlqP9JYQbonyp7fqd/F5
         wgRVrBjjjQFxnsdcd61ppdPczGtabudOZ00zGMFtNmKHVsmlBcjd4bNx8oot1rmk1Cg2
         w2/Xdw4guId0X2J4WH+0+fLMB4PFWsXjgZ49bx4TarkV2jftuwloegE0XWtEFQTgRRga
         r6JufpilJoKhXBzjFXd6UDdpbF2c6AHoviPa9E8O57ZYAZ0RBc06RtNSsAvcIXIFvkBR
         KoD7jmNMuZ0wgbYOraCeWf/aOkrI1+fHY0ibiWLwdNk25EIt8CrwSVUskD0OzhwYo891
         qT1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVyfB8LRXjULbVXaSvSl8WNQVF7NnisYONGwxf9+FZCUOuPGWMsfWeTBtszueXQlaPFDMLU1ce7/+9x@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6lhZo9MQYainE0JLbvIUUSJKXC+pKH1xIopbaU2l8KhI4o2NR
	4OoYcz73l55RB9YZEBgP4Hdny4vyj9vAgfDtosb1M4kGYjdl7oOgZCr5Xy4/VrgPc1SkN7yMDyP
	PUD+lQgrd+LYGwxGLDq0urhcsKvrnbtjfxwIJVQiFd66MjXPuMxZ7XbUEcCLSPurfI3Iak9M=
X-Gm-Gg: ASbGncuYeKLmUtmduRG2OxhM3hZXvMFs+EaxeNLkvYqgC+Ssv2l1yRS8BYhU0m//t0G
	WBOoidHYGEAMmFZRsDpYQ9Nnf9vTVJ+eRAK8EjEgg6poz42oym13PJPyAgz2RbBDNFLpMgKl9CG
	H+siWFlCUdxCJFTCTqIi+M2NwPIHcCi3daxs8MPJbAXaMyCY3ENgPmiMjmwgkK60BaKDJYDx87f
	dfsqkzl9USGDD2VPcAewMLwQQGPTLTFlyusOMzVivhs6KuH02HM3GL3LABU6hds4FTARHC7ixUx
	EuDC+PeqQPpmisFOrKe15N8hX7EO76n9CucdYm8d/k7coNZBvSQGu6aPCh/ERRvWbhIk0Pdja5x
	2p0juj/VnpDCF3h0QTlUfWqSq6wUto5hNax3RnuA=
X-Received: by 2002:a17:903:1a4c:b0:267:ba92:4d19 with SMTP id d9443c01a7336-290c99a8ed3mr63606605ad.0.1760732749969;
        Fri, 17 Oct 2025 13:25:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxfxr0prdBShKiiD3OH0xFK8B3tzOOnqVQzoTfYO6FzFCXRk2P6WQVkDGH421mM7plLtUZuA==
X-Received: by 2002:a17:903:1a4c:b0:267:ba92:4d19 with SMTP id d9443c01a7336-290c99a8ed3mr63606425ad.0.1760732749517;
        Fri, 17 Oct 2025 13:25:49 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292472197e9sm3835075ad.116.2025.10.17.13.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 13:25:48 -0700 (PDT)
Date: Sat, 18 Oct 2025 04:25:44 +0800
From: Zorro Lang <zlang@redhat.com>
To: ethanwu <ethanwu@synology.com>
Cc: fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com, ethan198912@gmail.com
Subject: Re: [PATCH v3] ceph/006: test snapshot data integrity after punch
 hole operations
Message-ID: <20251017202544.3a5es5j57r6ifkwd@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251009093129.2437815-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009093129.2437815-1-ethanwu@synology.com>

On Thu, Oct 09, 2025 at 05:31:29PM +0800, ethanwu wrote:
> Add test to verify that Ceph snapshots preserve original file data
> when the live file is modified with punch hole operations. The test
> creates a file, takes a snapshot, punches multiple holes in the
> original file, then verifies the snapshot data remains unchanged.
> 
> Signed-off-by: ethanwu <ethanwu@synology.com>
> ---
>  v1->v2: previous version is 'ceph/006: test snapshot data integrity
>  after punch hole'.
>     1. move it to generic and add _require_snapshot check.
>     2. modify punch hole offset/len to be 64K aligned
>  v2->v3:
>     1. move test back to ceph specific since it uses ceph snapshot API.
>     2. support custom snapdirname mount option.
>     3. add _ceph_remove_snapshot and _ceph_create_snapshot functions.
> 
> ---

Thanks for your update :) I'm not familiar with ceph, so I'll try to review
this patch from fstests side. Welcome ceph list provide more review points :)

>  common/ceph        | 76 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/006     | 58 +++++++++++++++++++++++++++++++++++
>  tests/ceph/006.out |  2 ++
>  3 files changed, 136 insertions(+)
>  create mode 100755 tests/ceph/006
>  create mode 100644 tests/ceph/006.out
> 
> diff --git a/common/ceph b/common/ceph
> index df7a6814..6a19527e 100644
> --- a/common/ceph
> +++ b/common/ceph
> @@ -38,3 +38,79 @@ _ceph_get_client_id()
>  {
>  	$GETFATTR_PROG --only-values -n "ceph.client_id" $TEST_DIR 2>/dev/null
>  }
> +
> +# Get the snapshot directory name from mount options
> +# Defaults to ".snap" if snapdirname option is not set
> +_ceph_get_snapdirname()
> +{
> +	local mnt_point=$1
> +	local snapdirname
> +
> +	# Extract snapdirname from mount options
> +	snapdirname=$(findmnt -n -o OPTIONS "$mnt_point" | grep -o 'snapdirname=[^,]*' | cut -d'=' -f2)
> +
> +	# Default to .snap if not set
> +	if [ -z "$snapdirname" ]; then
> +		echo ".snap"
> +	else
> +		echo "$snapdirname"
> +	fi
> +}
> +
> +# Create a CephFS snapshot
> +# _ceph_create_snapshot <directory_path> <snapshot_name>
> +# Creates a snapshot under <directory_path>/.snap/<snapshot_name>
> +# or <directory_path>/<custom_snapdir>/<snapshot_name> if snapdirname is set
> +_ceph_create_snapshot()
> +{
> +	local dir_path=$1
> +	local snap_name=$2
> +	local snapdirname
> +	local snapdir
> +	local mnt_point
> +
> +	if [ -z "$dir_path" ] || [ -z "$snap_name" ]; then
> +		echo "Usage: _ceph_create_snapshot <directory_path> <snapshot_name>"
> +		return 1
> +	fi
> +
> +	# Find the mount point for this directory
> +	mnt_point=$(df -P "$dir_path" | tail -1 | awk '{print $NF}')
> +	snapdirname=$(_ceph_get_snapdirname "$mnt_point")
> +	snapdir="$dir_path/$snapdirname/$snap_name"
> +
> +	mkdir "$snapdir" || return 1
> +	echo "$snapdir"
> +}
> +
> +# Remove a CephFS snapshot
> +# _ceph_remove_snapshot <directory_path> <snapshot_name>
> +_ceph_remove_snapshot()
> +{
> +	local dir_path=$1
> +	local snap_name=$2
> +	local snapdirname
> +	local snapdir
> +	local mnt_point
> +
> +	if [ -z "$dir_path" ] || [ -z "$snap_name" ]; then
> +		echo "Usage: _ceph_remove_snapshot <directory_path> <snapshot_name>"
> +		return 1
> +	fi
> +
> +	# Find the mount point for this directory
> +	mnt_point=$(df -P "$dir_path" | tail -1 | awk '{print $NF}')
> +	snapdirname=$(_ceph_get_snapdirname "$mnt_point")
> +	snapdir="$dir_path/$snapdirname/$snap_name"
> +
> +	rmdir "$snapdir" 2>/dev/null

What if the snapdir can't be removed? Is that possible?

> +}
> +
> +# this test requires ceph snapshot support
> +_require_ceph_snapshot()
> +{
> +	local snapdirname=$(_ceph_get_snapdirname "$TEST_DIR")
> +	local test_snapdir="$TEST_DIR/$snapdirname/test_snap_$$"
> +	mkdir "$test_snapdir" 2>/dev/null || _notrun "Ceph snapshots not supported (requires fs flag 'allow_snaps' and client auth capability 'snap')"

Is "$snapdirname" created before calling this function? Do we need "-p" option?

> +	rmdir "$test_snapdir"
> +}
> diff --git a/tests/ceph/006 b/tests/ceph/006
> new file mode 100755
> index 00000000..a5af6ca3
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
> +. common/ceph
> +
> +_require_test
> +_require_xfs_io_command "pwrite"

I think "pwrite" is nearly always supported, don't need to check it :)

> +_require_xfs_io_command "fpunch"
> +_require_ceph_snapshot
> +_exclude_test_mount_option "test_dummy_encryption"
> +
> +# TODO: commit is not merged yet. Update with final commit SHA once merged.
> +_fixed_by_kernel_commit 1b7b474b3a78 \
> +	"ceph: fix snapshot context missing in ceph_zero_partial_object"
> +
> +workdir=$TEST_DIR/test-$seq
> +_ceph_remove_snapshot $workdir snap1
> +rm -rf $workdir
> +mkdir $workdir
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
> +
> +snapdir=$(_ceph_create_snapshot $workdir snap1)

As you just "return 1" if the _ceph_create_snapshot fails, what if the
snapshot isn't created? So how about calling "_fail" if it fails.

> +
> +original_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
> +
> +$XFS_IO_PROG -c "fpunch 0 65536" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 131072 65536" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 262144 65536" $workdir/foo
> +$XFS_IO_PROG -c "fpunch 393216 65536" $workdir/foo
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
> +_ceph_remove_snapshot $workdir snap1

Better to make sure the snapshot is removed in _cleanup.

Thanks,
Zorro

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


