Return-Path: <ceph-devel+bounces-3778-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E0EBB2AAA
	for <lists+ceph-devel@lfdr.de>; Thu, 02 Oct 2025 09:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4085919257D2
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Oct 2025 07:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F2D287272;
	Thu,  2 Oct 2025 07:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SKkO2cNC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357F51DE4CD
	for <ceph-devel@vger.kernel.org>; Thu,  2 Oct 2025 07:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759389241; cv=none; b=kuri1sAcxMHctLTXl864K9Np5YvjxDwa1n0oaQwEweFQv5rLnwOrQT5KliGZhCXQh2AE/238cJofWaqd09KAcOblDNTMt2s2+xv77toNHYz+VDEiHC/KVRI1yZcKVDFiLRrjk7lCQqW6iHa/tHov5JIUckQ+InktE+5CeDy6XU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759389241; c=relaxed/simple;
	bh=FBscNO4Osp8fJCrRhXQDU2USDsG0KLIXJoOhhs49+Ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3hTnNrz/CjxY3CYxnNh0e7SHEJJ55LUcpfesteveSlfADqTphIcqs8FrD/Hm/3kMq7FU9GILakOepC3WNKGpCPvKnzObBWUNWch/ucXmjVioIawKzT7m7Mv+UuAejDicWkSL594brUj/GlAxaz8KWJCBR0t8A3fo0j6E/0VtOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SKkO2cNC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759389238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fnZ27ieYTOSFRfY/wHn6jiluEoUMobm+VDg/9WPXtb0=;
	b=SKkO2cNC9XSGQwyj4GbCWGIT1vT1eoUO3MDpVm9k0j2oSJJB4tFeZRxquoolAn2pqLcuOa
	vvURUswVAGW8VDZyqOFg8a7O+oaOnavIc5LyyfgmXj8jknF4/XrNMKsbFlxVfICA1lElz7
	A3mPNpSsSE4vvlhTSBlTP1vBw+PHKGc=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-_DjrRSArOO-XossFAe3p7A-1; Thu, 02 Oct 2025 03:13:55 -0400
X-MC-Unique: _DjrRSArOO-XossFAe3p7A-1
X-Mimecast-MFC-AGG-ID: _DjrRSArOO-XossFAe3p7A_1759389235
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-26e4fcc744dso4260345ad.3
        for <ceph-devel@vger.kernel.org>; Thu, 02 Oct 2025 00:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759389234; x=1759994034;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnZ27ieYTOSFRfY/wHn6jiluEoUMobm+VDg/9WPXtb0=;
        b=hyLJtsphC86S+FixJ218Bl6f5V6lLXmDTRcOtiEDKXg8otlUPvNT5pSaNUouoHss2a
         swInMCakVKB7xnbCrNdbK4QbDfDzYq+nhnYeo45dCtEAmFfPUhqH89XjvZe4D2UsX+EO
         BoXk1iWcex6SV6DPD97CPfbcEZ/RSZ+QxvXiCi+1HW2FE8TPEDJawln1rU2ZbiXxLJa/
         yQd+uXqyW/GCO/GnZIZpRBP+Tg+zaNeyuSEMMLoPPPoBFtc8OUYz3Zt8haSLms56ZX6E
         RjmG4RQirA4vIVxzqqwGq7Ed49Z9XyzXGto66N+kkp6o+zLxJ5XIjKsTEHctEX2Z5Cl+
         RZwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIhokPOZfO48DCZKSynPnX+5vTFq8vfG3iGvKqVYHBvbPeIdoXNl7/schzjDsYHWmJjttU/7Tg42uK@vger.kernel.org
X-Gm-Message-State: AOJu0YzutownP3oTPMHBhnx1gIYdWIcTCSjXsYogMwzWOxvszjqTww4I
	80rtx/84IOMWphvsVTHYexScyGeq48Ng6npDK5sRYsu+8IRAKwLa0wVSLs5eC1l37z/I7Kn0Pdj
	656NSnzNxFx31WK7szIjDT/fG1d/2y+dEGvsjVuI1mzW7nHxYyWKPaadOdvf6oG3EMVZGwbo=
