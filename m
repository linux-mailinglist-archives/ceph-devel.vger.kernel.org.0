Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6986D60F7F0
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 14:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbiJ0MtU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 08:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbiJ0MtQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 08:49:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D5216F432
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666874953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cHqvMwxRqRdRD6fhEnjExRRGq07E2A9r8/jZD1+Fv8Y=;
        b=Y+ODmrzv1o9aaryEyzeJAa6rCLHNn2xfaCI+zmm/jWCp/0fIzm+1qYfq/v7oUlZhhx3FBG
        /u2Cgk7Nch0jD7oYys9PtzS579OkhqGIxIgYnCMU16fPGH/OuBAxC8zCMMmBgmczsOKwvb
        5Sk4zg52x5m2qNoLhOIkn8JRmYuIFt4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-JQh7zBpwMaKSgQcujyaQwg-1; Thu, 27 Oct 2022 08:49:12 -0400
X-MC-Unique: JQh7zBpwMaKSgQcujyaQwg-1
Received: by mail-pg1-f197.google.com with SMTP id v18-20020a637a12000000b0046ed84b94efso717154pgc.6
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHqvMwxRqRdRD6fhEnjExRRGq07E2A9r8/jZD1+Fv8Y=;
        b=EfZsnxeu4uzC24baiV4B7h6ubCq7uz9XEe48UOGcxXl9kOQ+ggyYNwMVu7wJmdTffw
         CJwCL+htA4tCdgBjOtATRXgcYwhf7FhvQgEQUoOMxHPqFoAytlswrdE4T/gRTjeQC9BX
         N6yo0M/BEt3cX4w8Bki2AyreghwHk+vaWh0UA2O6wqV1Sv2I+Zt9sy7aVXHCPblboYZE
         Pzy2BnN2y/1lbaEmS0T/QRf+CpDvdPYXwoJf5ZAjIdVYWhlZ3HfGkkmz2OCbxFmO2Tep
         7jJy7aKWmGJwYrBhZC+mizcJhf3BImqWKeYfopYyz7P75o7SITdzMr9ynrT8v84ga90g
         32zw==
X-Gm-Message-State: ACrzQf0ryJ46Q5+89Phm5L6qdSsHhZQJHyJ+hQV1bosHBtWuJrTfBvsd
        p8ROnl7eY720V2bVzgfcFIvZsp0QaDVuc7yDK6XcXwCngpx5kQ7fBDodUuwLLDstgZUA85XW9hi
        IE/cqdQlGYK+Bi8wzRZkScQ==
X-Received: by 2002:aa7:94b1:0:b0:56c:8da8:4e3 with SMTP id a17-20020aa794b1000000b0056c8da804e3mr4133622pfl.62.1666874951251;
        Thu, 27 Oct 2022 05:49:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4BjVbAuCIJjG2mfjadC4PhqrAigrSHZs2aTxvBOrojc11nh9kg5IOgvPJ31z+dghdvh28emw==
X-Received: by 2002:aa7:94b1:0:b0:56c:8da8:4e3 with SMTP id a17-20020aa794b1000000b0056c8da804e3mr4133593pfl.62.1666874950919;
        Thu, 27 Oct 2022 05:49:10 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1153608plf.161.2022.10.27.05.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:49:10 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:49:04 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        lhenriques@suse.de, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Subject: Re: [PATCH v2] encrypt: add ceph support
Message-ID: <20221027124904.ibx62eqbyyqghdjm@zlang-mailbox>
References: <20221027030021.296548-1-xiubli@redhat.com>
 <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
 <e5c876ce-8f0d-c51e-bb04-78c49ebf79c9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5c876ce-8f0d-c51e-bb04-78c49ebf79c9@redhat.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 27, 2022 at 05:49:08PM +0800, Xiubo Li wrote:
> 
> On 27/10/2022 11:20, Zorro Lang wrote:
> > On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   common/encrypt | 3 +++
> > >   1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/common/encrypt b/common/encrypt
> > > index 45ce0954..1a77e23b 100644
> > > --- a/common/encrypt
> > > +++ b/common/encrypt
> > > @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
> > >   		# erase the UBI volume; reformated automatically on next mount
> > >   		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
> > >   		;;
> > > +	ceph)
> > > +		_scratch_cleanup_files
> 
> Here I just skip ceph and it is enough. Because the
> _require_scratch_encryption() will do the same thing as I did in my V1's 2/2
> patch.

Great, actually that's what I hope to know. So the ceph encryption testing
can be supported naturally by just enabling ceph in _scratch_mkfs_encrypted.

And from the testing output you showed in last patch, it looks good on testing
ceph encryption. So I think this patch works as expected. I'll merger this
patch if no more review points from ceph list. And feel free to improve cases
in encrypt group later if someone fails on ceph.

Thanks,
Zorro

> 
> - Xiubo
> 
> > > +		;;
> > Any commits about that?
> > 
> > Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
> > encrypted ceph? Due to you tried to do some "checking" job last time.
> > 
> > Can "./check -g encrypt" work on ceph? May you paste this test result to help
> > to review? And welcome review points from ceph list.
> > 
> > Thanks,
> > Zorro
> > 
> > [1]
> > $ grep -rsn _scratch_mkfs_encrypted tests/generic/
> > tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
> > tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full
> > 
> > >   	*)
> > >   		_notrun "No encryption support for $FSTYP"
> > >   		;;
> > > -- 
> > > 2.31.1
> > > 
> 

