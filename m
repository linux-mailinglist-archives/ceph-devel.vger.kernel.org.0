Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DC43ED7D8
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 15:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhHPNqI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 09:46:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56824 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237458AbhHPNoF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Aug 2021 09:44:05 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2DE5021DF3;
        Mon, 16 Aug 2021 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629121413; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UI8w0cxWrr9XgTQX6lpsosrGlq9uh/SVTIgrWnFzpIQ=;
        b=CTVsBBnxVRta2xtUuwP0Q6AzSa7GyPdQy8/YROzOWsf6kk6BWD2j8FWqphHP+Rlh+Y4AVe
        nQlZHc23HVyInK47CE9M3nl4oziClBcXX8BjzD5LoqtIhsSbC014W5hiVA32MW7vipqIPB
        cDAvp+updmhB2KbDb0jLxBGq0PluTfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629121413;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UI8w0cxWrr9XgTQX6lpsosrGlq9uh/SVTIgrWnFzpIQ=;
        b=Q9T/ESJDR+QmnMxEXTIxFOhSwtYjBiIUXf9VxRkq+VypXL+/Lyu/Vnxu0mgcSmeNdyb8mH
        Qabd0dysZi7DUNAg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id D62A313301;
        Mon, 16 Aug 2021 13:43:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id 5GxSMYRrGmGQPQAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Mon, 16 Aug 2021 13:43:32 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 3606e8a9;
        Mon, 16 Aug 2021 13:43:32 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [fscrypt][RFC PATCH] ceph: don't allow changing layout on
 encrypted files/directories
References: <YRZtiL+qo95vK0Nf@suse.de>
        <e07e5f52bf73c0a9ef1441295f5ff42753d3e29a.camel@kernel.org>
Date:   Mon, 16 Aug 2021 14:43:31 +0100
In-Reply-To: <e07e5f52bf73c0a9ef1441295f5ff42753d3e29a.camel@kernel.org> (Jeff
        Layton's message of "Mon, 16 Aug 2021 08:44:01 -0400")
Message-ID: <87pmudtsho.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Fri, 2021-08-13 at 14:03 +0100, Luis Henriques wrote:
>> Encryption is currently only supported on files/directories with layouts
>> where stripe_count=3D1.  Forbid changing layouts when encryption is invo=
lved.
>>=20
>> Signed-off-by: Luis Henriques <lhenriques@suse.de>
>> ---
>> Hi!
>>=20
>> While continuing looking into fscrypt, I realized we're not yet forbiddi=
ng
>> different layouts on encrypted files.  This patch tries to do just that.
>>=20
>> Regarding the setxattr, I've also made a change [1] to the MDS code so t=
hat it
>> also prevents layouts to be changed.  This should make the changes to
>> ceph_sync_setxattr() redundant, but in practice it doesn't because if we=
 encrypt
>> a directory and immediately after that we change that directory layout, =
the MDS
>> wouldn't yet have received the fscrypt_auth for that inode.  So... yeah,=
 an
>> alternative would be to propagate the fscrypt context immediately after
>> encrypting a directory.
>>=20
>> [1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1=
ced02f7dd42aa10
>>=20
>> Cheers,
>> --
>> Luis
>>=20
>>  fs/ceph/ioctl.c | 4 ++++
>>  fs/ceph/xattr.c | 6 ++++++
>>  2 files changed, 10 insertions(+)
>>=20
>> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
>> index 477ecc667aee..42abfc564301 100644
>> --- a/fs/ceph/ioctl.c
>> +++ b/fs/ceph/ioctl.c
>> @@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file =
*file, unsigned long arg)
>>  	struct inode *inode =3D file_inode(file);
>>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>>=20=20
>> +	/* encrypted directories can't have striped layout */
>> +	if (ci->i_layout.stripe_count > 1)
>> +		return -EOPNOTSUPP;
>> +
>
> Yes, I've been needing to add that for a while. I'm not sure EOPNOTSUPP
> is the right error code though. Maybe EINVAL instead?
>

Right, I had that initially and changed it after a long indecision.  But
yeah, I've no strong opinion either way.

>
>>  	ret =3D vet_mds_for_fscrypt(file);
>>  	if (ret)
>>  		return ret;
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index b175b3029dc0..7921cb34900c 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -1051,6 +1051,12 @@ static int ceph_sync_setxattr(struct inode *inode=
, const char *name,
>>  	int op =3D CEPH_MDS_OP_SETXATTR;
>>  	int err;
>>=20=20
>> +	/* encrypted directories/files can't have their layout changed */
>> +	if (IS_ENCRYPTED(inode) &&
>> +	    (!strncmp(name, "ceph.file.layout", 16) ||
>> +	     !strncmp(name, "ceph.dir.layout", 15)))
>> +		return -EOPNOTSUPP;
>> +
>
> Yuck.

Agreed!

> What might be nicer is to just make ceph_vxattrcb_layout* return an
> error when the inode is encrypted? You can return negative error codes
> from the ->getxattr_cb ops, and that's probably the better place to
> check for this.

I'm not sure I understand your suggestion.  This is on the SETXATTR path,
so we'll need to block attempts to send this operation to the MDS.

An alternative would be to do this (return an error) on the MDS side, but
this would mean that we should also send the fscrypt fields to the MDS
because it may may not know yet that the inode is encrypted.  Which could
be the correct thing to do BTW.  Although I don't think client B could
concurrently change the layout of a directory that client A just set as
encrypted without client A sending that information to the MDS first...

Cheers,
--=20
Luis


>
>>  	if (size > 0) {
>>  		/* copy value into pagelist */
>>  		pagelist =3D ceph_pagelist_alloc(GFP_NOFS);
>>=20
>> Cheers,
>> --
>> Lu=C3=ADs
>
> --=20
> Jeff Layton <jlayton@kernel.org>
>
