Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B335461D7
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 11:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349080AbiFJJWF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 05:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349111AbiFJJVs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 05:21:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01D1119142E
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 02:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654852749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X0AMPbkKhpdg7q0DancqofewrNdx6mFHU0gwDtav3v0=;
        b=SgWFfu5SfETH9O7QEjI2Qq7igvgQcHqaMgk125tPLBs75JyIFVWcnH+JVBPQ/eQ32KpDjV
        7RXK8A4VBSYX2RN9ZUQDnzQXv6IFuH25CTPbza4u8UyuYBxJMCdCPZokjtmImhqRKCdgB0
        kJ6aoHnr/p6Nwtuk+jOZmy8XWhJ4O40=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-cxoWNpQgNgSVqgGwEdKvvw-1; Fri, 10 Jun 2022 05:19:08 -0400
X-MC-Unique: cxoWNpQgNgSVqgGwEdKvvw-1
Received: by mail-qk1-f197.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso13002089qkb.0
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jun 2022 02:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=X0AMPbkKhpdg7q0DancqofewrNdx6mFHU0gwDtav3v0=;
        b=A0RjzFidPNqjgLnBqeigD6XQNBuypXwWsrd061f5xF5frusPYhiIDL3GNAE14cOKJ8
         Pwpfe1mld5TAX8/0t8mw6c36zefTMO/biofAJw68AZlxLmSZ/LoYQ/ps2kVdXBOPMQqI
         yiiD0UR9qZb4oN7ovevDNOgqlVOSNZD23aAtguvvid2fwbTyUjFkvgMdmdMo24Q3cbwH
         GPeFHNwma5f1I1JycHj2g841WJae48OXUqHnT24UQCjsCgy6/fozU35D1mNvqvW/sWYJ
         Ga5mi2DSkDLhcVw/+SqTkBTNgZdep+vOiowDXWh8bJNdEgCmB6Fp/8dFKcYxGF9fBXVD
         3qXw==
X-Gm-Message-State: AOAM531g8HzjDKia99VEv/zNnWItnQbiIJYQGPseUckaNir8xlZfgX7e
        eB3RJ7HQ4cCPNRa59AgECwt1Zb+d0Uvq6dvzK1NxKQzUxSUIAa02uILZXd0LQqZbrCHBDZuClAm
        Amdb8RIdPnuHa7IJnM5mVcw==
X-Received: by 2002:a05:6214:5f8d:b0:464:6b1b:1bf2 with SMTP id ls13-20020a0562145f8d00b004646b1b1bf2mr33087142qvb.0.1654852747753;
        Fri, 10 Jun 2022 02:19:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFzSDQQVuVx2QtTYthqX9570kQJUi1CSJocxBs0ABJubI2O6NQmCL556UriOzDh41WzCYopA==
X-Received: by 2002:a05:6214:5f8d:b0:464:6b1b:1bf2 with SMTP id ls13-20020a0562145f8d00b004646b1b1bf2mr33087130qvb.0.1654852747481;
        Fri, 10 Jun 2022 02:19:07 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t69-20020a374648000000b006a71c420460sm4706121qka.22.2022.06.10.02.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 02:19:06 -0700 (PDT)
Date:   Fri, 10 Jun 2022 17:19:01 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] generic/486: adjust the max xattr size
Message-ID: <20220610091901.is7qjqq3asr7hihh@zlang-mailbox>
References: <20220609105343.13591-1-lhenriques@suse.de>
 <20220609105343.13591-3-lhenriques@suse.de>
 <4c4572a2-2681-c2f7-a8dc-55eb2f5fc077@redhat.com>
 <20220610072545.GY1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220610072545.GY1098723@dread.disaster.area>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 10, 2022 at 05:25:45PM +1000, Dave Chinner wrote:
> On Fri, Jun 10, 2022 at 01:35:36PM +0800, Xiubo Li wrote:
> > 
> > On 6/9/22 6:53 PM, Luís Henriques wrote:
> > > CephFS doesn't have a maximum xattr size.  Instead, it imposes a maximum
> > > size for the full set of xattrs names+values, which by default is 64K.
> > > And since ceph reports 4M as the blocksize (the default ceph object size),
> > > generic/486 will fail in this filesystem because it will end up using
> > > XATTR_SIZE_MAX to set the size of the 2nd (big) xattr value.
> > > 
> > > The fix is to adjust the max size in attr_replace_test so that it takes
> > > into account the initial xattr name and value lengths.
> > > 
> > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > ---
> > >   src/attr_replace_test.c | 7 ++++++-
> > >   1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> > > index cca8dcf8ff60..1c8d1049a1d8 100644
> > > --- a/src/attr_replace_test.c
> > > +++ b/src/attr_replace_test.c
> > > @@ -29,6 +29,11 @@ int main(int argc, char *argv[])
> > >   	char *value;
> > >   	struct stat sbuf;
> > >   	size_t size = sizeof(value);
> > > +	/*
> > > +	 * Take into account the initial (small) xattr name and value sizes and
> > > +	 * subtract them from the XATTR_SIZE_MAX maximum.
> > > +	 */
> > > +	size_t maxsize = XATTR_SIZE_MAX - strlen(name) - 1;
> > 
> > Why not use the statfs to get the filesystem type first ? And then just
> > minus the strlen(name) for ceph only ?
> 
> No. The test mechanism has no business knowing what filesystem type
> it is running on - the test itself is supposed to get the limits for
> the filesystem type from the test infrastructure.
> 
> As I've already said: the right thing to do is to pass the maximum
> attr size for the test to use via the command line from the fstest
> itself. As per g/020, the fstests infrastructure is where we encode
> weird fs limit differences and behaviours based on $FSTYP.  Hacking
> around weird filesystem specific behaviours deep inside random bits
> of test source code is not maintainable.
> 
> AFAIA, only ceph is having a problem with this test, so it's trivial
> to encode into g/486 with:
> 
> # ceph has a weird dynamic maximum xattr size and block size that is
> # much, much larger than the maximum supported attr size. Hence the
> # replace test can't auto-probe a sane attr size and so we have
> # to provide it with a maximum size that will work.
> max_attr_size=65536
> [ "$FSTYP" = "ceph" ] && max_attr_size=64000
> attr_replace_test -m $max_attr_size .....
> .....

Agree. I'd recommend changing the attr_replace_test.c, make it have a
default max xattr size (keep using the XATTR_SIZE_MAX or define one if
it's not defined), then give it an optinal option which can specify a
customed max xattr size from outside.

Then the test case (e.g. g/486) which uses attr_replace_test can
specify a max xattr size if it needs. And it's easier to figure
out what attr size is better for a specified fs in test case.

Thanks,
Zorro

> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 

