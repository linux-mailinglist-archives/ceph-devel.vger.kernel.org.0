Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462D155D4D8
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343521AbiF1IwQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jun 2022 04:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245546AbiF1IwO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jun 2022 04:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B3F42F668
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jun 2022 01:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656406332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sg+6t/WRC3y7wGjHl1FclmwwuLrthUOcnyFnztl34Bk=;
        b=YVcmyrhPuyAIEbqc3+NW6DgbGhXzP7MDjociabb98isMLuzsxYjvrnrmZMEcl3+EbAQ7eF
        TeJwhKlZAwbGSY1rWq1Ozyh49FWB7ZLcFeIj4F5fvk7+nsedeRmmZAfQ9ylqBDb/75eHcw
        RhtRJguFNnscjZ6l6DQJyfNDspOy7yA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-Pdbsfp6xN4uo0yoATFuJWg-1; Tue, 28 Jun 2022 04:52:09 -0400
X-MC-Unique: Pdbsfp6xN4uo0yoATFuJWg-1
Received: by mail-qk1-f200.google.com with SMTP id g194-20020a379dcb000000b006aef700d954so12661610qke.1
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jun 2022 01:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Sg+6t/WRC3y7wGjHl1FclmwwuLrthUOcnyFnztl34Bk=;
        b=wVlK5gOtisd1ODOlCciHbpmpxYDhYKiAKfq1W9Y/0an4nRyUbjOl8N2plx0fEchmRh
         o9v814V6xmkfAS6FG+j8wvaDURm0dTHQBxE5bzfTGWVMabbqAF9CV/qV0jIo7gMfxBBx
         paa/zopWoJYFwPlDEhM1KrhdxP4sSWLh1aNgjDsSPLejotLfZPnNhteINNBRFDj0976F
         j0yM/hFNPNRpKsMfeMDo3TkQlNS6kOU0xaSaSSRqep+3KWje2QX2lVlFlhwlD/HZ/c32
         PdzDe1T6qQl8Q+65HpyWYXqlL4lLxAQdecf2zdmLLpTAj4Pi3KIt5D3Y75tfl75adj/h
         Q1XA==
X-Gm-Message-State: AJIora9Zvz/uvnFcoo/IigQKKF5/QE6RcR0zJVxIEcxEX541lh2Qzfgl
        SOZz/JQZeMvLhrl2hdWoU0yXrTJbXDBJ1kE9oc8AAj45a82A4tkyEByXoEExIm9HKfj7SNqIJMc
        7OdVf9gu8A+F8b9eJk7jDwg==
X-Received: by 2002:a05:622a:44e:b0:305:252e:6807 with SMTP id o14-20020a05622a044e00b00305252e6807mr11912241qtx.440.1656406329259;
        Tue, 28 Jun 2022 01:52:09 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sHDfbVbTcurmEO5+rWThPzE8LQ1XynMoMUkbawOQYlZ6aJ5NH5VxVYrNy3iX+GflYr81i/Ag==
X-Received: by 2002:a05:622a:44e:b0:305:252e:6807 with SMTP id o14-20020a05622a044e00b00305252e6807mr11912232qtx.440.1656406328963;
        Tue, 28 Jun 2022 01:52:08 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y20-20020a05620a44d400b006af0639f7casm10255040qkp.12.2022.06.28.01.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 01:52:08 -0700 (PDT)
Date:   Tue, 28 Jun 2022 16:52:01 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>,
        fstests@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3] ceph/005: verify correct statfs behaviour with quotas
Message-ID: <20220628085201.p3pkyozrvbrf3vod@zlang-mailbox>
References: <20220627102631.5006-1-lhenriques@suse.de>
 <3a0a72f9-6b36-f101-d77e-f5b6e51adc56@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a0a72f9-6b36-f101-d77e-f5b6e51adc56@redhat.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 28, 2022 at 04:36:39PM +0800, Xiubo Li wrote:
> Hi Luis,
> 
> BTW, shouldn't you update the 'tests/ceph/group.list' at the same time ?

Thanks your review from cephfs side! We don't save group.list in fstests now,
group.list is generated when building fstests. Group names of a case are
recorded in the case itself, refer to:

  +_begin_fstest auto quick quota

Thanks,
Zorro

> 
> -- Xiubo
> 
> On 6/27/22 6:26 PM, Luís Henriques wrote:
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
> > Changes since v2:
> >   - correctly set SCRATCH_DEV, always using its original value
> > 
> > Changes since v1 are:
> >   - creation of an helper for getting total mount space using 'df'
> >   - now the test sends quota size to stdout
> > 
> >   common/rc          | 13 +++++++++++++
> >   tests/ceph/005     | 39 +++++++++++++++++++++++++++++++++++++++
> >   tests/ceph/005.out |  4 ++++
> >   3 files changed, 56 insertions(+)
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
> > index 000000000000..fd71d91350db
> > --- /dev/null
> > +++ b/tests/ceph/005
> > @@ -0,0 +1,39 @@
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
> > +SCRATCH_DEV_ORIG="$SCRATCH_DEV"
> > +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> > +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> > +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_unmount
> > +
> > +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_mount
> > +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> > +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_unmount
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

