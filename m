Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B145A53334F
	for <lists+ceph-devel@lfdr.de>; Wed, 25 May 2022 00:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiEXWLx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 May 2022 18:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiEXWLv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 May 2022 18:11:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F9C2FE4C;
        Tue, 24 May 2022 15:11:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 69C041F8D6;
        Tue, 24 May 2022 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653430308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUilvDc5VpPdpdcvwIhX1OMwlgDV/cOZqTz70E/jD0k=;
        b=rujv2iaf4e/RYx8Tr3LPueqlhGtAmXIUPpESCU8f41mEkFVa9RsXseT/GPSqDxcSuA5AyI
        MqSLdjG19dQH3NN5h+h23Yu8lXAsrYWACMUsLvbYNMXep0cw8INIgtgMZR6w4jH+yYC38C
        RMChYpf0I4C+CM2r+I/XQqg2rnVKv0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653430308;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUilvDc5VpPdpdcvwIhX1OMwlgDV/cOZqTz70E/jD0k=;
        b=q9FME0BqgFBf2Bqk64ceLm/TKCkWip/7QaxYdfFwVLRglrsnMhhHWS+CNStJa9lVyrW0wU
        VMAszz5hv1anOxBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2D9C413AE3;
        Tue, 24 May 2022 22:11:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xNPMCSRYjWLZVAAAMHmgww
        (envelope-from <ddiss@suse.de>); Tue, 24 May 2022 22:11:48 +0000
Date:   Wed, 25 May 2022 00:11:42 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     =?UTF-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] ceph/005: verify correct statfs behaviour with quotas
Message-ID: <20220525001142.0a17a41a@suse.de>
In-Reply-To: <20220427143409.987-1-lhenriques@suse.de>
References: <20220427143409.987-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Lu=C3=ADs,

It looks like this one is still in need of review...

On Wed, 27 Apr 2022 15:34:09 +0100, Lu=C3=ADs Henriques wrote:

> When using a directory with 'max_bytes' quota as a base for a mount,
> statfs shall use that 'max_bytes' value as the total disk size.  That
> value shall be used even when using subdirectory as base for the mount.
>=20
> A bug was found where, when this subdirectory also had a 'max_files'
> quota, the real filesystem size would be returned instead of the parent
> 'max_bytes' quota value.  This test case verifies this bug is fixed.
>=20
> Signed-off-by: Lu=C3=ADs Henriques <lhenriques@suse.de>
> ---
>  tests/ceph/005     | 40 ++++++++++++++++++++++++++++++++++++++++
>  tests/ceph/005.out |  2 ++
>  2 files changed, 42 insertions(+)
>  create mode 100755 tests/ceph/005
>  create mode 100644 tests/ceph/005.out
>=20
> diff --git a/tests/ceph/005 b/tests/ceph/005
> new file mode 100755
> index 000000000000..0763a235a677
> --- /dev/null
> +++ b/tests/ceph/005
> @@ -0,0 +1,40 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test 005
> +#
> +# Make sure statfs reports correct total size when:
> +# 1. using a directory with 'max_byte' quota as base for a mount
> +# 2. using a subdirectory of the above directory with 'max_files' quota
> +#
> +. ./common/preamble
> +_begin_fstest auto quick quota
> +
> +_supported_fs generic
> +_require_scratch
> +
> +_scratch_mount
> +mkdir -p $SCRATCH_MNT/quota-dir/subdir
> +
> +# set quotas
> +quota=3D$((1024*10000))
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v $quota $SCRATCH_MNT/quota-dir
> +$SETFATTR_PROG -n ceph.quota.max_files -v $quota $SCRATCH_MNT/quota-dir/=
subdir
> +_scratch_unmount
> +
> +SCRATCH_DEV=3D$SCRATCH_DEV/quota-dir _scratch_mount

Aside from the standard please-quote-your-variables gripe, I'm a little
confused with the use of SCRATCH_DEV for this test. Network FSes where
mkfs isn't provided don't generally use it. Is there any way that this
could be run against TEST_DEV, or does the umount / mount complicate
things too much?

Cheers, David
