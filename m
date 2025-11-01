Return-Path: <ceph-devel+bounces-3898-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00061C28074
	for <lists+ceph-devel@lfdr.de>; Sat, 01 Nov 2025 15:01:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24BFC189F3F7
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Nov 2025 14:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FDC172610;
	Sat,  1 Nov 2025 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrAtHBee";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAAno2lw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EAA224244
	for <ceph-devel@vger.kernel.org>; Sat,  1 Nov 2025 14:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762005668; cv=none; b=EEQBLUdku6Ns7L58n52CASN7D2SRIzwebBw3xC0DzH1SWzDMWJ6STn+HcKGxXFh+UEuvqrzCczj/lsGZTo+iWeynxisOhHaGsC8k/fzIBvTxP6lSjL0+wW9Pty8nwuwHwnu0vJR40Cb0kbwVM1W1NW7/RxsQY6aHfqU373pFSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762005668; c=relaxed/simple;
	bh=kE8LqVTDNLmDdNE2UA9x1K/d+4ONoIIL83APPWfRTbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOrAnZIfRLx8+kIqQ0+sGNI8rpfA9P2uafmDKn64jUdy6hG5xEA0qdkfOvgcp91gwVlfonuXufQqcUla5zbnEGDxoYN0fyW8O5Ltl8KSeTZ9AY50UoCA0UrJBzfdXHpIxPsWvt42DUKdA61Ms+KB5KqO4KIP6wCTz5bA+xTMRyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrAtHBee; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAAno2lw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762005663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CDVwTxYBtBxn1fy7a/PU86aEw+yg0LDe5xrN1UV8APk=;
	b=FrAtHBeeskjROg9OSjFDqW9HIyRLHLUxXbqB++OvlXzn9Uxt4k4ZCZdgnidXTXgso1uEeI
	+8/XnoS96B6Uip5pAeBpxeArMjGqtp3967ZFp2ky5rqlkFyLMw9DfPV12GrDhUqZu9StO1
	AnLrzjrgrJR8ApXduHTWJBWZEE8PhdA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-4AEnz1K_Pmujiqo-Qxx3iw-1; Sat, 01 Nov 2025 10:01:02 -0400
X-MC-Unique: 4AEnz1K_Pmujiqo-Qxx3iw-1
X-Mimecast-MFC-AGG-ID: 4AEnz1K_Pmujiqo-Qxx3iw_1762005661
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b62b7af4fddso2462694a12.2
        for <ceph-devel@vger.kernel.org>; Sat, 01 Nov 2025 07:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762005661; x=1762610461; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDVwTxYBtBxn1fy7a/PU86aEw+yg0LDe5xrN1UV8APk=;
        b=aAAno2lwk3eyVg3DKBGzwz4sDxHgoSL7zlp30XIHU/rqTtfKTfog8SiABiIj+o8Awo
         g1KGfE8AUetulZmfCeRJJK+o9CcTqCaYHn4HJ7ylLH0pUIsbYu22c8NHxmtN8mhIiyFj
         oUjNdMNAKmAf/Pu5k0B6fT3RiygXrknmhTlvEaDEVFtDO83jBsWTqEahAgVWF4oG7wKV
         q/R/QMk0jwl06sgc4MJkUhv2hLtkq1RKG0tuBzPcq2TrQwskrH1ER7ZkWJwcW8VyzC4T
         JlasMRR5KDsXcz/yeWD1VYB01NSbzRMYaOsOEIqnB7iAsjh1SIEs5P/4Jb78KZ8MLc3Y
         NAxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762005661; x=1762610461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CDVwTxYBtBxn1fy7a/PU86aEw+yg0LDe5xrN1UV8APk=;
        b=Olp3/r0G6InqhGBeoT8N2YUv7/W3mmOLAjwJ/g0xMNTkRyvuKXR+WBuXD9gWPL8Vzh
         IHOVdFPYUVfiG5jwL8c0o21ru8SZOQzvLMe5lywQnM+ulK4EKjApVpf01QdP5iMZy5Ut
         HSlrBZ4GBkgliieTne7TsNOFwUg0ybsWaK5Bn72LbKJutWsNQGOY+oOuwStc2LgrFEIl
         NEoBHvJRN4jyWw5Jk10pJgNBbcrZdfWEaiqFawLKowbVdrPbvbRm5ZBTI7jFam4xPcZE
         nQcshL9F0JE1SJN7xQjCBPQt2LO2Y9hBMIDuWuX0LzWtv+8LUckYq9EtM+wCZZClrz1y
         A+Lg==
X-Forwarded-Encrypted: i=1; AJvYcCXyrZbTUmfhoXYrqxJ4RoSCA2fqA586fo6hfkdgMi0Ok8LcYERwgZrwUJOcXsgOvXKY2HNDOu0J/bIl@vger.kernel.org
X-Gm-Message-State: AOJu0YxX2iUoI+odNEo/QBM0toqDkUAilNoaKFnLDTy0uKNZXKmWHyfn
	G0nb6vrIGE0rhjpCE4e0nqUYfapmkmRt0P63qsBQcmY2g3ltv+NHsqfeFQ025BeX66IL0Ea1TdE
	BdNlFlojR3EQUYgHBhoGyjHjA598HGD8zuboMvKIfVRVxVl8nBMLlwQWUBVVUd5Wn4FWuJ//trA
	==