X-Gm-Gg: ASbGncuifQp4YyB8ZSVNcVP9TSOxUWQ0pTBn8IJ6uLXJ27x8PKKUEa6gCGMrFb28v5t
	ZsWvP/MgxcG0XpXd6PnkaCqqRPx30P6FezXNDtrPobXrodqxVh4unzdoHcSGS1knn/zplHYCxkn
	H8QFJtDLSsEmt4SDvyEoW/dDTaOsTv5osEjrf4ze/D2yb0kHolQTe4hUiSx5ORyl2pIU2GpKtCo
	nlKnTc5HWRMW2MOd4RT96cTf5Ikm+eBqIPprMiAfPaqKnW3Vy0zq0vQ+x2ZrTlas6OWvflxrhmA
	4FkFD57VeBN8XlfyZl4INKam5lEDAwB4bfv63JQgtcPLPP572qX5x4HNfjmnGLQyWsrFvwzHwdV
	EA8CnZ5DvDQ==
X-Received: by 2002:a17:902:ebc8:b0:261:cb35:5a0e with SMTP id d9443c01a7336-28e7f4dafbemr67568505ad.57.1759389234271;
        Thu, 02 Oct 2025 00:13:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQB3n307tLwZdG10MItso7oQUjbG7xbdVGGydSZYosB0LXus2LOnyLPLkmvn7ogR4JYi6y4Q==
X-Received: by 2002:a17:902:ebc8:b0:261:cb35:5a0e with SMTP id d9443c01a7336-28e7f4dafbemr67568235ad.57.1759389233648;
        Thu, 02 Oct 2025 00:13:53 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3399bc196c3sm3310645a91.0.2025.10.02.00.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 00:13:53 -0700 (PDT)
Date: Thu, 2 Oct 2025 15:13:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	"ethanwu@synology.com" <ethanwu@synology.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"ethan198912@gmail.com" <ethan198912@gmail.com>
Subject: Re: [PATCH] ceph/006: test snapshot data integrity after punch hole
 operations
Message-ID: <20251002071348.57mqzt6iqvlnf7hf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250930075743.2404523-1-ethanwu@synology.com>
 <7d9866d591e7fe4e5f3336aaa13107db402a608d.camel@ibm.com>
 <d6b17cbb-3504-4c3c-9f31-35c538248503@Mail>
 <cc9d84c5a3b683ccd7c86fcede503e07b048e94c.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc9d84c5a3b683ccd7c86fcede503e07b048e94c.camel@ibm.com>

