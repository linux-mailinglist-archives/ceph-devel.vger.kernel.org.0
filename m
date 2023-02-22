Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB96469F645
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Feb 2023 15:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjBVOQX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Feb 2023 09:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjBVOQQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 22 Feb 2023 09:16:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1DC144A3
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 06:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677075334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPNy9tLGVjaBjeUQMmIhCGcrG83Gp98NBbtaFuvdgUc=;
        b=ODZQ3YBDRNGTClm9sxNwU4yb5Yl4qRmzsPozULuMkn6AW1h5jhGC6DCfwcSKJCmWTbYKNM
        gg19Zldxfzw6/tTyI+mUCo9OYhh0k56Z9l7+SNyJ5VUTP4cRZdvytW9RPhb/rkAg+1hTKY
        8oq9K6QrCFQdUMySDIA2NxJ9Mbvjk/o=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-126-9ok7O0WaPq-JwCrBvcUVJg-1; Wed, 22 Feb 2023 09:15:33 -0500
X-MC-Unique: 9ok7O0WaPq-JwCrBvcUVJg-1
Received: by mail-pl1-f197.google.com with SMTP id l10-20020a17090270ca00b0019caa6e6bd1so765309plt.2
        for <ceph-devel@vger.kernel.org>; Wed, 22 Feb 2023 06:15:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPNy9tLGVjaBjeUQMmIhCGcrG83Gp98NBbtaFuvdgUc=;
        b=ZFnSKHZB0gaFcX1NZ0w8mAvyNNIBgIUuUppSGSf1KZ4uSrGXS62gBwWSJVnBhmswCn
         AScuyJz38pqmazXshaV5a6pzdhDzV1rs5PjRmEHPrKgcLQGDAJxNH94G/uwAlDauGzol
         lWzqQYRKvgSvAN7lNfSZFundzsOg4WpIAprT4BX1VCiIZF6icQURl7Ik+g/efKMwKmnG
         yv8s7k5dz8Ap1yOVjKki40i+4wmgor5VwluWycZWspaDE8IpSoodUveziHZhge2A+D6g
         gTOybjYEMi6mWOjMdxz+uxL+RiKqZwfL6ETspul1BkGzsDGk2AaSmRG7yzv4km8EhGfU
         nlLQ==
X-Gm-Message-State: AO0yUKWABGyRPOT7Vlib9pnJye8sboGNydlBN95Xlmy3dUZDgv2kTMRs
        +qhvC9V4U8bt9RZI190ZcHvY6GUURchkrhMXlk9qcySmuCCLhgenzIP8LiKoQTkwk36DIPWdlKb
        KToZKjbgpoVJIned3zu0MDzK0E3LCSw==
X-Received: by 2002:a05:6a20:698f:b0:b5:c751:78bb with SMTP id t15-20020a056a20698f00b000b5c75178bbmr9618685pzk.6.1677075332179;
        Wed, 22 Feb 2023 06:15:32 -0800 (PST)
X-Google-Smtp-Source: AK7set+mAXTNGHcMULpHxNWNSizVVLre7mb5z3XCD2w6nURApl1+MPV6Hud1WTjUVCMmnjxvmXmwww==
X-Received: by 2002:a05:6a20:698f:b0:b5:c751:78bb with SMTP id t15-20020a056a20698f00b000b5c75178bbmr9618645pzk.6.1677075331701;
        Wed, 22 Feb 2023 06:15:31 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y21-20020a634b15000000b004ff6b744248sm4816599pga.48.2023.02.22.06.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:15:31 -0800 (PST)
Date:   Wed, 22 Feb 2023 22:15:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] generic/020: fix really long attr test failure for ceph
Message-ID: <20230222141526.hgrewr3ezkohukk4@zlang-mailbox>
References: <20230217124558.555027-1-xiubli@redhat.com>
 <Y++0t8qxK8et8fTg@magnolia>
 <20230218060436.534bnbs5znio5pd7@zlang-mailbox>
 <Y/UZ2mwahyPzYSMj@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/UZ2mwahyPzYSMj@magnolia>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 21, 2023 at 11:22:02AM -0800, Darrick J. Wong wrote:
> On Sat, Feb 18, 2023 at 02:04:36PM +0800, Zorro Lang wrote:
> > On Fri, Feb 17, 2023 at 09:09:11AM -0800, Darrick J. Wong wrote:
> > > On Fri, Feb 17, 2023 at 08:45:58PM +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
> > > > itself will set the security.selinux extended attribute to MDS.
> > > > And it will also eat some space of the total size.
> > > > 
> > > > Fixes: https://tracker.ceph.com/issues/58742
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >  tests/generic/020 | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/tests/generic/020 b/tests/generic/020
> > > > index be5cecad..594535b5 100755
> > > > --- a/tests/generic/020
> > > > +++ b/tests/generic/020
> > > > @@ -150,9 +150,11 @@ _attr_get_maxval_size()
> > > >  		# it imposes a maximum size for the full set of xattrs
> > > >  		# names+values, which by default is 64K.  Compute the maximum
> > > >  		# taking into account the already existing attributes
> > > > -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> > > > +		size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> > > >  			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> > > > -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> > > > +		selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
> > > > +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> > > > +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))

The max_attrval_size isn't a local variable, due to we need it to be global.
But the "size" and "selinux_size" look like not global variable, so better
to be *local*.

> > > 
> > > If this is a ceph bug, then why is the change being applied to the
> > > section for FSTYP=ext* ?  Why not create a case statement for ceph?
> > 
> > Hi Darrick,
> > 
> > Looks like this change is in ceph section [1], did you hit any errors when
> > you merge it?
> 
> ahahaa, diff tried to merge that hunk into _attr_get_max and not
> _attr_get_maxval_size, and I didn't notice.  Question withdrawn
> with apologies. :/

Never mind. If there's not objection from you or ceph list, I'll merge this
patch after it changes as above :)

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > [1]
> > _attr_get_maxval_size()
> > {
> >         local max_attrval_namelen="$1"
> >         local filename="$2"
> > 
> >         # Set max attr value size in bytes based on fs type
> >         case "$FSTYP" in
> >         ...
> >         ...
> >         ceph)
> >                 # CephFS does not have a maximum value for attributes.  Instead,
> >                 # it imposes a maximum size for the full set of xattrs
> >                 # names+values, which by default is 64K.  Compute the maximum
> >                 # taking into account the already existing attributes
> > ====>           max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> >                         awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> > ====>           max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> > 
> > 
> > 
> > > 
> > > --D
> > > 
> > > >  		;;
> > > >  	*)
> > > >  		# Assume max ~1 block of attrs
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> 

