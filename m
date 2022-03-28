Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FF44E9C2D
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Mar 2022 18:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbiC1Q0E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Mar 2022 12:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240958AbiC1Q0C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Mar 2022 12:26:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8E131516
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 09:24:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F939CE1407
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 16:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AC6C004DD;
        Mon, 28 Mar 2022 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648484658;
        bh=p9yMJoYX5O4hMc6LHel+fKIf+HOd83HJ7fvlPKM/5WA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LpYgmhOUkLBQzyWcvfVuSqC5948bd0Ia0lySLvj2zCshYPzfm3hMAj4KrUOI9DARq
         guXxnrOCUMH0TpiemvDcqBaoaG2PMY2xPX6Pk4+hsLnYvJvey8uMCLgCrmZw6iHe8a
         kuHXvHCCXaapp2HVgxwsTnSyuQWvAhdtVySVFXoJNDrFHT/+qGV8KfxcMVlnwkGbb7
         G1NTtUMtaSqUAx9cD0+tXRVHb7tUCb62W1ho4M1oJOD7YXghwkelSGUIvUq92xHzb7
         FmBvRIJPXgPzCgOfJpYt94hZywppu6b9vcbIemZXFlfLLLEAm+k+ZSFwYlKgzax6vc
         PLSCdmDUbWVRg==
Message-ID: <2956c9efb7c048ed0636034bedced4be282a118f.camel@kernel.org>
Subject: Re: [PATCH] ceph: shrink dcache when adding a key
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com
Date:   Mon, 28 Mar 2022 12:24:16 -0400
In-Reply-To: <87r16mqct7.fsf@brahms.olymp>
References: <20220328133257.28422-1-jlayton@kernel.org>
         <87r16mqct7.fsf@brahms.olymp>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-03-28 at 17:09 +0100, Luís Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > Any extant dentries under a directory will be invalid once a key is
> > added to the directory. Prune any child dentries of the parent after
> > adding a key.
> > 
> > Cc: Luís Henriques <lhenriques@suse.de>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/ioctl.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > This one is for the ceph+fscrypt series.
> > 
> > Luis, this seems to fix 580 and 593 for me. 595 still fails with it, but
> > that one is more related to file contents.
> > 
> > diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> > index 9675ef3a6c47..12d5469c5df2 100644
> > --- a/fs/ceph/ioctl.c
> > +++ b/fs/ceph/ioctl.c
> > @@ -397,7 +397,10 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >  		ret = vet_mds_for_fscrypt(file);
> >  		if (ret)
> >  			return ret;
> > -		return fscrypt_ioctl_add_key(file, (void __user *)arg);
> > +		ret = fscrypt_ioctl_add_key(file, (void __user *)arg);
> > +		if (ret == 0)
> > +			shrink_dcache_parent(file_dentry(file));
> > +		return ret;
> 
> OK, a problem with this is that we're using the big hammer: this ioctl is
> being executed on the filesystem root and not the directory you're
> expecting.  This is because keys can used for more than one directory.
> So, the performance penalty with this fix is probably not acceptable.
> 

file represents an open file description, so file_dentry should be
wherever its path terminates. So, I think this should end up getting run
on the correct dentry.

Oh, but looking at the fscrypt command line application, yeah it does
seem to open the root of the fs, so this would end up purging a lot more
dentries than intended.

Fair enough...I'll drop this one. We'll need to think of some other way
to fix this.
-- 
Jeff Layton <jlayton@kernel.org>
