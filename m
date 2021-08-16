Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC88B3EDA77
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 18:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhHPQD4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 12:03:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43688 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhHPQDz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Aug 2021 12:03:55 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5C7031FF94;
        Mon, 16 Aug 2021 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629129803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xnbr3kLFAwo6VGy0q66BBpHfF5zxjt9NJjmOzi584V0=;
        b=SrPVkVqQ78CqhcgZALIPRkUwJpBGaiE6dxtVxR22S6C4KF6n5bvliH6pqZfO0WAVwqiKbO
        OoGY6eOvUa4EdSr1KKv/Dvm4Ry57tTEwvfuYie3lS6N3RQEx8fuALK613ywghrQXckESlS
        nVd2w66is1f9gpe8qGqQ7Te+3aXPynY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629129803;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xnbr3kLFAwo6VGy0q66BBpHfF5zxjt9NJjmOzi584V0=;
        b=W9IUy+MvZcCguQcIfJRYWunpGZIt0/SNPLHGTlUAwAIbDnqBfX3CRZeHBJvdmnoeT/QTBY
        ZACH7iz51YSqSsAw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 16F7513301;
        Mon, 16 Aug 2021 16:03:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id B3eLAkuMGmFNXQAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Mon, 16 Aug 2021 16:03:23 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 7a432a69;
        Mon, 16 Aug 2021 16:03:22 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [fscrypt][RFC PATCH] ceph: don't allow changing layout on
 encrypted files/directories
References: <YRZtiL+qo95vK0Nf@suse.de>
        <e07e5f52bf73c0a9ef1441295f5ff42753d3e29a.camel@kernel.org>
        <87pmudtsho.fsf@suse.de>
        <1b55600eb096ac806ccd43c93aa0230a8cc46283.camel@kernel.org>
Date:   Mon, 16 Aug 2021 17:03:22 +0100
In-Reply-To: <1b55600eb096ac806ccd43c93aa0230a8cc46283.camel@kernel.org> (Jeff
        Layton's message of "Mon, 16 Aug 2021 10:01:26 -0400")
Message-ID: <87lf51tm0l.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Mon, 2021-08-16 at 14:43 +0100, Luis Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > On Fri, 2021-08-13 at 14:03 +0100, Luis Henriques wrote:
>> > > Encryption is currently only supported on files/directories with layouts
>> > > where stripe_count=1.  Forbid changing layouts when encryption is involved.
>> > > 
>> > > Signed-off-by: Luis Henriques <lhenriques@suse.de>
>> > > ---
>> > > Hi!
>> > > 
>> > > While continuing looking into fscrypt, I realized we're not yet forbidding
>> > > different layouts on encrypted files.  This patch tries to do just that.
>> > > 
>> > > Regarding the setxattr, I've also made a change [1] to the MDS code so that it
>> > > also prevents layouts to be changed.  This should make the changes to
>> > > ceph_sync_setxattr() redundant, but in practice it doesn't because if we encrypt
>> > > a directory and immediately after that we change that directory layout, the MDS
>> > > wouldn't yet have received the fscrypt_auth for that inode.  So... yeah, an
>> > > alternative would be to propagate the fscrypt context immediately after
>> > > encrypting a directory.
>> > > 
>> > > [1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10
>> > > 
>> > > Cheers,
>> > > --
>> > > Luis
>> > > 
>> > >  fs/ceph/ioctl.c | 4 ++++
>> > >  fs/ceph/xattr.c | 6 ++++++
>> > >  2 files changed, 10 insertions(+)
>> > > 
>> > > diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
>> > > index 477ecc667aee..42abfc564301 100644
>> > > --- a/fs/ceph/ioctl.c
>> > > +++ b/fs/ceph/ioctl.c
>> > > @@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
>> > >  	struct inode *inode = file_inode(file);
>> > >  	struct ceph_inode_info *ci = ceph_inode(inode);
>> > >  
>> > > +	/* encrypted directories can't have striped layout */
>> > > +	if (ci->i_layout.stripe_count > 1)
>> > > +		return -EOPNOTSUPP;
>> > > +
>> > 
>> > Yes, I've been needing to add that for a while. I'm not sure EOPNOTSUPP
>> > is the right error code though. Maybe EINVAL instead?
>> > 
>> 
>> Right, I had that initially and changed it after a long indecision.  But
>> yeah, I've no strong opinion either way.
>> 
>
> It's a judgement call, really...
>
>> > 
>> > >  	ret = vet_mds_for_fscrypt(file);
>> > >  	if (ret)
>> > >  		return ret;
>> > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> > > index b175b3029dc0..7921cb34900c 100644
>> > > --- a/fs/ceph/xattr.c
>> > > +++ b/fs/ceph/xattr.c
>> > > @@ -1051,6 +1051,12 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
>> > >  	int op = CEPH_MDS_OP_SETXATTR;
>> > >  	int err;
>> > >  
>> > > +	/* encrypted directories/files can't have their layout changed */
>> > > +	if (IS_ENCRYPTED(inode) &&
>> > > +	    (!strncmp(name, "ceph.file.layout", 16) ||
>> > > +	     !strncmp(name, "ceph.dir.layout", 15)))
>> > > +		return -EOPNOTSUPP;
>> > > +
>> > 
>> > Yuck.
>> 
>> Agreed!
>> 
>> > What might be nicer is to just make ceph_vxattrcb_layout* return an
>> > error when the inode is encrypted? You can return negative error codes
>> > from the ->getxattr_cb ops, and that's probably the better place to
>> > check for this.
>> 
>> I'm not sure I understand your suggestion.  This is on the SETXATTR path,
>> so we'll need to block attempts to send this operation to the MDS.
>> 
>
> Doh! You're correct -- I was thinking about getxattr, but setxattr
> doesn't have the same ops vectors. We could add a new option to vet
> setxattr requests locally, but that might not be sufficient actually...
>
>> An alternative would be to do this (return an error) on the MDS side, but
>> this would mean that we should also send the fscrypt fields to the MDS
>> because it may may not know yet that the inode is encrypted.  Which could
>> be the correct thing to do BTW.  Although I don't think client B could
>> concurrently change the layout of a directory that client A just set as
>> encrypted without client A sending that information to the MDS first...
>> 
>
> Now that I think about it some more, we probably need to let the MDS vet
> these requests.

Sure, and that's what I tried to do with the MDS patch in [1].  I'm not
confident that's safe enough, although I _think_ the case you describe:

 client A                             client B
                                      mkdir XYZ
 lookup inode XYZ
 setxattr (set layout)                encrypt XYZ

should be protected with the right caps + MDS locks.  But I'll go look
closer because I *know* I am still missing something.

[1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10

Cheers,
-- 
Luis

> It's possible that we'd do a lookup of the inode and
> then call setxattr on it concurrently with another client making the
> inode encrypted.
>
> We could ensure that we have As caps here to try to prevent that, but it
> hardly seems worthwhile. These are not commonly changed. It seems best
> to just let the MDS gather the appropriate locks and handle it there.
>
> -- 
> Jeff Layton <jlayton@kernel.org>
>
