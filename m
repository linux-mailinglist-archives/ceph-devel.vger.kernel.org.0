Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCA55D89A
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbiF0JTy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jun 2022 05:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiF0JTx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jun 2022 05:19:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB8263B8;
        Mon, 27 Jun 2022 02:19:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EA5771F8AC;
        Mon, 27 Jun 2022 09:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656321590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sm4xpFowiV7Pb+AM9h+icrSiBuInNpe2uAQ9pxcj5ek=;
        b=wnF9/6NlVxijYEipNiiWrMysvk2+Y5oqQCXhHcPoPBlrlqOVhjBjcqVTy07dNxgkicMaMB
        eFBiFC+I07i5qh47XfxV+yAP+vlmjE+u7idCo0bSfOl+sdyAUW11v4nahMj6H39p8PNAHw
        BjRay/XBWJGfQlxcBh6VIJE7nZQC7gs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656321590;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sm4xpFowiV7Pb+AM9h+icrSiBuInNpe2uAQ9pxcj5ek=;
        b=IyWaIrVIKWwX6XwI97Q+6Q6tEgm6M+IJ628LBYtL/6YGFRuXQCp9sgvzddm1LOixkf/zrz
        tPriHFovX3uUC0Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8142113456;
        Mon, 27 Jun 2022 09:19:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ckt/HDZ2uWJoJgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 27 Jun 2022 09:19:50 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d8d992fd;
        Mon, 27 Jun 2022 09:20:37 +0000 (UTC)
Date:   Mon, 27 Jun 2022 10:20:37 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     fstests@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph/005: verify correct statfs behaviour with quotas
Message-ID: <Yrl2ZXzOcwM6LCLe@suse.de>
References: <20220615151418.23805-1-lhenriques@suse.de>
 <1924a7cc-245d-f35b-5e7c-a82f36cf2271@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1924a7cc-245d-f35b-5e7c-a82f36cf2271@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 27, 2022 at 08:35:14AM +0800, Xiubo Li wrote:
> Hi Luis,
> 
> Sorry for late.
> 
> On 6/15/22 11:14 PM, Luís Henriques wrote:
> > When using a directory with 'max_bytes' quota as a base for a mount,
> > statfs shall use that 'max_bytes' value as the total disk size.  That
> > value shall be used even when using subdirectory as base for the mount.
> > 
> > A bug was found where, when this subdirectory also had a 'max_files'
> > quota, the real filesystem size would be returned instead of the parent
> > 'max_bytes' quota value.  This test case verifies this bug is fixed.
> > 
> > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > ---
> > Finally, I've managed to come back to this test.  The major changes since
> > v1 are:
> >   - creation of an helper for getting total mount space using 'df'
> >   - now the test sends quota size to stdout
> > 
> >   common/rc          | 13 +++++++++++++
> >   tests/ceph/005     | 38 ++++++++++++++++++++++++++++++++++++++
> >   tests/ceph/005.out |  4 ++++
> >   3 files changed, 55 insertions(+)
> >   create mode 100755 tests/ceph/005
> >   create mode 100644 tests/ceph/005.out
> > 
> > diff --git a/common/rc b/common/rc
> > index 2f31ca464621..72eabb7a428c 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4254,6 +4254,19 @@ _get_available_space()
> >   	echo $((avail_kb * 1024))
> >   }
> > +# get the total space in bytes
> > +#
> > +_get_total_space()
> > +{
> > +	if [ -z "$1" ]; then
> > +		echo "Usage: _get_total_space <mnt>"
> > +		exit 1
> > +	fi
> > +	local total_kb;
> > +	total_kb=`$DF_PROG $1 | tail -n1 | awk '{ print $3 }'`
> > +	echo $(($total_kb * 1024))
> > +}
> > +
> >   # return device size in kb
> >   _get_device_size()
> >   {
> > diff --git a/tests/ceph/005 b/tests/ceph/005
> > new file mode 100755
> > index 000000000000..7eb687e8a092
> > --- /dev/null
> > +++ b/tests/ceph/005
> > @@ -0,0 +1,38 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
> > +#
> > +# FS QA Test 005
> > +#
> > +# Make sure statfs reports correct total size when:
> > +# 1. using a directory with 'max_byte' quota as base for a mount
> > +# 2. using a subdirectory of the above directory with 'max_files' quota
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick quota
> > +
> > +_supported_fs ceph
> > +_require_scratch
> > +
> > +_scratch_mount
> > +mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
> > +
> > +# set quota
> > +quota=$((2 ** 30)) # 1G
> > +$SETFATTR_PROG -n ceph.quota.max_bytes -v "$quota" "$SCRATCH_MNT/quota-dir"
> > +$SETFATTR_PROG -n ceph.quota.max_files -v "$quota" "$SCRATCH_MNT/quota-dir/subdir"
> > +_scratch_unmount
> > +
> > +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> > +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> > +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_unmount
> > +
> 
> For the 'SCRATCH_DEV' here, if you do:
> 
> SCRATCH_DEV="$SCRATCH_DEV/quota-dir"
> 
> twice, won't it be "${ceph_scratch_dev}/quota-dir/quota-dir" at last ?
> 
> Shouldn't it be:
> 
> SCRATCH_DEV="$TEST_DIR/quota-dir" ?

No, actually we do really need to have $SCRATCH_DEV and not $TEST_DIR
here, because we want to have SCRATCH_DEV set to something like:

	<mon-ip-addr>:<port>:/quota-dir

so that we will use that directory (with quotas) as base for the mount.

Regarding the second attribution using the already modifed $SCRATCH_DEV
variable, that's not really what is happening (and I had to go
double-check myself, as you got me confused too :-).

So, if you do:

SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_unmount

the SCRATCH_DEV value is changed *only* for the _scratch_[un]mount
functions, but SCRATCH_DEV value isn't really changed after these
attributions.  This is probably a bashism (I'm not really sure), but you
can see a similar pattern in other places (see, for example, test
xfs/234).

Anyway, if you prefer, I'm fine sending v3 of this test doing something
like:

SCRATCH_DEV_ORIG="$SCRATCH_DEV"
SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_mount
...

Cheers,
--
Luís

> 
> -- Xiubo
> 
> > +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_mount
> > +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> > +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_unmount
> > +
> > +echo "Silence is golden"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/ceph/005.out b/tests/ceph/005.out
> > new file mode 100644
> > index 000000000000..47798b1fcd6f
> > --- /dev/null
> > +++ b/tests/ceph/005.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 005
> > +ceph quota size is 1073741824 bytes
> > +subdir ceph quota size is 1073741824 bytes
> > +Silence is golden
> > 
> 
