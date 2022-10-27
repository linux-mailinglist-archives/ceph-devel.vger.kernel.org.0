Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A61360F80A
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 14:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbiJ0Mwk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 08:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiJ0Mwj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 08:52:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DA86C104
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666875157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOyMbmJZgxsgbqrGPqmAeeEUH+41Z5rxH+cR4EGVYzU=;
        b=chEMPNrRholy3pvxPNoEoSUBdBBP4buCbAaAdiwfCJ2xhok+STKdtvtfMyWxEW1CxgLUq4
        s6s83TP15xoC4YBe2gOMAWiCmS29+HpJ89sCstfvtDl+Q6ZWZpX74u1INrlR/dgbVtad3T
        nA5PjqLmmroXFm0qzqXde5Z1SOr2Kj4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-6-3u1Ns9k7OMOmPhVZ7JikFA-1; Thu, 27 Oct 2022 08:52:35 -0400
X-MC-Unique: 3u1Ns9k7OMOmPhVZ7JikFA-1
Received: by mail-pg1-f200.google.com with SMTP id v18-20020a637a12000000b0046ed84b94efso721127pgc.6
        for <ceph-devel@vger.kernel.org>; Thu, 27 Oct 2022 05:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOyMbmJZgxsgbqrGPqmAeeEUH+41Z5rxH+cR4EGVYzU=;
        b=h6jgfuqz/3Lj6M2Wo4/pdmrzffXNKWbzAFVJHDfxJ93sge+T7zC6DZdIpbccbUsiXc
         vDbpMFUzw/4166BUpowZVkENN4YSG8A1RkBJ9W9gwPIW164L4gTr5e5mwG82T3UBUMYg
         l2YOhKJuXt5BWenu16G18UQvOcy5mWkWGMgnsLzhTP2jPMnKND8laDn3RBshj6AEmqCs
         msIYdNN1S7ejYU30oOueUBYOD5AgSIH3p46SrWmhkvj/qDC/zQORsLAN8ZkLLRUSakFi
         zVZx7XaBsvm1izmABwPKeXEkm5KKQLw1Nt3s4dnhNTktTpLIv1DRmfoBVdBG2PIUFJyj
         hWlQ==
X-Gm-Message-State: ACrzQf1+ZOimUkl2oKBJbBNbjGHfoxwE9QIwpuW1a1eMThaRf1cQuDss
        ni69VRBTEOrWXTAUH6/CO0/X00C6OcLXVLnjtfKte+Y8ynQZmnukTrLdD7a1pzdP10or3DcSYJg
        /kEsiJUed69KjtIGiLY9IvA==
X-Received: by 2002:a65:6148:0:b0:458:88cd:f46 with SMTP id o8-20020a656148000000b0045888cd0f46mr8018724pgv.303.1666875154368;
        Thu, 27 Oct 2022 05:52:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ciDg4P10K5WHCo5gkuMkWl2MqrwJKf+3nDOwoQKJal1edjy5jZilBa2PzDpoHhuFomOQPng==
X-Received: by 2002:a65:6148:0:b0:458:88cd:f46 with SMTP id o8-20020a656148000000b0045888cd0f46mr8018706pgv.303.1666875154110;
        Thu, 27 Oct 2022 05:52:34 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a6-20020a170902710600b001865e69b4d7sm1097255pll.264.2022.10.27.05.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 05:52:33 -0700 (PDT)
Date:   Thu, 27 Oct 2022 20:52:28 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     xiubli@redhat.com, fstests@vger.kernel.org, david@fromorbit.com,
        djwong@kernel.org, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Subject: Re: [PATCH v2] encrypt: add ceph support
Message-ID: <20221027125228.myk36misrwadkawu@zlang-mailbox>
References: <20221027030021.296548-1-xiubli@redhat.com>
 <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
 <Y1pQz8LICOT1idp+@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y1pQz8LICOT1idp+@suse.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 27, 2022 at 10:35:11AM +0100, Luís Henriques wrote:
> On Thu, Oct 27, 2022 at 11:20:23AM +0800, Zorro Lang wrote:
> > On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >  common/encrypt | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/common/encrypt b/common/encrypt
> > > index 45ce0954..1a77e23b 100644
> > > --- a/common/encrypt
> > > +++ b/common/encrypt
> > > @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
> > >  		# erase the UBI volume; reformated automatically on next mount
> > >  		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
> > >  		;;
> > > +	ceph)
> > > +		_scratch_cleanup_files
> > > +		;;
> > 
> > Any commits about that?
> > 
> > Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
> > encrypted ceph? Due to you tried to do some "checking" job last time.
> > 
> > Can "./check -g encrypt" work on ceph? May you paste this test result to help
> > to review? And welcome review points from ceph list.
> 
> I think Xiubo's patch is likely to be required for enabling encryption
> testing in ceph.  Simply doing a '_scratch_cleanup_files' is exactly what
> network filesystems are doing on _scratch_mkfs().  Thus it makes sense for
> ceph to do the same for testing fscrypt support, as we don't really have
> an 'mkfs.ceph' tool.
> 
> Now, this patch alone is probably not enough to allow to do all the
> validation we're looking for.  (But note that I did *not* tried it myself,
> so I may be wrong.)  I think we'll need to go through each of the
> 'encrypt' tests, run it in ceph and see if they are really testing what
> they are supposed to.
> 
> But that's just my two cents ;-)

Sure :) I just hope to know if this patch is enough to help those encrypt
cases start running on ceph. As for some specific testing failures, that
can be another patchset.

Thanks,
Zorro

> 
> Cheers,
> --
> Luís
> 
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
> > >  	*)
> > >  		_notrun "No encryption support for $FSTYP"
> > >  		;;
> > > -- 
> > > 2.31.1
> > > 
> > 
> 

