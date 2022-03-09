Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE24D2C9F
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 10:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiCIJ57 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 04:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiCIJ57 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 04:57:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED94E16E7DD
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 01:57:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A9219210F3;
        Wed,  9 Mar 2022 09:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646819819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zb48jbI0WE62hJW/wisItCc2xpycRqlBRVr1v9CbqVE=;
        b=Ogjlu6xEQHLRzakeHDEFAYk2pcTa4deI0wlUOZ5BoSAuzoHg5tsIo+e4VsZl9Oe5BXEy+s
        7MRdzm+XhdaNWrCc2VOuYSUUbA40U7BIo9HATAB0ASZe+YjmlgxZhs47VGnzIW4m2DiQiG
        pmR1jfmI6d6kJCobFeChhYptgqVwfgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646819819;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zb48jbI0WE62hJW/wisItCc2xpycRqlBRVr1v9CbqVE=;
        b=xPBieJITRZ3JOIf/e2e6rIWAyM/x2WgV4/xlBOwzOl8b7+IerqW9Ij2qsOGqQxLiiV12ux
        eLJfMmv0fC8COcBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 494D313D79;
        Wed,  9 Mar 2022 09:56:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BlkKD+t5KGItNwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 09 Mar 2022 09:56:59 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 786c9fa9;
        Wed, 9 Mar 2022 09:57:13 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v5] ceph: do not dencrypt the dentry name twice for readdir
References: <20220305122527.1102109-1-xiubli@redhat.com>
        <87h788z67y.fsf@brahms.olymp>
        <a5d1050b-c922-e5a8-8cee-4b74b4695b73@redhat.com>
Date:   Wed, 09 Mar 2022 09:57:13 +0000
In-Reply-To: <a5d1050b-c922-e5a8-8cee-4b74b4695b73@redhat.com> (Xiubo Li's
        message of "Wed, 9 Mar 2022 11:21:48 +0800")
Message-ID: <87v8wn78jq.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

Xiubo Li <xiubli@redhat.com> writes:

> On 3/9/22 1:47 AM, Lu=C3=ADs Henriques wrote:
>> xiubli@redhat.com writes:
>>
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> For the readdir request the dentries will be pasred and dencrypted
>>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>>> get the dentry name from the dentry cache instead of parsing and
>>> dencrypting them again. This could improve performance.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>
>>> V5:
>>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>>> - release the rde->dentry in destroy_reply_info
>>>
>>>
>>>   fs/ceph/crypto.h     |  8 ++++++
>>>   fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>>>   fs/ceph/inode.c      |  7 ++++++
>>>   fs/ceph/mds_client.c |  2 ++
>>>   fs/ceph/mds_client.h |  1 +
>>>   5 files changed, 46 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
>>> index 1e08f8a64ad6..c85cb8c8bd79 100644
>>> --- a/fs/ceph/crypto.h
>>> +++ b/fs/ceph/crypto.h
>>> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_=
fscrypt_auth *fa)
>>>    */
>>>   #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>>>   +/*
>>> + * The encrypted long snap name will be in format of
>>> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max l=
ongth
>>> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + e=
xtra 7
>>> + * bytes to align the total size to 8 bytes.
>>> + */
>>> +#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
>>> +
>> I think this constant needs to be defined in a different way and we need
>> to keep the snapshots names length a bit shorter than NAME_MAX.  And I'm
>> not talking just about the encrypted snapshots.
>>
>> Right now, ceph PR#45192 fixes an MDS limitation that is keeping long
>> snapshot names smaller than 80 characters.  With this limitation we would
>> need to keep the snapshot names < 64:
>>
>>     '_' + <name> + '_' + '<inode#>' '\0'
>>      1  +   64   +  1  +    12     +  1 =3D 80
>>
>> Note however that currently clients *do* allow to create snapshots with
>> bigger names.  And if we do that we'll get an error when doing an LSSNAP
>> on a .snap subdirectory that will contain the corresponding long name:
>>
>>    # mkdir a/.snap/123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgz=
xcvb78912345
>>    # ls -li a/b/.snap
>>    ls: a/b/.snap/_123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzx=
cvb78912345_109951162777: No such file or directory
>>
>> We can limit the snapshot names on creation, but this should probably be
>> handled on the MDS side (so that old clients won't break anything).  Does
>> this make sense?  I can work on an MDS patch for this but... to which
>> length should names be limited? NAME_MAX - (2*'_' + <inode len>)?  Or
>> should we take base64-encoded names already into account?
>>
>> (Sorry, I'm jumping around between PRs and patches, and trying to make a=
ny
>> sense out of the snapshots code :-/ )
>
> For fscrypt case I think it's okay, because the max len of the encrypted =
name
> will be 189 bytes, so even plusing the extra 2 * sizeof('_') - sizeof(<in=
ode#>)=C2=A0
> =3D=3D 15 bytes with ceph PR#41592 it should work well.

Is it really 189 bytes, or 252, which is the result of base64 encoding 189
bytes?  Reading the documentation in the CEPH_NOHASH_NAME_MAX definition
it seems to be 252.  And in that case we need to limit the names length
even further.

>
> But for none fscrypt case, we must limit the max len to NAME_MAX - 2 *
> sizeof('_') - sizeof(<inode#>) =3D=3D 255 - 2 - 13 =3D=3D 240. So fixing =
this in=20
> MDS side makes sense IMO.

Yeah, I suppose this makes sense.  I can send out a PR soon with this, and
try to document it somewhere.  But it may make sense to merge both PRs at
the same time and *backport* them to older releases.

Cheers,
--=20
Lu=C3=ADs