On Wed, Oct 01, 2025 at 06:09:34PM +0000, Viacheslav Dubeyko wrote:
> On Wed, 2025-10-01 at 11:11 +0800, ethanwu wrote:
> > Viacheslav Dubeyko <Slava. Dubeyko@ ibm. com> 於 2025-10-01 02: 24 寫道： On Tue, 2025-09-30 at 15: 57 +0800, ethanwu wrote: > Add test to verify that Ceph snapshots preserve original file data > when the live file is modified with punch
> >  
> > Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> 於 2025-10-01 02:24 寫道：
> > 
> > 
> > > On Tue, 2025-09-30 at 15:57 +0800, ethanwu wrote:
> > > > Add test to verify that Ceph snapshots preserve original file data
> > > > when the live file is modified with punch hole operations. The test
> > > > creates a file, takes a snapshot, punches multiple holes in the
> > > > original file, then verifies the snapshot data remains unchanged.
> > > > 
> > > > Signed-off-by: ethanwu <ethanwu@synology.com>
> > > > ---
> > > >  tests/ceph/006     | 58 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/ceph/006.out |  2 ++
> > > >  2 files changed, 60 insertions(+)
> > > >  create mode 100755 tests/ceph/006
> > > >  create mode 100644 tests/ceph/006.out
> > > > 
> > > > diff --git a/tests/ceph/006 b/tests/ceph/006
> > > > new file mode 100755
> > > > index 00000000..3f4b4547
> > > > --- /dev/null
> > > > +++ b/tests/ceph/006
> > > > @@ -0,0 +1,58 @@
> > > > +#!/bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (C) 2025 Synology All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. ceph/006
> > > > +#
> > > > +# Test that snapshot data remains intact after punch hole operations
> > > > +# on the original file.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick snapshot
> > > > +
> > > > +. common/filter
> > > > +
> > > > +_require_test
> > > > +_require_xfs_io_command "pwrite"
> > > > +_require_xfs_io_command "fpunch"
> > > > +_exclude_test_mount_option "test_dummy_encryption"
> > > > +
> > > > +# TODO: Update with final commit SHA when merged
> > > > +_fixed_by_kernel_commit 1b7b474b3a78 \
> > > > + "ceph: fix snapshot context missing in ceph_zero_partial_object"
> > > > +
> > > > +workdir=$TEST_DIR/test-$seq
> > > > +snapdir=$workdir/.snap/snap1
> > > > +rmdir $snapdir 2>/dev/null
> > > > +rm -rf $workdir
> > > > +mkdir $workdir
> > > > +
> > > > +$XFS_IO_PROG -f -c "pwrite -S 0xab 0 1048576" $workdir/foo > /dev/null
> > > > +
> > > > +mkdir $snapdir
> > > > +
> > > > +original_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
> > > > +
> > > > +# Punch several holes of various sizes at different offsets
> > > > +$XFS_IO_PROG -c "fpunch 0 4096" $workdir/foo
> > > > +$XFS_IO_PROG -c "fpunch 16384 8192" $workdir/foo
> > > > +$XFS_IO_PROG -c "fpunch 65536 16384" $workdir/foo
> > > > +$XFS_IO_PROG -c "fpunch 262144 32768" $workdir/foo
> > > > +$XFS_IO_PROG -c "fpunch 1024000 4096" $workdir/foo
> > > > +
> > > > +# Make sure we don't read from cache
> > > > +echo 3 > /proc/sys/vm/drop_caches
> > > > +
> > > > +snapshot_md5=$(md5sum $snapdir/foo | cut -d' ' -f1)
> > > > +
> > > > +if [ "$original_md5" != "$snapshot_md5" ]; then
> > > > +    echo "FAIL: Snapshot data changed after punch hole operations"
> > > > +    echo "Original md5sum: $original_md5"
> > > > +    echo "Snapshot md5sum: $snapshot_md5"
> > > > +fi
> > > > +
> > > > +echo "Silence is golden"
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/ceph/006.out b/tests/ceph/006.out
> > > > new file mode 100644
> > > > index 00000000..675c1b7c
> > > > --- /dev/null
> > > > +++ b/tests/ceph/006.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 006
> > > > +Silence is golden
> > > 
> > > One idea has crossed my mind. I think we need to check somehow that snapshots
> > > support has been enabled. Otherwise, I believe that test will fail. But it will
> > > be better to inform about necessity to enable the snapshots support.

Weird, not sure why I didn't get this email ...

> > > 
> > > Thanks,
> > > Slava.
> > 
> > OK, I'll add the following into common/ceph
> >  
> > +# this test requires ceph snapshot support
> > +_require_ceph_snapshot()
> > +{
> > + local test_snapdir="$TEST_DIR/.snap/test_snap_$$"
> > + mkdir "$test_snapdir" 2>/dev/null || _notrun "Ceph snapshots not supported (requires fs flag 'allow_snaps' and client auth capability 'snap')"
> > + rmdir "$test_snapdir"

So ".snap" directory is a ceph specific directory for snapshot. Sorry, I never used
ceph, I'm wondering, if ceph snapshot feature isn't supported, users can't create any
directory with "." prefix, or only can't create ".snap" in ceph? Due to ".snap" directory
can be created in general filesystems (no special meaning):

  $ mkdir .snap
  $ ls -ld .snap
  drwxr-xr-x. 2 zorro zorro 6 Oct  2 15:09 .snap
  $ rm -rf .snap

Thanks,
Zorro

> > +}
> >  
> > and add 
> > +_require_ceph_snapshot
> > in ceph/006
> >  
> > is this check and error message clear enough?
> > 
> 
> Looks good. I believe it looks reasonably enough. :)
> 
> Thanks,
> Slava.


