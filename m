Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6C160F3C4
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Oct 2022 11:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiJ0JeQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Oct 2022 05:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbiJ0JeP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Oct 2022 05:34:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA0A55B4;
        Thu, 27 Oct 2022 02:34:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BC8D11FD9E;
        Thu, 27 Oct 2022 09:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666863253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mo5VjBJopb6t0bIX2LNQKERqIU6BVSbT2DILkFGTOxw=;
        b=b6qEnDSqLVt35QnK/rh2rZJJA1B+IsXQLlukd62OTEr26NFTbR7BwdcVn6Gh018vSU1Jnr
        w4gOPGYhta5LpKKh+advTOfweF6n/Ws7eo2N6/rByG9P0RZSbl0AcEqUPvlWHdZ8etrPLc
        Yh/F4+ZiImlyINaKeAjZgWB9j1Rc3eI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666863253;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mo5VjBJopb6t0bIX2LNQKERqIU6BVSbT2DILkFGTOxw=;
        b=5cJH7zhUb8kwNdTztpjcxVHcwg3SumEIEjc8HDgEKEAq3qhBSslf6ID5ug8Tw1RoMdjZqF
        mFJzrgsyWjZgSQBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 395A313357;
        Thu, 27 Oct 2022 09:34:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9HgAC5VQWmMFYwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 27 Oct 2022 09:34:13 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f36b2c5c;
        Thu, 27 Oct 2022 09:35:11 +0000 (UTC)
Date:   Thu, 27 Oct 2022 10:35:11 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     xiubli@redhat.com, fstests@vger.kernel.org, david@fromorbit.com,
        djwong@kernel.org, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com
Subject: Re: [PATCH v2] encrypt: add ceph support
Message-ID: <Y1pQz8LICOT1idp+@suse.de>
References: <20221027030021.296548-1-xiubli@redhat.com>
 <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221027032023.6arvnrkl7fymdjqj@zlang-mailbox>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 27, 2022 at 11:20:23AM +0800, Zorro Lang wrote:
> On Thu, Oct 27, 2022 at 11:00:21AM +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  common/encrypt | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/common/encrypt b/common/encrypt
> > index 45ce0954..1a77e23b 100644
> > --- a/common/encrypt
> > +++ b/common/encrypt
> > @@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
> >  		# erase the UBI volume; reformated automatically on next mount
> >  		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
> >  		;;
> > +	ceph)
> > +		_scratch_cleanup_files
> > +		;;
> 
> Any commits about that?
> 
> Sorry I'm not familar with cephfs, is this patch enough to help ceph to test
> encrypted ceph? Due to you tried to do some "checking" job last time.
> 
> Can "./check -g encrypt" work on ceph? May you paste this test result to help
> to review? And welcome review points from ceph list.

I think Xiubo's patch is likely to be required for enabling encryption
testing in ceph.  Simply doing a '_scratch_cleanup_files' is exactly what
network filesystems are doing on _scratch_mkfs().  Thus it makes sense for
ceph to do the same for testing fscrypt support, as we don't really have
an 'mkfs.ceph' tool.

Now, this patch alone is probably not enough to allow to do all the
validation we're looking for.  (But note that I did *not* tried it myself,
so I may be wrong.)  I think we'll need to go through each of the
'encrypt' tests, run it in ceph and see if they are really testing what
they are supposed to.

But that's just my two cents ;-)

Cheers,
--
Luís

> 
> Thanks,
> Zorro
> 
> [1]
> $ grep -rsn _scratch_mkfs_encrypted tests/generic/
> tests/generic/395:22:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/396:21:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/580:23:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/581:36:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/595:35:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/613:29:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/621:57:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/429:36:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/397:28:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/398:28:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/421:24:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/440:29:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/419:29:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/435:33:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/593:24:_scratch_mkfs_encrypted &>> $seqres.full
> tests/generic/576:34:_scratch_mkfs_encrypted_verity &>> $seqres.full
> 
> >  	*)
> >  		_notrun "No encryption support for $FSTYP"
> >  		;;
> > -- 
> > 2.31.1
> > 
> 