X-Gm-Gg: ASbGncuEpnPveTDKdyIVSjJ0QwWioLe7rCRLrU0aWhX66H3TFSoA+ZWdP/occ6YlpyQ
	klZYJNnqWMMRHMGdreSTjCL8hXV6heKOtFK/EvY9xPAEwns7UtcG1b2EuszdhCPjOhhMcmhitJp
	ZkFKvs/YYHhbPIP5ITSJRPJM6VdTLb7SAmVvvLKw648N7SAEulkp5jFDB06tenmL9dz1NESVttv
	nRe/1rFkCfopY9CcjIFtET4E+VZQUvm3RkDSYFKL/b1dVCca8uZmY7qf12AtZnIePdeEP99BfFI
	BZnUBbXpSaEbcjkzJi0QRHcvHbLe90cYQh4VZ+nlBk2mbm098nJ2Jpzi1EgLHVLntUxJpkxCWiJ
	C3ECxBMPvaCLq6HjfjJcJi+BCS3d1J1zWwK1iXdU=
X-Received: by 2002:a17:903:17ce:b0:290:9ee1:dcf5 with SMTP id d9443c01a7336-2951a39927emr105591435ad.13.1762005660428;
        Sat, 01 Nov 2025 07:01:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcpJPswtDtOwIJOgQqZQ9X3ckyiNXP+WkquTmImta6kfvZd/eiqyCqYxZR9wF1KkN1bZTXWg==
X-Received: by 2002:a17:903:17ce:b0:290:9ee1:dcf5 with SMTP id d9443c01a7336-2951a39927emr105590455ad.13.1762005659581;
        Sat, 01 Nov 2025 07:00:59 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295269bd633sm57536025ad.98.2025.11.01.07.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:00:58 -0700 (PDT)
Date: Sat, 1 Nov 2025 22:00:53 +0800
From: Zorro Lang <zlang@redhat.com>
To: ethanwu <ethanwu@synology.com>
Cc: fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
	Slava.Dubeyko@ibm.com, ethan198912@gmail.com
Subject: Re: [PATCH v4] ceph/006: test snapshot data integrity after punch
 hole operations
Message-ID: <20251101140053.v7ctcmmqpksz6fzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251021084921.3307823-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021084921.3307823-1-ethanwu@synology.com>

On Tue, Oct 21, 2025 at 04:49:21PM +0800, ethanwu wrote:
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
>  v3->v4:
>     1. call _fail if snapshot creation fails.
>     2. remove _require_xfs_io_command "pwrite"
>     3. cleanup snapshot after test
> ---
>  common/ceph        | 76 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/006     | 63 ++++++++++++++++++++++++++++++++++++++
>  tests/ceph/006.out |  2 ++
>  3 files changed, 141 insertions(+)
>  create mode 100755 tests/ceph/006
>  create mode 100644 tests/ceph/006.out
> 
> diff --git a/common/ceph b/common/ceph
> index df7a6814..5bdcb3ad 100644
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
> +	mkdir "$snapdir" || _fail "Failed to create snapshot $snapdir"
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
> +}
> +
> +# this test requires ceph snapshot support
> +_require_ceph_snapshot()
> +{
> +	local snapdirname=$(_ceph_get_snapdirname "$TEST_DIR")
> +	local test_snapdir="$TEST_DIR/$snapdirname/test_snap_$$"
> +	mkdir "$test_snapdir" 2>/dev/null || _notrun "Ceph snapshots not supported (requires fs flag 'allow_snaps' and client auth capability 'snap')"
> +	rmdir "$test_snapdir"
> +}
> diff --git a/tests/ceph/006 b/tests/ceph/006
> new file mode 100755
> index 00000000..a32e3138
> --- /dev/null
> +++ b/tests/ceph/006
> @@ -0,0 +1,63 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 Synology All Rights Reserved.
> +#
> +# FS QA Test No. ceph/006
                    ^^^^^^^^
		    006

Generally, please don't change this line manually.

> +#
> +# Test that snapshot data remains intact after punch hole operations
> +# on the original file.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick snapshot
> +
> +. common/ceph
> +
> +# Override the default cleanup function
> +_cleanup()
> +{
> +    _ceph_remove_snapshot $workdir snap1

	_ceph_remove_snapshot $workdir snap1
	cd /
	rm -r -f $tmp.*

> +}
> +
> +_require_test
> +_require_xfs_io_command "fpunch"
> +_require_ceph_snapshot
> +_exclude_test_mount_option "test_dummy_encryption"
> +
> +# TODO: commit is not merged yet. Update with final commit SHA once merged.
> +_fixed_by_kernel_commit 1b7b474b3a78 \
                           ^^^^^^^^^^^^
                           xxxxxxxxxxxx

If it's not merged, we can use "xxxxxxx...", that can be easily found by "grep",
to check which test cases need updating.


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

This's not necessary if you've called it in _cleanup.

I'll merge this patch with above changes, if there's not more review points
from ceph list.

Reviewed-by: Zorro Lang <zlang@redhat.com>

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


